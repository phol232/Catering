# Design Document - CaterPro Mobile App

## Overview

CaterPro is a Flutter mobile application that connects catering clients with service providers through an intuitive, professionally designed interface. The app follows Clean Architecture principles with BLoC state management, integrating Supabase for authentication and PostgreSQL database operations.

The application supports multiple user roles (CLIENTE, ADMIN, LOGISTICA, COCINA, GESTOR) with role-based navigation and features. The design prioritizes a guest-first experience where users can explore past events before committing to registration, only requiring authentication when requesting quotes or managing events.

## Architecture

### High-Level Architecture

The application follows Clean Architecture with three main layers:

**Presentation Layer (UI)**
- Flutter widgets and screens
- BLoC components for state management
- Theme configuration with brand colors
- Navigation and routing

**Domain Layer (Business Logic)**
- Use cases and business rules
- Entity models
- Repository interfaces (abstractions)
- BLoC event/state definitions

**Data Layer**
- Repository implementations
- Supabase client integration
- Data models and mappers
- Local storage (shared preferences for session)

### Technology Stack

- **Framework**: Flutter 3.9.2+
- **State Management**: flutter_bloc ^8.1.3
- **Backend**: Supabase (Auth + PostgreSQL)
- **Authentication**: supabase_flutter ^2.0.0
- **Environment Config**: flutter_dotenv ^5.1.0
- **HTTP Client**: Built into supabase_flutter
- **Local Storage**: shared_preferences ^2.2.0
- **Dependency Injection**: get_it ^7.6.0
- **Navigation**: go_router ^12.0.0


## Components and Interfaces

