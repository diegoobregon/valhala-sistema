import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ApiService } from '../core/api.service';
import { CheckOutSalida, ReservaGantt } from '../core/models';

@Component({
  selector: 'app-transacciones',
  standalone: true,
  imports: [ReactiveFormsModule],
  template: `
  <div class="grid2">
    <div class="card">
      <h2>RF-06 · Check-out (despacho)</h2>
      <p class="muted" style="margin-bottom:14px">
        Bloquea el despacho si el equipo tiene SOAT, SCTR o TREC vencido.
      </p>
      <form [formGroup]="fOut" (ngSubmit)="checkout()">
        <label>Reserva a despachar</label>
        <select formControlName="idReserva">
          @for (r of reservas(); track r.idReserva) {
            <option [value]="r.idReserva">
              #{{ r.idReserva }} — {{ r.itemContrato?.equipo?.codigoPatrimonial }} ({{ r.fechaInicioReserva }})
            </option>
          }
        </select>
        <label>Horometro inicial</label>
        <input type="number" step="0.01" formControlName="horometroInicial">
        <button type="submit" [disabled]="fOut.invalid">Despachar equipo</button>
      </form>
      @if (msgOut()) { <div class="msg" [class.ok]="okOut()" [class.er]="!okOut()">{{ msgOut() }}</div> }
    </div>

    <div class="card">
      <h2>RF-05 · Check-in (retorno y liquidacion)</h2>
      <p class="muted" style="margin-bottom:14px">
        Rechaza el retorno si el horometro final es menor al inicial (antifraude).
      </p>
      <form [formGroup]="fIn" (ngSubmit)="checkin()">
        <label>Salida (check-out) a cerrar</label>
        @if (salidas().length) {
          <select formControlName="idSalida">
            @for (s of salidas(); track s.idSalida) {
              <option [value]="s.idSalida">
                CO #{{ s.idSalida }} — {{ s.reserva?.itemContrato?.equipo?.codigoPatrimonial }}
                (inicial {{ s.horometroInicial }} h)
              </option>
            }
          </select>
        } @else {
          <input type="number" formControlName="idSalida" placeholder="ID de la salida (ej. 1)">
          <small class="muted">Agregue el GET en CheckOutController para poblar esta lista.</small>
        }
        <label>Horometro final</label>
        <input type="number" step="0.01" formControlName="horometroFinal">
        <button type="submit" [disabled]="fIn.invalid">Registrar retorno y liquidar</button>
      </form>
      @if (msgIn()) { <div class="msg" [class.ok]="okIn()" [class.er]="!okIn()">{{ msgIn() }}</div> }
    </div>
  </div>

  <div class="card">
    <h2>Despachos registrados</h2>
    @if (salidas().length) {
      <table>
        <tr><th>#</th><th>Equipo</th><th>Horometro inicial</th><th>Fecha despacho</th><th>Mecanico</th></tr>
        @for (s of salidas(); track s.idSalida) {
          <tr>
            <td>{{ s.idSalida }}</td>
            <td>{{ s.reserva?.itemContrato?.equipo?.codigoPatrimonial }}</td>
            <td>{{ s.horometroInicial }} h</td>
            <td>{{ s.fechaDespacho }}</td>
            <td>{{ s.usuarioMecanico?.nombres }}</td>
          </tr>
        }
      </table>
    } @else {
      <p class="muted">Endpoint GET /api/v1/transacciones/checkout no disponible todavia.</p>
    }
  </div>`
})
export class TransaccionesComponent {
  private api = inject(ApiService);
  private fb = inject(FormBuilder);

  reservas = signal<ReservaGantt[]>([]);
  salidas = signal<CheckOutSalida[]>([]);
  msgOut = signal(''); okOut = signal(true);
  msgIn = signal('');  okIn = signal(true);

  fOut = this.fb.nonNullable.group({
    idReserva: [0, Validators.required],
    horometroInicial: [0, [Validators.required, Validators.min(0)]]
  });

  fIn = this.fb.nonNullable.group({
    idSalida: [0, Validators.required],
    horometroFinal: [0, [Validators.required, Validators.min(0)]]
  });

  constructor() { this.cargar(); }

  cargar() {
    this.api.gantt().subscribe(r => {
      this.reservas.set(r);
      if (r.length) this.fOut.patchValue({ idReserva: r[0].idReserva });
    });
    this.api.salidas().subscribe({
      next: s => {
        this.salidas.set(s);
        if (s.length) this.fIn.patchValue({ idSalida: s[0].idSalida });
      },
      error: () => this.salidas.set([])
    });
  }

  checkout() {
    this.api.checkout(this.fOut.getRawValue()).subscribe({
      next: (s: any) => {
        this.okOut.set(true);
        this.msgOut.set(`Check-out registrado. Salida #${s.idSalida}. Equipo ALQUILADO.`);
        this.cargar();
      },
      error: (e: any) => {
        this.okOut.set(false);
        this.msgOut.set(e.error?.message || e.error?.mensaje ||
          'DocumentoVencidoException: el equipo tiene un documento legal vencido (RF-06).');
      }
    });
  }

  checkin() {
    this.api.checkin(this.fIn.getRawValue()).subscribe({
      next: (l: any) => {
        this.okIn.set(true);
        this.msgIn.set(
          `Liquidacion #${l.idLiquidacion} generada · Horas base ${l.horasBaseConsumidas} · ` +
          `Extra ${l.horasExtraCalculadas} · Subtotal S/ ${l.subtotal} · IGV S/ ${l.igv} · TOTAL S/ ${l.totalFacturar}`
        );
        this.cargar();
      },
      error: (e: any) => {
        this.okIn.set(false);
        this.msgIn.set(e.error?.message || e.error?.mensaje ||
          'FraudeHorometroException: el horometro final no puede ser menor al inicial (RF-05).');
      }
    });
  }
}
