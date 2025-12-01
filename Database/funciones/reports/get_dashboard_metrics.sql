-- Function to get all dashboard metrics in a single call
-- Returns aggregated data for revenue, orders, events, clients, and menus

CREATE OR REPLACE FUNCTION get_dashboard_metrics()
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  result JSON;
  current_month_start DATE;
  current_year_start DATE;
  last_month_start DATE;
  last_month_end DATE;
BEGIN
  -- Calculate date ranges
  current_month_start := DATE_TRUNC('month', CURRENT_DATE);
  current_year_start := DATE_TRUNC('year', CURRENT_DATE);
  last_month_start := DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month');
  last_month_end := current_month_start - INTERVAL '1 day';

  -- Build the complete metrics JSON
  SELECT JSON_BUILD_OBJECT(
    'revenue', (
      SELECT JSON_BUILD_OBJECT(
        'total_revenue', COALESCE(SUM(CASE WHEN estado IN ('ACEPTADA', 'RESERVADO', 'CONFIRMADO') THEN monto_cotizado ELSE 0 END), 0),
        'month_revenue', COALESCE(SUM(CASE 
          WHEN estado IN ('ACEPTADA', 'RESERVADO', 'CONFIRMADO') AND fecha_evento >= current_month_start 
          THEN monto_cotizado ELSE 0 END), 0),
        'year_revenue', COALESCE(SUM(CASE 
          WHEN estado IN ('ACEPTADA', 'RESERVADO', 'CONFIRMADO') AND fecha_evento >= current_year_start 
          THEN monto_cotizado ELSE 0 END), 0),
        'average_ticket', COALESCE(AVG(CASE WHEN estado IN ('ACEPTADA', 'RESERVADO', 'CONFIRMADO') THEN monto_cotizado END), 0),
        'month_growth', CASE 
          WHEN SUM(CASE 
            WHEN estado IN ('ACEPTADA', 'RESERVADO', 'CONFIRMADO')
            AND fecha_evento >= last_month_start 
            AND fecha_evento <= last_month_end 
            THEN monto_cotizado ELSE 0 END) > 0
          THEN (
            (SUM(CASE WHEN estado IN ('ACEPTADA', 'RESERVADO', 'CONFIRMADO') AND fecha_evento >= current_month_start THEN monto_cotizado ELSE 0 END) - 
             SUM(CASE WHEN estado IN ('ACEPTADA', 'RESERVADO', 'CONFIRMADO') AND fecha_evento >= last_month_start AND fecha_evento <= last_month_end THEN monto_cotizado ELSE 0 END)) 
            / SUM(CASE WHEN estado IN ('ACEPTADA', 'RESERVADO', 'CONFIRMADO') AND fecha_evento >= last_month_start AND fecha_evento <= last_month_end THEN monto_cotizado ELSE 0 END) * 100
          )
          ELSE 0
        END
      )
      FROM quote_requests
    ),
    'orders', (
      SELECT JSON_BUILD_OBJECT(
        'total_orders', COUNT(*),
        'pending_orders', SUM(CASE WHEN estado = 'PENDIENTE' THEN 1 ELSE 0 END),
        'in_progress_orders', SUM(CASE WHEN estado IN ('EN_REVISION', 'COTIZADA', 'ACEPTADA', 'RESERVADO') THEN 1 ELSE 0 END),
        'completed_orders', SUM(CASE WHEN estado = 'CONFIRMADO' THEN 1 ELSE 0 END),
        'cancelled_orders', SUM(CASE WHEN estado IN ('RECHAZADA', 'CANCELADA') THEN 1 ELSE 0 END),
        'month_orders', SUM(CASE WHEN fecha_evento >= current_month_start THEN 1 ELSE 0 END),
        'month_growth', CASE 
          WHEN SUM(CASE WHEN fecha_evento >= last_month_start AND fecha_evento <= last_month_end THEN 1 ELSE 0 END) > 0
          THEN (
            (SUM(CASE WHEN fecha_evento >= current_month_start THEN 1 ELSE 0 END)::FLOAT - 
             SUM(CASE WHEN fecha_evento >= last_month_start AND fecha_evento <= last_month_end THEN 1 ELSE 0 END)::FLOAT) 
            / SUM(CASE WHEN fecha_evento >= last_month_start AND fecha_evento <= last_month_end THEN 1 ELSE 0 END)::FLOAT * 100
          )
          ELSE 0
        END
      )
      FROM quote_requests
    ),
    'events', (
      SELECT JSON_BUILD_OBJECT(
        'active_events', SUM(CASE WHEN fecha_evento >= CURRENT_DATE AND fecha_evento <= CURRENT_DATE + INTERVAL '30 days' THEN 1 ELSE 0 END),
        'completed_events', SUM(CASE WHEN fecha_evento < CURRENT_DATE AND estado = 'CONFIRMADO' THEN 1 ELSE 0 END),
        'year_events', SUM(CASE WHEN fecha_evento >= current_year_start THEN 1 ELSE 0 END),
        'occupancy_rate', CASE 
          WHEN COUNT(*) > 0 
          THEN (SUM(CASE WHEN fecha_evento >= current_month_start THEN 1 ELSE 0 END)::FLOAT / 30 * 100)
          ELSE 0 
        END
      )
      FROM quote_requests
      WHERE estado IN ('ACEPTADA', 'RESERVADO', 'CONFIRMADO')
    ),
    'clients', (
      SELECT JSON_BUILD_OBJECT(
        'total_clients', COUNT(DISTINCT id),
        'new_clients_month', COUNT(DISTINCT CASE WHEN created_at >= current_month_start THEN id END),
        'recurring_clients', COUNT(DISTINCT CASE 
          WHEN id IN (
            SELECT cliente_id 
            FROM quote_requests 
            GROUP BY cliente_id 
            HAVING COUNT(*) > 1
          ) THEN id END),
        'recurring_percentage', CASE 
          WHEN COUNT(DISTINCT id) > 0 
          THEN (COUNT(DISTINCT CASE 
            WHEN id IN (
              SELECT cliente_id 
              FROM quote_requests 
              GROUP BY cliente_id 
              HAVING COUNT(*) > 1
            ) THEN id END)::FLOAT / COUNT(DISTINCT id)::FLOAT * 100)
          ELSE 0 
        END
      )
      FROM users
      WHERE role = 'CLIENTE'
    ),
    'menus', (
      SELECT JSON_BUILD_OBJECT(
        'available_menus', (SELECT COUNT(*) FROM menus WHERE esta_activo = true),
        'total_dishes', (SELECT COUNT(*) FROM dishes),
        'most_popular_menu', 'N/A',
        'most_popular_menu_orders', 0
      )
    )
  ) INTO result;

  RETURN result;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_dashboard_metrics() TO authenticated;
