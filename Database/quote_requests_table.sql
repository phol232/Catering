-- ===========================
--  TABLAS NORMALIZADAS DE SOLICITUDES DE COTIZACIÓN
-- ===========================

-- Enum para estados de cotización
CREATE TYPE quote_status AS ENUM (
  'PENDIENTE',      -- Recién creada, esperando revisión
  'EN_REVISION',    -- Admin está revisando
  'COTIZADA',       -- Admin envió cotización
  'ACEPTADA',       -- Cliente aceptó la cotización
  'RECHAZADA',      -- Cliente rechazó
  'CANCELADA'       -- Cancelada por cualquier motivo
);

-- Tabla principal de solicitudes de cotización
CREATE TABLE quote_requests (
  id                BIGSERIAL PRIMARY KEY,
  cliente_id        BIGINT NOT NULL REFERENCES users(id),
  
  -- Información básica del evento
  nombre_evento     VARCHAR(150) NOT NULL,
  tipo_evento       VARCHAR(50) NOT NULL,
  fecha_evento      DATE NOT NULL,
  hora_inicio       TIME,
  hora_fin          TIME,
  num_invitados     INTEGER NOT NULL,
  
  -- Ubicación
  direccion         TEXT NOT NULL,
  ciudad            VARCHAR(100) NOT NULL,
  
  -- Detalles del servicio
  tipo_servicio     VARCHAR(100),
  descripcion       TEXT,
  presupuesto_aproximado NUMERIC(10,2),
  
  -- Contacto
  telefono_contacto VARCHAR(30) NOT NULL,
  email_contacto    VARCHAR(255) NOT NULL,
  
  -- Estado y seguimiento
  estado            quote_status NOT NULL DEFAULT 'PENDIENTE',
  monto_cotizado    NUMERIC(10,2),
  notas_admin       TEXT,
  
  -- Timestamps
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Tabla de restricciones alimentarias por cotización
CREATE TABLE quote_dietary_restrictions (
  id                BIGSERIAL PRIMARY KEY,
  quote_request_id  BIGINT NOT NULL REFERENCES quote_requests(id) ON DELETE CASCADE,
  descripcion       TEXT NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Tabla de servicios adicionales solicitados
CREATE TABLE quote_additional_services (
  id                BIGSERIAL PRIMARY KEY,
  quote_request_id  BIGINT NOT NULL REFERENCES quote_requests(id) ON DELETE CASCADE,
  servicio          VARCHAR(50) NOT NULL,  -- meseros, montaje, decoracion, sonido
  descripcion       TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Índices para mejorar rendimiento
CREATE INDEX idx_quote_requests_cliente ON quote_requests(cliente_id);
CREATE INDEX idx_quote_requests_estado ON quote_requests(estado);
CREATE INDEX idx_quote_requests_fecha ON quote_requests(fecha_evento);
CREATE INDEX idx_quote_dietary_restrictions_quote ON quote_dietary_restrictions(quote_request_id);
CREATE INDEX idx_quote_additional_services_quote ON quote_additional_services(quote_request_id);

-- Trigger para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_quote_request_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_quote_request_timestamp
BEFORE UPDATE ON quote_requests
FOR EACH ROW
EXECUTE FUNCTION update_quote_request_timestamp();

-- Comentarios para documentación
COMMENT ON TABLE quote_requests IS 'Solicitudes de cotización realizadas por clientes';
COMMENT ON TABLE quote_dietary_restrictions IS 'Restricciones alimentarias específicas por cotización';
COMMENT ON TABLE quote_additional_services IS 'Servicios adicionales solicitados por cotización';
COMMENT ON COLUMN quote_requests.estado IS 'Estado actual de la solicitud';
COMMENT ON COLUMN quote_requests.monto_cotizado IS 'Monto final cotizado por el administrador';
