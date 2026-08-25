import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from './services/api.service';

@Component({
  selector: 'app-trans',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
  <div class="twrap">
    <div class="tgrid">
      <div class="tcard">
        <h3>🚜 Check-Out | Despacho (RF-06)</h3>
        <label>Reserva confirmada
          <select [(ngModel)]="fOut.idReserva">
            <option *ngFor="let r of reservas" [ngValue]="r.idReserva">#{{ r.idReserva }} | {{ r.itemContrato?.equipo?.codigoPatrimonial }} | {{ r.fechaInicioReserva }} a {{ r.fechaFinReserva }}</option>
          </select>
        </label>
        <label>Horómetro inicial
          <input type="number" [(ngModel)]="fOut.horometroInicial" placeholder="Ej: 3105.25" />
        </label>
        <button class="btn-go" (click)="checkout()">🔑 Despachar equipo</button>
      </div>
      <div class="tcard">
        <h3>🔧 Check-In | Retorno (RF-05)</h3>
        <label>Salida en campo
          <select [(ngModel)]="fIn.idSalida">
            <option *ngFor="let s of salidas" [ngValue]="s.idSalida">#{{ s.idSalida }} | {{ s.reserva?.itemContrato?.equipo?.codigoPatrimonial }} | salió {{ s.fechaDespacho | date:'dd/MM HH:mm' }}</option>
          </select>
        </label>
        <label>Horómetro final
          <input type="number" [(ngModel)]="fIn.horometroFinal" placeholder="Ej: 3200.00" />
        </label>
        <button class="btn-go" (click)="checkin()">💰 Registrar retorno y liquidar</button>
      </div>
    </div>

    <div class="alert err" *ngIf="error">⛔ {{ error }}</div>
    <div class="alert ok" *ngIf="ok">✅ {{ ok }}</div>

    <div class="tcard liq" *ngIf="resultado">
      <h3>💰 Liquidación generada automáticamente</h3>
      <div class="lrow"><span>Horas base consumidas</span><b>{{ resultado.horasBaseConsumidas }} h</b></div>
      <div class="lrow"><span>Horas extra (tarifa x1.5)</span><b>{{ resultado.horasExtraCalculadas }} h</b></div>
      <div class="lrow"><span>Subtotal</span><b>S/ {{ resultado.subtotal }}</b></div>
      <div class="lrow"><span>IGV (18%)</span><b>S/ {{ resultado.igv }}</b></div>
      <div class="lrow total"><span>TOTAL A FACTURAR</span><b>S/ {{ resultado.totalFacturar }}</b></div>
    </div>
  </div>
  `,
  styles: [`
    .twrap { display:flex; flex-direction:column; gap:16px; }
    .tgrid { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
    .tcard { background:#fff; border-radius:12px; padding:20px; box-shadow:0 2px 6px rgba(15,47,79,.06); }
    .tcard h3 { margin:0 0 14px; color:#0f2f4f; font-size:15px; }
    .tcard label { display:block; font-size:12px; font-weight:600; color:#334155; margin-bottom:12px; }
    .tcard select, .tcard input { width:100%; box-sizing:border-box; padding:9px 12px; margin-top:4px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px; }
    .btn-go { width:100%; padding:11px; background:linear-gradient(90deg,#0f2f4f,#0f766e); color:#fff; border:0; border-radius:8px; cursor:pointer; font-weight:700; font-size:13px; }
    .btn-go:hover { filter:brightness(1.15); }
    .alert { padding:12px 16px; border-radius:8px; font-size:13px; font-weight:600; }
    .alert.err { background:#fef2f2; color:#dc2626; border:1px solid #fecaca; }
    .alert.ok { background:#f0fdf4; color:#15803d; border:1px solid #bbf7d0; }
    .liq { border-left:4px solid #f59e0b; }
    .lrow { display:flex; justify-content:space-between; padding:8px 0; border-bottom:1px solid #f1f5f9; font-size:13px; color:#64748b; }
    .lrow b { color:#0f2f4f; }
    .lrow.total { border-bottom:0; font-size:16px; }
    .lrow.total b { color:#b45309; font-size:18px; }
  `]
})
export class TransComponent implements OnInit {
  reservas: any[] = []; salidas: any[] = [];
  fOut: any = {}; fIn: any = {};
  resultado: any = null; error = ''; ok = '';

  constructor(private api: ApiService) {}
  ngOnInit() { this.cargar(); }

  cargar() {
    this.api.gantt().subscribe(r => (this.reservas = r.filter(x => x.estadoReserva === 'CONFIRMADA')));
    this.api.salidas().subscribe(r => (this.salidas = r));
  }

  checkout() {
    this.error = ''; this.ok = '';
    this.api.checkout(this.fOut).subscribe({
      next: (r) => { this.ok = 'Equipo despachado (salida #' + r.idSalida + '). Documentos legales validados (RF-06).'; this.fOut = {}; this.cargar(); },
      error: (e) => (this.error = e.error?.error || 'Error en el despacho')
    });
  }

  checkin() {
    this.error = ''; this.ok = '';
    this.api.checkin(this.fIn).subscribe({
      next: (r) => { this.resultado = r; this.ok = 'Retorno registrado. Liquidación generada (RF-05).'; this.fIn = {}; this.cargar(); },
      error: (e) => (this.error = e.error?.error || 'Error en el retorno')
    });
  }
}