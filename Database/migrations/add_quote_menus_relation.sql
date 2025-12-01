-- ===========================
--  RELACIÓN ENTRE COTIZACIONES Y MENÚS
-- ===========================

-- Tabla para asociar menús con cotizaciones
-- Una cotización puede tener múltiples menús seleccionados
CREATE TABLE IF NOT EXISTS quote_menus (
  id                BIGSERIAL PRIMARY KEY,
  quote_request_id  BIGINT NOT NULL REFERENCES quote_requests(id) ON DELETE CASCADE,
  menu_id           BIGINT NOT NULL REFERENCES menus(id) ON DELETE CASCADE,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(quote_request_id, menu_id)
);

-- Índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_quote_menus_quote ON quote_menus(quote_request_id);
CREATE INDEX IF NOT EXISTS idx_quote_menus_menu ON quote_menus(menu_id);

-- Comentarios para documentación
COMMENT ON TABLE quote_menus IS 'Relación muchos-a-muchos entre cotizaciones y menús seleccionados';
COMMENT ON COLUMN quote_menus.quote_request_id IS 'ID de la cotización';
COMMENT ON COLUMN quote_menus.menu_id IS 'ID del menú seleccionado';