### Feature Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── env_config.dart          # Load .env variables
│   │   └── supabase_config.dart     # Supabase initialization
│   ├── theme/
│   │   ├── app_theme.dart           # MaterialTheme with brand colors
│   │   └── app_colors.dart          # Color constants
│   ├── di/
│   │   └── injection.dart           # GetIt dependency injection setup
│   ├── navigation/
│   │   └── app_router.dart          # GoRouter configuration
│   └── utils/
│       ├── validators.dart          # Email, password validation
│       └── constants.dart           # App-wide constants
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── auth_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_with_email.dart
│   │   │       ├── register_with_email.dart
│   │   │       ├── login_with_google.dart
│   │   │       ├── logout.dart
│   │   │       └── get_current_user.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   └── register_screen.dart
│   │       └── widgets/
│   │           ├── email_input_field.dart
│   │           ├── password_input_field.dart
│   │           └── social_auth_button.dart
│   ├── events/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── event_model.dart
│   │   │   │   └── event_detail_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── event_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── event_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── event_entity.dart
│   │   │   │   └── event_detail_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── event_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_public_events.dart
│   │   │       ├── search_events.dart
│   │   │       ├── get_client_events.dart
│   │   │       └── get_event_detail.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── event_list_bloc.dart
│   │       │   ├── event_detail_bloc.dart
│   │       │   └── client_events_bloc.dart
│   │       ├── screens/
│   │       │   ├── home_screen.dart
│   │       │   ├── event_detail_screen.dart
│   │       │   └── client_dashboard_screen.dart
│   │       └── widgets/
│   │           ├── event_carousel.dart
│   │           ├── event_card.dart
│   │           ├── event_search_bar.dart
│   │           └── event_status_badge.dart
│   ├── quotes/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── quote_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── quote_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── quote_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── quote_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── quote_repository.dart
│   │   │   └── usecases/
│   │   │       ├── calculate_quote.dart
│   │   │       └── create_quote_request.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── quote_bloc.dart
│   │       │   ├── quote_event.dart
│   │       │   └── quote_state.dart
│   │       ├── screens/
│   │       │   └── quote_request_screen.dart
│   │       └── widgets/
│   │           ├── menu_selector.dart
│   │           ├── guest_count_input.dart
│   │           ├── extra_services_selector.dart
│   │           └── quote_summary.dart
│   └── menus/
│       ├── data/
│       │   ├── models/
│       │   │   ├── menu_model.dart
│       │   │   └── dish_model.dart
│       │   ├── repositories/
│       │   │   └── menu_repository_impl.dart
│       │   └── datasources/
│       │       └── menu_remote_datasource.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── menu_entity.dart
│       │   │   └── dish_entity.dart
│       │   ├── repositories/
│       │   │   └── menu_repository.dart
│       │   └── usecases/
│       │       ├── get_active_menus.dart
│       │       └── get_menu_detail.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── menu_bloc.dart
│           │   ├── menu_event.dart
│           │   └── menu_state.dart
│           ├── screens/
│           │   └── menu_detail_screen.dart
│           └── widgets/
│               ├── menu_card.dart
│               ├── dish_list_item.dart
│               └── dietary_filter_chips.dart
└── main.dart
```


### Key Interfaces

#### AuthRepository Interface

```dart
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmail(String email, String password);
  Future<Either<Failure, UserEntity>> registerWithEmail(String email, String password, String nombre);
  Future<Either<Failure, UserEntity>> loginWithGoogle();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Stream<AuthState> get authStateChanges;
}
```

#### EventRepository Interface

```dart
abstract class EventRepository {
  Future<Either<Failure, List<EventEntity>>> getPublicEvents({int limit = 20, int offset = 0});
  Future<Either<Failure, List<EventEntity>>> searchEvents(String query);
  Future<Either<Failure, List<EventEntity>>> getClientEvents(int clientId);
  Future<Either<Failure, EventDetailEntity>> getEventDetail(int eventId);
}
```

#### QuoteRepository Interface

```dart
abstract class QuoteRepository {
  Future<Either<Failure, QuoteEntity>> calculateQuote(int eventId);
  Future<Either<Failure, int>> createQuoteRequest({
    required int clientId,
    required int menuId,
    required int numGuests,
    required DateTime eventDate,
    required String eventName,
    List<ExtraServiceSelection>? extras,
  });
}
```

#### MenuRepository Interface

```dart
abstract class MenuRepository {
  Future<Either<Failure, List<MenuEntity>>> getActiveMenus();
  Future<Either<Failure, MenuDetailEntity>> getMenuDetail(int menuId);
  Future<Either<Failure, List<MenuEntity>>> filterMenusByDietaryRestriction(String restriction);
}
```

## Data Models

### User Model

```dart
class UserModel {
  final int id;
  final String nombre;
  final String email;
  final String? telefono;
  final UserRole role;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      telefono: json['telefono'],
      role: UserRole.fromString(json['role']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'role': role.toString(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      nombre: nombre,
      email: email,
      telefono: telefono,
      role: role,
    );
  }
}

enum UserRole {
  cliente,
  admin,
  logistica,
  cocina,
  gestor;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name.toUpperCase() == value.toUpperCase(),
    );
  }
}
```

### Event Model

```dart
class EventModel {
  final int id;
  final int clienteId;
  final int? menuId;
  final String? nombreEvento;
  final String? tipoEvento;
  final DateTime fecha;
  final TimeOfDay? horaInicio;
  final TimeOfDay? horaFin;
  final int numInvitados;
  final String? direccion;
  final String? ciudad;
  final EventStatus estado;
  final String? notaCliente;
  final DateTime createdAt;
  final String? menuNombre;
  final String? imageUrl;

  EventModel({
    required this.id,
    required this.clienteId,
    this.menuId,
    this.nombreEvento,
    this.tipoEvento,
    required this.fecha,
    this.horaInicio,
    this.horaFin,
    required this.numInvitados,
    this.direccion,
    this.ciudad,
    required this.estado,
    this.notaCliente,
    required this.createdAt,
    this.menuNombre,
    this.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      clienteId: json['cliente_id'],
      menuId: json['menu_id'],
      nombreEvento: json['nombre_evento'],
      tipoEvento: json['tipo_evento'],
      fecha: DateTime.parse(json['fecha']),
      horaInicio: json['hora_inicio'] != null ? _parseTime(json['hora_inicio']) : null,
      horaFin: json['hora_fin'] != null ? _parseTime(json['hora_fin']) : null,
      numInvitados: json['num_invitados'],
      direccion: json['direccion'],
      ciudad: json['ciudad'],
      estado: EventStatus.fromString(json['estado']),
      notaCliente: json['nota_cliente'],
      createdAt: DateTime.parse(json['created_at']),
      menuNombre: json['menu_nombre'],
      imageUrl: json['image_url'],
    );
  }

