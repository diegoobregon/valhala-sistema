# VALHALA — Frontend Angular: instalacion paso a paso

## Opcion A — sobre tu proyecto actual (recomendado, 5 min)

Desde `D:\ciclo 8\exp4\valhala-sistema\valhala-frontend`:

```powershell
# 1) Limpiar los archivos rotos que dejaron los scripts .ps1
Remove-Item -Recurse -Force src\app -ErrorAction SilentlyContinue
Remove-Item -Force src\main.ts, src\index.html, src\styles.css -ErrorAction SilentlyContinue
Remove-Item -Force diseno_pro.ps1, frontend_completo.ps1, generar_frontend.ps1, parche6.ps1 -ErrorAction SilentlyContinue

# 2) Copiar el contenido de este zip (carpeta src\ y proxy.conf.json) dentro de valhala-frontend

# 3) Verificar que angular.json apunte al proxy
#    projects > valhala-frontend > architect > serve > options:
#      "proxyConfig": "proxy.conf.json"

# 4) Levantar
npm install
npm start
```

Abrir http://localhost:4200 · admin@valhala.pe / admin123

## Opcion B — proyecto Angular desde cero

```powershell
cd "D:\ciclo 8\exp4\valhala-sistema"
Remove-Item -Recurse -Force valhala-frontend
npx @angular/cli@latest new valhala-frontend --style=css --ssr=false --routing=false --skip-tests
cd valhala-frontend
# copiar src\ y proxy.conf.json de este zip encima
npm start
```

## Configurar el proxy en angular.json

Busca el bloque `"serve"` y agrega `proxyConfig`:

```json
"serve": {
  "builder": "@angular/build:dev-server",
  "options": { "proxyConfig": "proxy.conf.json" },
  "configurations": { ... }
}
```

El proxy hace que `/api/**` del frontend (4200) llegue al backend (8080).
Asi no dependes de CORS y las rutas del ApiService quedan limpias.

## Estructura generada

```
src/
  index.html
  main.ts
  styles.css
  app/
    app.component.ts        componente raiz (router-outlet)
    app.config.ts           provideRouter + provideHttpClient + interceptor
    app.routes.ts           rutas con lazy loading y authGuard
    core/
      models.ts             interfaces tipadas de las 16 entidades
      api.service.ts        todos los endpoints REST del backend
      auth.service.ts       login, signals de rol y nombres, logout
      auth.interceptor.ts   RNF-05: inyecta "Authorization: Bearer <jwt>"
      auth.guard.ts         protege las rutas privadas
    pages/
      login.component.ts          formulario reactivo con validaciones
      shell.component.ts          layout, menu y sesion
      gantt.component.ts          RF-01 anticolisiones + RF-02 barras Gantt
      equipos.component.ts        CRUD de flota
      contratos.component.ts      clientes, contratos e items (FormArray)
      transacciones.component.ts  RF-05 check-in y RF-06 check-out
      liquidaciones.component.ts  modulo financiero (solo ADMIN/CLIENTE)
      documentos.component.ts     documentos legales y mantenimientos
      usuarios.component.ts       alta de operadores con BCrypt
```

## Anadido opcional al backend (habilita la lista de despachos)

En `CheckOutController.java`:

```java
private final CheckOutSalidaRepository repo;   // inyectar en el constructor

@GetMapping
@PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
public List<CheckOutSalida> listar() { return repo.findAll(); }
```

Sin esto el modulo de transacciones funciona igual, pero pide el ID de salida a mano.

## Guion de demo para las capturas

1. Login → JWT en la pestana Network.
2. Dashboard Gantt → barras de las reservas activas.
3. Reserva con fechas solapadas → ColisionReservaException (RF-01).
4. Reserva con fechas libres → aceptada.
5. Check-out del equipo con SCTR vencido → DocumentoVencidoException (RF-06).
6. Check-out de un equipo con documentos vigentes → salida creada.
7. Check-in con horometro menor al inicial → FraudeHorometroException (RF-05).
8. Check-in correcto → liquidacion con horas extra, IGV y total.
9. Pestana Liquidaciones → total acumulado.
10. Login como mecanico@valhala.pe → Liquidaciones muestra 403 (RBAC).
