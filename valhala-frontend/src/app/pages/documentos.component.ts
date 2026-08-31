import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ApiService } from '../core/api.service';
import { AuthService } from '../core/auth.service';
import { DocumentoLegal, Equipo, Mantenimiento } from '../core/models';

@Component({
  selector: 'app-documentos',
  standalone: true,
  imports: [ReactiveFormsModule],
  template: `
  <div class="card">
    <h2>Documentos legales de la flota</h2>
    <table>
      <tr><th>#</th><th>Equipo</th><th>Tipo</th><th>Numero de poliza</th><th>Vence</th><th>Situacion</th></tr>
      @for (d of docs(); track d.idDocumento) {
        <tr>
          <td>{{ d.idDocumento }}</td>
          <td>{{ d.equipo?.codigoPatrimonial }}</td>
          <td>{{ d.tipoPoliza }}</td>
          <td>{{ d.numeroPoliza }}</td>
          <td>{{ d.fechaVencimiento }}</td>
          <td>
            <span class="badge" [class.b-ok]="!vencido(d)" [class.b-er]="vencido(d)">
              {{ vencido(d) ? 'VENCIDO — bloquea despacho' : 'VIGENTE' }}
            </span>
          </td>
        </tr>
      }
    </table>
  </div>

  <div class="card">
    <h2>Mantenimientos de taller</h2>
    <table>
      <tr><th>#</th><th>Equipo</th><th>Tipo</th><th>Horometro</th><th>Costo S/</th><th>Mecanico</th></tr>
      @for (m of mants(); track m.idMantenimiento) {
        <tr>
          <td>{{ m.idMantenimiento }}</td>
          <td>{{ m.equipo?.codigoPatrimonial }}</td>
          <td>{{ m.tipoMantenimiento }}</td>
          <td>{{ m.horometroEjecucion }} h</td>
          <td>{{ m.costoReparacion }}</td>
          <td>{{ m.usuarioMecanico?.nombres }}</td>
        </tr>
      }
    </table>
  </div>

  <div class="grid2">
    @if (auth.esAdmin()) {
      <div class="card">
        <h2>Registrar documento legal</h2>
        <form [formGroup]="fDoc" (ngSubmit)="guardarDoc()">
          <label>Equipo</label>
          <select formControlName="idEquipo">
            @for (e of equipos(); track e.idEquipo) {
              <option [value]="e.idEquipo">{{ e.codigoPatrimonial }} — {{ e.marca }}</option>
            }
          </select>
          <label>Tipo de poliza</label>
          <select formControlName="tipoPoliza">
            <option value="SOAT">SOAT</option>
            <option value="SCTR">SCTR</option>
            <option value="TREC">TREC</option>
            <option value="CERT_OPERATIVIDAD">Certificado de operatividad</option>
          </select>
          <label>Numero de poliza</label><input formControlName="numeroPoliza">
          <label>Fecha de vencimiento</label><input type="date" formControlName="fechaVencimiento">
          <button type="submit" [disabled]="fDoc.invalid">Registrar documento</button>
        </form>
      </div>
    }

    <div class="card">
      <h2>Registrar mantenimiento</h2>
      <form [formGroup]="fMan" (ngSubmit)="guardarMan()">
        <label>Equipo</label>
        <select formControlName="idEquipo">
          @for (e of equipos(); track e.idEquipo) {
            <option [value]="e.idEquipo">{{ e.codigoPatrimonial }} — {{ e.marca }}</option>
          }
        </select>
        <label>Tipo de mantenimiento</label>
        <input formControlName="tipoMantenimiento" placeholder="PM1 - Servicio 250H">
        <label>Horometro de ejecucion</label>
        <input type="number" step="0.01" formControlName="horometroEjecucion">
        <label>Costo de reparacion S/</label>
        <input type="number" step="0.01" formControlName="costoReparacion">
        <button type="submit" [disabled]="fMan.invalid">Registrar mantenimiento</button>
      </form>
    </div>
  </div>

  @if (msg()) { <div class="msg" [class.ok]="ok()" [class.er]="!ok()">{{ msg() }}</div> }`
})
export class DocumentosComponent {
  private api = inject(ApiService);
  private fb = inject(FormBuilder);
  auth = inject(AuthService);

  docs = signal<DocumentoLegal[]>([]);
  mants = signal<Mantenimiento[]>([]);
  equipos = signal<Equipo[]>([]);
  msg = signal(''); ok = signal(true);

  fDoc = this.fb.nonNullable.group({
    idEquipo: [0, Validators.required],
    tipoPoliza: ['SOAT', Validators.required],
    numeroPoliza: ['', Validators.required],
    fechaVencimiento: ['', Validators.required]
  });

  fMan = this.fb.nonNullable.group({
    idEquipo: [0, Validators.required],
    tipoMantenimiento: ['', Validators.required],
    horometroEjecucion: [0, Validators.min(0)],
    costoReparacion: [0, Validators.min(0)]
  });

  constructor() { this.cargar(); }

  vencido(d: DocumentoLegal): boolean {
    return new Date(d.fechaVencimiento) < new Date();
  }

  cargar() {
    this.api.documentos().subscribe({ next: r => this.docs.set(r), error: () => this.docs.set([]) });
    this.api.mantenimientos().subscribe({ next: r => this.mants.set(r), error: () => this.mants.set([]) });
    this.api.equipos().subscribe(r => {
      this.equipos.set(r);
      if (r.length) {
        this.fDoc.patchValue({ idEquipo: r[0].idEquipo });
        this.fMan.patchValue({ idEquipo: r[0].idEquipo });
      }
    });
  }

  guardarDoc() {
    this.api.crearDocumento(this.fDoc.getRawValue()).subscribe({
      next: () => { this.ok.set(true); this.msg.set('Documento legal registrado.'); this.cargar(); },
      error: () => { this.ok.set(false); this.msg.set('Error: el numero de poliza ya existe.'); }
    });
  }

  guardarMan() {
    this.api.crearMantenimiento(this.fMan.getRawValue()).subscribe({
      next: () => { this.ok.set(true); this.msg.set('Mantenimiento registrado.'); this.cargar(); },
      error: () => { this.ok.set(false); this.msg.set('Error al registrar el mantenimiento.'); }
    });
  }
}
