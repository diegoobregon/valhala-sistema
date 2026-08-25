# Sistema Web B2B - VALHALA S.A.C.

**Análisis, Diseño e Implementación de un Sistema Web B2B para el Control de Flota y Logística de Alquiler de Maquinaria de Línea Amarilla**

Repositorio único del proyecto: Base de Datos + Backend + Frontend.

## 📁 Estructura del repositorio

| Carpeta | Contenido | Tecnología |
|---|---|---|
| `valhala-backend/` | API REST corporativa | Java 17 + Spring Boot 3 + Spring Security (JWT) + Spring Data JPA |
| `valhala-frontend/` | SPA + PWA Offline-First | Angular 17 (TypeScript) |
| `valhala-db/` | Script SQL `valhala_db.sql` | PostgreSQL 16 — 16 tablas + particiones IoT |

## 🧰 Herramientas a instalar

1. **Java JDK 17 o superior** → https://adoptium.net/
2. **PostgreSQL 16** (incluye pgAdmin) → https://www.postgresql.org/download/windows/
3. **Node.js 22 LTS** → https://nodejs.org/ (vale la versión portable `win-x64` zip)
4. **Git** → https://git-scm.com/
5. **Maven** → *NO se instala*: el backend incluye Maven Wrapper (`mvnw.cmd`).

## 🗄️ 1) Levantar la Base de Datos

    "C:\Program Files\PostgreSQL\16\bin\psql.exe" -U postgres -c "CREATE DATABASE valhala_db;"
    "C:\Program Files\PostgreSQL\16\bin\psql.exe" -U postgres -d valhala_db -f valhala-db\valhala_db.sql

> ⚠️ Usar **psql** (no el Query Tool de pgAdmin): el dump contiene `COPY ... FROM stdin` que el Query Tool no soporta.
> Verificar las 16 tablas con: `\dt`

## ☕ 2) Levantar el Backend (puerto 8080)

1. Editar `valhala-backend/src/main/resources/application.properties` y colocar usuario/contraseña de PostgreSQL local.
2. Ejecutar:

    cd valhala-backend
    mvnw.cmd spring-boot:run

✅ API REST disponible en `http://localhost:8080` (login: `POST /api/v1/auth/login`).

## 🟩 3) Levantar el Frontend (puerto 4200)

    cd valhala-frontend
    npm install
    npm start

✅ Interfaz en `http://localhost:4200`.
> Requiere **Node 22+**. Con Node portable, activar antes en la misma consola:
> `set PATH=%PATH%;C:\ruta\de\node-v22`

## 🎬 Orden de ejecución para demo

1. PostgreSQL activo → 2. Backend (`mvnw.cmd spring-boot:run`) → 3. Frontend (`npm start`).

## 🔐 Seguridad

JWT stateless + roles **ADMIN / MECANICO** (tablas `roles` y `usuarios`), contraseñas con BCrypt y control de acceso `@PreAuthorize`.

## ✍️ Autor

**OBREGON ARANGO, Diego** — Ingeniería de Sistemas de Información — Ciclo IV — 2026
