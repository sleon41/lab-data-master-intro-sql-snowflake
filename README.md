![logo\_ironhack\_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Lab | Fundamentos SQL en Snowflake – Día 1

## Introducción

Eres el nuevo arquitecto de datos en una pequeña pero prometedora startup de tecnología. La empresa ha comenzado a recopilar datos de clientes, productos y pedidos desde su tienda online, pero hasta ahora lo han estado haciendo de manera desorganizada con hojas de cálculo. Tu misión es diseñar y construir una base de datos relacional en Snowflake que sirva como el primer paso hacia una infraestructura analítica robusta.

Este laboratorio simula el primer día de trabajo en esta empresa. Se enfoca en la creación de esquemas, tablas, relaciones y consultas fundamentales que reflejen un modelo de base de datos limpio, eficiente y escalable.

## Requisitos

* Haz un ***fork*** de este repositorio.
* Clona este repositorio.

## Entrega

- Haz Commit y Push
- Crea un Pull Request (PR)
- Copia el enlace a tu PR (con tu solución) y pégalo en el campo de entrega del portal del estudiante – solo así se considerará entregado el lab

## Desafío 1 – Diseñar la Base de Datos (Modelo ERD)

Antes de comenzar a escribir SQL, realiza el diseño lógico de la base de datos:

### Entidades mínimas

1. **Clientes**: ID, nombre, correo electrónico, país.
2. **Productos**: ID, nombre, categoría, precio.
3. **Pedidos**: ID de pedido, fecha, ID cliente, ID producto, cantidad.

### Recomendaciones:

* Usa identificadores únicos (`INT` o `VARCHAR`) como claves primarias.
* Identifica claves foráneas y relaciones:

  * Cliente ↔ Pedidos (1\:N)
  * Producto ↔ Pedidos (1\:N)

### Tarea:

* Dibuja un **diagrama entidad-relación (ERD)** donde se vean las tablas y relaciones. Puedes hacerlo a mano, con draw\.io o dbdiagram.io.
* Asegúrate de indicar los tipos de relación y los nombres de claves primarias/foráneas.

> ✅ Entregable: Imagen del diagrama ERD (`.png` o `.jpg`).

## Desafío 2 – Crear la Base de Datos y Tablas en Snowflake

Accede al entorno de Snowflake (usando consola web o SnowSQL) y sigue los siguientes pasos:

### 1. Crear el almacén, base de datos y esquema

```sql
CREATE WAREHOUSE IF NOT EXISTS ironhack_wh WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE;
USE WAREHOUSE ironhack_wh;

CREATE DATABASE IF NOT EXISTS ecommerce_lab;
CREATE SCHEMA IF NOT EXISTS ecommerce_lab.modelo_relacional;
USE SCHEMA ecommerce_lab.modelo_relacional;
```

### 2. Crear las tablas

```sql
CREATE TABLE Clientes (
  ClienteID INT PRIMARY KEY,
  Nombre VARCHAR(100),
  Email VARCHAR(150),
  Pais VARCHAR(50)
);

CREATE TABLE Productos (
  ProductoID INT PRIMARY KEY,
  Nombre VARCHAR(100),
  Categoria VARCHAR(50),
  Precio DECIMAL(10,2)
);

CREATE TABLE Pedidos (
  PedidoID INT PRIMARY KEY,
  Fecha DATE,
  ClienteID INT,
  ProductoID INT,
  Cantidad INT
);
```

> ❗Nota: Snowflake no aplica restricciones de clave foránea por defecto, pero es buena práctica documentarlas para futuros desarrollos.

> ✅ Entregable: `create.sql` con las sentencias `CREATE DATABASE`, `CREATE SCHEMA` y `CREATE TABLE`.

## Desafío 3 – Poblar la Base de Datos

### 1. Insertar datos de ejemplo

```sql
INSERT INTO Clientes VALUES
(1, 'Ana Gómez', 'ana@example.com', 'España'),
(2, 'Carlos Pérez', 'carlos@example.com', 'México'),
(3, 'Lucía Díaz', 'lucia@example.com', 'Colombia');

INSERT INTO Productos VALUES
(100, 'Portátil Dell XPS 13', 'Informática', 1200.00),
(101, 'iPhone 13', 'Electrónica', 999.99),
(102, 'Auriculares Sony WH-1000XM4', 'Audio', 349.90);

INSERT INTO Pedidos VALUES
(5001, '2024-06-01', 1, 100, 1),
(5002, '2024-06-02', 2, 101, 2),
(5003, '2024-06-02', 3, 102, 1),
(5004, '2024-06-03', 1, 102, 2);
```

> ✅ Entregable: `seeding.sql` con todos los `INSERT`.

### 2. Consultas básicas

* Todos los clientes:

```sql
SELECT * FROM Clientes;
```

* Pedidos del 2 de junio:

```sql
SELECT * FROM Pedidos WHERE Fecha = '2024-06-02';
```

* Productos con precio > 500:

```sql
SELECT * FROM Productos WHERE Precio > 500;
```

### 3. Consultas con `JOIN`

```sql
SELECT
  p.PedidoID,
  c.Nombre AS Cliente,
  pr.Nombre AS Producto,
  p.Cantidad,
  pr.Precio,
  (p.Cantidad * pr.Precio) AS Total
FROM Pedidos p
JOIN Clientes c ON p.ClienteID = c.ClienteID
JOIN Productos pr ON p.ProductoID = pr.ProductoID;
```

> ✅ Resultado esperado: Tabla con resumen de ventas por cliente y producto.

## Desafío 4 – Consultas Agregadas

* Total de pedidos por cliente:

```sql
SELECT ClienteID, COUNT(*) AS TotalPedidos FROM Pedidos GROUP BY ClienteID;
```

* Producto más vendido:

```sql
SELECT ProductoID, SUM(Cantidad) AS Total FROM Pedidos GROUP BY ProductoID ORDER BY Total DESC LIMIT 1;
```

> ✅ Bonus: exporta la consulta a `.csv` si usas la interfaz de Snowflake.

<!-- ## Entregables

* `create.sql`: archivo con todas las sentencias de creación de esquema y tablas.
* `seeding.sql`: archivo con los `INSERT INTO`.
* Diagrama ERD como imagen (`.png`, `.jpg`).
* Capturas de pantalla de las consultas y resultados (opcional).

## Entrega

1. Crea una carpeta con el nombre `lab-sql-dia1`.
2. Añade tus archivos `create.sql`, `seeding.sql`, el diagrama y capturas.
3. Súbelo a tu repositorio personal de GitHub.
4. Crea una `pull request` hacia el repositorio de clase.
5. En el título de la PR usa el formato: `[lab-sql-dia1] Tu Nombre`. -->

## Entregables

Dentro de tu repositorio forkeado, asegúrate de añadir los siguientes archivos:

* `create.sql` – Archivo con todas las sentencias `CREATE DATABASE`, `CREATE SCHEMA` y `CREATE TABLE`
* `seeding.sql` – Archivo con las sentencias `INSERT INTO` para poblar las tablas
* `diagram.png` o `diagram.jpg` – Imagen del diagrama ERD (puedes usar [https://dbdiagram.io](https://dbdiagram.io))
* `lab-notes.md` – Archivo con una breve explicación del modelo que creaste:
  * Qué entidades y relaciones diseñaste
  * Qué decisiones tomaste para las claves primarias y foráneas
  * Qué consultas implementaste y qué resultados obtuviste
* (Opcional) Capturas de pantalla con los resultados de las consultas

### Checklist Antes de Entregar

* [ ] `create.sql`
* [ ] `seeding.sql`
* [ ] `diagram.png` o `diagram.jpg`
* [ ] `lab-notes.md` con explicación del modelo y resultados
* [ ] (Opcional) Capturas de pantalla de consultas
* [ ] ✅ **Has pegado el enlace a tu Pull Request en el portal del estudiante**

¿Necesitas ayuda? Consulta con tu instructor o pregunta en el canal de Slack de tu cohort.

## ¡Has completado tu primer laboratorio en Snowflake!

A partir de aquí, los siguientes laboratorios añadirán complejidad: limpieza, estandarización, normalización, arquitectura Medallion y más. Este ha sido el primer paso para convertirte en un experto en arquitectura de datos moderna.

¡Buen trabajo!