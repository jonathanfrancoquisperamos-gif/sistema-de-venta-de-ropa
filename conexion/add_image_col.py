import psycopg2
from conexion import crear_conexion

conn = crear_conexion()
if conn:
    try:
        cur = conn.cursor()
        cur.execute("ALTER TABLE producto ADD COLUMN imagen VARCHAR(255);")
        conn.commit()
        print("Columna 'imagen' añadida a 'producto'.")
        cur.close()
    except Exception as e:
        print(f"Error: {e}")
    finally:
        conn.close()
