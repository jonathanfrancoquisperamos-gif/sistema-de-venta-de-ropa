import sys
import os
from flask import Flask, render_template

# Permite importar desde la misma carpeta a pesar de cómo se ejecute
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from conexion import crear_conexion
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

@app.route('/')
def index():
    conn = crear_conexion()
    productos = []
    error = None
    
    if conn:
        try:
            # RealDictCursor nos devuelve los resultados como diccionarios
            cur = conn.cursor(cursor_factory=RealDictCursor)
            
            # La tabla se llama 'producto' en minúsculas en PostgreSQL
            cur.execute('SELECT * FROM producto')
            productos = cur.fetchall()
                
            cur.close()
        except Exception as query_error:
            error = f"Error al realizar la consulta: {query_error}"
        finally:
            conn.close()
    else:
        error = "No se pudo conectar a la base de datos PostgreSQL."

    return render_template('index.html', productos=productos, error=error)

if __name__ == '__main__':
    # Levanta el servidor de desarrollo
    app.run(debug=True)
