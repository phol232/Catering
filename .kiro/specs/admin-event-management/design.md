# Design Document - Panel de Administración de Eventos

## Overview

El Panel de Administración de Eventos es un módulo completo para gestionar eventos de catering. Utiliza Clean Architecture con BLoC para state management, implementa un Bottom Navigation Bar para navegación entre secciones, y proporciona funcionalidad CRUD completa con soporte para subida de imágenes a Supabase Storage.

## Architecture

### High-Level Architecture

```
Presentation Layer (UI)
├── Admin Dashboard con Bottom Navigation
├── Event List Screen
├── Event Form Screen (Create/Edit)
├── Loading Screen
└── BLoC Components

Domain Layer (Business Logic)
├── Event Entity
├── Event Repository Interface
├── Use Cases (CRUD + Image Upload)
└── BLoC Events/States

Data Layer
├── Event Repository Implementation
├── Event Remote Data Source
├── Event Model
└── Supabase Storage Integration
```

### Technology Stack

- **State Management**: flutter_bloc
- **Image Picker**: image_picker ^1.0.0
- **Image Storage**: Supabase Storage
- **Image Compression**: flutter_image_compress ^2.0.0
- **UUID Generation**: uuid ^4.0.0
- **Navigation**: go_router (ya implementado)

## Components and Interfaces

### Event Entity

```dart
class EventEntity extends Equatable {
  final int id;
  final int clienteId;
  final int? menuId;
  final String nombreEvento;
  final String? tipoEvento;
  final DateTime fecha;
  final TimeOfDay? horaInicio;
  final TimeOfDay? horaFin;
  final int numInvitados;
  final String? direccion;
  final String? ciudad;
  final EventStatus estado;
  final String? notaCliente;
  final String? imageUrl;
  final DateTime createdAt;

  const EventEntity({
    required this.id,
    required this.clienteId,
    this.menuId,
    required this.nombreEvento,
    this.tipoEvento,
    required this.fecha,
    this.horaInicio,
    this.horaFin,
    required this.numInvitados,
    this.direccion,
    this.ciudad,
    required this.estado,
    this.notaCliente,
    this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        clienteId,
        menuId,
        nombreEvento,
        tipoEvento,
        fecha,
        horaInicio,
        horaFin,
        numInvitados,
        direccion,
        ciudad,
        estado,
        notaCliente,
        imageUrl,
        createdAt,
      ];
}
```

### Event Repository Interface

```dart
abstract class EventRepository {
  Future<Either<Failure, List<EventEntity>>> getAllEvents();
  Future<Either<Failure, EventEntity>> getEventById(int id);
  Future<Either<Failure, EventEntity>> createEvent(CreateEventParams params);
  Future<Either<Failure, EventEntity>> updateEvent(UpdateEventParams params);
  Future<Either<Failure, void>> deleteEvent(int id);
  Future<Either<Failure, String>> uploadEventImage(File imageFile);
  Future<Either<Failure, void>> deleteEventImage(String imageUrl);
}
```

### Use Cases

```dart
// Get All Events
class GetAllEvents extends UseCase<List<EventEntity>, NoParams> {
  final EventRepository repository;
  
  GetAllEvents(this.repository);
  
  @override
  Future<Either<Failure, List<EventEntity>>> call(NoParams params) {
    return repository.getAllEvents();
  }
}

// Create Event
class CreateEvent extends UseCase<EventEntity, CreateEventParams> {
  final EventRepository repository;
  
  CreateEvent(this.repository);
  
  @override
  Future<Either<Failure, EventEntity>> call(CreateEventParams params) {
    return repository.createEvent(params);
  }
}

// Update Event
class UpdateEvent extends UseCase<EventEntity, UpdateEventParams> {
  final EventRepository repository;
  
  UpdateEvent(this.repository);
  
  @override
  Future<Either<Failure, EventEntity>> call(UpdateEventParams params) {
    return repository.updateEvent(params);
  }
}

// Delete Event
class DeleteEvent extends UseCase<void, int> {
  final EventRepository repository;
  
  DeleteEvent(this.repository);
  
  @override
  Future<Either<Failure, void>> call(int eventId) {
    return repository.deleteEvent(eventId);
  }
}

// Upload Image
class UploadEventImage extends UseCase<String, File> {
  final EventRepository repository;
  
  UploadEventImage(this.repository);
  
  @override
  Future<Either<Failure, String>> call(File imageFile) {
    return repository.uploadEventImage(imageFile);
  }
}
```

