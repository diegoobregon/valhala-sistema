import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { RegistroRequest, RegistroResponse } from '../core/models';

@Component({
  selector: 'app-registro',
  standalone: true,
  imports: [ReactiveFormsModule, RouterLink],
  template: `
  <div class="wrap">
    <div class="card">
      <div class="logo">VAL<span>HALA</span> <small>Registro de Empresa</small></div>
      <p class="muted" style="margin-bottom:22px">Crea tu cuenta corporativa SaaS</p>

      <form [formGroup]="form" (ngSubmit)="registrar()">
        <h3 style="margin-top:0">Datos de la empresa</h3>
        <label>RUC (11 dígitos)</label>
        <input formControlName="ruc" maxlength="11" placeholder="20555555555">
        @if (form.controls.ruc.touched && form.controls.ruc.invalid) {
          <small class="err">RUC debe tener 11 dígitos.</small>
        }

        <label>Razón social</label>
        <input formControlName="razonSocial" placeholder="ANDINA MAQUINARIAS S.A.C.">
        @if (form.controls.razonSocial.touched && form.controls.razonSocial.invalid) {
          <small class="err">Razón social requerida.</small>
        }

        <label>Email de contacto</label>
        <input type="email" formControlName="emailContacto" placeholder="admin@andina.pe">
        @if (form.controls.emailContacto.touched && form.controls.emailContacto.invalid) {
          <small class="err">Email válido requerido.</small>
        }

        <h3>Datos del administrador</h3>
        <div class="grid2">
          <div>
            <label>Nombres</label>
            <input formControlName="nombresAdmin" placeholder="Juan">
          </div>
          <div>
            <label>Apellidos</label>
            <input formControlName="apellidosAdmin" placeholder="Perez">
          </div>
        </div>
        <label>DNI (8 dígitos)</label>
        <input formControlName="dniAdmin" maxlength="8" placeholder="87654321">
        @if (form.controls.dniAdmin.touched && form.controls.dniAdmin.invalid) {
          <small class="err">DNI debe tener 8 dígitos.</small>
        }

        <label>Contraseña (mínimo 6)</label>
        <input type="password" formControlName="password" placeholder="********">
        @if (form.controls.password.touched && form.controls.password.invalid) {
          <small class="err">Mínimo 6 caracteres.</small>
        }

        <button type="submit" style="width:100%;margin-top:12px" [disabled]="form.invalid || cargando()">
          {{ cargando() ? 'Registrando...' : 'Registrar empresa' }}
        </button>
      </form>

      @if (error()) { <div class="msg er">{{ error() }}</div> }
      <p class="muted" style="margin-top:18px;text-align:center">
        ¿Ya tienes cuenta? <a routerLink="/login">Inicia sesión</a>
      </p>
    </div>
  </div>`,
  styles: [`
    .wrap{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px}
    .card{width:100%;max-width:520px;background:#161b22;padding:30px;border-radius:10px;border:1px solid #30363d}
    .logo{font-size:24px;font-weight:700;letter-spacing:3px;margin-bottom:8px;color:#fff}
    .logo span{color:#f59e0b}
    .logo small{font-size:13px;font-weight:400;color:#8b949e;margin-left:10px}
    .err{color:#f85149;font-size:12px;display:block;margin:-8px 0 10px}
    .grid2{display:grid;grid-template-columns:1fr 1fr;gap:12px}
    h3{font-size:14px;color:#f59e0b;margin:18px 0 10px;padding-top:14px;border-top:1px solid #30363d}
    a{color:#f59e0b;text-decoration:none}
    a:hover{text-decoration:underline}
    .muted{color:#8b949e;font-size:13px}
    label{display:block;font-size:13px;color:#c9d1d9;margin:10px 0 4px}
    input{width:100%;padding:10px;background:#0d1117;border:1px solid #30363d;border-radius:6px;color:#fff;font-size:14px}
    button{padding:12px;background:#f59e0b;color:#111;border:none;border-radius:6px;font-weight:700;cursor:pointer;font-size:15px}
    button:disabled{opacity:0.5;cursor:not-allowed}
    .msg{padding:12px;margin-top:12px;border-radius:4px;font-size:14px}
    .msg.er{background:#f8514922;border-left:4px solid #f85149;color:#f85149}
  `]
})
export class RegistroComponent {
  private fb = inject(FormBuilder);
  private http = inject(HttpClient);
  private router = inject(Router);

  cargando = signal(false);
  error = signal('');

  form = this.fb.nonNullable.group({
    ruc: ['', [Validators.required, Validators.pattern(/^\d{11}$/)]],
    razonSocial: ['', Validators.required],
    emailContacto: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(6)]],
    nombresAdmin: ['', Validators.required],
    apellidosAdmin: ['', Validators.required],
    dniAdmin: ['', [Validators.required, Validators.pattern(/^\d{8}$/)]]
  });

  registrar() {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.cargando.set(true);
    this.error.set('');
    
    const body: RegistroRequest = this.form.getRawValue();
    this.http.post<RegistroResponse>('/api/v1/auth/registro', body).subscribe({
      next: (r) => {
        this.cargando.set(false);
        localStorage.setItem('valhala_email_pendiente', body.emailContacto);
        this.router.navigate(['/verificar']);
      },
      error: (e: any) => {
        this.cargando.set(false);
        this.error.set(e.error?.message || e.error?.mensaje || 'Error al registrar. Verifica los datos.');
      }
    });
  }
}