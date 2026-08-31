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
    header{background:#0d1013;border-bottom:3px solid var(--am);padding:14px 26px;
      display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px}
    header h1{font-size:17px;letter-spacing:2px}
    header h1 span{color:var(--am)}
    header small{font-weight:400;color:var(--mut);letter-spacing:0;margin-left:10px;font-size:12px}
    .user{display:flex;align-items:center;gap:10px;font-size:13px}
    nav{display:flex;gap:4px;flex-wrap:wrap;padding:12px 26px;background:#11151a;border-bottom:1px solid var(--bd)}
    nav a{color:var(--tx);text-decoration:none;padding:8px 14px;border-radius:6px;font-size:13px}
    nav a:hover{background:#1c232a}
    nav a.on{background:var(--am);color:#111;font-weight:700}
    main{max-width:1180px;margin:0 auto;padding:24px}
  `]
})
export class ShellComponent {
  auth = inject(AuthService);
}