## Data Models

### Event Model

```dart
class EventModel {
  final int id;
  final int clienteId;
  final int? menuId;
  final String nombreEvento;
  final String? tipoEvento;
  final DateTime fecha;
  final TimeOfDay? horaInicio;
  final TimeOfDay? horaFin;
  final int numInvitados;
  final String? direccion;
  final String? ciudad;
  final EventStatus estado;
  final String? notaCliente;
  final String? imageUrl;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.clienteId,
    this.menuId,
    required this.nombreEvento,
    this.tipoEvento,
    required this.fecha,
    this.horaInicio,
    this.horaFin,
    required this.numInvitados,
    this.direccion,
    this.ciudad,
    required this.estado,
    this.notaCliente,
    this.imageUrl,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      clienteId: json['cliente_id'],
      menuId: json['menu_id'],
      nombreEvento: json['nombre_evento'] ?? '',
      tipoEvento: json['tipo_evento'],
      fecha: DateTime.parse(json['fecha']),
      horaInicio: json['hora_inicio'] != null 
          ? _parseTime(json['hora_inicio']) 
          : null,
      horaFin: json['hora_fin'] != null 
          ? _parseTime(json['hora_fin']) 
          : null,
      numInvitados: json['num_invitados'],
      direccion: json['direccion'],
      ciudad: json['ciudad'],
      estado: EventStatus.fromString(json['estado']),
      notaCliente: json['nota_cliente'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cliente_id': clienteId,
      'menu_id': menuId,
      'nombre_evento': nombreEvento,
      'tipo_evento': tipoEvento,
      'fecha': fecha.toIso8601String().split('T')[0],
      'hora_inicio': horaInicio != null 
          ? '${horaInicio!.hour.toString().padLeft(2, '0')}:${horaInicio!.minute.toString().padLeft(2, '0')}' 
          : null,
      'hora_fin': horaFin != null 
          ? '${horaFin!.hour.toString().padLeft(2, '0')}:${horaFin!.minute.toString().padLeft(2, '0')}' 
          : null,
      'num_invitados': numInvitados,
      'direccion': direccion,
      'ciudad': ciudad,
      'estado': estado.name.toUpperCase(),
      'nota_cliente': notaCliente,
      'image_url': imageUrl,
    };
  }

  EventEntity toEntity() {
    return EventEntity(
      id: id,
      clienteId: clienteId,
      menuId: menuId,
      nombreEvento: nombreEvento,
      tipoEvento: tipoEvento,
      fecha: fecha,
      horaInicio: horaInicio,
      horaFin: horaFin,
      numInvitados: numInvitados,
      direccion: direccion,
      ciudad: ciudad,
      estado: estado,
      notaCliente: notaCliente,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]), 
      minute: int.parse(parts[1]),
    );
  }
}
```

## BLoC Implementation

### Event BLoC Events

```dart
abstract class EventEvent extends Equatable {
  const EventEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadAllEvents extends EventEvent {}

class CreateEventRequested extends EventEvent {
  final CreateEventParams params;
  
  const CreateEventRequested(this.params);
  
  @override
  List<Object?> get props => [params];
}

class UpdateEventRequested extends EventEvent {
  final UpdateEventParams params;
  
  const UpdateEventRequested(this.params);
  
  @override
  List<Object?> get props => [params];
}

class DeleteEventRequested extends EventEvent {
  final int eventId;
  
  const DeleteEventRequested(this.eventId);
  
  @override
  List<Object?> get props => [eventId];
}

class UploadImageRequested extends EventEvent {
  final File imageFile;
  
  const UploadImageRequested(this.imageFile);
  
  @override
  List<Object?> get props => [imageFile];
}
```

### Event BLoC States

```dart
abstract class EventState extends Equatable {
  const EventState();
  
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<EventEntity> events;
  
  const EventsLoaded(this.events);
  
  @override
  List<Object?> get props => [events];
}

class EventOperationSuccess extends EventState {
  final String message;
  
  const EventOperationSuccess(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ImageUploaded extends EventState {
  final String imageUrl;
  
  const ImageUploaded(this.imageUrl);
  
  @override
  List<Object?> get props => [imageUrl];
}

class EventError extends EventState {
  final String message;
  
  const EventError(this.message);
  
  @override
  List<Object?> get props => [message];
}
```

