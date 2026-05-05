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
<img width="639" height="411" alt="Captura de pantalla 2026-04-29 094610" src="https://github.com/user-attachments/assets/ae37e24b-6565-4c54-9f91-080a064b9332" />
Relaciones clave:
- Cliente 1:N Pedido
- Pedido 1:N DetallePedido
- Pedido 1:N Pago
- Producto 1:N VarianteProducto
- Producto N:M Proveedor
- Sucursal N:M VarianteProducto (InventarioSucursal)
<img width="625" height="488" alt="Captura de pantalla 2026-04-30 232112" src="https://github.com/user-attachments/assets/9b073f69-5ea7-4161-8f9e-f37f2d2a6fe6" />



