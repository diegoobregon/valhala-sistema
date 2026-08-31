import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../core/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [ReactiveFormsModule],
  template: `
  <div class="wrap">
    <div class="card">
      <div class="logo">VAL<span>HALA</span> S.A.C.</div>
      <p class="muted" style="margin-bottom:22px">Control de Flota y Logistica de Linea Amarilla</p>

      <form [formGroup]="form" (ngSubmit)="entrar()">
        <label>Correo corporativo</label>
        <input type="email" formControlName="email" placeholder="admin&#64;valhala.pe">
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
      <p class="muted" style="margin-top:18px">Autenticacion JWT + BCrypt (RNF-05)</p>
    </div>
  </div>`,
  styles: [`
    .wrap{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px}
    .card{width:100%;max-width:390px}
    .logo{font-size:24px;font-weight:700;letter-spacing:3px}
    .logo span{color:var(--am)}
    .err{color:var(--er);font-size:12px;display:block;margin:-8px 0 10px}
  `]
})
export class LoginComponent {
  private fb = inject(FormBuilder);
  private auth = inject(AuthService);
  private router = inject(Router);

  cargando = signal(false);
  error = signal('');

  form = this.fb.nonNullable.group({
    email: ['admin@valhala.pe', [Validators.required, Validators.email]],
    password: ['admin123', [Validators.required, Validators.minLength(6)]]
  });

  entrar() {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.cargando.set(true);
    this.error.set('');
    this.auth.login(this.form.getRawValue()).subscribe({
      next: () => { this.cargando.set(false); this.router.navigate(['/gantt']); },
      error: (e: any) => {
        this.cargando.set(false);
        this.error.set(e.status === 401 || e.status === 403
          ? 'Credenciales invalidas.'
          : 'No hay conexion con el backend (puerto 8080).');
      }
    });
  }
}
