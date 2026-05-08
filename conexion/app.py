import sys
import os
from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
from datetime import date

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from conexion import crear_conexion
from psycopg2.extras import RealDictCursor
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.secret_key = 'tienda_ropa_secret_2026'

UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'static', 'uploads', 'productos')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# ─────────────────────────────────────────────
#  HELPERS
# ─────────────────────────────────────────────
def get_db():
    conn = crear_conexion()
    if not conn:
        return None
    return conn


# ─────────────────────────────────────────────
#  DASHBOARD
# ─────────────────────────────────────────────
@app.route('/')
def dashboard():
    conn = get_db()
    stats = {}
    ventas_recientes = []
    productos_top = []

    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)

        cur.execute("SELECT COUNT(*) as total FROM producto")
        stats['productos'] = cur.fetchone()['total']

        cur.execute("SELECT COUNT(*) as total FROM cliente")
        stats['clientes'] = cur.fetchone()['total']

        cur.execute("SELECT COUNT(*) as total FROM pedido")
        stats['pedidos'] = cur.fetchone()['total']

        cur.execute("SELECT COALESCE(SUM(monto),0) as total FROM pago")
        stats['ingresos'] = float(cur.fetchone()['total'])

        cur.execute("""
            SELECT pe.idpedido, c.nombre || ' ' || c.apellido AS cliente,
                   pe.fechapedido, pe.estadopedido,
                   COALESCE(SUM(dp.precioventa * dp.cantidad),0) AS total
            FROM pedido pe
            JOIN cliente c ON c.idcliente = pe.idcliente
            LEFT JOIN detallepedido dp ON dp.idpedido = pe.idpedido
            GROUP BY pe.idpedido, c.nombre, c.apellido, pe.fechapedido, pe.estadopedido
            ORDER BY pe.fechapedido DESC LIMIT 5
        """)
        ventas_recientes = cur.fetchall()

        cur.execute("""
            SELECT p.nombre, p.categoria, p.marca, p.imagen,
                   COALESCE(SUM(dp.cantidad),0) AS vendidos
            FROM producto p
            LEFT JOIN varianteproducto vp ON vp.idproducto = p.idproducto
            LEFT JOIN detallepedido dp ON dp.idvariante = vp.idvariante
            GROUP BY p.idproducto, p.nombre, p.categoria, p.marca, p.imagen
            ORDER BY vendidos DESC LIMIT 5
        """)
        productos_top = cur.fetchall()

        cur.close()
        conn.close()

    return render_template('dashboard.html', stats=stats,
                           ventas_recientes=ventas_recientes,
                           productos_top=productos_top)


# ─────────────────────────────────────────────
#  PRODUCTOS
# ─────────────────────────────────────────────
@app.route('/productos')
def productos():
    conn = get_db()
    productos = []
    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT * FROM producto ORDER BY idproducto DESC")
        productos = cur.fetchall()
        cur.close()
        conn.close()
    return render_template('productos.html', productos=productos)


@app.route('/productos/nuevo', methods=['GET', 'POST'])
def nuevo_producto():
    if request.method == 'POST':
        nombre = request.form['nombre']
        categoria = request.form['categoria']
        marca = request.form['marca']
        precio = request.form['preciobase']

        imagen_filename = None
        if 'imagen' in request.files:
            file = request.files['imagen']
            if file.filename != '':
                filename = secure_filename(file.filename)
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
                imagen_filename = filename

        conn = get_db()
        if conn:
            try:
                cur = conn.cursor()
                cur.execute(
                    "INSERT INTO producto (nombre, categoria, marca, preciobase, imagen) VALUES (%s,%s,%s,%s,%s)",
                    (nombre, categoria, marca, precio, imagen_filename)
                )
                conn.commit()
                cur.close()
                conn.close()
                flash('Producto agregado exitosamente.', 'success')
                return redirect(url_for('productos'))
            except Exception as e:
                conn.rollback()
                flash(f'Error: {e}', 'error')
                conn.close()

    return render_template('producto_form.html', producto=None, accion='Nuevo')


