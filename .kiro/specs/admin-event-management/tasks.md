# Implementation Plan - Panel de Administración de Eventos

- [x] 1. Configurar dependencias y estructura
  - Agregar image_picker, flutter_image_compress y uuid al pubspec.yaml
  - Crear estructura de carpetas para events feature
  - Configurar Supabase Storage bucket para imágenes
  - _Requirements: 7.1, 7.4_

- [x] 2. Implementar capa de dominio para eventos
  - [x] 2.1 Crear EventEntity con todos los campos incluyendo imageUrl
    - Definir EventEntity con Equatable
    - Incluir todos los campos del evento
    - _Requirements: 3.2, 4.1_
  
  - [x] 2.2 Crear EventRepository interface
    - Definir métodos CRUD (getAllEvents, getEventById, createEvent, updateEvent, deleteEvent)
    - Definir métodos para imágenes (uploadEventImage, deleteEventImage)
    - _Requirements: 3.1, 4.1, 5.1, 6.1, 7.5_
  
  - [x] 2.3 Crear use cases para eventos
    - Implementar GetAllEvents use case
    - Implementar CreateEvent use case
    - Implementar UpdateEvent use case
    - Implementar DeleteEvent use case
    - Implementar UploadEventImage use case
    - _Requirements: 3.1, 4.4, 5.4, 6.3, 7.5_

- [x] 3. Implementar capa de datos para eventos
  - [x] 3.1 Crear EventModel con serialización
    - Implementar fromJson y toJson
    - Implementar toEntity
    - Manejar conversión de TimeOfDay
    - _Requirements: 3.2, 4.4_
  
  - [x] 3.2 Crear EventRemoteDataSource
    - Implementar getAllEvents con query a Supabase
    - Implementar getEventById
    - Implementar createEvent con insert
    - Implementar updateEvent con update
    - Implementar deleteEvent con delete
    - _Requirements: 3.1, 4.4, 5.4, 6.3_
  
  - [x] 3.3 Crear ImageUploadService
    - Implementar uploadEventImage con compresión
    - Implementar deleteEventImage
    - Generar nombres únicos con UUID y timestamp
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_
  
  - [x] 3.4 Implementar EventRepositoryImpl
    - Implementar todos los métodos del repository
    - Integrar ImageUploadService
    - Manejar errores y convertir a Failures
    - _Requirements: 3.1, 4.4, 5.4, 6.3, 7.5_

- [x] 4. Implementar BLoC para gestión de eventos
  - [x] 4.1 Crear EventEvent classes
    - Definir LoadAllEvents
    - Definir CreateEventRequested
    - Definir UpdateEventRequested
    - Definir DeleteEventRequested
    - Definir UploadImageRequested
    - _Requirements: 3.1, 4.1, 5.1, 6.1_
  
  - [x] 4.2 Crear EventState classes
    - Definir EventInitial
    - Definir EventLoading
    - Definir EventsLoaded
    - Definir EventOperationSuccess
    - Definir ImageUploaded
    - Definir EventError
    - _Requirements: 3.4, 8.1, 8.2_
  
  - [x] 4.3 Implementar EventBloc
    - Implementar handler para LoadAllEvents
    - Implementar handler para CreateEventRequested
    - Implementar handler para UpdateEventRequested
    - Implementar handler para DeleteEventRequested
    - Implementar handler para UploadImageRequested
    - _Requirements: 3.1, 4.4, 5.4, 6.3_

- [x] 5. Crear pantalla de carga
  - [x] 5.1 Implementar LoadingScreen widget
    - Crear diseño con logo y spinner
    - Usar colores de la marca
    - Agregar texto "Cargando..."
    - _Requirements: 2.1, 2.3, 2.4, 10.1, 10.2, 10.3_
  
  - [x] 5.2 Integrar LoadingScreen en flujo de login
    - Mostrar LoadingScreen cuando AuthState es AuthLoading
    - Ocultar cuando AuthState es AuthAuthenticated
    - _Requirements: 2.1, 2.2, 2.5_

- [x] 6. Implementar Bottom Navigation para Admin
  - [x] 6.1 Crear AdminDashboardScreen con BottomNavigationBar
    - Implementar StatefulWidget con índice actual
    - Crear 4 pestañas: Eventos, Pedidos, Menús, Config
    - Usar iconos apropiados para cada pestaña
    - _Requirements: 1.1, 1.5_
  
  - [x] 6.2 Estilizar Bottom Navigation
    - Aplicar colores de la marca
    - Resaltar pestaña activa con amarillo pastel
    - Usar gris claro para pestañas inactivas
    - _Requirements: 1.3, 10.1, 10.2, 10.3_
  
  - [x] 6.3 Implementar navegación entre pestañas
    - Cambiar vista al tocar pestaña
    - Mantener estado de cada sección
    - _Requirements: 1.2, 1.4_

