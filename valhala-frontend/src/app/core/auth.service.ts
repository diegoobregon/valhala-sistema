import { Injectable, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { tap } from 'rxjs';
import { LoginRequest, LoginResponse } from './models';

const K_TOKEN = 'valhala_token';
const K_ROL   = 'valhala_rol';
const K_NOM   = 'valhala_nombres';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private http   = inject(HttpClient);
  private router = inject(Router);

  rol     = signal<string>(localStorage.getItem(K_ROL) ?? '');
  nombres = signal<string>(localStorage.getItem(K_NOM) ?? '');

  login(body: LoginRequest) {
    return this.http.post<LoginResponse>('/api/v1/auth/login', body).pipe(
      tap(r => {
        localStorage.setItem(K_TOKEN, r.token);
        localStorage.setItem(K_ROL, r.rol);
        localStorage.setItem(K_NOM, r.nombres);
        this.rol.set(r.rol);
        this.nombres.set(r.nombres);
      })
    );
  }

  get token(): string | null { return localStorage.getItem(K_TOKEN); }
  get autenticado(): boolean { return !!this.token; }
  esAdmin(): boolean { return this.rol() === 'ADMIN'; }

  logout() {
    localStorage.clear();
    this.rol.set('');
    this.nombres.set('');
    this.router.navigate(['/login']);
  }
}
