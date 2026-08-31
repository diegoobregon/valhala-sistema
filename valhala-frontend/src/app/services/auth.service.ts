import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface LoginResponse { token: string; rol: string; nombres: string; }

@Injectable({ providedIn: 'root' })
export class AuthService {
  private base = 'http://127.0.0.1:8080/api/v1';
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