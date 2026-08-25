$utf8 = New-Object System.Text.UTF8Encoding $false

# =============== SERVICIOS AMPLIADOS ===============
[System.IO.File]::WriteAllText("D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-frontend\src\app\services\api.service.ts", @'
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private base = 'http://localhost:8080/api/v1';
  constructor(private http: HttpClient) {}

  // Lectura
  equipos(): Observable<any[]> { return this.http.get<any[]>(this.base + '/equipos'); }
  categorias(): Observable<any[]> { return this.http.get<any[]>(this.base + '/categorias'); }
  clientes(): Observable<any[]> { return this.http.get<any[]>(this.base + '/clientes'); }
  usuarios(): Observable<any[]> { return this.http.get<any[]>(this.base + '/usuarios'); }
  contratos(): Observable<any[]> { return this.http.get<any[]>(this.base + '/contratos'); }
  gantt(): Observable<any[]> { return this.http.get<any[]>(this.base + '/reservas/gantt'); }
  liquidaciones(): Observable<any[]> { return this.http.get<any[]>(this.base + '/liquidaciones'); }
  documentos(): Observable<any[]> { return this.http.get<any[]>(this.base + '/documentos'); }
  mantenimientos(): Observable<any[]> { return this.http.get<any[]>(this.base + '/mantenimientos'); }

  // Escritura (CRUD)
  crearEquipo(d: any): Observable<any> { return this.http.post(this.base + '/equipos', d); }
  actualizarEquipo(id: number, d: any): Observable<any> { return this.http.put(this.base + '/equipos/' + id, d); }
  eliminarEquipo(id: number): Observable<any> { return this.http.delete(this.base + '/equipos/' + id); }
  crearCliente(d: any): Observable<any> { return this.http.post(this.base + '/clientes', d); }
  crearUsuario(d: any): Observable<any> { return this.http.post(this.base + '/usuarios', d); }
  crearContrato(d: any): Observable<any> { return this.http.post(this.base + '/contratos', d); }
  crearReserva(d: any): Observable<any> { return this.http.post(this.base + '/reservas', d); }
  anularReserva(id: number): Observable<any> { return this.http.delete(this.base + '/reservas/' + id); }
  crearMantenimiento(d: any): Observable<any> { return this.http.post(this.base + '/mantenimientos', d); }
  crearDocumento(d: any): Observable<any> { return this.http.post(this.base + '/documentos', d); }
}
'@, $utf8)