@app.route('/productos/editar/<int:id>', methods=['GET', 'POST'])
def editar_producto(id):
    conn = get_db()
    if request.method == 'POST':
        nombre = request.form['nombre']
        categoria = request.form['categoria']
        marca = request.form['marca']
        precio = request.form['preciobase']

        imagen_filename = None
        if 'imagen' in request.files:
            file = request.files['imagen']
            if file.filename != '':
                filename = secure_filename(file.filename)
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
                imagen_filename = filename

        if conn:
            try:
                cur = conn.cursor()
                if imagen_filename:
                    cur.execute(
                        "UPDATE producto SET nombre=%s, categoria=%s, marca=%s, preciobase=%s, imagen=%s WHERE idproducto=%s",
                        (nombre, categoria, marca, precio, imagen_filename, id)
                    )
                else:
                    cur.execute(
                        "UPDATE producto SET nombre=%s, categoria=%s, marca=%s, preciobase=%s WHERE idproducto=%s",
                        (nombre, categoria, marca, precio, id)
                    )
                conn.commit()
                cur.close()
                conn.close()
                flash('Producto actualizado.', 'success')
                return redirect(url_for('productos'))
            except Exception as e:
                conn.rollback()
                flash(f'Error: {e}', 'error')
                conn.close()

    producto = None
    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT * FROM producto WHERE idproducto=%s", (id,))
        producto = cur.fetchone()
        cur.close()
        conn.close()
    return render_template('producto_form.html', producto=producto, accion='Editar')


@app.route('/productos/eliminar/<int:id>', methods=['POST'])
def eliminar_producto(id):
    conn = get_db()
    if conn:
        try:
            cur = conn.cursor()
            cur.execute("DELETE FROM producto WHERE idproducto=%s", (id,))
            conn.commit()
            cur.close()
            conn.close()
            flash('Producto eliminado.', 'success')
        except Exception as e:
            conn.rollback()
            flash(f'Error: {e}', 'error')
            conn.close()
    return redirect(url_for('productos'))


# ─────────────────────────────────────────────
#  CLIENTES
# ─────────────────────────────────────────────
@app.route('/clientes')
def clientes():
    conn = get_db()
    clientes = []
    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT * FROM cliente ORDER BY idcliente DESC")
        clientes = cur.fetchall()
        cur.close()
        conn.close()
    return render_template('clientes.html', clientes=clientes)


@app.route('/clientes/nuevo', methods=['GET', 'POST'])
def nuevo_cliente():
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        direccion = request.form['direccion']
        telefono = request.form['telefono']
        email = request.form['email']

        conn = get_db()
        if conn:
            try:
                cur = conn.cursor()
                cur.execute(
                    "INSERT INTO cliente (nombre, apellido, direccion, telefono, email) VALUES (%s,%s,%s,%s,%s)",
                    (nombre, apellido, direccion, telefono, email)
                )
                conn.commit()
                cur.close()
                conn.close()
                flash('Cliente registrado exitosamente.', 'success')
                return redirect(url_for('clientes'))
            except Exception as e:
                conn.rollback()
                flash(f'Error: {e}', 'error')
                conn.close()

    return render_template('cliente_form.html', cliente=None, accion='Nuevo')


@app.route('/clientes/editar/<int:id>', methods=['GET', 'POST'])
def editar_cliente(id):
    conn = get_db()
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        direccion = request.form['direccion']
        telefono = request.form['telefono']
        email = request.form['email']

        if conn:
            try:
                cur = conn.cursor()
                cur.execute(
                    "UPDATE cliente SET nombre=%s, apellido=%s, direccion=%s, telefono=%s, email=%s WHERE idcliente=%s",
                    (nombre, apellido, direccion, telefono, email, id)
                )
                conn.commit()
                cur.close()
                conn.close()
                flash('Cliente actualizado.', 'success')
                return redirect(url_for('clientes'))
            except Exception as e:
                conn.rollback()
                flash(f'Error: {e}', 'error')
                conn.close()

    cliente = None
    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT * FROM cliente WHERE idcliente=%s", (id,))
        cliente = cur.fetchone()
        cur.close()
        conn.close()
    return render_template('cliente_form.html', cliente=cliente, accion='Editar')


