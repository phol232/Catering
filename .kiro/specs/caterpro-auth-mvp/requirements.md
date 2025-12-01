# Requirements Document - CaterPro Mobile App

## Introduction

CaterPro es una plataforma móvil especializada en servicios de catering que permite a los clientes contratar servicios de buffet y cóctel con cotización automática, selección de servicios adicionales y gestión logística completa del evento. La aplicación conecta clientes con el equipo de catering (cocina, logística, administración) para una experiencia integral desde la cotización hasta la ejecución del evento.

## Glossary

- **CaterPro System**: La aplicación móvil completa incluyendo frontend Flutter y backend Supabase
- **User**: Cualquier persona que interactúa con la aplicación
- **Client**: Usuario con rol CLIENTE que contrata servicios de catering
- **Admin**: Usuario con rol ADMIN que gestiona menús, precios y configuración general
- **Logistics Staff**: Usuario con rol LOGISTICA que asigna equipos y coordina transporte
- **Kitchen Staff**: Usuario con rol COCINA que gestiona preparación de alimentos
- **Manager**: Usuario con rol GESTOR que supervisa operaciones y reportes financieros
- **Event**: Solicitud de servicio de catering para una fecha específica
- **Quote**: Cotización automática calculada según invitados y servicios seleccionados
- **Menu**: Conjunto de platos con precio por persona
- **Extra Service**: Servicio adicional como montaje, meseros, sonido, decoración
- **Guest**: Invitado a un evento con posibles restricciones alimentarias
- **Deposit**: Señal o pago inicial para confirmar reserva
- **Supabase**: Plataforma backend que provee autenticación, base de datos PostgreSQL y APIs
- **BLoC**: Business Logic Component, patrón de arquitectura para gestión de estado en Flutter
- **Clean Architecture**: Arquitectura por capas que separa lógica de negocio de UI y datos

## Requirements

### Requirement 1

**User Story:** As a guest user, I want to browse past catering events with images and details without logging in, so that I can explore the service offerings before committing to registration.

#### Acceptance Criteria

1. WHEN a user opens the application for the first time THEN the CaterPro System SHALL display a home screen with a carousel of featured events and a searchable event gallery
2. WHEN displaying events THEN the CaterPro System SHALL show event images, nombre_evento, fecha, tipo_evento, and brief description for each completed event
3. WHEN a user uses the search functionality THEN the CaterPro System SHALL filter events by nombre_evento, tipo_evento, ciudad, or fecha
4. WHEN a user scrolls through events THEN the CaterPro System SHALL load events paginated with smooth infinite scroll
5. WHEN a user taps on an event card THEN the CaterPro System SHALL display detailed event information including menu, photos, and guest count without requiring authentication

### Requirement 2

**User Story:** As a guest user, I want to request a quote for my event, so that at that point the system prompts me to register or login to continue.

#### Acceptance Criteria

1. WHEN a guest user clicks "Request Quote" or "Book Event" button THEN the CaterPro System SHALL display a login/register prompt bottom sheet
2. WHEN the authentication bottom sheet is shown THEN the CaterPro System SHALL preserve the user's quote request context to resume after authentication
3. WHEN a user completes authentication THEN the CaterPro System SHALL automatically navigate to the quote request form with preserved context
4. WHEN a user dismisses the authentication bottom sheet THEN the CaterPro System SHALL return to the event browsing screen without losing navigation state
5. WHEN authentication is required THEN the CaterPro System SHALL clearly communicate why login is needed in the bottom sheet header ("To request a quote, please sign in or create an account")

### Requirement 3

**User Story:** As a new user, I want to register an account with email/password or Google authentication, so that I can request quotes and manage my catering services.

#### Acceptance Criteria

1. WHEN a user chooses to register THEN the CaterPro System SHALL display a registration screen with email/password fields and Google sign-in button
2. WHEN a user enters valid email and password (minimum 8 characters) and submits THEN the CaterPro System SHALL create a new account in Supabase Auth with role CLIENTE by default
3. WHEN a user clicks the Google sign-in button and completes OAuth flow THEN the CaterPro System SHALL create or authenticate the user account via Supabase Google provider
4. WHEN registration is successful THEN the CaterPro System SHALL store user profile in the users table with nombre, email, telefono, and role fields
5. WHEN a user attempts to register with an already registered email THEN the CaterPro System SHALL display an error message and prevent duplicate account creation

### Requirement 4

**User Story:** As a registered user, I want to log in to my account using email/password or Google, so that I can access my personalized dashboard and manage my events.

#### Acceptance Criteria

1. WHEN a returning user chooses to login THEN the CaterPro System SHALL display a login screen with email/password fields and Google sign-in button
2. WHEN a user enters valid credentials and submits THEN the CaterPro System SHALL authenticate via Supabase Auth and retrieve user session
3. WHEN authentication is successful THEN the CaterPro System SHALL navigate to the appropriate dashboard based on user role (CLIENTE, ADMIN, LOGISTICA, COCINA, GESTOR)
4. WHEN a user enters invalid credentials THEN the CaterPro System SHALL display an error message without revealing whether email or password is incorrect
5. WHEN a user successfully authenticates THEN the CaterPro System SHALL persist the session locally for automatic login on subsequent app launches

