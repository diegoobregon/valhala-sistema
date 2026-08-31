import { Component, inject, signal } from '@angular/core';
import { FormArray, FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { ApiService } from '../core/api.service';
import { AuthService } from '../core/auth.service';
import { Cliente, Contrato, Equipo, ItemContrato } from '../core/models';

@Component({
  selector: 'app-contratos',
  standalone: true,
  imports: [ReactiveFormsModule],
  template: `
  <div class="card">
    <h2>Contratos corporativos</h2>
    <table>
      <tr><th>#</th><th>Cliente</th><th>RUC</th><th>Emision</th><th>Inicio</th><th>Fin</th><th>Estado</th></tr>
      @for (c of contratos(); track c.idContrato) {
        <tr>
          <td>{{ c.idContrato }}</td>
          <td>{{ c.cliente?.razonSocial }}</td>
          <td>{{ c.cliente?.ruc }}</td>
          <td>{{ c.fechaEmision }}</td>
          <td>{{ c.fechaInicio }}</td>
          <td>{{ c.fechaFin }}</td>
          <td><span class="badge b-ok">{{ c.estadoContrato }}</span></td>
        </tr>
      }
    </table>
  </div>

  <div class="card">
    <h2>Items contratados (equipos asignados)</h2>
    <table>
      <tr><th>#</th><th>Contrato</th><th>Equipo</th><th>Tarifa S//h</th><th>Horas min.</th><th>Flete S/</th></tr>
      @for (i of items(); track i.idItem) {
        <tr>
          <td>{{ i.idItem }}</td>
          <td>{{ i.contrato?.cliente?.razonSocial }}</td>
          <td>{{ i.equipo?.codigoPatrimonial }}</td>
          <td>{{ i.tarifaPorHora }}</td>
          <td>{{ i.horasMinimasGarantizadas }}</td>
          <td>{{ i.costoFlete }}</td>
        </tr>
      }
    </table>
  </div>

  @if (auth.esAdmin()) {
    <div class="grid2">
      <div class="card">
        <h2>Registrar cliente corporativo</h2>
        <form [formGroup]="fCli" (ngSubmit)="guardarCliente()">
          <label>RUC (11 digitos)</label>
          <input formControlName="ruc" maxlength="11" placeholder="20608330764">
          <label>Razon social</label><input formControlName="razonSocial">
          <label>Direccion fiscal</label><input formControlName="direccionFiscal">
          <label>Telefono</label><input formControlName="telefono">
          <label>Email de contacto</label><input type="email" formControlName="emailContacto">
          <button type="submit" [disabled]="fCli.invalid">Registrar cliente</button>
        </form>
      </div>

      <div class="card">
        <h2>Nuevo contrato</h2>
        <form [formGroup]="fCtr" (ngSubmit)="guardarContrato()">
          <label>Cliente</label>
          <select formControlName="idCliente">
            @for (c of clientes(); track c.idCliente) {
              <option [value]="c.idCliente">{{ c.razonSocial }}</option>
            }
          </select>
          <div class="grid2">
            <div><label>Fecha inicio</label><input type="date" formControlName="fechaInicio"></div>
            <div><label>Fecha fin</label><input type="date" formControlName="fechaFin"></div>
          </div>

          <label>Items del contrato</label>
          @for (it of itemsArray.controls; track $index) {
            <div class="grid2" [formGroup]="grupo(it)">
              <select formControlName="idEquipo">
                @for (e of equipos(); track e.idEquipo) {
                  <option [value]="e.idEquipo">{{ e.codigoPatrimonial }} - {{ e.marca }}</option>
                }
              </select>
              <input type="number" formControlName="tarifaPorHora" placeholder="Tarifa S//h">
              <input type="number" formControlName="horasMinimas" placeholder="Horas minimas">
              <input type="number" formControlName="costoFlete" placeholder="Flete S/">
            </div>
          }
          <button type="button" class="ghost" (click)="agregarItem()">+ Agregar item</button>
          <button type="submit" [disabled]="fCtr.invalid">Crear contrato</button>
        </form>
      </div>
    </div>
    @if (msg()) { <div class="msg" [class.ok]="ok()" [class.er]="!ok()">{{ msg() }}</div> }
  }`
})
export class ContratosComponent {
  private api = inject(ApiService);
  private fb = inject(FormBuilder);
  auth = inject(AuthService);

  contratos = signal<Contrato[]>([]);
  items = signal<ItemContrato[]>([]);
  clientes = signal<Cliente[]>([]);
  equipos = signal<Equipo[]>([]);
  msg = signal(''); ok = signal(true);

  fCli = this.fb.nonNullable.group({
    ruc: ['', [Validators.required, Validators.pattern(/^\d{11}$/)]],
    razonSocial: ['', Validators.required],
    direccionFiscal: [''],
    telefono: [''],
    emailContacto: ['', Validators.email]
  });
 
  fCtr = this.fb.nonNullable.group({
    idCliente: [0, Validators.required],
    fechaInicio: ['', Validators.required],
    fechaFin: ['', Validators.required],
    items: this.fb.array([this.nuevoItem()])
  });

  get itemsArray(): FormArray { return this.fCtr.get('items') as FormArray; }

  /** Cast necesario: FormArray.controls devuelve AbstractControl, no FormGroup. */
  grupo(c: any): FormGroup { return c as FormGroup; }

  private nuevoItem(): FormGroup {
    return this.fb.nonNullable.group({
      idEquipo: [0, Validators.required],
      tarifaPorHora: [200, Validators.min(1)],
      horasMinimas: [100, Validators.min(0)],
      costoFlete: [1000, Validators.min(0)]
    });
  }

  agregarItem() { this.itemsArray.push(this.nuevoItem()); }

  constructor() { this.cargar(); }

  cargar() {
    this.api.contratos().subscribe(r => this.contratos.set(r));
    this.api.items().subscribe(r => this.items.set(r));
    this.api.clientes().subscribe(r => {
      this.clientes.set(r);
      if (r.length) this.fCtr.patchValue({ idCliente: r[0].idCliente });
    });
    this.api.equipos().subscribe(r => {
      this.equipos.set(r);
      if (r.length) this.itemsArray.at(0).patchValue({ idEquipo: r[0].idEquipo });
    });
  }

  guardarCliente() {
    this.api.crearCliente(this.fCli.getRawValue()).subscribe({
      next: () => { this.ok.set(true); this.msg.set('Cliente registrado.'); this.fCli.reset(); this.cargar(); },
      error: () => { this.ok.set(false); this.msg.set('Error: el RUC ya existe o es invalido.'); }
    });
  }

  guardarContrato() {
    this.api.crearContrato(this.fCtr.getRawValue()).subscribe({
      next: () => { this.ok.set(true); this.msg.set('Contrato creado con sus items.'); this.cargar(); },
      error: () => { this.ok.set(false); this.msg.set('Error al crear el contrato. Verifique las fechas.'); }
    });
  }
}
