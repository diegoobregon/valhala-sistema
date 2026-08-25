$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText("D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-frontend\src\app\app.ts", @'
import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuthService } from './services/auth.service';
import { ApiService } from './services/api.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
  <div class="shell" *ngIf="!auth.isLoggedIn">
    <div class="login-card">
      <div class="logo">🚜</div>
      <h1>VALHALA S.A.C.</h1>
      <p class="sub">Control de Flota y Logística B2B</p>
      <input [(ngModel)]="email" placeholder="Correo corporativo" />
      <input [(ngModel)]="password" type="password" placeholder="Contraseña" (keyup.enter)="entrar()" />
      <button class="btn-primary" (click)="entrar()">Ingresar al Portal</button>
      <p class="err" *ngIf="error">{{ error }}</p>
    </div>
  </div>

  <div *ngIf="auth.isLoggedIn">
    <nav class="topbar">
      <div class="brand">🚜 VALHALA <span>S.A.C.</span></div>
      <div class="userchip">{{ auth.nombres }} <b class="rol">{{ auth.rol }}</b>
        <button class="btn-out" (click)="salir()">Salir</button>
      </div>
    </nav>

    <main class="wrap">
      <section class="kpis">
        <div class="kpi"><div class="num">{{ equipos.length }}</div><div class="lbl">Equipos en flota</div></div>
        <div class="kpi"><div class="num">{{ confCount() }}</div><div class="lbl">Reservas confirmadas</div></div>
        <div class="kpi"><div class="num">{{ pendCount() }}</div><div class="lbl">Liquidaciones por cobrar</div></div>
        <div class="kpi gold"><div class="num">S/ {{ totalPorCobrar() | number:'1.2-2' }}</div><div class="lbl">Monto por cobrar</div></div>
      </section>

      <div class="tabs">
        <button [class.on]="tab==='gantt'" (click)="tab='gantt'">📅 Gantt Reservas</button>
        <button [class.on]="tab==='liq'" (click)="tab='liq'">💰 Liquidaciones</button>
        <button [class.on]="tab==='eq'" (click)="tab='eq'">🚜 Equipos</button>
      </div>

      <section class="card" *ngIf="tab==='gantt'">
        <h2>Diagrama de Gantt | Disponibilidad (RF-02)</h2>
        <div class="ghead">
          <div class="glabel"></div>
          <div class="gmonths">
            <span [style.width.%]="31/92*100">JUL 2026</span>
            <span [style.width.%]="31/92*100">AGO 2026</span>
            <span [style.width.%]="30/92*100">SEP 2026</span>
          </div>
        </div>
        <div class="grow" *ngFor="let r of reservas">
          <div class="glabel">{{ r.itemContrato?.equipo?.codigoPatrimonial }}</div>
          <div class="gtrack">
            <div class="gbar" [class.pend]="r.estadoReserva!=='CONFIRMADA'"
                 [style.left.%]="pos(r).left" [style.width.%]="pos(r).width"
                 [title]="r.fechaInicioReserva + ' a ' + r.fechaFinReserva">
              {{ r.fechaInicioReserva | date:'dd/MM' }} a {{ r.fechaFinReserva | date:'dd/MM' }}
            </div>
          </div>
        </div>
        <div class="legend"><span class="dot conf"></span>Confirmada <span class="dot pend"></span>Pendiente</div>
      </section>

      <section class="card" *ngIf="tab==='liq'">
        <h2>Liquidaciones Financieras (RF-05)</h2>
        <table>
          <thead><tr><th>ID</th><th>Horas Base</th><th>Horas Extra</th><th>Subtotal</th><th>IGV (18%)</th><th>Total</th><th>Estado</th></tr></thead>
          <tbody>
            <tr *ngFor="let l of liquidaciones">
              <td>#{{ l.idLiquidacion }}</td>
              <td>{{ l.horasBaseConsumidas | number:'1.2-2' }}</td>
              <td>{{ l.horasExtraCalculadas | number:'1.2-2' }}</td>
              <td>S/ {{ l.subtotal | number:'1.2-2' }}</td>
              <td>S/ {{ l.igv | number:'1.2-2' }}</td>
              <td class="strong">S/ {{ l.totalFacturar | number:'1.2-2' }}</td>
              <td><span class="badge" [class.ok]="l.estadoCobro==='PAGADO'" [class.warn]="l.estadoCobro==='PENDIENTE'">{{ l.estadoCobro }}</span></td>
            </tr>
          </tbody>
        </table>
        <p class="empty" *ngIf="liquidaciones.length===0">Aun no hay liquidaciones registradas.</p>
      </section>

      <section class="card" *ngIf="tab==='eq'">
        <h2>Flota de Maquinaria</h2>
        <table>
          <thead><tr><th>Código</th><th>Marca</th><th>Modelo</th><th>Año</th><th>Horómetro</th></tr></thead>
          <tbody>
            <tr *ngFor="let e of equipos">
              <td class="strong">{{ e.codigoPatrimonial }}</td><td>{{ e.marca }}</td><td>{{ e.modelo }}</td>
              <td>{{ e.anioFabricacion }}</td><td>{{ e.horometroAcumulado | number:'1.2-2' }} h</td>
            </tr>
          </tbody>
        </table>
      </section>

      <footer>Sistema Web B2B | VALHALA S.A.C. | Ayacucho, 2026</footer>
    </main>
  </div>
  `,
  styles: [`
    :host { font-family:'Segoe UI',system-ui,sans-serif; color:#1e293b; }
    .shell { min-height:100vh; display:flex; align-items:center; justify-content:center;
      background:linear-gradient(135deg,#0f2f4f 0%,#134e4a 60%,#0f766e 100%); }
    .login-card { background:#fff; padding:36px 42px; border-radius:16px; width:340px;
      box-shadow:0 20px 50px rgba(0,0,0,.35); text-align:center; }
    .logo { font-size:44px; }
    .login-card h1 { margin:6px 0 0; color:#0f2f4f; font-size:22px; letter-spacing:.5px; }
    .sub { color:#64748b; font-size:13px; margin:4px 0 18px; }
    .login-card input { width:100%; box-sizing:border-box; padding:11px 12px; margin-bottom:10px;
      border:1px solid #cbd5e1; border-radius:8px; font-size:14px; }
    .login-card input:focus { outline:2px solid #0f766e; border-color:transparent; }
    .btn-primary { width:100%; padding:11px; border:0; border-radius:8px; cursor:pointer;
      background:linear-gradient(90deg,#0f2f4f,#0f766e); color:#fff; font-weight:600; font-size:14px; }
    .btn-primary:hover { filter:brightness(1.15); }
    .err { color:#dc2626; font-size:13px; }
    .topbar { background:#0f2f4f; color:#fff; display:flex; justify-content:space-between;
      align-items:center; padding:12px 28px; position:sticky; top:0; z-index:5;
      box-shadow:0 2px 10px rgba(0,0,0,.25); }
    .brand { font-weight:700; font-size:18px; }
    .brand span { color:#f59e0b; }
    .userchip { font-size:13px; display:flex; gap:10px; align-items:center; }
    .rol { background:#f59e0b; color:#0f2f4f; padding:2px 10px; border-radius:999px; font-size:11px; }
    .btn-out { background:transparent; border:1px solid #ffffff66; color:#fff; padding:6px 14px; border-radius:8px; cursor:pointer; }
    .btn-out:hover { background:#ffffff22; }
    .wrap { max-width:1150px; margin:0 auto; padding:22px 16px 40px; }
    .kpis { display:grid; grid-template-columns:repeat(4,1fr); gap:14px; margin-bottom:18px; }
    .kpi { background:#fff; border-radius:12px; padding:16px 18px; box-shadow:0 2px 8px rgba(15,47,79,.08); border-left:4px solid #0f766e; }
    .kpi .num { font-size:24px; font-weight:700; color:#0f2f4f; }
    .kpi .lbl { font-size:12px; color:#64748b; margin-top:2px; }
    .kpi.gold { border-left-color:#f59e0b; }
    .kpi.gold .num { color:#b45309; }
    .tabs { display:flex; gap:8px; margin-bottom:16px; }
    .tabs button { padding:9px 18px; border-radius:999px; border:1px solid #cbd5e1; background:#fff; cursor:pointer; font-size:13px; font-weight:600; color:#334155; }
    .tabs button.on { background:#0f2f4f; color:#fff; border-color:#0f2f4f; }
    .card { background:#fff; border-radius:12px; padding:20px 22px; box-shadow:0 2px 8px rgba(15,47,79,.08); }
    .card h2 { margin:0 0 14px; font-size:17px; color:#0f2f4f; }
    .ghead, .grow { display:flex; align-items:center; margin:6px 0; }
    .glabel { width:86px; font-weight:600; font-size:13px; color:#334155; }
    .gmonths { display:flex; flex:1; font-size:11px; color:#64748b; }
    .gmonths span { text-align:center; border-left:1px solid #e2e8f0; }
    .gtrack { position:relative; flex:1; background:#f1f5f9; height:26px; border-radius:6px; }
    .gbar { position:absolute; top:3px; bottom:3px; background:linear-gradient(90deg,#16a34a,#15803d);
      color:#fff; font-size:10.5px; border-radius:6px; padding:0 8px; display:flex; align-items:center;
      overflow:hidden; white-space:nowrap; box-shadow:0 1px 3px rgba(0,0,0,.25); }
    .gbar.pend { background:linear-gradient(90deg,#f59e0b,#d97706); }
    .legend { margin-top:10px; font-size:12px; color:#64748b; }
    .dot { display:inline-block; width:10px; height:10px; border-radius:3px; margin:0 4px 0 10px; }
    .dot.conf { background:#16a34a; } .dot.pend { background:#f59e0b; }
    table { width:100%; border-collapse:collapse; font-size:13.5px; }
    thead th { background:#0f2f4f; color:#fff; text-align:left; padding:10px 12px; font-weight:600; }
    tbody td { padding:10px 12px; border-bottom:1px solid #e2e8f0; }
    tbody tr:hover { background:#f8fafc; }
    .strong { font-weight:700; color:#0f2f4f; }
    .badge { padding:3px 10px; border-radius:999px; font-size:11px; font-weight:700; background:#e2e8f0; }
    .badge.warn { background:#fef3c7; color:#b45309; }
    .badge.ok { background:#dcfce7; color:#15803d; }
    .empty { color:#94a3b8; font-size:13px; }
    footer { text-align:center; color:#94a3b8; font-size:12px; margin-top:26px; }
  `]
})
export class App implements OnInit {
  email = ''; password = ''; error = '';
  tab = 'gantt';
  reservas: any[] = []; liquidaciones: any[] = []; equipos: any[] = [];

  constructor(public auth: AuthService, private api: ApiService) {}

  ngOnInit() { if (this.auth.isLoggedIn) this.cargar(); }

  entrar() {
    this.auth.login(this.email, this.password).subscribe({
      next: (r) => { this.auth.setSession(r); this.error = ''; this.cargar(); },
      error: () => (this.error = 'Credenciales invalidas')
    });
  }

  salir() { this.auth.logout(); this.reservas = []; this.liquidaciones = []; this.equipos = []; }

  cargar() {
    this.api.gantt().subscribe((r) => (this.reservas = r));
    this.api.liquidaciones().subscribe({ next: (r) => (this.liquidaciones = r), error: () => (this.liquidaciones = []) });
    this.api.equipos().subscribe((r) => (this.equipos = r));
  }

  confCount() { return this.reservas.filter(r => r.estadoReserva === 'CONFIRMADA').length; }
  pendCount() { return this.liquidaciones.filter(l => l.estadoCobro === 'PENDIENTE').length; }
  totalPorCobrar() { return this.liquidaciones.filter(l => l.estadoCobro === 'PENDIENTE').reduce((s, l) => s + Number(l.totalFacturar), 0); }

  pos(r: any) {
    const start = Date.parse('2026-07-01');
    const total = 92 * 86400000;
    const i = Date.parse(r.fechaInicioReserva) - start;
    const f = Date.parse(r.fechaFinReserva) - start;
    const left = Math.max(0, Math.min(100, (i / total) * 100));
    const width = Math.max(2, Math.min(100 - left, ((f - i) / total) * 100));
    return { left, width };
  }
}
'@, $utf8)
Write-Host "DISENO PRO APLICADO! Ctrl+F5 en el navegador."