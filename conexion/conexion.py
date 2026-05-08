import psycopg2
from psycopg2 import OperationalError

def crear_conexion():
   
    try:
       
        conexion = psycopg2.connect(
            host="localhost",           
            database="tienda_ropa", 
            user="postgres",           
            password="jona",   
            port="5432"                
        )
        print("Conexión exitosa a la base de datos de PostgreSQL")
        return conexion
    
    except OperationalError as e:
        print("Error al conectar ")
        print(e)
        return None

if __name__ == "__main__":
    conn = crear_conexion()
    
    if conn:
        conn.close()
        print("Conexión cerrada.")