  EventEntity toEntity() {
    return EventEntity(
      id: id,
      nombreEvento: nombreEvento ?? 'Sin nombre',
      fecha: fecha,
      ciudad: ciudad,
      numInvitados: numInvitados,
      menuNombre: menuNombre,
      estado: estado,
      imageUrl: imageUrl,
    );
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

enum EventStatus {
  cotizacion,
  reservaPendientePago,
  reservado,
  confirmado,
  enProceso,
  finalizado,
  cancelado;

  static EventStatus fromString(String value) {
    final normalized = value.toUpperCase().replaceAll('_', '');
    return EventStatus.values.firstWhere(
      (status) => status.name.toUpperCase().replaceAll('_', '') == normalized,
    );
  }
}
```


### Menu Model

```dart
class MenuModel {
  final int id;
  final String nombre;
  final String? tipo;
  final String? descripcion;
  final double precioPorPersona;
  final double? costoPorPersona;
  final bool estaActivo;

  MenuModel({
    required this.id,
    required this.nombre,
    this.tipo,
    this.descripcion,
    required this.precioPorPersona,
    this.costoPorPersona,
    required this.estaActivo,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      descripcion: json['descripcion'],
      precioPorPersona: (json['precio_por_persona'] as num).toDouble(),
      costoPorPersona: json['costo_por_persona'] != null 
          ? (json['costo_por_persona'] as num).toDouble() 
          : null,
      estaActivo: json['esta_activo'],
    );
  }

  MenuEntity toEntity() {
    return MenuEntity(
      id: id,
      nombre: nombre,
      tipo: tipo,
      descripcion: descripcion,
      precioPorPersona: precioPorPersona,
    );
  }
}
```

### Quote Model

```dart
class QuoteModel {
  final int eventId;
  final double menuCost;
  final double extrasCost;
  final double totalCost;
  final List<ExtraServiceItem> extras;

  QuoteModel({
    required this.eventId,
    required this.menuCost,
    required this.extrasCost,
    required this.totalCost,
    required this.extras,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      eventId: json['event_id'],
      menuCost: (json['menu_cost'] as num).toDouble(),
      extrasCost: (json['extras_cost'] as num).toDouble(),
      totalCost: (json['total_cost'] as num).toDouble(),
      extras: (json['extras'] as List)
          .map((e) => ExtraServiceItem.fromJson(e))
          .toList(),
    );
  }

  QuoteEntity toEntity() {
    return QuoteEntity(
      eventId: eventId,
      menuCost: menuCost,
      extrasCost: extrasCost,
      totalCost: totalCost,
      extras: extras.map((e) => e.toEntity()).toList(),
    );
  }
}

class ExtraServiceItem {
  final int extraId;
  final String nombre;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  ExtraServiceItem({
    required this.extraId,
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory ExtraServiceItem.fromJson(Map<String, dynamic> json) {
    return ExtraServiceItem(
      extraId: json['extra_id'],
      nombre: json['nombre'],
      cantidad: json['cantidad'],
      precioUnitario: (json['precio_unitario'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  ExtraServiceEntity toEntity() {
    return ExtraServiceEntity(
      extraId: extraId,
      nombre: nombre,
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      subtotal: subtotal,
    );
  }
}
```


## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Authentication Properties

Property 1: Event display completeness
*For any* event displayed in the gallery, the rendered output should contain nombre_evento, fecha, tipo_evento, image, and description fields
**Validates: Requirements 1.2**

Property 2: Search result relevance
*For any* search query and event list, all returned results should match the query in at least one field (nombre_evento, tipo_evento, ciudad, or fecha)
**Validates: Requirements 1.3**

Property 3: Pagination consistency
*For any* page number N and page size S, requesting page N should return events from index (N×S) to ((N+1)×S-1) without duplicates or gaps
**Validates: Requirements 1.4**

Property 4: Quote context preservation
*For any* quote request context, after completing authentication flow, the restored context should be identical to the original context
**Validates: Requirements 2.2**

Property 5: Navigation state preservation on bottom sheet dismiss
*For any* navigation state, dismissing the authentication bottom sheet should preserve the exact navigation stack and scroll position
**Validates: Requirements 2.4**

Property 6: Registration creates correct user role
*For any* valid email and password (≥8 characters), successful registration should create a user record with role = CLIENTE
**Validates: Requirements 3.2**

Property 7: User profile persistence completeness
*For any* successful registration with nombre, email, telefono, after registration completes, querying the users table should return a record with all provided fields
**Validates: Requirements 3.4**

Property 8: Duplicate email rejection
*For any* email that already exists in the users table, attempting to register with that email should fail with an error and not create a duplicate record
**Validates: Requirements 3.5**

Property 9: Valid credentials authentication
*For any* valid email/password pair in the database, submitting those credentials should result in successful authentication and session creation
**Validates: Requirements 4.2**

Property 10: Role-based navigation
*For any* user role (CLIENTE, ADMIN, LOGISTICA, COCINA, GESTOR), successful authentication should navigate to the dashboard corresponding to that role
**Validates: Requirements 4.3**

Property 11: Invalid credentials generic error
*For any* invalid credential combination (wrong email or wrong password), the error message should not reveal which field is incorrect
**Validates: Requirements 4.4**

Property 12: Session persistence across restarts
*For any* successful authentication, after app restart, the session should be automatically restored without requiring re-authentication
**Validates: Requirements 4.5**

### Event Management Properties

Property 13: Client event filtering
*For any* authenticated client with ID C, their dashboard should display only events where cliente_id = C
**Validates: Requirements 5.1**

Property 14: Event card display completeness
*For any* event displayed on client dashboard, the card should contain nombre_evento, fecha, estado, menu preview, and image
**Validates: Requirements 5.2**

Property 15: Event status filtering
*For any* event list and status filter S, all returned events should have estado = S
**Validates: Requirements 5.3**

### Quote Calculation Properties

Property 16: Base cost calculation
*For any* menu with precio_por_persona = P and num_invitados = N, the calculated base cost should equal P × N
**Validates: Requirements 6.1**

Property 17: Quote calculation invokes database function
*For any* event ID, calculating a quote should invoke the calculate_quote(event_id) database function and return its result
**Validates: Requirements 6.2**

Property 18: Quote breakdown completeness
*For any* calculated quote, the displayed breakdown should show menu_cost, extras_cost, and total_cost where total_cost = menu_cost + extras_cost
**Validates: Requirements 6.3**

Property 19: Quote recalculation on input change
*For any* quote with inputs (menu, num_guests, extras), changing any input should trigger automatic recalculation with updated values
**Validates: Requirements 6.4**

Property 20: Quote persists to finance table
*For any* generated quote with total T for event E, the event_finance table should have a record where event_id = E and ingreso_estimado = T
**Validates: Requirements 6.5**

### Extra Services Properties

Property 21: Active services filtering
*For any* list of extra services displayed, all services should have esta_activo = TRUE
**Validates: Requirements 7.1**

Property 22: Quantity input matches service unit
*For any* extra service with unidad = U, the quantity input should accept values appropriate for U (integer for POR_EVENTO, decimal for POR_HORA, etc.)
**Validates: Requirements 7.2**

Property 23: Extra service subtotal calculation
*For any* extra service with precio_unitario = P and cantidad = Q, the calculated subtotal should equal P × Q and be stored in event_extras table
**Validates: Requirements 7.3**

Property 24: Extra service removal updates quote
*For any* event with extras, removing an extra service should delete its event_extras record and recalculate the quote to exclude that service's cost
**Validates: Requirements 7.4**

Property 25: Extra modification updates display
*For any* modification to extra services (add, remove, quantity change), the quote display should immediately reflect the new total cost
**Validates: Requirements 7.5**

### Payment and Reservation Properties

Property 26: Quote confirmation state transition
*For any* event with estado = COTIZACION, confirming the quote should transition estado to RESERVA_PENDIENTE_PAGO
**Validates: Requirements 8.1**

Property 27: Deposit payment record creation
*For any* deposit payment initiation, a payment record should be created with tipo = SENIAL and estado = PENDIENTE
**Validates: Requirements 8.2**

Property 28: Payment confirmation state updates
*For any* payment with estado = PENDIENTE, confirming payment should update payment.estado to PAGADO and event.estado to RESERVADO
**Validates: Requirements 8.3**

Property 29: Payment data persistence
*For any* deposit payment with monto M, fecha F, metodo ME, referencia_externa R, the payments table should store all four fields correctly
**Validates: Requirements 8.4**

Property 30: Reservation prevents double booking
*For any* event E1 with estado = RESERVADO on date D, attempting to create another event E2 on date D should fail if capacity is exceeded
**Validates: Requirements 8.5**

### Menu and Dietary Properties

Property 31: Menu display completeness
*For any* menu displayed, the view should show nombre, tipo, descripcion, and precio_por_persona
**Validates: Requirements 9.1**

Property 32: Menu dishes retrieval
*For any* menu with ID M, expanding details should retrieve and display all dishes where menu_dishes.menu_id = M
**Validates: Requirements 9.2**

Property 33: Dish display completeness
*For any* dish displayed, the view should show categoria, descripcion, es_vegetariano, es_vegano, es_sin_gluten, es_sin_lactosa
**Validates: Requirements 9.3**

Property 34: Dietary restriction filtering
*For any* dietary restriction filter R, all returned menus should contain at least one dish where the corresponding dietary flag is TRUE
**Validates: Requirements 9.4**

Property 35: Dishes grouped by category
*For any* menu detail view, dishes should be grouped by categoria with all dishes of the same category appearing together
**Validates: Requirements 9.5**

### Financial Reporting Properties

Property 36: Manager financial data access
*For any* user with role = GESTOR, accessing financial reports should return all events with their complete event_finance records
**Validates: Requirements 13.1**

Property 37: Financial display completeness
*For any* event finance record, the display should show costo_estimado, costo_real, ingreso_estimado, ingreso_real, margen_estimado, margen_real
**Validates: Requirements 13.2**

Property 38: Margin calculation correctness
*For any* event finance with ingreso I and costo C, the calculated margen should equal (I - C) for both estimated and real values
**Validates: Requirements 13.3**

Property 39: Date range aggregation
*For any* date range [D1, D2], the aggregated financial totals should equal the sum of all event finances where fecha is between D1 and D2
**Validates: Requirements 13.4**

### Session Management Properties

Property 40: Session persistence mechanism
*For any* authenticated session, the session token should be stored locally and automatically included in subsequent Supabase requests
**Validates: Requirements 16.4**


## Error Handling

### Error Types

The application will use a unified error handling approach with the following error categories:

```dart
abstract class Failure {
  final String message;
  final String? code;
  
  const Failure(this.message, [this.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message, 'NETWORK_ERROR');
}

class AuthFailure extends Failure {
  const AuthFailure(String message, [String? code]) : super(message, code);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message) : super(message, 'DATABASE_ERROR');
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message, 'VALIDATION_ERROR');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message, 'NOT_FOUND');
}

class PermissionFailure extends Failure {
  const PermissionFailure(String message) : super(message, 'PERMISSION_DENIED');
}
```

### Error Handling Strategy

1. **Repository Layer**: Catch all exceptions and convert to appropriate Failure types
2. **BLoC Layer**: Handle Failure objects and emit appropriate error states
3. **UI Layer**: Display user-friendly error messages based on Failure types

### Specific Error Scenarios

**Authentication Errors**
- Invalid credentials → Generic "Invalid email or password" message (Property 11)
- Duplicate email registration → "This email is already registered"
- Network timeout → "Connection failed. Please check your internet"
- OAuth cancellation → Silent return to previous screen

**Quote Calculation Errors**
- Invalid menu selection → "Please select a valid menu"
- Zero or negative guests → "Number of guests must be at least 1"
- Database function failure → "Unable to calculate quote. Please try again"

**Payment Errors**
- Payment gateway failure → "Payment processing failed. Please try again"
- Insufficient deposit amount → "Deposit must be at least X% of total"
- Double booking attempt → "This date is no longer available"

**Data Validation Errors**
- Email format → "Please enter a valid email address"
- Password length → "Password must be at least 8 characters"
- Required fields → "Please fill in all required fields"

## Testing Strategy

### Unit Testing

Unit tests will verify individual components in isolation:

**Repository Tests**
- Test data model serialization/deserialization
- Test repository methods with mocked data sources
- Test error handling and failure mapping

**BLoC Tests**
- Test event handling and state transitions
- Test business logic in use cases
- Test error state emissions

**Validation Tests**
- Test email validation logic
- Test password strength requirements
- Test input sanitization

### Property-Based Testing

Property-based tests will verify universal properties across many inputs using the `test` package with custom generators:

**Testing Framework**: Dart's built-in `test` package with custom property testing utilities

**Configuration**: Each property test should run a minimum of 100 iterations with randomly generated inputs

**Property Test Tagging**: Each property-based test MUST be tagged with a comment explicitly referencing the correctness property from this design document using this format:
```dart
// **Feature: caterpro-auth-mvp, Property 16: Base cost calculation**
test('base cost calculation property', () { ... });
```

**Key Properties to Test**:

1. **Property 16**: Base cost calculation - Generate random menu prices and guest counts, verify P × N = base_cost
2. **Property 18**: Quote breakdown - Generate random quotes, verify total_cost = menu_cost + extras_cost
3. **Property 23**: Extra service subtotal - Generate random services and quantities, verify P × Q = subtotal
4. **Property 38**: Margin calculation - Generate random ingreso and costo values, verify margen = ingreso - costo
5. **Property 8**: Duplicate email rejection - Generate random emails, register twice, verify second fails
6. **Property 13**: Client event filtering - Generate random events for multiple clients, verify each sees only their events
7. **Property 15**: Event status filtering - Generate random events with various statuses, verify filter returns only matching status
8. **Property 21**: Active services filtering - Generate random services with mixed esta_activo values, verify only TRUE returned
9. **Property 34**: Dietary restriction filtering - Generate random menus and dishes, verify filter returns only matching menus
10. **Property 39**: Date range aggregation - Generate random events across dates, verify aggregation sums correctly

### Integration Testing

Integration tests will verify feature workflows:

**Authentication Flow**
- Complete registration → login → session persistence → logout flow
- OAuth flow with mocked Google provider
- Session restoration after app restart

**Quote Request Flow**
- Browse events → request quote (triggers auth) → complete auth → resume quote request
- Select menu → enter guests → add extras → view calculated quote
- Confirm quote → initiate payment → confirm payment → verify reservation

**Event Management Flow**
- Client views their events → filters by status → views event detail
- Admin creates menu → adds dishes → sets prices → activates menu

### Widget Testing

Widget tests will verify UI components:

**Screen Tests**
- Login screen renders correctly with all fields
- Home screen displays event carousel and search
- Quote screen shows menu selector and guest input

**Widget Tests**
- Event card displays all required information
- Status badge uses correct colors for each status
- Search bar filters events correctly

**Theme Tests**
- Verify brand colors are applied correctly
- Verify text styles use correct colors on dark backgrounds
- Verify button styles use YellowPastel primary color

### End-to-End Testing

E2E tests will verify complete user journeys:

- Guest user browses events → requests quote → registers → completes quote → makes payment
- Client logs in → views their events → views event detail with menu and guests
- Admin logs in → creates new menu → adds dishes → sets dietary flags


## Navigation and Routing

### Route Structure

Using `go_router` for declarative routing with deep linking support:

```dart
final router = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState is AuthAuthenticated;
    final isAuthRoute = state.location.startsWith('/auth');
    
    // Redirect to home if authenticated and trying to access auth routes
    if (isAuthenticated && isAuthRoute) {
      return '/home';
    }
    
    // Allow access to home and event details without auth
    if (state.location == '/home' || state.location.startsWith('/events/')) {
      return null;
    }
    
    // Redirect to auth if trying to access protected routes
    if (!isAuthenticated && !isAuthRoute) {
      return '/auth/login?redirect=${state.location}';
    }
    
    return null;
  },
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/events/:id',
      builder: (context, state) {
        final eventId = int.parse(state.params['id']!);
        return EventDetailScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) {
        final redirect = state.queryParams['redirect'];
        return LoginScreen(redirectTo: redirect);
      },
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) {
        final redirect = state.queryParams['redirect'];
        return RegisterScreen(redirectTo: redirect);
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const ClientDashboardScreen(),
    ),
    GoRoute(
      path: '/quote/request',
      builder: (context, state) => const QuoteRequestScreen(),
    ),
    GoRoute(
      path: '/quote/:eventId',
      builder: (context, state) {
        final eventId = int.parse(state.params['eventId']!);
        return QuoteDetailScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: '/menus/:id',
      builder: (context, state) {
        final menuId = int.parse(state.params['id']!);
        return MenuDetailScreen(menuId: menuId);
      },
    ),
  ],
);
```

### Navigation Flows

**Guest User Flow**
1. App Launch → Home Screen (event carousel + gallery)
2. Tap Event → Event Detail Screen (no auth required)
3. Tap "Request Quote" → Auth Modal → Login/Register Screen
4. Complete Auth → Quote Request Screen (with preserved context)

**Authenticated Client Flow**
1. App Launch → Auto-login → Client Dashboard
2. View My Events → Event Detail → View Quote/Payment Status
3. Request New Quote → Quote Request Screen → Payment Screen

**Role-Based Dashboards**
- CLIENTE → Client Dashboard (my events, request quote)
- ADMIN → Admin Dashboard (manage menus, view all events)
- LOGISTICA → Logistics Dashboard (assign staff, view schedules)
- COCINA → Kitchen Dashboard (view events, guest restrictions)
- GESTOR → Manager Dashboard (financial reports, analytics)

## Dependency Injection Setup

Using `get_it` for service locator pattern:

```dart
final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External dependencies
  final supabase = await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseKey,
  );
  getIt.registerSingleton<SupabaseClient>(supabase.client);
  
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<QuoteRemoteDataSource>(
    () => QuoteRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<MenuRemoteDataSource>(
    () => MenuRemoteDataSourceImpl(getIt()),
  );
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(getIt()),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => LoginWithEmail(getIt()));
  getIt.registerLazySingleton(() => RegisterWithEmail(getIt()));
  getIt.registerLazySingleton(() => LoginWithGoogle(getIt()));
  getIt.registerLazySingleton(() => Logout(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt()));
  getIt.registerLazySingleton(() => GetPublicEvents(getIt()));
  getIt.registerLazySingleton(() => SearchEvents(getIt()));
  getIt.registerLazySingleton(() => GetClientEvents(getIt()));
  getIt.registerLazySingleton(() => CalculateQuote(getIt()));
  getIt.registerLazySingleton(() => GetActiveMenus(getIt()));
  
  // BLoCs (registered as factories for multiple instances)
  getIt.registerFactory(() => AuthBloc(
    loginWithEmail: getIt(),
    registerWithEmail: getIt(),
    loginWithGoogle: getIt(),
    logout: getIt(),
    getCurrentUser: getIt(),
  ));
  getIt.registerFactory(() => EventListBloc(
    getPublicEvents: getIt(),
    searchEvents: getIt(),
  ));
  getIt.registerFactory(() => ClientEventsBloc(
    getClientEvents: getIt(),
  ));
  getIt.registerFactory(() => QuoteBloc(
    calculateQuote: getIt(),
  ));
  getIt.registerFactory(() => MenuBloc(
    getActiveMenus: getIt(),
  ));
}
```

## State Management with BLoC

### BLoC Pattern Structure

Each feature follows this BLoC structure:

**Events**: User actions or system events
**States**: UI states representing different scenarios
**BLoC**: Business logic that transforms events into states

### Example: AuthBloc

```dart
// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthLoginWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  
  const AuthLoginWithEmailRequested(this.email, this.password);
  
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  final String nombre;
  