@app.route('/clientes/eliminar/<int:id>', methods=['POST'])
def eliminar_cliente(id):
    conn = get_db()
    if conn:
        try:
            cur = conn.cursor()
            cur.execute("DELETE FROM cliente WHERE idcliente=%s", (id,))
            conn.commit()
            cur.close()
            conn.close()
            flash('Cliente eliminado.', 'success')
        except Exception as e:
            conn.rollback()
            flash(f'Error: {e}', 'error')
            conn.close()
    return redirect(url_for('clientes'))


# ─────────────────────────────────────────────
#  PEDIDOS / VENTAS
# ─────────────────────────────────────────────
@app.route('/pedidos')
def pedidos():
    conn = get_db()
    pedidos = []
    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("""
            SELECT pe.idpedido, c.nombre || ' ' || c.apellido AS cliente,
                   v.nombre || ' ' || v.apellido AS vendedor,
                   pe.fechapedido, pe.estadopedido,
                   COALESCE(SUM(dp.precioventa * dp.cantidad),0) AS total
            FROM pedido pe
            JOIN cliente c ON c.idcliente = pe.idcliente
            JOIN vendedor v ON v.idvendedor = pe.idvendedor
            LEFT JOIN detallepedido dp ON dp.idpedido = pe.idpedido
            GROUP BY pe.idpedido, c.nombre, c.apellido, v.nombre, v.apellido,
                     pe.fechapedido, pe.estadopedido
            ORDER BY pe.fechapedido DESC
        """)
        pedidos = cur.fetchall()
        cur.close()
        conn.close()
    return render_template('pedidos.html', pedidos=pedidos)


@app.route('/pedidos/nuevo', methods=['GET', 'POST'])
def nuevo_pedido():
    conn = get_db()
    clientes_list = []
    vendedores_list = []
    productos_list = []

    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT idcliente, nombre || ' ' || apellido AS nombre FROM cliente ORDER BY nombre")
        clientes_list = cur.fetchall()
        cur.execute("SELECT idvendedor, nombre || ' ' || apellido AS nombre FROM vendedor ORDER BY nombre")
        vendedores_list = cur.fetchall()
        cur.execute("""
            SELECT vp.idvariante,
                   p.nombre || ' - ' || vp.talla || ' / ' || vp.color AS descripcion,
                   p.preciobase
            FROM varianteproducto vp
            JOIN producto p ON p.idproducto = vp.idproducto
            WHERE vp.stockactual > 0
            ORDER BY p.nombre
        """)
        productos_list = cur.fetchall()
        cur.close()
        conn.close()

    if request.method == 'POST':
        idcliente = request.form['idcliente']
        idvendedor = request.form['idvendedor']
        fecha = request.form['fechapedido']
        estado = request.form['estadopedido']
        variantes = request.form.getlist('idvariante[]')
        cantidades = request.form.getlist('cantidad[]')
        precios = request.form.getlist('precio[]')
        metodo_pago = request.form['metodopago']

        conn2 = get_db()
        if conn2:
            try:
                cur = conn2.cursor()
                
                if idcliente == 'NEW':
                    new_nombre = request.form.get('new_nombre')
                    new_apellido = request.form.get('new_apellido')
                    new_telefono = request.form.get('new_telefono')
                    new_email = request.form.get('new_email')
                    new_direccion = request.form.get('new_direccion')
                    cur.execute(
                        "INSERT INTO cliente (nombre, apellido, direccion, telefono, email) VALUES (%s,%s,%s,%s,%s) RETURNING idcliente",
                        (new_nombre, new_apellido, new_direccion, new_telefono, new_email)
                    )
                    idcliente = cur.fetchone()[0]

                cur.execute(
                    "INSERT INTO pedido (idcliente, idvendedor, fechapedido, estadopedido) VALUES (%s,%s,%s,%s) RETURNING idpedido",
                    (idcliente, idvendedor, fecha, estado)
                )
                idpedido = cur.fetchone()[0]

                total_pago = 0
                for i in range(len(variantes)):
                    if variantes[i]:
                        cant = int(cantidades[i])
                        precio = float(precios[i])
                        cur.execute(
                            "INSERT INTO detallepedido (idpedido, idvariante, cantidad, precioventa) VALUES (%s,%s,%s,%s)",
                            (idpedido, variantes[i], cant, precio)
                        )
                        total_pago += cant * precio

                if total_pago > 0:
                    cur.execute(
                        "INSERT INTO pago (idpedido, fechapago, monto, metodopago) VALUES (%s,%s,%s,%s)",
                        (idpedido, fecha, total_pago, metodo_pago)
                    )

                conn2.commit()
                cur.close()
                conn2.close()
                flash('Pedido registrado exitosamente.', 'success')
                return redirect(url_for('pedidos'))
            except Exception as e:
                conn2.rollback()
                flash(f'Error al registrar pedido: {e}', 'error')
                conn2.close()

    return render_template('pedido_form.html',
                           clientes=clientes_list,
                           vendedores=vendedores_list,
                           productos=productos_list,
                           hoy=date.today().isoformat())


