import { Component, inject, signal, computed } from '@angular/core';
import { DatePipe } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ApiService } from '../core/api.service';
import { AuthService } from '../core/auth.service';
import { ItemContrato, ReservaGantt } from '../core/models';

@Component({
  selector: 'app-gantt',
  standalone: true,
  imports: [ReactiveFormsModule, DatePipe],
  template: `
  <div class="card">
    <h2>RF-02 · Disponibilidad de maquinaria (Gantt)</h2>
    @if (reservas().length === 0) {
      <p class="muted">Sin reservas activas registradas.</p>
    } @else {
      @for (r of reservas(); track r.idReserva) {
        <div class="row">
          <b>{{ r.itemContrato?.equipo?.codigoPatrimonial }}</b>
          <div class="track">
            <div class="bar" [style.left.%]="offset(r)" [style.width.%]="ancho(r)"
                 [title]="r.itemContrato?.contrato?.cliente?.razonSocial || ''">
              {{ r.fechaInicioReserva }} → {{ r.fechaFinReserva }}
            </div>
          </div>
          <span class="badge" [class.b-ok]="r.estadoReserva==='CONFIRMADA'"
                [class.b-am]="r.estadoReserva!=='CONFIRMADA'">{{ r.estadoReserva }}</span>
        </div>
      }
      <p class="muted" style="margin-top:12px">
        Rango mostrado: {{ min() | date:'dd/MM/yyyy' }} — {{ max() | date:'dd/MM/yyyy' }}
      </p>
    }
  </div>

  <div class="card">
    <h2>RF-01 · Nueva reserva (motor anticolisiones)</h2>
    <form [formGroup]="form" (ngSubmit)="reservar()">
      <div class="grid3">
        <div>
          <label>Item de contrato (equipo)</label>
          <select formControlName="idItemContrato">
            @for (i of items(); track i.idItem) {
              <option [value]="i.idItem">
                {{ i.equipo?.codigoPatrimonial }} — {{ i.contrato?.cliente?.razonSocial }} (S/ {{ i.tarifaPorHora }}/h)
              </option>
            }
          </select>
        </div>
        <div><label>Fecha inicio</label><input type="date" formControlName="fechaInicio"></div>
        <div><label>Fecha fin</label><input type="date" formControlName="fechaFin"></div>
      </div>
      <button type="submit" [disabled]="form.invalid">Registrar reserva</button>
    </form>
    @if (msg()) { <div class="msg" [class.ok]="ok()" [class.er]="!ok()">{{ msg() }}</div> }
  </div>

  <div class="card">
    <h2>Detalle de reservas</h2>
    <table>
      <tr><th>#</th><th>Equipo</th><th>Cliente</th><th>Inicio</th><th>Fin</th><th>Estado</th>
        @if (auth.esAdmin()) { <th></th> }</tr>
      @for (r of reservas(); track r.idReserva) {
        <tr>
          <td>{{ r.idReserva }}</td>
          <td>{{ r.itemContrato?.equipo?.codigoPatrimonial }}</td>
          <td>{{ r.itemContrato?.contrato?.cliente?.razonSocial }}</td>
          <td>{{ r.fechaInicioReserva }}</td>
          <td>{{ r.fechaFinReserva }}</td>
          <td>{{ r.estadoReserva }}</td>
          @if (auth.esAdmin()) {
            <td><button class="danger" (click)="anular(r.idReserva)">Anular</button></td>
          }
        </tr>
      }
    </table>
  </div>`,
  styles: [`
    .row{display:grid;grid-template-columns:120px 1fr 110px;align-items:center;gap:12px;margin-bottom:10px}
    .track{position:relative;height:26px;background:#141a20;border-radius:5px}
    .bar{position:absolute;height:26px;background:var(--am);border-radius:5px;color:#111;
      font-size:11px;font-weight:700;display:flex;align-items:center;padding:0 8px;white-space:nowrap;overflow:hidden}
  `]
})
export class GanttComponent {
  private api = inject(ApiService);
  private fb = inject(FormBuilder);
  auth = inject(AuthService);

  reservas = signal<ReservaGantt[]>([]);
  items = signal<ItemContrato[]>([]);
  msg = signal(''); ok = signal(true);

  form = this.fb.nonNullable.group({
    idItemContrato: [0, Validators.required],
    fechaInicio: ['', Validators.required],
    fechaFin: ['', Validators.required]
  });

  min = computed(() => this.reservas().length
    ? new Date(this.reservas().map(r => r.fechaInicioReserva).sort()[0]) : new Date());
  max = computed(() => this.reservas().length
    ? new Date(this.reservas().map(r => r.fechaFinReserva).sort().reverse()[0]) : new Date());

  constructor() { this.cargar(); }

  cargar() {
    this.api.gantt().subscribe(r => this.reservas.set(r));
    this.api.items().subscribe(i => {
      this.items.set(i);
      if (i.length) this.form.patchValue({ idItemContrato: i[0].idItem });
    });
  }

  private span(): number {
    const d = (this.max().getTime() - this.min().getTime()) / 86400000;
    return d > 0 ? d : 1;
  }
  offset(r: ReservaGantt): number {
    return (new Date(r.fechaInicioReserva).getTime() - this.min().getTime()) / 86400000 / this.span() * 100;
  }
  ancho(r: ReservaGantt): number {
    const w = (new Date(r.fechaFinReserva).getTime() - new Date(r.fechaInicioReserva).getTime())
      / 86400000 / this.span() * 100;
    return Math.max(w, 4);
  }

  reservar() {
    this.api.crearReserva(this.form.getRawValue()).subscribe({
      next: () => { this.ok.set(true); this.msg.set('Reserva registrada: sin colision de fechas.'); this.cargar(); },
      error: (e: any) => {
        this.ok.set(false);
        this.msg.set(e.error?.message || e.error?.mensaje ||
          'ColisionReservaException: el equipo ya esta reservado en ese rango (RF-01).');
      }
    });
  }

  anular(id: number) {
    this.api.anularReserva(id).subscribe({
      next: () => { this.ok.set(true); this.msg.set('Reserva anulada.'); this.cargar(); },
      error: () => { this.ok.set(false); this.msg.set('No se pudo anular la reserva.'); }
    });
  }
}
