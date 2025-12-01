-- #############################################################################
--  ARCHIVO DE FUNCIONES SQL PARA CATERING APP
-- #############################################################################

-- =============================================================================
--  FUNCIÓN: OBTENER TODOS LOS EVENTOS (PARA VISTA PRINCIPAL)
--  Propósito: Devuelve una lista simplificada de todos los eventos para la HomeScreen.
--  HU: El usuario cliente y el gestor pueden ver los eventos disponibles/creados.
-- =============================================================================
CREATE OR REPLACE FUNCTION get_all_events()
RETURNS TABLE (
  id BIGINT,
  nombre_evento VARCHAR(150),
  fecha DATE,
  ciudad VARCHAR(100),
  num_invitados INTEGER,
  menu_nombre VARCHAR(120),
  estado event_status
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.id,
    e.nombre_evento,
    e.fecha,
    e.ciudad,
    e.num_invitados,
    m.nombre AS menu_nombre,
    e.estado
  FROM
    events AS e
  LEFT JOIN
    menus AS m ON e.menu_id = m.id
  ORDER BY
    e.fecha DESC;
END;
$$ LANGUAGE plpgsql;


-- =============================================================================
--  FUNCIÓN: CALCULAR COTIZACIÓN DE UN EVENTO
--  Propósito: Calcula el costo total de un evento y actualiza el resumen financiero.
--  HU-C1: Obtener cotización automática según número de invitados y menú.
--  RF1: Cotización por invitados.
-- =============================================================================
CREATE OR REPLACE FUNCTION calculate_quote(p_event_id BIGINT)
RETURNS NUMERIC(10, 2) AS $$
DECLARE
  v_menu_cost NUMERIC(10, 2) := 0;
  v_extras_cost NUMERIC(10, 2) := 0;
  v_total_quote NUMERIC(10, 2);
BEGIN
  -- 1. Calcular costo del menú (precio por persona * número de invitados)
  SELECT
    COALESCE(e.num_invitados * m.precio_por_persona, 0) INTO v_menu_cost
  FROM
    events AS e
  JOIN
    menus AS m ON e.menu_id = m.id
  WHERE
    e.id = p_event_id;

  -- 2. Calcular costo total de los servicios extra seleccionados
  SELECT
    COALESCE(SUM(ee.subtotal), 0) INTO v_extras_cost
  FROM
    event_extras AS ee
  WHERE
    ee.event_id = p_event_id;

  -- 3. Calcular el total de la cotización
  v_total_quote := v_menu_cost + v_extras_cost;

  -- 4. Actualizar la tabla financiera con el ingreso estimado (la cotización)
  INSERT INTO event_finance (event_id, ingreso_estimado)
  VALUES (p_event_id, v_total_quote)
  ON CONFLICT (event_id) DO UPDATE
  SET ingreso_estimado = EXCLUDED.ingreso_estimado;

  RETURN v_total_quote;
END;
$$ LANGUAGE plpgsql;