@app.route('/pedidos/estado/<int:id>', methods=['POST'])
def cambiar_estado(id):
    nuevo_estado = request.form['estado']
    conn = get_db()
    if conn:
        try:
            cur = conn.cursor()
            cur.execute("UPDATE pedido SET estadopedido=%s WHERE idpedido=%s", (nuevo_estado, id))
            conn.commit()
            cur.close()
            conn.close()
            flash('Estado actualizado.', 'success')
        except Exception as e:
            conn.rollback()
            flash(f'Error: {e}', 'error')
            conn.close()
    return redirect(url_for('pedidos'))


# ─────────────────────────────────────────────
#  VENDEDORES, PROVEEDORES, SUCURSALES E INVENTARIO (Vistas sencillas)
# ─────────────────────────────────────────────
@app.route('/vendedores', methods=['GET', 'POST'])
def vendedores():
    conn = get_db()
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        email = request.form['email']
        telefono = request.form['telefono']
        rol = request.form['rol']
        if conn:
            try:
                cur = conn.cursor()
                cur.execute("INSERT INTO vendedor (nombre, apellido, email, telefono, rol) VALUES (%s,%s,%s,%s,%s)", (nombre, apellido, email, telefono, rol))
                conn.commit()
                cur.close()
                flash('Vendedor agregado exitosamente.', 'success')
            except Exception as e:
                conn.rollback()
                flash(f'Error: {e}', 'error')
        return redirect(url_for('vendedores'))

    items = []
    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT idvendedor as id, nombre || ' ' || apellido as col1, email as col2, telefono as col3, rol as col4 FROM vendedor ORDER BY idvendedor DESC")
        items = cur.fetchall()
        cur.close()
        conn.close()
        
    form_fields = [
        {"name": "nombre", "label": "Nombre *", "type": "text", "required": True},
        {"name": "apellido", "label": "Apellido *", "type": "text", "required": True},
        {"name": "email", "label": "Email", "type": "email", "required": False},
        {"name": "telefono", "label": "Teléfono", "type": "text", "required": False},
        {"name": "rol", "label": "Rol (Cajero, Vendedor, Supervisor)", "type": "text", "required": False}
    ]
    return render_template('generico.html', titulo="Vendedores", icon="👔", items=items, headers=["ID", "Nombre", "Email", "Teléfono", "Rol"], form_fields=form_fields)

@app.route('/proveedores', methods=['GET', 'POST'])
def proveedores():
    conn = get_db()
    if request.method == 'POST':
        nombre = request.form['nombre']
        direccion = request.form['direccion']
        telefono = request.form['telefono']
        email = request.form['email']
        if conn:
            try:
                cur = conn.cursor()
                cur.execute("INSERT INTO proveedor (nombre, direccion, telefono, email) VALUES (%s,%s,%s,%s)", (nombre, direccion, telefono, email))
                conn.commit()
                cur.close()
                flash('Proveedor agregado exitosamente.', 'success')
            except Exception as e:
                conn.rollback()
                flash(f'Error: {e}', 'error')
        return redirect(url_for('proveedores'))

    items = []
    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT idproveedor as id, nombre as col1, direccion as col2, telefono as col3, email as col4 FROM proveedor ORDER BY idproveedor DESC")
        items = cur.fetchall()
        cur.close()
        conn.close()
        
    form_fields = [
        {"name": "nombre", "label": "Nombre *", "type": "text", "required": True},
        {"name": "direccion", "label": "Dirección", "type": "text", "required": False},
        {"name": "telefono", "label": "Teléfono", "type": "text", "required": False},
        {"name": "email", "label": "Email", "type": "email", "required": False}
    ]
    return render_template('generico.html', titulo="Proveedores", icon="🏭", items=items, headers=["ID", "Nombre", "Dirección", "Teléfono", "Email"], form_fields=form_fields)

