-- ===========================
--  TIPOS ENUM
-- ===========================
CREATE TYPE user_role AS ENUM ('CLIENTE', 'ADMIN', 'LOGISTICA', 'COCINA', 'GESTOR');

CREATE TYPE event_status AS ENUM (
  'COTIZACION',
  'RESERVA_PENDIENTE_PAGO',
  'RESERVADO',
  'CONFIRMADO',
  'EN_PROCESO',
  'FINALIZADO',
  'CANCELADO'
);

CREATE TYPE price_unit AS ENUM ('POR_EVENTO', 'POR_PERSONA', 'POR_HORA');

CREATE TYPE payment_type AS ENUM ('SENIAL', 'SALDO', 'OTRO');

CREATE TYPE payment_status AS ENUM ('PENDIENTE', 'PAGADO', 'ANULADO');

CREATE TYPE restriction_type AS ENUM ('ALERGIA', 'RELIGIOSA', 'ETICA', 'OTRA');

-- ===========================
--  USUARIOS
-- ===========================
CREATE TABLE users (
  id             BIGSERIAL PRIMARY KEY,
  nombre         VARCHAR(120) NOT NULL,
  email          VARCHAR(255) UNIQUE NOT NULL,
  telefono       VARCHAR(30),
  password_hash  TEXT NOT NULL,
  role           user_role NOT NULL DEFAULT 'CLIENTE',
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ===========================
--  MENÚS Y PLATOS
-- ===========================
CREATE TABLE menus (
  id                   BIGSERIAL PRIMARY KEY,
  nombre               VARCHAR(120) NOT NULL,
  tipo                 VARCHAR(50), -- buffet, cóctel, etc.
  descripcion          TEXT,
  precio_por_persona   NUMERIC(10,2) NOT NULL,
  costo_por_persona    NUMERIC(10,2),       -- opcional, para margen
  esta_activo          BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE dishes (
  id             BIGSERIAL PRIMARY KEY,
  nombre         VARCHAR(120) NOT NULL,
  descripcion    TEXT,
  categoria      VARCHAR(50), -- entrada, fondo, postre, bebida...
  es_vegetariano BOOLEAN,
  es_vegano      BOOLEAN,
  es_sin_gluten  BOOLEAN,
  es_sin_lactosa BOOLEAN
);

-- Relación muchos-a-muchos menú <-> platos
CREATE TABLE menu_dishes (
  menu_id   BIGINT NOT NULL REFERENCES menus(id) ON DELETE CASCADE,
  dish_id   BIGINT NOT NULL REFERENCES dishes(id) ON DELETE CASCADE,
  cantidad  INTEGER,
  PRIMARY KEY (menu_id, dish_id)
);

-- ===========================
--  EVENTOS / COTIZACIONES
-- ===========================
CREATE TABLE events (
  id              BIGSERIAL PRIMARY KEY,
  cliente_id      BIGINT NOT NULL REFERENCES users(id),
  menu_id         BIGINT REFERENCES menus(id),
  nombre_evento   VARCHAR(150),
  tipo_evento     VARCHAR(50), -- boda, corporativo, etc.
  fecha           DATE NOT NULL,
  hora_inicio     TIME,
  hora_fin        TIME,
  num_invitados   INTEGER NOT NULL,
  direccion       TEXT,
  ciudad          VARCHAR(100),
  estado          event_status NOT NULL DEFAULT 'COTIZACION',
  nota_cliente    TEXT,
  image_url       TEXT, -- URL de la imagen del evento
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ===========================
--  SERVICIOS EXTRA (montaje, meseros, etc.)
-- ===========================
CREATE TABLE extra_services (
  id              BIGSERIAL PRIMARY KEY,
  nombre          VARCHAR(120) NOT NULL,
  descripcion     TEXT,
  tipo            VARCHAR(50), -- montaje, meseros, sonido, decoración...
  unidad          price_unit NOT NULL DEFAULT 'POR_EVENTO',
  precio_unitario NUMERIC(10,2) NOT NULL,
  costo_unitario  NUMERIC(10,2),
  esta_activo     BOOLEAN NOT NULL DEFAULT TRUE
);

-- Servicios extra seleccionados por evento (HU-C2, RF3)
CREATE TABLE event_extras (
  id              BIGSERIAL PRIMARY KEY,
  event_id        BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  extra_id        BIGINT NOT NULL REFERENCES extra_services(id),
  cantidad        INTEGER NOT NULL DEFAULT 1,
  precio_unitario NUMERIC(10,2) NOT NULL,
  subtotal        NUMERIC(10,2) NOT NULL
);

-- ===========================
--  INVITADOS Y ALERGIAS (RF5)
-- ===========================
CREATE TABLE guests (
  id                   BIGSERIAL PRIMARY KEY,
  event_id             BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  nombre               VARCHAR(120),
  email                VARCHAR(255),
  telefono             VARCHAR(30),
  tiene_restricciones  BOOLEAN NOT NULL DEFAULT FALSE,
  notas                TEXT
);

CREATE TABLE guest_restrictions (
  id          BIGSERIAL PRIMARY KEY,
  guest_id    BIGINT NOT NULL REFERENCES guests(id) ON DELETE CASCADE,
  tipo        restriction_type NOT NULL,
  descripcion TEXT NOT NULL
);

-- ===========================
--  PERSONAL ASIGNADO (LOGÍSTICA / COCINA / MESEROS) HU-E2
-- ===========================
CREATE TABLE event_staff (
  id             BIGSERIAL PRIMARY KEY,
  event_id       BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  staff_id       BIGINT NOT NULL REFERENCES users(id),
  rol_en_evento  VARCHAR(50), -- jefe cocina, mesero, logística, chofer...
  hora_inicio    TIME,
  hora_fin       TIME,
  notas          TEXT
);

-- ===========================
--  PAGOS (SEÑAL, SALDO) HU-C3
-- ===========================
CREATE TABLE payments (
  id                BIGSERIAL PRIMARY KEY,
  event_id          BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  tipo              payment_type NOT NULL,         -- señal, saldo, etc.
  monto             NUMERIC(10,2) NOT NULL,
  fecha             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  metodo            TEXT,                          -- efectivo, tarjeta, etc.
  estado            payment_status NOT NULL DEFAULT 'PENDIENTE',
  referencia_externa TEXT                           -- ID pasarela de pago
);

-- ===========================
--  RESUMEN FINANCIERO POR EVENTO (HU-E4, RF6)
-- ===========================
CREATE TABLE event_finance (
  event_id         BIGINT PRIMARY KEY REFERENCES events(id) ON DELETE CASCADE,
  costo_estimado   NUMERIC(10,2),
  costo_real       NUMERIC(10,2),
  ingreso_estimado NUMERIC(10,2),
  ingreso_real     NUMERIC(10,2),
  margen_estimado  NUMERIC(10,2),
  margen_real      NUMERIC(10,2)
);