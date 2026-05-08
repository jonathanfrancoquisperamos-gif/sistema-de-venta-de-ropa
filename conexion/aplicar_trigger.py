import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from conexion import crear_conexion

sql_trigger = """
-- 1. Crear la función del trigger
CREATE OR REPLACE FUNCTION fn_descontar_stock()
RETURNS TRIGGER AS $$
BEGIN
    -- Restar el stock
    UPDATE varianteproducto
    SET stockactual = stockactual - NEW.cantidad
    WHERE idvariante = NEW.idvariante;
    
    -- Validar que el stock no sea negativo
    IF (SELECT stockactual FROM varianteproducto WHERE idvariante = NEW.idvariante) < 0 THEN
        RAISE EXCEPTION 'Stock insuficiente para la variante ID: %', NEW.idvariante;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Eliminar el trigger si ya existe para evitar errores
DROP TRIGGER IF EXISTS trg_descontar_stock ON detallepedido;

-- 3. Crear el trigger
CREATE TRIGGER trg_descontar_stock
AFTER INSERT ON detallepedido
FOR EACH ROW
EXECUTE FUNCTION fn_descontar_stock();
"""

def aplicar():
    conn = crear_conexion()
    if conn:
        try:
            cur = conn.cursor()
            cur.execute(sql_trigger)
            conn.commit()
            print("¡Trigger trg_descontar_stock creado y aplicado exitosamente en la base de datos!")
        except Exception as e:
            print(f"Error al aplicar el trigger: {e}")
            conn.rollback()
        finally:
            conn.close()

if __name__ == '__main__':
    aplicar()