  const AuthRegisterWithEmailRequested(this.email, this.password, this.nombre);
  
  @override
  List<Object?> get props => [email, password, nombre];
}

class AuthLoginWithGoogleRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatusRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  
  const AuthAuthenticated(this.user);
  
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail loginWithEmail;
  final RegisterWithEmail registerWithEmail;
  final LoginWithGoogle loginWithGoogle;
  final Logout logout;
  final GetCurrentUser getCurrentUser;
  
  AuthBloc({
    required this.loginWithEmail,
    required this.registerWithEmail,
    required this.loginWithGoogle,
    required this.logout,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<AuthLoginWithEmailRequested>(_onLoginWithEmail);
    on<AuthRegisterWithEmailRequested>(_onRegisterWithEmail);
    on<AuthLoginWithGoogleRequested>(_onLoginWithGoogle);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthCheckStatusRequested>(_onCheckStatus);
  }
  
  Future<void> _onLoginWithEmail(
    AuthLoginWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await loginWithEmail(
      LoginWithEmailParams(email: event.email, password: event.password),
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
  
  Future<void> _onRegisterWithEmail(
    AuthRegisterWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await registerWithEmail(
      RegisterWithEmailParams(
        email: event.email,
        password: event.password,
        nombre: event.nombre,
      ),
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
  
  Future<void> _onLoginWithGoogle(
    AuthLoginWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await loginWithGoogle(NoParams());
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
  
  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logout(NoParams());
    emit(AuthUnauthenticated());
  }
  
  Future<void> _onCheckStatus(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUser(NoParams());
    
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }
}
```

## Database Integration

### Supabase Client Configuration

```dart
class SupabaseConfig {
  static late SupabaseClient client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseKey,
      authCallbackUrlHostname: 'login-callback',
      debug: kDebugMode,
    );
    
    client = Supabase.instance.client;
  }
}
```

### Database Query Examples

**Get Public Events**
```dart
final response = await supabase
    .from('events')
    .select('*, menus(nombre)')
    .eq('estado', 'FINALIZADO')
    .order('fecha', ascending: false)
    .limit(20);
```

**Calculate Quote (Call Function)**
```dart
final response = await supabase
    .rpc('calculate_quote', params: {'p_event_id': eventId});
```

**Create Event with Transaction**
```dart
final eventResponse = await supabase
    .from('events')
    .insert({
      'cliente_id': clientId,
      'menu_id': menuId,
      'nombre_evento': eventName,
      'fecha': eventDate.toIso8601String(),
      'num_invitados': numGuests,
      'estado': 'COTIZACION',
    })
    .select()
    .single();

final eventId = eventResponse['id'];

// Add extra services
for (final extra in extras) {
  await supabase.from('event_extras').insert({
    'event_id': eventId,
    'extra_id': extra.extraId,
    'cantidad': extra.cantidad,
    'precio_unitario': extra.precioUnitario,
    'subtotal': extra.subtotal,
  });
}
```

## Performance Considerations

### Pagination Strategy
- Load events in batches of 20
- Implement infinite scroll with offset-based pagination
- Cache loaded events in BLoC state to avoid redundant queries

### Image Loading
- Use `cached_network_image` package for event images
- Implement placeholder and error widgets
- Compress images on upload (backend responsibility)

### State Management Optimization
- Use `Equatable` for efficient state comparison
- Implement `buildWhen` and `listenWhen` in BlocBuilder/BlocListener
- Dispose BLoCs properly to prevent memory leaks

### Database Query Optimization
- Use indexed columns for filtering (fecha, estado, cliente_id)
- Limit selected columns to only what's needed
- Use database functions for complex calculations (calculate_quote)