@app.route('/sucursales', methods=['GET', 'POST'])
def sucursales():
    conn = get_db()
    if request.method == 'POST':
        nombre = request.form['nombre']
        direccion = request.form['direccion']
        ciudad = request.form['ciudad']
        if conn:
            try:
                cur = conn.cursor()
                cur.execute("INSERT INTO sucursal (nombre, direccion, ciudad) VALUES (%s,%s,%s)", (nombre, direccion, ciudad))
                conn.commit()
                cur.close()
                flash('Sucursal agregada exitosamente.', 'success')
            except Exception as e:
                conn.rollback()
                flash(f'Error: {e}', 'error')
        return redirect(url_for('sucursales'))

    items = []
    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT idsucursal as id, nombre as col1, direccion as col2, ciudad as col3, '' as col4 FROM sucursal ORDER BY idsucursal DESC")
        items = cur.fetchall()
        cur.close()
        conn.close()
        
    form_fields = [
        {"name": "nombre", "label": "Nombre *", "type": "text", "required": True},
        {"name": "direccion", "label": "Dirección", "type": "text", "required": False},
        {"name": "ciudad", "label": "Ciudad", "type": "text", "required": False}
    ]
    return render_template('generico.html', titulo="Sucursales", icon="🏢", items=items, headers=["ID", "Nombre", "Dirección", "Ciudad", ""], form_fields=form_fields)

@app.route('/inventario', methods=['GET', 'POST'])
def inventario():
    conn = get_db()
    if request.method == 'POST':
        idproducto = request.form['idproducto']
        talla = request.form['talla']
        color = request.form['color']
        stock = request.form['stockactual']
        if conn:
            try:
                cur = conn.cursor()
                cur.execute("INSERT INTO varianteproducto (idproducto, talla, color, stockactual) VALUES (%s,%s,%s,%s)", (idproducto, talla, color, stock))
                conn.commit()
                cur.close()
                flash('Variante agregada al inventario exitosamente.', 'success')
            except Exception as e:
                conn.rollback()
                flash(f'Error: {e}', 'error')
        return redirect(url_for('inventario'))

    items = []
    productos_opts = []
    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT vp.idvariante as id, p.nombre as col1, vp.talla as col2, vp.color as col3, vp.stockactual as col4 FROM varianteproducto vp JOIN producto p ON p.idproducto = vp.idproducto ORDER BY vp.idvariante DESC")
        items = cur.fetchall()
        
        cur.execute("SELECT idproducto as id, nombre FROM producto ORDER BY nombre")
        productos_opts = cur.fetchall()
        cur.close()
        conn.close()
        
    form_fields = [
        {"name": "idproducto", "label": "Producto *", "type": "select", "required": True, "options": productos_opts},
        {"name": "talla", "label": "Talla *", "type": "text", "required": True},
        {"name": "color", "label": "Color *", "type": "text", "required": True},
        {"name": "stockactual", "label": "Stock inicial *", "type": "number", "required": True}
    ]
    return render_template('generico.html', titulo="Inventario (Variantes)", icon="📦", items=items, headers=["ID", "Producto", "Talla", "Color", "Stock"], form_fields=form_fields)

# ─────────────────────────────────────────────
#  API – precios de variantes (AJAX)
# ─────────────────────────────────────────────
@app.route('/api/variante/<int:id>')
def api_variante(id):
    conn = get_db()
    if conn:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("""
            SELECT vp.idvariante, p.preciobase, vp.stockactual
            FROM varianteproducto vp
            JOIN producto p ON p.idproducto = vp.idproducto
            WHERE vp.idvariante=%s
        """, (id,))
        row = cur.fetchone()
        cur.close()
        conn.close()
        if row:
            return jsonify(dict(row))
    return jsonify({'error': 'not found'}), 404


if __name__ == '__main__':
    app.run(debug=True)
