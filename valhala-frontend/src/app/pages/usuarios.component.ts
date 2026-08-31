import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ApiService } from '../core/api.service';
import { Usuario } from '../core/models';

@Component({
  selector: 'app-usuarios',
  standalone: true,
  imports: [ReactiveFormsModule],
  template: `
  <div class="card">
    <h2>Operadores del sistema (RBAC)</h2>
    <table>
      <tr><th>#</th><th>DNI</th><th>Nombres</th><th>Apellidos</th><th>Email</th><th>Rol</th><th>Estado</th></tr>
      @for (u of usuarios(); track u.idUsuario) {
        <tr>
          <td>{{ u.idUsuario }}</td>
          <td>{{ u.dni }}</td>
          <td>{{ u.nombres }}</td>
          <td>{{ u.apellidos }}</td>
          <td>{{ u.email }}</td>
          <td><span class="badge b-am">{{ u.rol?.nombreRol }}</span></td>
          <td>
            <span class="badge" [class.b-ok]="u.estadoActivo" [class.b-er]="!u.estadoActivo">
              {{ u.estadoActivo ? 'ACTIVO' : 'INACTIVO' }}
            </span>
          </td>
        </tr>
      }
    </table>
  </div>

  <div class="card">
    <h2>Crear usuario (contrasena cifrada con BCrypt)</h2>
    <form [formGroup]="form" (ngSubmit)="guardar()">
      <div class="grid3">
        <div>
          <label>Rol</label>
          <select formControlName="idRol">
            <option [value]="1">ADMIN</option>
            <option [value]="2">MECANICO</option>
            <option [value]="3">CLIENTE</option>
          </select>
        </div>
        <div><label>DNI (8 digitos)</label><input formControlName="dni" maxlength="8"></div>
        <div><label>Nombres</label><input formControlName="nombres"></div>
        <div><label>Apellidos</label><input formControlName="apellidos"></div>
        <div><label>Email</label><input type="email" formControlName="email"></div>
        <div><label>Contrasena (min. 8)</label><input type="password" formControlName="password"></div>
      </div>
      <button type="submit" [disabled]="form.invalid">Crear usuario</button>
    </form>
    @if (msg()) { <div class="msg" [class.ok]="ok()" [class.er]="!ok()">{{ msg() }}</div> }
  </div>`
})
export class UsuariosComponent {
  private api = inject(ApiService);
  private fb = inject(FormBuilder);

  usuarios = signal<Usuario[]>([]);
  msg = signal(''); ok = signal(true);

  form = this.fb.nonNullable.group({
    idRol: [2, Validators.required],
    dni: ['', [Validators.required, Validators.pattern(/^\d{8}$/)]],
    nombres: ['', Validators.required],
    apellidos: ['', Validators.required],
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(8)]]
  });

  constructor() { this.cargar(); }

  cargar() {
    this.api.usuarios().subscribe({ next: r => this.usuarios.set(r), error: () => this.usuarios.set([]) });
  }

  guardar() {
    this.api.crearUsuario(this.form.getRawValue()).subscribe({
      next: () => { this.ok.set(true); this.msg.set('Usuario creado con contrasena cifrada.'); this.form.reset({ idRol: 2 }); this.cargar(); },
      error: () => { this.ok.set(false); this.msg.set('Error: DNI o email duplicado.'); }
    });
  }
}
