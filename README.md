# IronStrongDB

Base de datos para proyecto de gestión de gimnasio (DDL, seeds, procedimientos y módulo web).

## Estructura del repo
- `sql/` — scripts: `ddl.sql`, `seed.sql`, `programacion_bd.sql`, `renovacion_membresia.sql`, `queries.sql`
- `web/` — módulo front (index.html + assets)
- `docs/` — documentación y capturas

## Cómo ejecutar (MySQL 8.0)
1. Crear base de datos e importar `sql/ddl.sql`.
2. Insertar datos: `sql/seed.sql`.
3. Ejecutar `sql/programacion_bd.sql` para funciones/procedimientos.
4. Revisar `queries.sql` para reportes de ejemplo.

## Branching
- `main` — producción
- `develop` — integración
- `feature/*` — features

## Contacto
Autor: TU NOMBRE - correo@example.com