## UI Components

### Admin Dashboard with Bottom Navigation

```dart
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const EventManagementScreen(),
    const OrdersScreen(), // Placeholder
    const MenusScreen(),  // Placeholder
    const ConfigScreen(), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.grayDark,
        selectedItemColor: AppColors.yellowPastel,
        unselectedItemColor: AppColors.grayLight,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menús',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Config',
          ),
        ],
      ),
    );
  }
}
```

### Loading Screen

```dart
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.yellowPastel,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.restaurant,
                size: 60,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'CaterPro',
              style: TextStyle(
                color: AppColors.yellowPastel,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.yellowPastel,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Cargando...',
              style: TextStyle(
                color: AppColors.grayLight,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Image Upload Implementation

### Supabase Storage Setup

1. Create bucket in Supabase:
```sql
-- Create storage bucket for event images
INSERT INTO storage.buckets (id, name, public)
VALUES ('event-images', 'event-images', true);

-- Allow authenticated users to upload
CREATE POLICY "Authenticated users can upload event images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'event-images');

-- Allow public read access
CREATE POLICY "Public can view event images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'event-images');

-- Allow authenticated users to delete their uploads
CREATE POLICY "Authenticated users can delete event images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'event-images');
```

### Image Upload Service

```dart
class ImageUploadService {
  final SupabaseClient supabaseClient;
  
  ImageUploadService(this.supabaseClient);
  
  Future<String> uploadEventImage(File imageFile) async {
    try {
      // Compress image if needed
      final compressedFile = await _compressImage(imageFile);
      
      // Generate unique filename
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v4()}.jpg';
      
      // Upload to Supabase Storage
      await supabaseClient.storage
          .from('event-images')
          .upload(fileName, compressedFile);
      
      // Get public URL
      final imageUrl = supabaseClient.storage
          .from('event-images')
          .getPublicUrl(fileName);
      
      return imageUrl;
    } catch (e) {
      throw Exception('Error al subir imagen: $e');
    }
  }
  
  Future<void> deleteEventImage(String imageUrl) async {
    try {
      // Extract filename from URL
      final fileName = imageUrl.split('/').last;
      
      // Delete from storage
      await supabaseClient.storage
          .from('event-images')
          .remove([fileName]);
    } catch (e) {
      throw Exception('Error al eliminar imagen: $e');
    }
  }
  
  Future<File> _compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, lastIndex);
    final outPath = "${splitted}_compressed.jpg";
    
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 85,
      minWidth: 1024,
      minHeight: 1024,
    );
    
    return File(result!.path);
  }
}
```

## Error Handling

### Error Types

```dart
class ImageUploadFailure extends Failure {
  const ImageUploadFailure(String message) : super(message, 'IMAGE_UPLOAD_ERROR');
}

class EventNotFoundFailure extends Failure {
  const EventNotFoundFailure(String message) : super(message, 'EVENT_NOT_FOUND');
}

class EventValidationFailure extends Failure {
  const EventValidationFailure(String message) : super(message, 'VALIDATION_ERROR');
}
```

## Testing Strategy

### Unit Tests
- Test event CRUD operations
- Test image upload/delete logic
- Test form validation
- Test BLoC event handlers

### Widget Tests
- Test Bottom Navigation behavior
- Test Event List rendering
- Test Event Form validation
- Test Loading Screen display

### Integration Tests
- Test complete event creation flow
- Test event editing with image update
- Test event deletion with image cleanup
- Test navigation between tabs

## Navigation Flow

```
Login Success → Loading Screen → Admin Dashboard (Bottom Nav)
                                        ↓
                        ┌───────────────┼───────────────┬──────────┐
                        ↓               ↓               ↓          ↓
                    Eventos         Pedidos         Menús      Config
                        ↓
                Event List Screen
                        ↓
            ┌───────────┼───────────┐
            ↓           ↓           ↓
        Create      Edit        Delete
        Form        Form        Dialog
```

## Performance Considerations

- Implement image compression before upload
- Use cached_network_image for displaying event images
- Implement pagination for event list (20 items per page)
- Lazy load images in list view
- Cache event list in BLoC state