### Requirement 5

**User Story:** As an authenticated client, I want to view my contracted events with their status and details, so that I can track my catering services.

#### Acceptance Criteria

1. WHEN a client accesses their dashboard THEN the CaterPro System SHALL display all events where cliente_id matches the authenticated user
2. WHEN displaying client events THEN the CaterPro System SHALL show event cards with nombre_evento, fecha, estado, menu preview, and event image
3. WHEN a client filters their events THEN the CaterPro System SHALL allow filtering by estado (COTIZACION, RESERVADO, CONFIRMADO, EN_PROCESO, FINALIZADO, CANCELADO)
4. WHEN a client taps on their event THEN the CaterPro System SHALL navigate to detailed event view with full information, payments, and guest list
5. WHEN displaying event status THEN the CaterPro System SHALL use color-coded badges aligned with the brand palette (yellow for active, gray for completed/cancelled)

### Requirement 6

**User Story:** As a client, I want to obtain an automatic quote based on number of guests and selected menu, so that I can quickly understand the cost of my catering event.

#### Acceptance Criteria

1. WHEN a client selects a menu and enters number of guests THEN the CaterPro System SHALL calculate the base cost as (precio_por_persona × num_invitados)
2. WHEN the base cost is calculated THEN the CaterPro System SHALL invoke the calculate_quote database function to compute total including extras
3. WHEN the quote calculation is complete THEN the CaterPro System SHALL display the itemized breakdown showing menu cost, extras cost, and total
4. WHEN a client modifies number of guests or menu selection THEN the CaterPro System SHALL recalculate the quote automatically in real-time
5. WHEN the quote is generated THEN the CaterPro System SHALL update the event_finance table with ingreso_estimado value

### Requirement 7

**User Story:** As a client, I want to select additional services like setup, waiters, sound, and decoration, so that I can customize my event according to my needs.

#### Acceptance Criteria

1. WHEN a client is creating or editing an event THEN the CaterPro System SHALL display a list of available extra_services filtered by esta_activo = TRUE
2. WHEN a client selects an extra service THEN the CaterPro System SHALL allow specifying quantity based on the service unidad (POR_EVENTO, POR_PERSONA, POR_HORA)
3. WHEN an extra service is added THEN the CaterPro System SHALL calculate subtotal as (precio_unitario × cantidad) and insert into event_extras table
4. WHEN a client removes an extra service THEN the CaterPro System SHALL delete the corresponding event_extras record and recalculate quote
5. WHEN extra services are modified THEN the CaterPro System SHALL update the quote display to reflect new total cost

### Requirement 8

**User Story:** As a client, I want to reserve a date and pay a deposit, so that I can secure my catering service for my event.

#### Acceptance Criteria

1. WHEN a client confirms a quote THEN the CaterPro System SHALL transition the event estado from COTIZACION to RESERVA_PENDIENTE_PAGO
2. WHEN a client initiates deposit payment THEN the CaterPro System SHALL create a payment record with tipo = SENIAL and estado = PENDIENTE
3. WHEN payment is confirmed THEN the CaterPro System SHALL update payment estado to PAGADO and event estado to RESERVADO
4. WHEN a deposit payment is recorded THEN the CaterPro System SHALL store monto, fecha, metodo, and referencia_externa in the payments table
5. WHEN an event is reserved THEN the CaterPro System SHALL prevent other clients from booking the same date and service capacity

### Requirement 9

**User Story:** As a client, I want to view detailed menu information including dietary restrictions, so that I can ensure the food meets my guests' needs.

#### Acceptance Criteria

1. WHEN a client views a menu THEN the CaterPro System SHALL display nombre, tipo, descripcion, and precio_por_persona
2. WHEN a client expands menu details THEN the CaterPro System SHALL retrieve and display all associated dishes via menu_dishes relationship
3. WHEN displaying dishes THEN the CaterPro System SHALL show categoria, descripcion, and dietary flags (es_vegetariano, es_vegano, es_sin_gluten, es_sin_lactosa)
4. WHEN a client filters menus by dietary restriction THEN the CaterPro System SHALL return only menus containing dishes that match the specified criteria
5. WHEN menu information is displayed THEN the CaterPro System SHALL present it in a visually organized format grouped by categoria

### Requirement 10

**User Story:** As kitchen or logistics staff, I want to view the guest list and special dietary requests for an event, so that I can prepare accordingly and ensure all needs are met.

#### Acceptance Criteria

1. WHEN kitchen or logistics staff opens an event detail THEN the CaterPro System SHALL display the complete guests list with nombre, email, telefono
2. WHEN displaying guests THEN the CaterPro System SHALL highlight guests where tiene_restricciones = TRUE
3. WHEN staff views a guest with restrictions THEN the CaterPro System SHALL display all associated guest_restrictions with tipo and descripcion
4. WHEN staff requests to export guest list THEN the CaterPro System SHALL generate a downloadable file (CSV or PDF) containing all guest information and restrictions
5. WHEN the guest list is displayed THEN the CaterPro System SHALL show total count of guests and breakdown by restriction types

