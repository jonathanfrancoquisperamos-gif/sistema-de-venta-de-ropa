# Sistema de Venta de Ropa
Proyecto académico - Base de Datos II

##  Descripción
Este proyecto implementa un sistema de ventas para una tienda de ropa.  
Incluye el modelado de la base de datos y la generación del DDL en PostgreSQL.

## Modelado
El modelo contempla las siguientes entidades principales:
- Cliente
- Vendedor
- Proveedor
- Producto
- VarianteProducto
- Pedido
- DetallePedido
- Pago
- Sucursal
- InventarioSucursal

Relaciones clave:
- Cliente 1:N Pedido
- Pedido 1:N DetallePedido
- Pedido 1:N Pago
- Producto 1:N VarianteProducto
- Producto N:M Proveedor
- Sucursal N:M VarianteProducto (InventarioSucursal)

## Archivos incluidos
- `diagramaProyecto.pdf` → Diagrama E/R del sistema.
- `esquema.pdf` → Esquema lógico de la base de datos.
- `tienda_ropa.sql` → Script SQL con el DDL para PostgreSQL.
- `Avance` → Notas de progreso del proyecto.

##  Requisitos
- PostgreSQL 15+
- pgAdmin 4 o cliente psql
- Git para control de versiones


