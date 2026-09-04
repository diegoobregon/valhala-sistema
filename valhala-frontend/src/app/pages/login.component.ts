import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../core/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [ReactiveFormsModule, RouterLink],
  template: `
  <div class="wrap">
    <div class="card">
      <div class="logo">VAL<span>HALA</span> S.A.C.</div>
      <p class="muted" style="margin-bottom:22px">Control de Flota y Logistica de Linea Amarilla</p>

      <form [formGroup]="form" (ngSubmit)="entrar()">
        <label>Correo corporativo</label>
        <input type="email" formControlName="email" placeholder="admin@valhala.pe">
        @if (form.controls.email.touched && form.controls.email.invalid) {
          <small class="err">Correo requerido y con formato valido.</small>
        }

        <label>Contrasena</label>
        <input type="password" formControlName="password" placeholder="********">
        @if (form.controls.password.touched && form.controls.password.invalid) {
          <small class="err">Minimo 6 caracteres.</small>
        }

        <button type="submit" style="width:100%;margin-top:8px" [disabled]="form.invalid || cargando()">
          {{ cargando() ? 'Verificando...' : 'Ingresar' }}
        </button>
      </form>

      @if (error()) { <div class="msg er">{{ error() }}</div> }
      @if (noVerificada()) {
        <div class="msg am">
          Tu empresa está pendiente de verificación.<br>
          <button class="ghost" (click)="irAVerificar()" style="margin-top:8px">
            Ingresar código de verificación →
          </button>
        </div>
      }
      <p class="muted" style="margin-top:18px;text-align:center">
        ¿Eres empresa nueva? <a routerLink="/registro">Regístrate aquí</a>
      </p>
      <p class="muted" style="margin-top:8px;text-align:center;font-size:11px">
        Autenticacion JWT + BCrypt (RNF-05)
      </p>
    </div>
  </div>`,
  styles: [`
    .wrap{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px}
    .card{width:100%;max-width:390px;background:#161b22;padding:30px;border-radius:10px;border:1px solid #30363d}
    .logo{font-size:24px;font-weight:700;letter-spacing:3px;color:#fff}
    .logo span{color:#f59e0b}
    .err{color:#f85149;font-size:12px;display:block;margin:-8px 0 10px}
    .msg{padding:12px;margin-top:12px;border-radius:4px;font-size:14px}
    .msg.er{background:#f8514922;border-left:4px solid #f85149;color:#f85149}
    .msg.am{background:#f59e0b22;border-left:4px solid #f59e0b;color:#f59e0b}
    .msg.am button{background:transparent;border:1px solid #f59e0b;color:#f59e0b;padding:6px 12px;border-radius:4px;cursor:pointer}
    .msg.am button:hover{background:#f59e0b33}
    a{color:#f59e0b;text-decoration:none}
    a:hover{text-decoration:underline}
    .muted{color:#8b949e;font-size:13px}
    label{display:block;font-size:13px;color:#c9d1d9;margin:10px 0 4px}
    input{width:100%;padding:10px;background:#0d1117;border:1px solid #30363d;border-radius:6px;color:#fff;font-size:14px}
    button{padding:12px;background:#f59e0b;color:#111;border:none;border-radius:6px;font-weight:700;cursor:pointer;font-size:15px}
    button:disabled{opacity:0.5;cursor:not-allowed}
  `]
})
export class LoginComponent {
  private fb = inject(FormBuilder);
  private auth = inject(AuthService);
  private router = inject(Router);

  cargando = signal(false);
  error = signal('');
  noVerificada = signal(false);
  emailPendiente = '';

  form = this.fb.nonNullable.group({
    email: ['admin@valhala.pe', [Validators.required, Validators.email]],
    password: ['admin123', [Validators.required, Validators.minLength(6)]]
  });

  entrar() {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.cargando.set(true);
    this.error.set('');
    this.noVerificada.set(false);
    
    this.auth.login(this.form.getRawValue()).subscribe({
      next: () => { 
        this.cargando.set(false); 
        this.router.navigate(['/gantt']); 
      },
      error: (e: any) => {
        this.cargando.set(false);
        const msg = e.error?.message || e.error?.mensaje || '';
        if (e.status === 403 && (msg.includes('verificada') || msg.includes('verificado'))) {
          this.noVerificada.set(true);
          this.emailPendiente = this.form.getRawValue().email;
          localStorage.setItem('valhala_email_pendiente', this.emailPendiente);
        } else if (e.status === 401 || e.status === 403) {
          this.error.set('Credenciales invalidas.');
        } else {
          this.error.set('No hay conexion con el backend (puerto 8080).');
        }
      }
    });
  }

  irAVerificar() {
    this.router.navigate(['/verificar']);
  }
}