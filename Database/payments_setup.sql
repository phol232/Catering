-- ===========================
--  VERIFICACIÓN Y SETUP DE TABLA PAYMENTS
-- ===========================

-- Verificar que la tabla payments existe
SELECT EXISTS (
  SELECT FROM information_schema.tables 
  WHERE table_schema = 'public' 
  AND table_name = 'payments'
);

-- Si necesitas crear la tabla (ya debería existir en schema.sql)
-- CREATE TABLE IF NOT EXISTS payments (
--   id                BIGSERIAL PRIMARY KEY,
--   event_id          BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
--   tipo              payment_type NOT NULL,
--   monto             NUMERIC(10,2) NOT NULL,
--   fecha             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
--   metodo            TEXT,
--   estado            payment_status NOT NULL DEFAULT 'PENDIENTE',
--   referencia_externa TEXT
-- );

-- Habilitar RLS (Row Level Security) para payments
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- Política: Los clientes solo pueden ver sus propios pagos
CREATE POLICY "Clientes pueden ver sus propios pagos"
ON payments
FOR SELECT
USING (
  event_id IN (
    SELECT id FROM events WHERE cliente_id = auth.uid()::bigint
  )
);

-- Política: Los admins pueden ver todos los pagos
CREATE POLICY "Admins pueden ver todos los pagos"
ON payments
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE id = auth.uid()::bigint 
    AND role = 'ADMIN'
  )
);

-- Política: Solo el sistema puede insertar pagos (desde backend)
CREATE POLICY "Sistema puede insertar pagos"
ON payments
FOR INSERT
WITH CHECK (true);

-- Política: Admins pueden actualizar pagos
CREATE POLICY "Admins pueden actualizar pagos"
ON payments
FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE id = auth.uid()::bigint 
    AND role = 'ADMIN'
  )
);

-- Índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_payments_event_id ON payments(event_id);
CREATE INDEX IF NOT EXISTS idx_payments_estado ON payments(estado);
CREATE INDEX IF NOT EXISTS idx_payments_referencia_externa ON payments(referencia_externa);

-- Función para actualizar el estado del evento/cotización después de un pago
CREATE OR REPLACE FUNCTION update_quote_status_after_payment()
RETURNS TRIGGER AS $$
BEGIN
  -- Si el pago es de tipo SENIAL y está PAGADO, actualizar cotización a RESERVADO
  IF NEW.tipo = 'SENIAL' AND NEW.estado = 'PAGADO' THEN
    -- Actualizar en events si existe
    UPDATE events 
    SET estado = 'RESERVADO' 
    WHERE id = NEW.event_id 
    AND estado = 'COTIZACION';
    
    -- Actualizar en quote_requests si existe
    UPDATE quote_requests 
    SET estado = 'RESERVADO' 
    WHERE id = NEW.event_id 
    AND estado = 'ACEPTADA';
  END IF;
  
  -- Si el pago es de tipo SALDO y está PAGADO, actualizar a CONFIRMADO
  IF NEW.tipo = 'SALDO' AND NEW.estado = 'PAGADO' THEN
    -- Actualizar en events si existe
    UPDATE events 
    SET estado = 'CONFIRMADO' 
    WHERE id = NEW.event_id 
    AND estado = 'RESERVADO';
    
    -- Actualizar en quote_requests si existe
    UPDATE quote_requests 
    SET estado = 'CONFIRMADO' 
    WHERE id = NEW.event_id 
    AND estado = 'RESERVADO';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para ejecutar la función después de insertar o actualizar un pago
DROP TRIGGER IF EXISTS trigger_update_quote_status_after_payment ON payments;
CREATE TRIGGER trigger_update_quote_status_after_payment
AFTER INSERT OR UPDATE ON payments
FOR EACH ROW
EXECUTE FUNCTION update_quote_status_after_payment();

-- Consulta de ejemplo para ver pagos con información del evento
-- SELECT 
--   p.id,
--   p.event_id,
--   e.nombre_evento,
--   p.tipo,
--   p.monto,
--   p.fecha,
--   p.metodo,
--   p.estado,
--   p.referencia_externa
-- FROM payments p
-- JOIN events e ON p.event_id = e.id
-- ORDER BY p.fecha DESC;
