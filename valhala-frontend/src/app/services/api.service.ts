import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private base = 'http://localhost:8080/api/v1';
  constructor(private http: HttpClient) {}

  equipos(): Observable<any[]> { return this.http.get<any[]>(this.base + '/equipos'); }
  categorias(): Observable<any[]> { return this.http.get<any[]>(this.base + '/categorias'); }
  clientes(): Observable<any[]> { return this.http.get<any[]>(this.base + '/clientes'); }
  usuarios(): Observable<any[]> { return this.http.get<any[]>(this.base + '/usuarios'); }
  contratos(): Observable<any[]> { return this.http.get<any[]>(this.base + '/contratos'); }
  gantt(): Observable<any[]> { return this.http.get<any[]>(this.base + '/reservas/gantt'); }
  liquidaciones(): Observable<any[]> { return this.http.get<any[]>(this.base + '/liquidaciones'); }
  documentos(): Observable<any[]> { return this.http.get<any[]>(this.base + '/documentos'); }
  mantenimientos(): Observable<any[]> { return this.http.get<any[]>(this.base + '/mantenimientos'); }
  salidas(): Observable<any[]> { return this.http.get<any[]>(this.base + '/transacciones/checkout'); }

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
  checkout(d: any): Observable<any> { return this.http.post(this.base + '/transacciones/checkout', d); }
  checkin(d: any): Observable<any> { return this.http.post(this.base + '/transacciones/checkin', d); }
}