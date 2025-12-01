-- EJECUTA ESTE SCRIPT EN SUPABASE SQL EDITOR

-- 1. Crear tabla de menús
CREATE TABLE IF NOT EXISTS menus (
  id BIGSERIAL PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  tipo VARCHAR(50),
  descripcion TEXT,
  precio_por_persona NUMERIC(10,2) NOT NULL,
  costo_por_persona NUMERIC(10,2),
  esta_activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- 2. Crear tabla de platos
CREATE TABLE IF NOT EXISTS dishes (
  id BIGSERIAL PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  descripcion TEXT,
  categoria VARCHAR(50),
  es_vegetariano BOOLEAN DEFAULT FALSE,
  es_vegano BOOLEAN DEFAULT FALSE,
  es_sin_gluten BOOLEAN DEFAULT FALSE,
  es_sin_lactosa BOOLEAN DEFAULT FALSE
);

-- 3. Crear tabla de relación menú-platos
CREATE TABLE IF NOT EXISTS menu_dishes (
  menu_id BIGINT NOT NULL REFERENCES menus(id) ON DELETE CASCADE,
  dish_id BIGINT NOT NULL REFERENCES dishes(id) ON DELETE CASCADE,
  cantidad INTEGER DEFAULT 1,
  PRIMARY KEY (menu_id, dish_id)
);

-- 4. Habilitar RLS
ALTER TABLE menus ENABLE ROW LEVEL SECURITY;
ALTER TABLE dishes ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_dishes ENABLE ROW LEVEL SECURITY;

-- 5. Políticas para menus (todos pueden ver, solo admins pueden modificar)
DROP POLICY IF EXISTS "Todos pueden ver menús activos" ON menus;
CREATE POLICY "Todos pueden ver menús activos" ON menus
  FOR SELECT
  USING (esta_activo = TRUE OR auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Admins pueden gestionar menús" ON menus;
CREATE POLICY "Admins pueden gestionar menús" ON menus
  FOR ALL
  USING (auth.uid() IS NOT NULL);

-- 6. Políticas para dishes (todos pueden ver, solo admins pueden modificar)
DROP POLICY IF EXISTS "Todos pueden ver platos" ON dishes;
CREATE POLICY "Todos pueden ver platos" ON dishes
  FOR SELECT
  USING (TRUE);

DROP POLICY IF EXISTS "Admins pueden gestionar platos" ON dishes;
CREATE POLICY "Admins pueden gestionar platos" ON dishes
  FOR ALL
  USING (auth.uid() IS NOT NULL);

-- 7. Políticas para menu_dishes
DROP POLICY IF EXISTS "Todos pueden ver menu_dishes" ON menu_dishes;
CREATE POLICY "Todos pueden ver menu_dishes" ON menu_dishes
  FOR SELECT
  USING (TRUE);

DROP POLICY IF EXISTS "Admins pueden gestionar menu_dishes" ON menu_dishes;
CREATE POLICY "Admins pueden gestionar menu_dishes" ON menu_dishes
  FOR ALL
  USING (auth.uid() IS NOT NULL);

-- 8. Insertar datos de prueba
INSERT INTO dishes (nombre, descripcion, categoria, es_vegetariano, es_vegano, es_sin_gluten, es_sin_lactosa)
VALUES 
  ('Ensalada César', 'Ensalada clásica con aderezo césar', 'entrada', TRUE, FALSE, FALSE, FALSE),
  ('Pollo a la Parrilla', 'Pechuga de pollo marinada', 'fondo', FALSE, FALSE, TRUE, TRUE),
  ('Pasta Alfredo', 'Pasta con salsa cremosa', 'fondo', TRUE, FALSE, FALSE, FALSE)
ON CONFLICT DO NOTHING;

INSERT INTO menus (nombre, tipo, descripcion, precio_por_persona, costo_por_persona, esta_activo)
VALUES 
  ('Menú Ejecutivo', 'buffet', 'Menú completo para eventos corporativos', 25.00, 15.00, TRUE)
ON CONFLICT DO NOTHING;

-- Verificar que todo se creó correctamente
SELECT 'Menús creados:' as info, COUNT(*) as total FROM menus
UNION ALL
SELECT 'Platos creados:', COUNT(*) FROM dishes;
