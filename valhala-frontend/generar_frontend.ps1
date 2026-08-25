$root = "D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-frontend"
$utf8 = New-Object System.Text.UTF8Encoding $false
function W($rel, $content) {
    $path = Join-Path $root $rel
    $dir = Split-Path $path -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::WriteAllText($path, $content, $utf8)
    Write-Host "OK $rel"
}

W "src\app\interceptors\auth.interceptor.ts" @'
import { HttpInterceptorFn } from '@angular/common/http';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const token = localStorage.getItem('valhala_token');
  if (token) {
    req = req.clone({ setHeaders: { Authorization: 'Bearer ' + token } });
  }
  return next(req);
};
'@

W "src\app\services\auth.service.ts" @'
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface LoginResponse { token: string; rol: string; nombres: string; }

@Injectable({ providedIn: 'root' })
export class AuthService {
  private base = 'http://localhost:8080/api/v1';
  constructor(private http: HttpClient) {}

  login(email: string, password: string): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(this.base + '/auth/login', { email, password });
  }
  setSession(r: LoginResponse) {
    localStorage.setItem('valhala_token', r.token);
    localStorage.setItem('valhala_rol', r.rol);
    localStorage.setItem('valhala_nombres', r.nombres);
  }
  get token() { return localStorage.getItem('valhala_token'); }
  get rol() { return localStorage.getItem('valhala_rol') || ''; }
  get nombres() { return localStorage.getItem('valhala_nombres') || ''; }
  get isLoggedIn() { return !!this.token; }
  logout() { localStorage.removeItem('valhala_token'); localStorage.removeItem('valhala_rol'); localStorage.removeItem('valhala_nombres'); }
}
'@

W "src\app\services\api.service.ts" @'
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private base = 'http://localhost:8080/api/v1';
  constructor(private http: HttpClient) {}
  equipos(): Observable<any[]> { return this.http.get<any[]>(this.base + '/equipos'); }
  gantt(): Observable<any[]> { return this.http.get<any[]>(this.base + '/reservas/gantt'); }
  liquidaciones(): Observable<any[]> { return this.http.get<any[]>(this.base + '/liquidaciones'); }
}
'@

W "src\app\app.config.ts" @'
import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { authInterceptor } from './interceptors/auth.interceptor';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideHttpClient(withInterceptors([authInterceptor]))
  ]
};
'@

W "src\app\app.component.ts" @'
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
  <div class="app">
    <header class="top">
      <h1>VALHALA S.A.C. — Control de Flota B2B</h1>
      <div *ngIf="auth.isLoggedIn" class="user">
        {{ auth.nombres }} ({{ auth.rol }})
        <button (click)="salir()">Salir</button>
      </div>
    </header>

    <div *ngIf="!auth.isLoggedIn" class="login-box">
      <h2>Iniciar Sesion</h2>
      <input [(ngModel)]="email" placeholder="correo corporativo" />
      <input [(ngModel)]="password" type="password" placeholder="contrasena" />
      <button (click)="entrar()">Ingresar</button>
      <p class="err" *ngIf="error">{{ error }}</p>
    </div>

    <div *ngIf="auth.isLoggedIn">
      <nav>
        <button [class.on]="tab==='gantt'" (click)="tab='gantt'">Gantt Reservas</button>
        <button [class.on]="tab==='liq'" (click)="tab='liq'">Liquidaciones</button>
        <button [class.on]="tab==='eq'" (click)="tab='eq'">Equipos</button>
      </nav>

      <section *ngIf="tab==='gantt'">
        <h2>Diagrama de Gantt — Disponibilidad (RF-02)</h2>
        <div class="gantt">
          <div class="grow" *ngFor="let r of reservas">
            <div class="glabel">{{ r.itemContrato?.equipo?.codigoPatrimonial }}</div>
            <div class="gtrack">
              <div class="gbar" [class.conf]="r.estadoReserva==='CONFIRMADA'"
                   [style.left.%]="pos(r).left" [style.width.%]="pos(r).width">
                {{ r.fechaInicioReserva }} a {{ r.fechaFinReserva }}
              </div>
            </div>
          </div>
        </div>
      </section>

      <section *ngIf="tab==='liq'">
        <h2>Liquidaciones Financieras (RF-05)</h2>
        <table>
          <tr><th>ID</th><th>Horas Base</th><th>Horas Extra</th><th>Subtotal</th><th>IGV</th><th>Total</th><th>Estado</th></tr>
          <tr *ngFor="let l of liquidaciones">
            <td>{{ l.idLiquidacion }}</td>
            <td>{{ l.horasBaseConsumidas }}</td>
            <td>{{ l.horasExtraCalculadas }}</td>
            <td>S/ {{ l.subtotal }}</td>
            <td>S/ {{ l.igv }}</td>
            <td><b>S/ {{ l.totalFacturar }}</b></td>
            <td>{{ l.estadoCobro }}</td>
          </tr>
        </table>
      </section>

      <section *ngIf="tab==='eq'">
        <h2>Flota de Maquinaria</h2>
        <table>
          <tr><th>Codigo</th><th>Marca</th><th>Modelo</th><th>Anio</th><th>Horometro</th></tr>
          <tr *ngFor="let e of equipos">
            <td>{{ e.codigoPatrimonial }}</td><td>{{ e.marca }}</td><td>{{ e.modelo }}</td>
            <td>{{ e.anioFabricacion }}</td><td>{{ e.horometroAcumulado }}</td>
          </tr>
        </table>
      </section>
    </div>
  </div>
  `,
  styles: [`
    :host { font-family: 'Segoe UI', sans-serif; }
    .app { max-width: 1100px; margin: 0 auto; padding: 16px; }
    .top { display:flex; justify-content:space-between; align-items:center; background:#123a5c; color:#fff; padding:12px 16px; border-radius:8px; }
    .top h1 { font-size:18px; margin:0; }
    .login-box { max-width:340px; margin:60px auto; padding:24px; border:1px solid #ccc; border-radius:10px; display:flex; flex-direction:column; gap:10px; }
    .login-box input { padding:10px; }
    button { padding:8px 14px; cursor:pointer; }
    nav { margin:16px 0; display:flex; gap:8px; }
    nav button.on { background:#123a5c; color:#fff; }
    table { width:100%; border-collapse:collapse; }
    th,td { border:1px solid #ddd; padding:8px; text-align:left; }
    th { background:#123a5c; color:#fff; }
    .grow { display:flex; align-items:center; margin:6px 0; }
    .glabel { width:90px; font-weight:600; }
    .gtrack { position:relative; flex:1; background:#eee; height:26px; border-radius:4px; }
    .gbar { position:absolute; top:2px; bottom:2px; background:#f80; color:#fff; font-size:11px; border-radius:4px; padding:3px 6px; overflow:hidden; white-space:nowrap; }
    .gbar.conf { background:#2a7d4f; }
    .err { color:#c00; }
  `]
})
export class AppComponent implements OnInit {
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
    this.api.liquidaciones().subscribe((r) => (this.liquidaciones = r));
    this.api.equipos().subscribe((r) => (this.equipos = r));
  }

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
'@

$html = [System.IO.File]::ReadAllText("$root\index.html")
$html = $html -replace '<title>.*</title>', '<title>VALHALA S.A.C. | Control de Flota</title>'
[System.IO.File]::WriteAllText("$root\index.html", $html, $utf8)
Write-Host "FRONTEND GENERADO!"