- [x] 7. Implementar lista de eventos
  - [x] 7.1 Crear EventListScreen
    - Implementar BlocBuilder para EventBloc
    - Mostrar lista de eventos con ListView.builder
    - Ordenar eventos por fecha descendente
    - _Requirements: 3.1, 3.2_
  
  - [x] 7.2 Crear EventCard widget
    - Mostrar imagen del evento con cached_network_image
    - Mostrar nombre, fecha, tipo, ciudad y estado
    - Agregar botones de editar y eliminar
    - _Requirements: 3.2, 10.1, 10.2, 10.4_
  
  - [x] 7.3 Implementar estado vacío
    - Mostrar mensaje cuando no hay eventos
    - Agregar botón "Crear Primer Evento"
    - _Requirements: 3.3_
  
  - [x] 7.4 Implementar indicador de carga
    - Mostrar CircularProgressIndicator mientras carga
    - _Requirements: 3.4_
  
  - [x] 7.5 Agregar botón flotante para crear evento
    - Posicionar FloatingActionButton
    - Mostrar Bottom Sheet de formulario al tocar
    - _Requirements: 4.1_

- [x] 8. Implementar formulario de evento con Bottom Sheet
  - [x] 8.1 Crear EventFormBottomSheet
    - Crear formulario con GlobalKey en Bottom Sheet
    - Agregar campos: nombre, tipo, fecha, hora inicio, hora fin, invitados, dirección, ciudad, menú, nota
    - Implementar modo crear/editar
    - Hacer scrollable con DraggableScrollableSheet
    - _Requirements: 4.1, 5.2_
  
  - [x] 8.2 Implementar selector de imagen
    - Agregar botón para seleccionar imagen
    - Mostrar vista previa de imagen seleccionada
    - Usar image_picker para seleccionar de galería
    - _Requirements: 4.2, 7.1_
  
  - [x] 8.3 Implementar validaciones de formulario
    - Validar nombre requerido
    - Validar fecha requerida
    - Validar número de invitados >= 1
    - Deshabilitar botón guardar si hay errores
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_
  
  - [x] 8.4 Implementar lógica de guardado
    - Subir imagen si fue seleccionada
    - Crear o actualizar evento con datos del formulario
    - Mostrar indicador de carga durante operación
    - _Requirements: 4.3, 4.4, 5.3, 5.4_
  
  - [x] 8.5 Manejar respuesta de guardado
    - Mostrar mensaje de éxito
    - Cerrar Bottom Sheet
    - Recargar lista de eventos
    - _Requirements: 4.5, 5.5, 8.1_

- [x] 9. Implementar eliminación de eventos
  - [x] 9.1 Crear diálogo de confirmación
    - Mostrar AlertDialog al tocar eliminar
    - Incluir botones Cancelar y Eliminar
    - _Requirements: 6.1, 6.5_
  
  - [x] 9.2 Implementar lógica de eliminación
    - Eliminar imagen de Storage si existe
    - Eliminar evento de base de datos
    - _Requirements: 6.2, 6.3_
  
  - [x] 9.3 Manejar respuesta de eliminación
    - Mostrar mensaje de éxito
    - Recargar lista de eventos
    - _Requirements: 6.4, 8.1_

- [x] 10. Implementar manejo de mensajes
  - [x] 10.1 Crear SnackBar para mensajes de éxito
    - Usar color verde para éxito
    - Auto-ocultar después de 1 segundos
    - _Requirements: 8.1, 8.3_
  
  - [x] 10.2 Crear SnackBar para mensajes de error
    - Usar color rojo para errores
    - Mostrar mensaje específico según tipo de error
    - Auto-ocultar después de 1 segundos
    - _Requirements: 8.2, 8.3, 8.4, 8.5_

- [x] 11. Actualizar dependency injection
  - [x] 11.1 Registrar dependencias de eventos
    - Registrar EventRemoteDataSource
    - Registrar ImageUploadService
    - Registrar EventRepository
    - Registrar todos los use cases
    - Registrar EventBloc como factory
    - _Requirements: 3.1, 4.1, 5.1, 6.1_

- [x] 12. Actualizar navegación principal
  - [x] 12.1 Modificar router para Admin
    - Cambiar ruta de admin dashboard a nueva pantalla con Bottom Nav
    - No se necesitan rutas adicionales (todo es Bottom Sheet)
    - _Requirements: 1.1_

- [x] 13. Crear pantallas placeholder
  - [x] 13.1 Crear OrdersScreen placeholder
    - Pantalla simple con mensaje "Próximamente"
    - _Requirements: 1.1_
  
  - [x] 13.2 Crear MenusScreen placeholder
    - Pantalla simple con mensaje "Próximamente"
    - _Requirements: 1.1_
  
  - [x] 13.3 Crear ConfigScreen placeholder
    - Pantalla simple con mensaje "Próximamente"
    - _Requirements: 1.1_

- [ ] 14. Testing y refinamiento
  - [ ] 14.1 Probar flujo completo de creación
    - Crear evento con imagen
    - Verificar que aparece en lista
    - _Requirements: 4.5_
  
  - [ ] 14.2 Probar flujo completo de edición
    - Editar evento existente
    - Cambiar imagen
    - Verificar actualización en lista
    - _Requirements: 5.5_
  
  - [ ] 14.3 Probar flujo completo de eliminación
    - Eliminar evento
    - Verificar que desaparece de lista
    - Verificar que imagen se eliminó de Storage
    - _Requirements: 6.4_
  
  - [ ] 14.4 Probar manejo de errores
    - Probar sin conexión a internet
    - Probar con imagen muy grande
    - Probar con datos inválidos
    - _Requirements: 8.2, 8.4_

- [ ] 15. Checkpoint final
  - Verificar que todos los flujos funcionan correctamente
  - Verificar que los colores de la marca se aplican consistentemente
  - Verificar que los mensajes están en español
  - Asegurar que no hay memory leaks
