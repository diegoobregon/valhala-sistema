import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { AuthService } from '../core/auth.service';

@Component({
  selector: 'app-shell',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive],
  template: `
  <header>
    <h1>VAL<span>HALA</span> <small>Control de Flota B2B</small></h1>
    <div class="user">
      @if (auth.empresa()) {
        <span class="empresa-chip">🏢 {{ auth.empresa() }}</span>
      }
      <span>{{ auth.nombres() }}</span>
      <span class="badge b-am">{{ auth.rol() }}</span>
      <button class="ghost" (click)="auth.logout()">Salir</button>
    </div>
  </header>

  <nav>
    <a routerLink="/gantt" routerLinkActive="on">Dashboard Gantt</a>
    <a routerLink="/equipos" routerLinkActive="on">Flota</a>
    <a routerLink="/contratos" routerLinkActive="on">Contratos</a>
    <a routerLink="/transacciones" routerLinkActive="on">Check-out / Check-in</a>
    <a routerLink="/liquidaciones" routerLinkActive="on">Liquidaciones</a>
    <a routerLink="/documentos" routerLinkActive="on">Documentos y taller</a>
    @if (auth.esAdmin()) { <a routerLink="/usuarios" routerLinkActive="on">Usuarios</a> }
  </nav>

  <main><router-outlet></router-outlet></main>`,
  styles: [`
    header{background:#0d1013;border-bottom:3px solid #f59e0b;padding:14px 26px;
      display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px}
    header h1{font-size:17px;letter-spacing:2px;color:#fff}
    header h1 span{color:#f59e0b}
    header h1 small{font-weight:400;color:#8b949e;letter-spacing:0;margin-left:10px;font-size:12px}
    .user{display:flex;align-items:center;gap:10px;font-size:13px;color:#c9d1d9}
    .empresa-chip{background:#3b82f622;color:#3b82f6;padding:4px 10px;border-radius:4px;font-size:12px;font-weight:600;border:1px solid #3b82f644}
    nav{display:flex;gap:4px;flex-wrap:wrap;padding:12px 26px;background:#11151a;border-bottom:1px solid #30363d}
    nav a{color:#c9d1d9;text-decoration:none;padding:8px 14px;border-radius:6px;font-size:13px}
    nav a:hover{background:#1c232a}
    nav a.on{background:#f59e0b;color:#111;font-weight:700}
    main{max-width:1180px;margin:0 auto;padding:24px}
    .badge{padding:3px 8px;border-radius:4px;font-size:11px;font-weight:700}
    .b-am{background:#f59e0b;color:#111}
    .ghost{background:transparent;border:1px solid #30363d;color:#c9d1d9;padding:6px 12px;border-radius:4px;cursor:pointer;font-size:12px}
    .ghost:hover{background:#30363d}
  `]
})
export class ShellComponent {
  auth = inject(AuthService);
}