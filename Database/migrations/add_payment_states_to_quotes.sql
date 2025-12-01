-- ===========================
--  MIGRACIÓN: Agregar estados de pago a quote_requests
-- ===========================

-- Agregar nuevos estados al enum quote_status
ALTER TYPE quote_status ADD VALUE IF NOT EXISTS 'RESERVADO';
ALTER TYPE quote_status ADD VALUE IF NOT EXISTS 'CONFIRMADO';

-- Nota: Los valores se agregan al final del enum
-- El orden será: PENDIENTE, EN_REVISION, COTIZADA, ACEPTADA, RECHAZADA, CANCELADA, RESERVADO, CONFIRMADO

-- Actualizar el trigger para usar los nuevos estados
CREATE OR REPLACE FUNCTION update_quote_status_after_payment()
RETURNS TRIGGER AS $$
BEGIN
  -- Si el pago es de tipo SENIAL y está PAGADO, actualizar cotización a RESERVADO
  IF NEW.tipo = 'SENIAL' AND NEW.estado = 'PAGADO' THEN
    -- Actualizar en quote_requests si existe
    UPDATE quote_requests 
    SET estado = 'RESERVADO',
        updated_at = NOW()
    WHERE id = NEW.event_id 
    AND estado = 'COTIZADA';  
    
    -- Actualizar en events si existe (para compatibilidad futura)
    UPDATE events 
    SET estado = 'RESERVADO' 
    WHERE id = NEW.event_id 
    AND estado = 'COTIZACION';
  END IF;
  
  -- Si el pago es de tipo SALDO y está PAGADO, actualizar a CONFIRMADO
  IF NEW.tipo = 'SALDO' AND NEW.estado = 'PAGADO' THEN
    -- Actualizar en quote_requests si existe
    UPDATE quote_requests 
    SET estado = 'CONFIRMADO',
        updated_at = NOW()
    WHERE id = NEW.event_id 
    AND estado = 'RESERVADO';
    
    -- Actualizar en events si existe (para compatibilidad futura)
    UPDATE events 
    SET estado = 'CONFIRMADO' 
    WHERE id = NEW.event_id 
    AND estado = 'RESERVADO';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Recrear el trigger
DROP TRIGGER IF EXISTS trigger_update_quote_status_after_payment ON payments;
CREATE TRIGGER trigger_update_quote_status_after_payment
AFTER INSERT OR UPDATE ON payments
FOR EACH ROW
EXECUTE FUNCTION update_quote_status_after_payment();

-- Verificar que el trigger se creó correctamente
SELECT 
  trigger_name, 
  event_manipulation, 
  event_object_table, 
  action_statement
FROM information_schema.triggers
WHERE trigger_name = 'trigger_update_quote_status_after_payment';