# =============== APP COMPLETA (SIDEBAR + CRUD + FERREYROS STYLE) ===============
[System.IO.File]::WriteAllText("D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-frontend\src\app\app.component.ts", @'
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
  <!-- LOGIN -->
  <div class="shell" *ngIf="!auth.isLoggedIn">
    <div class="login-card">
      <div class="logo">🚜</div>
      <h1>VALHALA S.A.C.</h1>
      <p class="sub">Sistema Web B2B | Control de Flota</p>
      <input [(ngModel)]="email" placeholder="Correo corporativo" />
      <input [(ngModel)]="password" type="password" placeholder="Contraseña" (keyup.enter)="entrar()" />
      <button class="btn-primary" (click)="entrar()">Ingresar al Portal</button>
      <p class="err" *ngIf="error">{{ error }}</p>
      <div class="hint">
        <b>Demo:</b><br>
        admin&#64;valhala.pe / admin123<br>
        cliente&#64;consorcioandes.pe / cliente123<br>
        mecanico&#64;valhala.pe / mecanico123
      </div>
    </div>
  </div>

  <!-- APP AUTENTICADA -->
  <div class="layout" *ngIf="auth.isLoggedIn">
    <aside class="sidebar">
      <div class="sbrand">🚜 VALHALA<br><small>S.A.C.</small></div>
      <div class="suser">
        <div class="avatar">{{ auth.nombres.charAt(0) }}</div>
        <div class="uname">{{ auth.nombres }}<br><span class="urole">{{ auth.rol }}</span></div>
      </div>
      <nav class="snav">
        <div class="sec">OPERACIONES</div>
        <a [class.on]="view==='dash'" (click)="view='dash'">📊 Dashboard</a>
        <a *ngIf="puede(['ADMIN','CLIENTE','MECANICO'])" [class.on]="view==='equipos'" (click)="view='equipos'; cargarEquipos()">🚜 Equipos</a>
        <a *ngIf="puede(['ADMIN','CLIENTE','MECANICO'])" [class.on]="view==='gantt'" (click)="view='gantt'; cargarGantt()">📅 Reservas (Gantt)</a>
        <a *ngIf="puede(['ADMIN','CLIENTE'])" [class.on]="view==='liquidaciones'" (click)="view='liquidaciones'; cargarLiq()">💰 Liquidaciones</a>

        <div class="sec">COMERCIAL</div>
        <a *ngIf="puede(['ADMIN','CLIENTE'])" [class.on]="view==='clientes'" (click)="view='clientes'; cargarCli()">🏢 Clientes</a>
        <a *ngIf="puede(['ADMIN','CLIENTE'])" [class.on]="view==='contratos'" (click)="view='contratos'; cargarCont()">📜 Contratos</a>

        <div class="sec">ADMINISTRACIÓN</div>
        <a *ngIf="puede(['ADMIN'])" [class.on]="view==='usuarios'" (click)="view='usuarios'; cargarUsr()">👥 Usuarios</a>
        <a *ngIf="puede(['ADMIN','MECANICO'])" [class.on]="view==='mantenimientos'" (click)="view='mantenimientos'; cargarMan()">🔧 Mantenimientos</a>
        <a *ngIf="puede(['ADMIN','MECANICO'])" [class.on]="view==='documentos'" (click)="view='documentos'; cargarDoc()">📋 Docs Legales</a>
      </nav>
      <button class="btn-out" (click)="salir()">🚪 Cerrar sesión</button>
    </aside>

    <main class="content">
      <header class="topbar">
        <h1>{{ tituloView() }}</h1>
        <div class="chip">{{ auth.nombres }} | {{ auth.rol }}</div>
      </header>

      <!-- DASHBOARD -->
      <section *ngIf="view==='dash'" class="pad">
        <div class="kpis">
          <div class="kpi"><div class="n">{{ equipos.length }}</div><div class="l">Equipos en flota</div></div>
          <div class="kpi"><div class="n">{{ reservas.filter(r=>r.estadoReserva==='CONFIRMADA').length }}</div><div class="l">Reservas activas</div></div>
          <div class="kpi"><div class="n">{{ liq.filter(l=>l.estadoCobro==='PENDIENTE').length }}</div><div class="l">Por cobrar</div></div>
          <div class="kpi gold"><div class="n">S/ {{ totalPorCobrar() | number:'1.2-2' }}</div><div class="l">Monto pendiente</div></div>
        </div>
        <div class="grid2">
          <div class="card">
            <h3>📅 Próximas reservas</h3>
            <table class="t"><tr *ngFor="let r of reservas.slice(0,5)"><td>{{ r.itemContrato?.equipo?.codigoPatrimonial }}</td><td>{{ r.fechaInicioReserva }} → {{ r.fechaFinReserva }}</td><td><span class="badge" [class.ok]="r.estadoReserva==='CONFIRMADA'">{{ r.estadoReserva }}</span></td></tr></table>
          </div>
          <div class="card">
            <h3>🚜 Últimos equipos registrados</h3>
            <table class="t"><tr *ngFor="let e of equipos.slice(0,5)"><td><b>{{ e.codigoPatrimonial }}</b></td><td>{{ e.marca }} {{ e.modelo }}</td><td>{{ e.horometroAcumulado }}h</td></tr></table>
          </div>
        </div>
      </section>

      <!-- EQUIPOS (ESTILO FERREYROS: TARJETAS) -->
      <section *ngIf="view==='equipos'" class="pad">
        <div class="toolbar">
          <input class="search" [(ngModel)]="q" placeholder="🔍 Buscar por código, marca o modelo..." />
          <button *ngIf="puede(['ADMIN'])" class="btn-ok" (click)="abrirFormEq()">+ Nuevo Equipo</button>
        </div>
        <div class="grid-maq">
          <div class="maq" *ngFor="let e of filtrarEquipos()">
            <div class="maq-img">🚜<span class="maq-cat">{{ e.categoria?.nombreCategoria }}</span></div>
            <div class="maq-body">
              <h3>{{ e.marca }} {{ e.modelo }}</h3>
              <div class="maq-code">{{ e.codigoPatrimonial }}</div>
              <div class="maq-row"><span>Año:</span><b>{{ e.anioFabricacion }}</b></div>
              <div class="maq-row"><span>Horómetro:</span><b>{{ e.horometroAcumulado }} h</b></div>
            </div>
            <div class="maq-foot" *ngIf="puede(['ADMIN'])">
              <button class="btn-edit" (click)="editarEq(e)">✏️</button>
              <button class="btn-del" (click)="borrarEq(e)">🗑️</button>
            </div>
          </div>
        </div>
      </section>

      <!-- GANTT -->
      <section *ngIf="view==='gantt'" class="pad">
        <button *ngIf="puede(['ADMIN','CLIENTE'])" class="btn-ok" (click)="abrirFormRes()">+ Nueva Reserva</button>
        <div class="card mt">
          <div class="ghead">
            <div class="glabel">Equipo</div>
            <div class="gmonths">
              <span [style.width.%]="31/92*100">JUL 2026</span>
              <span [style.width.%]="31/92*100">AGO 2026</span>
              <span [style.width.%]="30/92*100">SEP 2026</span>
            </div>
          </div>
          <div class="grow" *ngFor="let r of reservas">
            <div class="glabel">{{ r.itemContrato?.equipo?.codigoPatrimonial }}</div>
            <div class="gtrack">
              <div class="gbar" [class.pend]="r.estadoReserva!=='CONFIRMADA'" [class.anul]="r.estadoReserva==='ANULADA'"
                   [style.left.%]="pos(r).left" [style.width.%]="pos(r).width"
                   [title]="r.fechaInicioReserva + ' a ' + r.fechaFinReserva">
                {{ r.fechaInicioReserva | date:'dd/MM' }} → {{ r.fechaFinReserva | date:'dd/MM' }}
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- LIQUIDACIONES -->
      <section *ngIf="view==='liquidaciones'" class="pad">
        <div class="card">
          <table class="t full">
            <thead><tr><th>ID</th><th>Equipo</th><th>H. Base</th><th>H. Extra</th><th>Subtotal</th><th>IGV</th><th>Total</th><th>Estado</th></tr></thead>
            <tbody>
              <tr *ngFor="let l of liq">
                <td>#{{ l.idLiquidacion }}</td>
                <td>{{ l.retorno?.salida?.reserva?.itemContrato?.equipo?.codigoPatrimonial || '-' }}</td>
                <td>{{ l.horasBaseConsumidas | number:'1.2-2' }}</td>
                <td>{{ l.horasExtraCalculadas | number:'1.2-2' }}</td>
                <td>S/ {{ l.subtotal | number:'1.2-2' }}</td>
                <td>S/ {{ l.igv | number:'1.2-2' }}</td>
                <td class="strong">S/ {{ l.totalFacturar | number:'1.2-2' }}</td>
                <td><span class="badge" [class.ok]="l.estadoCobro==='PAGADO'" [class.warn]="l.estadoCobro==='PENDIENTE'">{{ l.estadoCobro }}</span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <!-- CLIENTES -->
      <section *ngIf="view==='clientes'" class="pad">
        <button *ngIf="puede(['ADMIN'])" class="btn-ok" (click)="abrirFormCli()">+ Nuevo Cliente</button>
        <div class="card mt">
          <table class="t full">
            <thead><tr><th>RUC</th><th>Razón Social</th><th>Teléfono</th><th>Email</th></tr></thead>
            <tbody><tr *ngFor="let c of clientes"><td>{{ c.ruc }}</td><td>{{ c.razonSocial }}</td><td>{{ c.telefono }}</td><td>{{ c.emailContacto }}</td></tr></tbody>
          </table>
        </div>
      </section>

      <!-- CONTRATOS -->
      <section *ngIf="view==='contratos'" class="pad">
        <button *ngIf="puede(['ADMIN'])" class="btn-ok" (click)="abrirFormCont()">+ Nuevo Contrato</button>
        <div class="card mt">
          <table class="t full">
            <thead><tr><th>ID</th><th>Cliente</th><th>Inicio</th><th>Fin</th><th>Estado</th></tr></thead>
            <tbody><tr *ngFor="let c of contratos"><td>#{{ c.idContrato }}</td><td>{{ c.cliente?.razonSocial }}</td><td>{{ c.fechaInicio }}</td><td>{{ c.fechaFin }}</td><td><span class="badge ok">{{ c.estadoContrato }}</span></td></tr></tbody>
          </table>
        </div>
      </section>

      <!-- USUARIOS -->
      <section *ngIf="view==='usuarios'" class="pad">
        <button class="btn-ok" (click)="abrirFormUsr()">+ Nuevo Usuario</button>
        <div class="card mt">
          <table class="t full">
            <thead><tr><th>DNI</th><th>Nombres</th><th>Apellidos</th><th>Email</th><th>Rol</th></tr></thead>
            <tbody><tr *ngFor="let u of usuarios"><td>{{ u.dni }}</td><td>{{ u.nombres }}</td><td>{{ u.apellidos }}</td><td>{{ u.email }}</td><td><span class="badge ok">{{ u.rol?.nombreRol }}</span></td></tr></tbody>
          </table>
        </div>
      </section>

      <!-- MANTENIMIENTOS -->
      <section *ngIf="view==='mantenimientos'" class="pad">
        <button class="btn-ok" (click)="abrirFormMan()">+ Registrar Mantenimiento</button>
        <div class="card mt">
          <table class="t full">
            <thead><tr><th>ID</th><th>Equipo</th><th>Tipo</th><th>Horómetro</th><th>Costo</th></tr></thead>
            <tbody><tr *ngFor="let m of mantenimientos"><td>#{{ m.idMantenimiento }}</td><td>{{ m.equipo?.codigoPatrimonial }}</td><td>{{ m.tipoMantenimiento }}</td><td>{{ m.horometroEjecucion }}</td><td>S/ {{ m.costoReparacion }}</td></tr></tbody>
          </table>
        </div>
      </section>

      <!-- DOCUMENTOS -->
      <section *ngIf="view==='documentos'" class="pad">
        <button *ngIf="puede(['ADMIN'])" class="btn-ok" (click)="abrirFormDoc()">+ Registrar Documento</button>
        <div class="card mt">
          <table class="t full">
            <thead><tr><th>Equipo</th><th>Tipo</th><th>N° Póliza</th><th>Vence</th><th>Estado</th></tr></thead>
            <tbody>
              <tr *ngFor="let d of documentos">
                <td>{{ d.equipo?.codigoPatrimonial }}</td><td>{{ d.tipoPoliza }}</td><td>{{ d.numeroPoliza }}</td>
                <td>{{ d.fechaVencimiento }}</td>
                <td><span class="badge" [class.ok]="d.estadoLegal==='VIGENTE'" [class.warn]="d.estadoLegal==='VENCIDO'">{{ d.estadoLegal }}</span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <footer>VALHALA S.A.C. © 2026 | Sistema Web B2B</footer>
    </main>
  </div>

  <!-- MODAL GENÉRICO -->
  <div class="modal-bg" *ngIf="modal" (click)="modal=false">
    <div class="modal" (click)="$event.stopPropagation()">
      <h2>{{ modalTitle }}</h2>

      <!-- FORM EQUIPO -->
      <div *ngIf="modalType==='equipo'">
        <label>Código Patrimonial <input [(ngModel)]="fEq.codigoPatrimonial" /></label>
        <label>Marca <input [(ngModel)]="fEq.marca" /></label>
        <label>Modelo <input [(ngModel)]="fEq.modelo" /></label>
        <label>Año <input type="number" [(ngModel)]="fEq.anioFabricacion" /></label>
        <label>Horómetro <input type="number" [(ngModel)]="fEq.horometroAcumulado" /></label>
        <label>Categoría
          <select [(ngModel)]="fEq.idCategoria">
            <option *ngFor="let c of categorias" [ngValue]="c.idCategoria">{{ c.nombreCategoria }}</option>
          </select>
        </label>
      </div>

      <!-- FORM CLIENTE -->
      <div *ngIf="modalType==='cliente'">
        <label>RUC <input [(ngModel)]="fCli.ruc" /></label>
        <label>Razón Social <input [(ngModel)]="fCli.razonSocial" /></label>
        <label>Dirección <input [(ngModel)]="fCli.direccionFiscal" /></label>
        <label>Teléfono <input [(ngModel)]="fCli.telefono" /></label>
        <label>Email <input [(ngModel)]="fCli.emailContacto" /></label>
      </div>

      <!-- FORM USUARIO -->
      <div *ngIf="modalType==='usuario'">
        <label>DNI <input [(ngModel)]="fUsr.dni" /></label>
        <label>Nombres <input [(ngModel)]="fUsr.nombres" /></label>
        <label>Apellidos <input [(ngModel)]="fUsr.apellidos" /></label>
        <label>Email <input [(ngModel)]="fUsr.email" /></label>
        <label>Contraseña <input type="password" [(ngModel)]="fUsr.password" /></label>
        <label>Rol
          <select [(ngModel)]="fUsr.idRol">
            <option [ngValue]="1">ADMIN</option>
            <option [ngValue]="2">MECANICO</option>
            <option [ngValue]="3">CLIENTE</option>
          </select>
        </label>
      </div>

      <!-- FORM CONTRATO -->
      <div *ngIf="modalType==='contrato'">
        <label>Cliente
          <select [(ngModel)]="fCont.idCliente">
            <option *ngFor="let c of clientes" [ngValue]="c.idCliente">{{ c.razonSocial }}</option>
          </select>
        </label>
        <label>Fecha Inicio <input type="date" [(ngModel)]="fCont.fechaInicio" /></label>
        <label>Fecha Fin <input type="date" [(ngModel)]="fCont.fechaFin" /></label>
      </div>

      <!-- FORM RESERVA -->
      <div *ngIf="modalType==='reserva'">
        <label>ID Ítem Contrato <input type="number" [(ngModel)]="fRes.idItemContrato" /></label>
        <label>Fecha Inicio <input type="date" [(ngModel)]="fRes.fechaInicio" /></label>
        <label>Fecha Fin <input type="date" [(ngModel)]="fRes.fechaFin" /></label>
      </div>

      <!-- FORM MANTENIMIENTO -->
      <div *ngIf="modalType==='mantenimiento'">
        <label>Equipo
          <select [(ngModel)]="fMan.idEquipo">
            <option *ngFor="let e of equipos" [ngValue]="e.idEquipo">{{ e.codigoPatrimonial }} - {{ e.marca }} {{ e.modelo }}</option>
          </select>
        </label>
        <label>Tipo <input [(ngModel)]="fMan.tipoMantenimiento" placeholder="Ej: Preventivo 500h" /></label>
        <label>Horómetro <input type="number" [(ngModel)]="fMan.horometroEjecucion" /></label>
        <label>Costo (S/) <input type="number" [(ngModel)]="fMan.costoReparacion" /></label>
      </div>

      <!-- FORM DOCUMENTO -->
      <div *ngIf="modalType==='documento'">
        <label>Equipo
          <select [(ngModel)]="fDoc.idEquipo">
            <option *ngFor="let e of equipos" [ngValue]="e.idEquipo">{{ e.codigoPatrimonial }}</option>
          </select>
        </label>
        <label>Tipo
          <select [(ngModel)]="fDoc.tipoPoliza">
            <option>SOAT</option><option>TREC</option>
          </select>
        </label>
        <label>N° Póliza <input [(ngModel)]="fDoc.numeroPoliza" /></label>
        <label>Vencimiento <input type="date" [(ngModel)]="fDoc.fechaVencimiento" /></label>
      </div>

      <div class="modal-actions">
        <button class="btn-cancel" (click)="modal=false">Cancelar</button>
        <button class="btn-ok" (click)="guardar()">💾 Guardar</button>
      </div>
    </div>
  </div>
  `,
  styles: [`
    :host { font-family:'Segoe UI',system-ui,sans-serif; color:#1e293b; display:block; min-height:100vh; background:#f1f5f9; }
    .shell { min-height:100vh; display:flex; align-items:center; justify-content:center;
      background:linear-gradient(135deg,#0f2f4f 0%,#134e4a 60%,#0f766e 100%); }
    .login-card { background:#fff; padding:36px 42px; border-radius:16px; width:360px;
      box-shadow:0 20px 50px rgba(0,0,0,.35); text-align:center; }
    .logo { font-size:50px; }
    .login-card h1 { margin:6px 0 0; color:#0f2f4f; font-size:24px; }
    .sub { color:#64748b; font-size:13px; margin:4px 0 18px; }
    .login-card input { width:100%; box-sizing:border-box; padding:11px 12px; margin-bottom:10px;
      border:1px solid #cbd5e1; border-radius:8px; font-size:14px; }
    .login-card input:focus { outline:2px solid #0f766e; border-color:transparent; }
    .btn-primary { width:100%; padding:12px; border:0; border-radius:8px; cursor:pointer;
      background:linear-gradient(90deg,#0f2f4f,#0f766e); color:#fff; font-weight:700; font-size:14px; margin-top:8px; }
    .btn-primary:hover { filter:brightness(1.15); }
    .err { color:#dc2626; font-size:13px; margin-top:8px; }
    .hint { margin-top:16px; font-size:11px; color:#94a3b8; text-align:left; line-height:1.5; }

    .layout { display:flex; min-height:100vh; }
    .sidebar { width:240px; background:#0f2f4f; color:#cbd5e1; padding:0; position:sticky; top:0; height:100vh; display:flex; flex-direction:column; }
    .sbrand { padding:20px; background:#0a2540; color:#fff; font-weight:800; font-size:18px; line-height:1.2; }
    .sbrand small { color:#f59e0b; font-weight:400; font-size:11px; letter-spacing:2px; }
    .suser { padding:16px 20px; border-bottom:1px solid #1e3a5f; display:flex; gap:12px; align-items:center; }
    .avatar { width:40px; height:40px; background:#f59e0b; color:#0f2f4f; border-radius:50%; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:18px; }
    .uname { font-size:13px; color:#fff; }
    .urole { font-size:10px; background:#0f766e; padding:2px 8px; border-radius:999px; color:#fff; }
    .snav { flex:1; padding:16px 0; overflow-y:auto; }
    .sec { font-size:10px; color:#64748b; letter-spacing:1.5px; padding:12px 20px 6px; font-weight:700; }
    .snav a { display:block; padding:10px 20px; color:#cbd5e1; cursor:pointer; font-size:13px; border-left:3px solid transparent; }
    .snav a:hover { background:#1e3a5f; color:#fff; }
    .snav a.on { background:#1e3a5f; color:#fff; border-left-color:#f59e0b; }
    .btn-out { margin:16px; padding:10px; background:transparent; color:#cbd5e1; border:1px solid #64748b; border-radius:8px; cursor:pointer; font-size:12px; }
    .btn-out:hover { background:#dc2626; border-color:#dc2626; color:#fff; }

    .content { flex:1; overflow-x:hidden; }
    .topbar { background:#fff; padding:14px 28px; border-bottom:1px solid #e2e8f0; display:flex; justify-content:space-between; align-items:center; position:sticky; top:0; z-index:3; }
    .topbar h1 { font-size:18px; color:#0f2f4f; margin:0; }
    .chip { font-size:12px; color:#64748b; }
    .pad { padding:22px 28px; }

    .kpis { display:grid; grid-template-columns:repeat(4,1fr); gap:14px; margin-bottom:20px; }
    .kpi { background:#fff; border-radius:12px; padding:18px; box-shadow:0 2px 6px rgba(15,47,79,.06); border-left:4px solid #0f766e; }
    .kpi .n { font-size:26px; font-weight:800; color:#0f2f4f; }
    .kpi .l { font-size:11px; color:#64748b; text-transform:uppercase; letter-spacing:.5px; margin-top:4px; }
    .kpi.gold { border-left-color:#f59e0b; }
    .kpi.gold .n { color:#b45309; }

    .grid2 { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
    .card { background:#fff; border-radius:12px; padding:20px; box-shadow:0 2px 6px rgba(15,47,79,.06); }
    .card h3 { margin:0 0 14px; color:#0f2f4f; font-size:15px; }
    .card.mt { margin-top:14px; }

    .toolbar { display:flex; gap:10px; margin-bottom:14px; }
    .search { flex:1; padding:10px 14px; border:1px solid #cbd5e1; border-radius:8px; font-size:13px; background:#fff; }
    .btn-ok { padding:10px 18px; background:#0f766e; color:#fff; border:0; border-radius:8px; cursor:pointer; font-weight:600; font-size:13px; }
    .btn-ok:hover { background:#0a5f58; }
    .btn-edit { background:#0ea5e9; color:#fff; border:0; padding:6px 10px; border-radius:6px; cursor:pointer; font-size:12px; }
    .btn-del { background:#dc2626; color:#fff; border:0; padding:6px 10px; border-radius:6px; cursor:pointer; font-size:12px; }
    .btn-cancel { padding:10px 18px; background:#e2e8f0; color:#334155; border:0; border-radius:8px; cursor:pointer; font-weight:600; }

    /* FERREYROS STYLE: TARJETAS DE MAQUINARIA */
    .grid-maq { display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:16px; }
    .maq { background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 2px 10px rgba(15,47,79,.1); transition:transform .2s, box-shadow .2s; border:1px solid #e2e8f0; }
    .maq:hover { transform:translateY(-4px); box-shadow:0 10px 25px rgba(15,47,79,.15); }
    .maq-img { background:linear-gradient(135deg,#f59e0b,#d97706); height:110px; display:flex; align-items:center; justify-content:center; font-size:56px; position:relative; }
    .maq-cat { position:absolute; top:10px; left:10px; background:rgba(15,47,79,.85); color:#fff; padding:3px 10px; border-radius:999px; font-size:10px; font-weight:700; }
    .maq-body { padding:14px 16px; }
    .maq-body h3 { margin:0 0 4px; color:#0f2f4f; font-size:15px; }
    .maq-code { font-family:'Courier New',monospace; color:#0f766e; font-weight:700; font-size:12px; margin-bottom:10px; }
    .maq-row { display:flex; justify-content:space-between; font-size:12px; color:#64748b; padding:2px 0; }
    .maq-row b { color:#0f2f4f; }
    .maq-foot { padding:10px 16px; background:#f8fafc; border-top:1px solid #e2e8f0; display:flex; gap:8px; justify-content:flex-end; }

    /* GANTT */
    .ghead, .grow { display:flex; align-items:center; margin:6px 0; }
    .glabel { width:90px; font-weight:700; font-size:12px; color:#0f2f4f; }
    .gmonths { display:flex; flex:1; font-size:10px; color:#64748b; font-weight:700; text-transform:uppercase; }
    .gmonths span { text-align:center; border-left:1px solid #e2e8f0; padding:4px 0; }
    .gtrack { position:relative; flex:1; background:#e2e8f0; height:30px; border-radius:6px; }
    .gbar { position:absolute; top:3px; bottom:3px; background:linear-gradient(90deg,#16a34a,#15803d);
      color:#fff; font-size:10px; border-radius:6px; padding:0 8px; display:flex; align-items:center;
      overflow:hidden; white-space:nowrap; box-shadow:0 1px 3px rgba(0,0,0,.25); font-weight:600; }
    .gbar.pend { background:linear-gradient(90deg,#f59e0b,#d97706); }
    .gbar.anul { background:#94a3b8; text-decoration:line-through; }

    /* TABLAS */
    table.t { width:100%; border-collapse:collapse; font-size:13px; }
    table.t.full { width:100%; }
    table.t th { background:#0f2f4f; color:#fff; text-align:left; padding:10px 12px; font-weight:600; font-size:11px; text-transform:uppercase; letter-spacing:.5px; }
    table.t td { padding:10px 12px; border-bottom:1px solid #e2e8f0; }
    table.t tbody tr:hover { background:#f8fafc; }
    .strong { font-weight:800; color:#0f2f4f; }
    .badge { padding:3px 10px; border-radius:999px; font-size:10px; font-weight:700; background:#e2e8f0; color:#334155; text-transform:uppercase; }
    .badge.ok { background:#dcfce7; color:#15803d; }
    .badge.warn { background:#fef3c7; color:#b45309; }

    /* MODAL */
    .modal-bg { position:fixed; inset:0; background:rgba(15,47,79,.6); display:flex; align-items:center; justify-content:center; z-index:100; backdrop-filter:blur(4px); }
    .modal { background:#fff; border-radius:12px; padding:26px; width:440px; max-height:85vh; overflow-y:auto; box-shadow:0 25px 60px rgba(0,0,0,.35); }
    .modal h2 { margin:0 0 18px; color:#0f2f4f; font-size:18px; }
    .modal label { display:block; font-size:12px; font-weight:600; color:#334155; margin-bottom:12px; }
    .modal input, .modal select { width:100%; box-sizing:border-box; padding:9px 12px; margin-top:4px; border:1px solid #cbd5e1; border-radius:6px; font-size:13px; }
    .modal input:focus, .modal select:focus { outline:2px solid #0f766e; border-color:transparent; }
    .modal-actions { display:flex; gap:10px; justify-content:flex-end; margin-top:20px; }

    footer { text-align:center; color:#94a3b8; font-size:11px; padding:30px; }
  `]
})
export class AppComponent implements OnInit {
  email = ''; password = ''; error = '';
  view = 'dash';
  modal = false; modalType = ''; modalTitle = '';

  equipos: any[] = []; categorias: any[] = []; clientes: any[] = [];
  usuarios: any[] = []; contratos: any[] = []; reservas: any[] = [];
  liq: any[] = []; documentos: any[] = []; mantenimientos: any[] = [];
  q = '';

  fEq: any = {}; fCli: any = {}; fUsr: any = {}; fCont: any = {}; fRes: any = {}; fMan: any = {}; fDoc: any = {};
  editEqId: number | null = null;

  constructor(public auth: AuthService, private api: ApiService) {}

  ngOnInit() { if (this.auth.isLoggedIn) this.cargarTodo(); }

  puede(roles: string[]) { return roles.includes(this.auth.rol); }

  entrar() {
    this.auth.login(this.email, this.password).subscribe({
      next: (r) => { this.auth.setSession(r); this.error = ''; this.cargarTodo(); },
      error: () => (this.error = 'Credenciales inválidas')
    });
  }

  salir() { this.auth.logout(); location.reload(); }

  cargarTodo() {
    this.cargarEquipos(); this.cargarGantt(); this.cargarLiq();
    this.cargarCli(); this.cargarCont();
    if (this.auth.rol === 'ADMIN') this.cargarUsr();
    this.cargarMan(); this.cargarDoc();
    this.api.categorias().subscribe((c) => (this.categorias = c));
  }

  cargarEquipos() { this.api.equipos().subscribe((r) => (this.equipos = r)); }
  cargarGantt() { this.api.gantt().subscribe((r) => (this.reservas = r)); }
  cargarLiq() { this.api.liquidaciones().subscribe({ next: (r) => (this.liq = r), error: () => (this.liq = []) }); }
  cargarCli() { this.api.clientes().subscribe((r) => (this.clientes = r)); }
  cargarCont() { this.api.contratos().subscribe((r) => (this.contratos = r)); }
  cargarUsr() { this.api.usuarios().subscribe({ next: (r) => (this.usuarios = r), error: () => {} }); }
  cargarMan() { this.api.mantenimientos().subscribe((r) => (this.mantenimientos = r)); }
  cargarDoc() { this.api.documentos().subscribe((r) => (this.documentos = r)); }

  tituloView() {
    const m: any = { dash:'📊 Dashboard Ejecutivo', equipos:'🚜 Flota de Maquinaria', gantt:'📅 Reservas (Gantt)', liquidaciones:'💰 Liquidaciones Financieras', clientes:'🏢 Clientes Corporativos', contratos:'📜 Contratos', usuarios:'👥 Usuarios del Sistema', mantenimientos:'🔧 Mantenimientos de Taller', documentos:'📋 Documentos Legales' };
    return m[this.view] || 'VALHALA S.A.C.';
  }

  totalPorCobrar() { return this.liq.filter(l => l.estadoCobro === 'PENDIENTE').reduce((s, l) => s + Number(l.totalFacturar), 0); }
  filtrarEquipos() {
    const q = this.q.toLowerCase();
    return this.equipos.filter(e => !q || (e.codigoPatrimonial||'').toLowerCase().includes(q) || (e.marca||'').toLowerCase().includes(q) || (e.modelo||'').toLowerCase().includes(q));
  }

  pos(r: any) {
    const start = Date.parse('2026-07-01'); const total = 92 * 86400000;
    const i = Date.parse(r.fechaInicioReserva) - start; const f = Date.parse(r.fechaFinReserva) - start;
    const left = Math.max(0, Math.min(100, (i/total)*100));
    const width = Math.max(2, Math.min(100-left, ((f-i)/total)*100));
    return { left, width };
  }

  // === CRUD EQUIPOS ===
  abrirFormEq() { this.editEqId = null; this.fEq = { anioFabricacion: 2024, horometroAcumulado: 0 }; this.modalType='equipo'; this.modalTitle='Nuevo Equipo'; this.modal=true; }
  editarEq(e: any) { this.editEqId = e.idEquipo; this.fEq = { idCategoria: e.categoria?.idCategoria, codigoPatrimonial: e.codigoPatrimonial, marca: e.marca, modelo: e.modelo, anioFabricacion: e.anioFabricacion, horometroAcumulado: e.horometroAcumulado }; this.modalType='equipo'; this.modalTitle='Editar Equipo'; this.modal=true; }
  borrarEq(e: any) { if (confirm('¿Eliminar ' + e.codigoPatrimonial + '?')) this.api.eliminarEquipo(e.idEquipo).subscribe(() => this.cargarEquipos()); }

  abrirFormCli() { this.fCli = {}; this.modalType='cliente'; this.modalTitle='Nuevo Cliente'; this.modal=true; }
  abrirFormUsr() { this.fUsr = { idRol: 1 }; this.modalType='usuario'; this.modalTitle='Nuevo Usuario'; this.modal=true; }
  abrirFormCont() { this.fCont = {}; this.modalType='contrato'; this.modalTitle='Nuevo Contrato'; this.modal=true; }
  abrirFormRes() { this.fRes = {}; this.modalType='reserva'; this.modalTitle='Nueva Reserva'; this.modal=true; }
  abrirFormMan() { this.fMan = {}; this.modalType='mantenimiento'; this.modalTitle='Registrar Mantenimiento'; this.modal=true; }
  abrirFormDoc() { this.fDoc = { tipoPoliza: 'SOAT' }; this.modalType='documento'; this.modalTitle='Registrar Documento'; this.modal=true; }

  guardar() {
    const done = () => { this.modal = false; this.cargarTodo(); };
    if (this.modalType === 'equipo') {
      const op = this.editEqId ? this.api.actualizarEquipo(this.editEqId, this.fEq) : this.api.crearEquipo(this.fEq);
      op.subscribe({ next: done, error: (e) => alert('Error: ' + (e.error?.error || e.message)) });
    } else if (this.modalType === 'cliente') this.api.crearCliente(this.fCli).subscribe({ next: done, error: (e) => alert('Error: ' + (e.error?.error || e.message)) });
    else if (this.modalType === 'usuario') this.api.crearUsuario(this.fUsr).subscribe({ next: done, error: (e) => alert('Error: ' + (e.error?.error || e.message)) });
    else if (this.modalType === 'contrato') this.api.crearContrato(this.fCont).subscribe({ next: done, error: (e) => alert('Error: ' + (e.error?.error || e.message)) });
    else if (this.modalType === 'reserva') this.api.crearReserva(this.fRes).subscribe({ next: done, error: (e) => alert(e.error?.error || 'Colisión de fechas (RF-01)') });
    else if (this.modalType === 'mantenimiento') this.api.crearMantenimiento(this.fMan).subscribe({ next: done, error: (e) => alert('Error: ' + (e.error?.error || e.message)) });
    else if (this.modalType === 'documento') this.api.crearDocumento(this.fDoc).subscribe({ next: done, error: (e) => alert('Error: ' + (e.error?.error || e.message)) });
  }
}
'@, $utf8)

Write-Host "FRONTEND PROFESIONAL GENERADO!"