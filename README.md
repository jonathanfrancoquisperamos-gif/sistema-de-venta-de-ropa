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
##  Base de Datos y Rellenado Inicial
Desarrollé la creación completa de las tablas en PostgreSQL (`tienda_ropa.sql`), estableciendo todas las llaves primarias, foráneas y restricciones necesarias. Además, realicé el **rellenado inicial de la base de datos** con registros de prueba reales para cada entidad (clientes, productos, variantes, vendedores, etc.), lo cual me permitió probar todo el comportamiento real del sistema.

##  Conexión y Backend (Python)
Para darle vida al proyecto, implementé un **Backend robusto utilizando Python y el framework Flask** (`app.py`). 
* Creé mi propio script de conexión (`conexion.py`) usando la librería `psycopg2` para enlazar mi aplicación web directamente a mi base de datos PostgreSQL.
* Diseñé rutas completas (CRUD) para gestionar Clientes, Productos, Pedidos, Vendedores, Proveedores, Sucursales y el Inventario de Variantes.
* Toda la extracción de datos la estructuré usando cursores en formato diccionario (`RealDictCursor`) para hacer el código dinámico y muy eficiente.

##  Frontend y Diseño de Interfaz
Construí una interfaz web desde cero (Frontend) con HTML5 y CSS3 nativo (`style.css`), aplicando un moderno e inmersivo **"Dark Mode"** (Modo oscuro). 
* **Dashboard interactivo:** Con tarjetas de métricas que resumen el total de mis ingresos monetarios, cantidad de clientes, pedidos y una tabla del Top de productos más vendidos.
* **Sistema Flexible y Sencillo:** Desarrollé formularios dinámicos donde, por ejemplo, puedo **crear un cliente nuevo directamente en el momento de realizar un pedido**, sin perder tiempo cambiando de ventana.
* Todo lo conecté y lo separé de manera organizada usando plantillas base (`base.html`) para reutilizar menús de navegación.

## 🛠️ Scripts y Modificaciones Automáticas
Para no modificar la estructura de la base de datos manualmente y llevar un control limpio de versiones, programé **scripts en Python** que alteran la base de datos directamente:
* `add_image_col.py`: Lo programé para realizar una migración automatizada, añadiendo la columna de `imagen` a mi tabla de productos, habilitando que las prendas puedan incluir fotos físicas subidas al servidor.

##  Triggers (Disparadores)
Como parte avanzada del proyecto de bases de datos, analicé e implementé Triggers a nivel de servidor.
* **Control de Stock Automatizado:** Escribí e implementé mi propio disparador (`trg_descontar_stock`) junto a su respectiva función en `plpgsql`. Se ejecuta automáticamente en el evento `AFTER INSERT` sobre la tabla `detallepedido`. De esta forma logré que el stock del inventario se descuente matemática y directamente a nivel de base de datos cada vez que registro una venta (sin depender de Python), lo cual previene errores severos si el servidor web fallase. Programé el script `aplicar_trigger.py` para inyectar este comportamiento automáticamente.

##  Propuesta de Vistas e Índices (Optimización)
Pensando a futuro, y para garantizar que mi sistema siga siendo ultra rápido aunque contenga miles de ventas en sus registros, desarrollé la siguiente propuesta formal de optimización:
* **Vistas (Views):**
  * `vista_ventas_detalle`: Para unificar `pedido`, `detallepedido`, `cliente`, `vendedor` y `producto` en una sola tabla virtual de lectura rápida (ideal para mi Dashboard).
  * `vista_inventario_actual`: Para monitorear el stock cruzando productos y variantes de manera plana (sin hacer JOINs costosos cada vez).
  * `vista_ingresos_resumen`: Para agrupar pagos mensuales y diarios, lo que me permitirá generar reportes PDF y gráficos financieros en milisegundos.
* **Índices (Indexes):**
  * Propongo añadir índices tipo *B-Tree* sobre todas mis llaves foráneas (`idcliente`, `idvendedor`, `idpedido`) para que las consultas de unión no saturen la memoria RAM del servidor de base de datos.
  * Añadir índices de filtrado en `pedido(fechapedido)` y `pedido(estadopedido)` para acelerar los reportes de ingresos diarios que muestra mi sistema de ventas.
  * Añadir un índice en `cliente(email)` para acelerar drásticamente el logueo de clientes o validaciones de usuarios existentes.