### Requirement 11

**User Story:** As logistics staff, I want to assign service team members and transportation to an event, so that operations run smoothly on the event date.

#### Acceptance Criteria

1. WHEN logistics staff opens event logistics panel THEN the CaterPro System SHALL display available users with roles COCINA, LOGISTICA, or staff members
2. WHEN logistics staff assigns a team member THEN the CaterPro System SHALL create an event_staff record with event_id, staff_id, rol_en_evento, hora_inicio, hora_fin
3. WHEN a team member is assigned THEN the CaterPro System SHALL validate that the staff member is not already assigned to another event at the same time
4. WHEN logistics staff removes an assignment THEN the CaterPro System SHALL delete the event_staff record and update availability
5. WHEN assignments are complete THEN the CaterPro System SHALL display a summary view of all assigned personnel with their roles and schedules

### Requirement 12

**User Story:** As an admin, I want to manage menus and prices per portion, so that I can keep the catalog updated and competitive.

#### Acceptance Criteria

1. WHEN an admin accesses menu management THEN the CaterPro System SHALL display all menus with CRUD operations (Create, Read, Update, Delete)
2. WHEN an admin creates or edits a menu THEN the CaterPro System SHALL allow setting nombre, tipo, descripcion, precio_por_persona, costo_por_persona, esta_activo
3. WHEN an admin adds dishes to a menu THEN the CaterPro System SHALL create menu_dishes relationships with optional cantidad field
4. WHEN an admin deactivates a menu THEN the CaterPro System SHALL set esta_activo = FALSE without deleting the record
5. WHEN an admin updates prices THEN the CaterPro System SHALL apply changes only to new quotes, preserving existing event pricing

### Requirement 13

**User Story:** As a manager, I want to view profit margin per event, so that I can analyze business performance and make informed decisions.

#### Acceptance Criteria

1. WHEN a manager accesses financial reports THEN the CaterPro System SHALL display all events with their event_finance data
2. WHEN displaying event finances THEN the CaterPro System SHALL show costo_estimado, costo_real, ingreso_estimado, ingreso_real, margen_estimado, margen_real
3. WHEN calculating margins THEN the CaterPro System SHALL compute margen as (ingreso - costo) for both estimated and real values
4. WHEN a manager filters by date range THEN the CaterPro System SHALL aggregate financial data and display total margins for the period
5. WHEN financial data is displayed THEN the CaterPro System SHALL present it with visual indicators (charts, color-coded margins) for quick analysis

### Requirement 14

**User Story:** As a user, I want the application to follow a clean architecture with BLoC pattern, so that the codebase is maintainable, testable, and scalable.

#### Acceptance Criteria

1. WHEN the application is structured THEN the CaterPro System SHALL organize code into features folders (auth, events, menus, payments, etc.)
2. WHEN implementing business logic THEN the CaterPro System SHALL use BLoC pattern with separate Event, State, and BLoC classes for each feature
3. WHEN accessing data THEN the CaterPro System SHALL implement repository pattern with abstract interfaces and concrete Supabase implementations
4. WHEN organizing layers THEN the CaterPro System SHALL separate presentation (UI), domain (business logic), and data (repositories) layers
5. WHEN dependencies are managed THEN the CaterPro System SHALL use dependency injection to provide repositories and BLoCs to widgets

### Requirement 15

**User Story:** As a user, I want the application to use the professional brand color palette (yellow pastel, black, gray), so that the interface is visually consistent and appealing.

#### Acceptance Criteria

1. WHEN the application theme is initialized THEN the CaterPro System SHALL apply YellowPastel (0xFFF2F862) as primary color for buttons and highlights
2. WHEN displaying backgrounds THEN the CaterPro System SHALL use Black (0xFF000000) as main background color
3. WHEN displaying cards and surfaces THEN the CaterPro System SHALL use GrayDark (0xFF404040) over black background
4. WHEN displaying text THEN the CaterPro System SHALL use WhiteAlmost (0xFFFEFEFE) for primary text on dark backgrounds
5. WHEN displaying secondary elements THEN the CaterPro System SHALL use GrayLight (0xFFC1C1C1) for secondary text, outlines, and muted icons

### Requirement 16

**User Story:** As a developer, I want to integrate Supabase authentication and database, so that the application has secure backend services without building custom infrastructure.

#### Acceptance Criteria

1. WHEN the application initializes THEN the CaterPro System SHALL load Supabase credentials from assets/env/.env file (API_URL_SUPABASE, API_KEY_SUPABASE)
2. WHEN authentication is required THEN the CaterPro System SHALL use Supabase Auth SDK for email/password and Google OAuth flows
3. WHEN database operations are performed THEN the CaterPro System SHALL use Supabase PostgreSQL client to execute queries and call functions
4. WHEN user sessions are managed THEN the CaterPro System SHALL use Supabase session persistence and automatic token refresh
5. WHEN environment variables are accessed THEN the CaterPro System SHALL use flutter_dotenv or similar package to securely load .env configuration
