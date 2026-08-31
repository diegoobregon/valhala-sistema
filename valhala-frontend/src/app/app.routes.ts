import { Routes } from '@angular/router';
import { authGuard } from './core/auth.guard';

export const routes: Routes = [
  { path: 'login', loadComponent: () => import('./pages/login.component').then(m => m.LoginComponent) },
  {
    path: '',
    loadComponent: () => import('./pages/shell.component').then(m => m.ShellComponent),
    canActivate: [authGuard],
    children: [
      { path: 'gantt',         loadComponent: () => import('./pages/gantt.component').then(m => m.GanttComponent) },
      { path: 'equipos',       loadComponent: () => import('./pages/equipos.component').then(m => m.EquiposComponent) },
      { path: 'contratos',     loadComponent: () => import('./pages/contratos.component').then(m => m.ContratosComponent) },
      { path: 'transacciones', loadComponent: () => import('./pages/transacciones.component').then(m => m.TransaccionesComponent) },
      { path: 'liquidaciones', loadComponent: () => import('./pages/liquidaciones.component').then(m => m.LiquidacionesComponent) },
      { path: 'documentos',    loadComponent: () => import('./pages/documentos.component').then(m => m.DocumentosComponent) },
      { path: 'usuarios',      loadComponent: () => import('./pages/usuarios.component').then(m => m.UsuariosComponent) },
      { path: '', redirectTo: 'gantt', pathMatch: 'full' }
    ]
  },
  { path: '**', redirectTo: '' }
];
