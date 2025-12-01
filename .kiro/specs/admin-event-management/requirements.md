# Requirements Document - Panel de Administración de Eventos

## Introduction

El Panel de Administración de CaterPro permite a los usuarios con rol ADMIN gestionar completamente los eventos de catering. Incluye un sistema de navegación por pestañas (Bottom Navigation) con acceso a Eventos, Pedidos, Menús y Configuración. El módulo de gestión de eventos permite crear, editar, eliminar y listar eventos con soporte para carga de imágenes que se convierten automáticamente a URLs mediante Supabase Storage.

## Glossary

- **Admin Panel**: Panel de administración con navegación por pestañas para gestión completa
- **Bottom Navigation**: Barra de navegación inferior con 4 pestañas principales
- **Event Management**: Módulo CRUD completo para gestión de eventos
- **Image Upload**: Funcionalidad para subir imágenes y convertirlas a URLs
- **Supabase Storage**: Servicio de almacenamiento de archivos de Supabase
- **Loading Screen**: Pantalla de carga mostrada durante operaciones asíncronas
- **CRUD**: Create, Read, Update, Delete - operaciones básicas de gestión

## Requirements

### Requirement 1

**User Story:** Como administrador, quiero ver una barra de navegación inferior con 4 pestañas, para poder acceder rápidamente a las diferentes secciones del panel.

#### Acceptance Criteria

1. WHEN un usuario con rol ADMIN inicia sesión THEN el CaterPro System SHALL mostrar un Bottom Navigation Bar con 4 pestañas: Eventos, Pedidos, Menús, Config
2. WHEN el administrador toca una pestaña THEN el CaterPro System SHALL cambiar la vista a la sección correspondiente sin recargar la aplicación
3. WHEN se muestra el Bottom Navigation THEN el CaterPro System SHALL resaltar la pestaña activa con el color amarillo pastel de la marca
4. WHEN el administrador navega entre pestañas THEN el CaterPro System SHALL mantener el estado de cada sección
5. WHEN se muestra el Bottom Navigation THEN el CaterPro System SHALL usar iconos claros y texto descriptivo en español para cada pestaña

### Requirement 2

**User Story:** Como administrador, quiero ver una pantalla de carga al iniciar sesión, para saber que el sistema está procesando mi autenticación.

#### Acceptance Criteria

1. WHEN el administrador envía credenciales válidas THEN el CaterPro System SHALL mostrar una pantalla de carga con el logo de la aplicación
2. WHEN la autenticación se completa exitosamente THEN el CaterPro System SHALL ocultar la pantalla de carga y mostrar el panel de administración
3. WHEN se muestra la pantalla de carga THEN el CaterPro System SHALL incluir un indicador de progreso animado
4. WHEN la pantalla de carga está visible THEN el CaterPro System SHALL usar los colores de la marca (amarillo pastel y negro)
5. WHEN la autenticación falla THEN el CaterPro System SHALL ocultar la pantalla de carga y mostrar el mensaje de error

### Requirement 3

**User Story:** Como administrador, quiero ver una lista de todos los eventos, para tener una visión general de los eventos en el sistema.

#### Acceptance Criteria

1. WHEN el administrador accede a la pestaña Eventos THEN el CaterPro System SHALL mostrar una lista de todos los eventos ordenados por fecha descendente
2. WHEN se muestra la lista de eventos THEN el CaterPro System SHALL incluir imagen, nombre del evento, fecha, tipo, ciudad y estado para cada evento
3. WHEN la lista de eventos está vacía THEN el CaterPro System SHALL mostrar un mensaje indicando que no hay eventos y un botón para crear el primero
4. WHEN se carga la lista de eventos THEN el CaterPro System SHALL mostrar un indicador de carga mientras obtiene los datos
5. WHEN hay más de 20 eventos THEN el CaterPro System SHALL implementar paginación o scroll infinito

### Requirement 4

**User Story:** Como administrador, quiero crear un nuevo evento con imagen, para agregar eventos al sistema con toda su información visual.

#### Acceptance Criteria

1. WHEN el administrador toca el botón "Crear Evento" THEN el CaterPro System SHALL mostrar un formulario con campos: nombre, tipo, fecha, hora inicio, hora fin, número de invitados, dirección, ciudad, menú, nota y opción para subir imagen
2. WHEN el administrador selecciona una imagen THEN el CaterPro System SHALL mostrar una vista previa de la imagen seleccionada
3. WHEN el administrador envía el formulario con imagen THEN el CaterPro System SHALL subir la imagen a Supabase Storage y obtener la URL
4. WHEN la imagen se sube exitosamente THEN el CaterPro System SHALL guardar el evento en la base de datos con la URL de la imagen en el campo image_url
5. WHEN el evento se crea exitosamente THEN el CaterPro System SHALL mostrar un mensaje de éxito, cerrar el formulario y actualizar la lista de eventos

