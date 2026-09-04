import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { VerificarRequest, VerificarResponse } from '../core/models';

@Component({
  selector: 'app-verificar',
  standalone: true,
  imports: [ReactiveFormsModule],
  template: `
  <div class="wrap">
    <div class="card">
      <div class="logo">VAL<span>HALA</span> <small>Verificación</small></div>
      <p class="muted" style="margin-bottom:22px">
        Revisa la consola del backend y copia el código de 6 dígitos
      </p>

      <form [formGroup]="form" (ngSubmit)="verificar()">
        <label>Email</label>
        <input type="email" formControlName="email" [readonly]="emailPrecargado()" 
               style="background:#1a1f25;cursor:not-allowed">

        <label>Código de verificación (6 dígitos)</label>
        <input formControlName="codigo" maxlength="6" placeholder="123456" 
               style="font-size:24px;letter-spacing:8px;text-align:center;font-weight:700">
        @if (form.controls.codigo.touched && form.controls.codigo.invalid) {
          <small class="err">El código debe tener 6 dígitos.</small>
        }

        <button type="submit" style="width:100%;margin-top:12px" [disabled]="form.invalid || cargando()">
          {{ cargando() ? 'Verificando...' : 'Verificar empresa' }}
        </button>
      </form>

      @if (error()) { <div class="msg er">{{ error() }}</div> }
      @if (exito()) { <div class="msg ok">{{ exito() }}</div> }
    </div>
  </div>`,
  styles: [`
    .wrap{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px}
    .card{width:100%;max-width:420px;background:#161b22;padding:30px;border-radius:10px;border:1px solid #30363d}
    .logo{font-size:24px;font-weight:700;letter-spacing:3px;margin-bottom:8px;color:#fff}
    .logo span{color:#f59e0b}
    .logo small{font-size:13px;font-weight:400;color:#8b949e;margin-left:10px}
    .err{color:#f85149;font-size:12px;display:block;margin:-8px 0 10px}
    .muted{color:#8b949e;font-size:13px}
    label{display:block;font-size:13px;color:#c9d1d9;margin:10px 0 4px}
    input{width:100%;padding:10px;background:#0d1117;border:1px solid #30363d;border-radius:6px;color:#fff;font-size:14px}
    button{padding:12px;background:#f59e0b;color:#111;border:none;border-radius:6px;font-weight:700;cursor:pointer;font-size:15px}
    button:disabled{opacity:0.5;cursor:not-allowed}
    .msg{padding:12px;margin-top:12px;border-radius:4px;font-size:14px}
    .msg.er{background:#f8514922;border-left:4px solid #f85149;color:#f85149}
    .msg.ok{background:#3fb95022;border-left:4px solid #3fb950;color:#3fb950}
  `]
})
export class VerificarComponent {
  private fb = inject(FormBuilder);
  private http = inject(HttpClient);
  private router = inject(Router);

  cargando = signal(false);
  error = signal('');
  exito = signal('');
  emailPrecargado = signal(false);

  form = this.fb.nonNullable.group({
    email: ['', [Validators.required, Validators.email]],
    codigo: ['', [Validators.required, Validators.pattern(/^\d{6}$/)]]
  });

  constructor() {
    const emailPendiente = localStorage.getItem('valhala_email_pendiente');
    if (emailPendiente) {
      this.form.patchValue({ email: emailPendiente });
      this.emailPrecargado.set(true);
    }
  }

  verificar() {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.cargando.set(true);
    this.error.set('');
    this.exito.set('');
    
    const body: VerificarRequest = this.form.getRawValue();
    this.http.post<VerificarResponse>('/api/v1/auth/verificar', body).subscribe({
      next: (r) => {
        this.cargando.set(false);
        this.exito.set('✅ ' + r.mensaje);
        localStorage.removeItem('valhala_email_pendiente');
        setTimeout(() => this.router.navigate(['/login']), 1500);
      },
      error: (e: any) => {
        this.cargando.set(false);
        this.error.set(e.error?.message || e.error?.mensaje || 'Código inválido o expirado.');
      }
    });
  }
}