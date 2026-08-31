import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import {
  Categoria, Cliente, Contrato, DocumentoLegal, Equipo, ItemContrato,
  Liquidacion, Mantenimiento, ReservaGantt, Usuario, CheckOutSalida, CheckInRetorno
} from './models';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private http = inject(HttpClient);
  private base = '/api/v1';

  // ---- Catalogo / flota ----
  categorias(): Observable<Categoria[]> { return this.http.get<Categoria[]>(`${this.base}/categorias`); }
  equipos(): Observable<Equipo[]>       { return this.http.get<Equipo[]>(`${this.base}/equipos`); }
  crearEquipo(d: any)                   { return this.http.post<Equipo>(`${this.base}/equipos`, d); }
  actualizarEquipo(id: number, d: any)  { return this.http.put<Equipo>(`${this.base}/equipos/${id}`, d); }
  eliminarEquipo(id: number)            { return this.http.delete<void>(`${this.base}/equipos/${id}`); }

  // ---- Comercial ----
  clientes(): Observable<Cliente[]>     { return this.http.get<Cliente[]>(`${this.base}/clientes`); }
  crearCliente(d: any)                  { return this.http.post<Cliente>(`${this.base}/clientes`, d); }
  contratos(): Observable<Contrato[]>   { return this.http.get<Contrato[]>(`${this.base}/contratos`); }
  crearContrato(d: any)                 { return this.http.post<Contrato>(`${this.base}/contratos`, d); }
  items(): Observable<ItemContrato[]>   { return this.http.get<ItemContrato[]>(`${this.base}/items`); }

  // ---- RF-01 / RF-02 Gantt ----
  gantt(): Observable<ReservaGantt[]>   { return this.http.get<ReservaGantt[]>(`${this.base}/reservas/gantt`); }
  crearReserva(d: any)                  { return this.http.post<ReservaGantt>(`${this.base}/reservas`, d); }
  anularReserva(id: number)             { return this.http.delete<void>(`${this.base}/reservas/${id}`); }

  // ---- RF-05 / RF-06 Transacciones ----
  salidas(): Observable<CheckOutSalida[]> { return this.http.get<CheckOutSalida[]>(`${this.base}/transacciones/checkout`); }
  checkout(d: any)                      { return this.http.post<CheckOutSalida>(`${this.base}/transacciones/checkout`, d); }
  checkin(d: any)                       { return this.http.post<Liquidacion>(`${this.base}/transacciones/checkin`, d); }

  // ---- Facturacion ----
  liquidaciones(): Observable<Liquidacion[]> { return this.http.get<Liquidacion[]>(`${this.base}/liquidaciones`); }

  // ---- Legal / taller ----
  documentos(): Observable<DocumentoLegal[]>   { return this.http.get<DocumentoLegal[]>(`${this.base}/documentos`); }
  crearDocumento(d: any)                       { return this.http.post<DocumentoLegal>(`${this.base}/documentos`, d); }
  mantenimientos(): Observable<Mantenimiento[]>{ return this.http.get<Mantenimiento[]>(`${this.base}/mantenimientos`); }
  crearMantenimiento(d: any)                   { return this.http.post<Mantenimiento>(`${this.base}/mantenimientos`, d); }

  // ---- Operadores ----
  usuarios(): Observable<Usuario[]>     { return this.http.get<Usuario[]>(`${this.base}/usuarios`); }
  crearUsuario(d: any)                  { return this.http.post<Usuario>(`${this.base}/usuarios`, d); }
}
