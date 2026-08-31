import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ApiService } from '../core/api.service';
import { AuthService } from '../core/auth.service';
import { Categoria, Equipo } from '../core/models';

@Component({
  selector: 'app-equipos',
  standalone: true,
  imports: [ReactiveFormsModule],
  template: `
  <div class="card">
    <h2>Catalogo de flota (Linea Amarilla)</h2>
    <table>
      <tr><th>Codigo</th><th>Categoria</th><th>Marca</th><th>Modelo</th><th>Anio</th><th>Horometro</th>
        @if (auth.esAdmin()) { <th></th> }</tr>
      @for (e of equipos(); track e.idEquipo) {
        <tr>
          <td><b>{{ e.codigoPatrimonial }}</b></td>
          <td>{{ e.categoria?.nombreCategoria }}</td>
          <td>{{ e.marca }}</td>
          <td>{{ e.modelo }}</td>
          <td>{{ e.anioFabricacion }}</td>
          <td>{{ e.horometroAcumulado }} h</td>
          @if (auth.esAdmin()) {
            <td>
              <button class="ghost" (click)="editar(e)">Editar</button>
              <button class="danger" (click)="eliminar(e.idEquipo)">Eliminar</button>
            </td>
          }
        </tr>
      }
    </table>
  </div>

  @if (auth.esAdmin()) {
    <div class="card">
      <h2>{{ editando() ? 'Editar equipo #' + editando() : 'Registrar nuevo equipo' }}</h2>
      <form [formGroup]="form" (ngSubmit)="guardar()">
        <div class="grid3">
          <div>
            <label>Categoria</label>
            <select formControlName="idCategoria">
              @for (c of categorias(); track c.idCategoria) {
                <option [value]="c.idCategoria">{{ c.nombreCategoria }}</option>
              }
            </select>
          </div>
          <div><label>Codigo patrimonial</label><input formControlName="codigoPatrimonial" placeholder="EX-006"></div>
          <div><label>Marca</label><input formControlName="marca" placeholder="Caterpillar"></div>
          <div><label>Modelo</label><input formControlName="modelo" placeholder="420"></div>
          <div><label>Anio de fabricacion</label><input type="number" formControlName="anioFabricacion"></div>
          <div><label>Horometro acumulado</label><input type="number" step="0.01" formControlName="horometroAcumulado"></div>
        </div>
        <button type="submit" [disabled]="form.invalid">{{ editando() ? 'Actualizar' : 'Registrar' }}</button>
        @if (editando()) { <button type="button" class="ghost" (click)="cancelar()">Cancelar</button> }
      </form>
      @if (msg()) { <div class="msg" [class.ok]="ok()" [class.er]="!ok()">{{ msg() }}</div> }
    </div>
  }`
})
export class EquiposComponent {
  private api = inject(ApiService);
  private fb = inject(FormBuilder);
  auth = inject(AuthService);

  equipos = signal<Equipo[]>([]);
  categorias = signal<Categoria[]>([]);
  editando = signal<number | null>(null);
  msg = signal(''); ok = signal(true);

  form = this.fb.nonNullable.group({
    idCategoria: [1, Validators.required],
    codigoPatrimonial: ['', [Validators.required, Validators.maxLength(50)]],
    marca: ['', Validators.required],
    modelo: ['', Validators.required],
    anioFabricacion: [2021, [Validators.min(1980), Validators.max(2026)]],
    horometroAcumulado: [0, Validators.min(0)]
  });

  constructor() { this.cargar(); }

  cargar() {
    this.api.equipos().subscribe(r => this.equipos.set(r));
    this.api.categorias().subscribe(c => this.categorias.set(c));
  }

  editar(e: Equipo) {
    this.editando.set(e.idEquipo);
    this.form.patchValue({
      idCategoria: e.categoria?.idCategoria,
      codigoPatrimonial: e.codigoPatrimonial,
      marca: e.marca, modelo: e.modelo,
      anioFabricacion: e.anioFabricacion,
      horometroAcumulado: e.horometroAcumulado
    });
  }

  cancelar() { this.editando.set(null); this.form.reset({ idCategoria: 1, anioFabricacion: 2021, horometroAcumulado: 0 }); }

  guardar() {
    const d = this.form.getRawValue();
    const req = this.editando()
      ? this.api.actualizarEquipo(this.editando()!, d)
      : this.api.crearEquipo(d);
    req.subscribe({
      next: () => { this.ok.set(true); this.msg.set('Equipo guardado correctamente.'); this.cancelar(); this.cargar(); },
      error: () => { this.ok.set(false); this.msg.set('Error al guardar: revise codigo patrimonial duplicado.'); }
    });
  }

  eliminar(id: number) {
    this.api.eliminarEquipo(id).subscribe({
      next: () => { this.ok.set(true); this.msg.set('Equipo eliminado.'); this.cargar(); },
      error: () => { this.ok.set(false); this.msg.set('No se puede eliminar: el equipo tiene contratos o reservas asociadas.'); }
    });
  }
}