### Requirement 5

**User Story:** Como administrador, quiero editar un evento existente, para actualizar su información incluyendo la imagen.

#### Acceptance Criteria

1. WHEN el administrador toca un evento en la lista THEN el CaterPro System SHALL mostrar las opciones de Editar y Eliminar
2. WHEN el administrador selecciona Editar THEN el CaterPro System SHALL mostrar el formulario pre-llenado con los datos actuales del evento
3. WHEN el administrador cambia la imagen THEN el CaterPro System SHALL subir la nueva imagen a Supabase Storage y eliminar la imagen anterior
4. WHEN el administrador guarda los cambios THEN el CaterPro System SHALL actualizar el evento en la base de datos
5. WHEN la edición se completa exitosamente THEN el CaterPro System SHALL mostrar un mensaje de éxito, cerrar el formulario y actualizar la lista de eventos

### Requirement 6

**User Story:** Como administrador, quiero eliminar un evento, para remover eventos que ya no son necesarios.

#### Acceptance Criteria

1. WHEN el administrador selecciona Eliminar en un evento THEN el CaterPro System SHALL mostrar un diálogo de confirmación
2. WHEN el administrador confirma la eliminación THEN el CaterPro System SHALL eliminar la imagen asociada de Supabase Storage
3. WHEN la imagen se elimina THEN el CaterPro System SHALL eliminar el registro del evento de la base de datos
4. WHEN la eliminación se completa exitosamente THEN el CaterPro System SHALL mostrar un mensaje de éxito y actualizar la lista de eventos
5. WHEN el administrador cancela la eliminación THEN el CaterPro System SHALL cerrar el diálogo sin realizar cambios

### Requirement 7

**User Story:** Como administrador, quiero que las imágenes se suban automáticamente a Supabase Storage, para no tener que gestionar URLs manualmente.

#### Acceptance Criteria

1. WHEN el administrador selecciona una imagen THEN el CaterPro System SHALL validar que el archivo sea una imagen (jpg, png, webp)
2. WHEN la imagen es válida THEN el CaterPro System SHALL comprimir la imagen si supera 2MB
3. WHEN se sube una imagen THEN el CaterPro System SHALL generar un nombre único usando el timestamp y un UUID
4. WHEN la imagen se sube a Supabase Storage THEN el CaterPro System SHALL almacenarla en el bucket "event-images"
5. WHEN la subida se completa THEN el CaterPro System SHALL obtener la URL pública de la imagen y usarla en el campo image_url

### Requirement 8

**User Story:** Como administrador, quiero ver mensajes claros de éxito o error, para saber el resultado de mis acciones.

#### Acceptance Criteria

1. WHEN una operación se completa exitosamente THEN el CaterPro System SHALL mostrar un SnackBar verde con el mensaje de éxito
2. WHEN una operación falla THEN el CaterPro System SHALL mostrar un SnackBar rojo con el mensaje de error
3. WHEN se muestra un mensaje THEN el CaterPro System SHALL ocultarlo automáticamente después de 3 segundos
4. WHEN hay un error de red THEN el CaterPro System SHALL mostrar un mensaje específico indicando problema de conexión
5. WHEN hay un error de validación THEN el CaterPro System SHALL mostrar el mensaje de error debajo del campo correspondiente

### Requirement 9

**User Story:** Como administrador, quiero que el formulario valide los datos antes de enviar, para evitar errores en la creación de eventos.

#### Acceptance Criteria

1. WHEN el campo nombre está vacío THEN el CaterPro System SHALL mostrar error "El nombre del evento es requerido"
2. WHEN el campo fecha está vacío THEN el CaterPro System SHALL mostrar error "La fecha es requerida"
3. WHEN el número de invitados es menor a 1 THEN el CaterPro System SHALL mostrar error "Debe haber al menos 1 invitado"
4. WHEN todos los campos requeridos son válidos THEN el CaterPro System SHALL habilitar el botón de guardar
5. WHEN hay errores de validación THEN el CaterPro System SHALL deshabilitar el botón de guardar

### Requirement 10

**User Story:** Como administrador, quiero que la interfaz use los colores de la marca, para mantener consistencia visual con el resto de la aplicación.

#### Acceptance Criteria

1. WHEN se muestra el panel de administración THEN el CaterPro System SHALL usar fondo negro (0xFF000000)
2. WHEN se muestran tarjetas o contenedores THEN el CaterPro System SHALL usar gris oscuro (0xFF404040)
3. WHEN se muestran botones primarios THEN el CaterPro System SHALL usar amarillo pastel (0xFFF2F862)
4. WHEN se muestra texto principal THEN el CaterPro System SHALL usar blanco casi puro (0xFFFEFEFE)
5. WHEN se muestra texto secundario THEN el CaterPro System SHALL usar gris claro (0xFFC1C1C1)
