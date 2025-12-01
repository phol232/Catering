import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/usecases/create_event.dart';
import '../../domain/usecases/delete_event.dart';
import '../../domain/usecases/get_all_events.dart';
import '../../domain/usecases/update_event.dart';
import '../../domain/usecases/upload_event_image.dart';
import 'event_event.dart';
import 'event_state.dart';

/// BLoC for managing event-related state and operations
class EventBloc extends Bloc<EventEvent, EventState> {
  final GetAllEvents getAllEvents;
  final CreateEvent createEvent;
  final UpdateEvent updateEvent;
  final DeleteEvent deleteEvent;
  final UploadEventImage uploadEventImage;

  EventBloc({
    required this.getAllEvents,
    required this.createEvent,
    required this.updateEvent,
    required this.deleteEvent,
    required this.uploadEventImage,
  }) : super(EventInitial()) {
    on<LoadAllEvents>(_onLoadAllEvents);
    on<CreateEventRequested>(_onCreateEventRequested);
    on<UpdateEventRequested>(_onUpdateEventRequested);
    on<DeleteEventRequested>(_onDeleteEventRequested);
    on<UploadImageRequested>(_onUploadImageRequested);
  }

  /// Handler for LoadAllEvents event
  Future<void> _onLoadAllEvents(
    LoadAllEvents event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());

    final result = await getAllEvents(NoParams());

    result.fold(
      (failure) => emit(EventError(failure.message)),
      (events) => emit(EventsLoaded(events)),
    );
  }

  /// Handler for CreateEventRequested event
  Future<void> _onCreateEventRequested(
    CreateEventRequested event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());

    final result = await createEvent(event.params);

    result.fold(
      (failure) => emit(EventError(failure.message)),
      (createdEvent) =>
          emit(const EventOperationSuccess('Evento creado exitosamente')),
    );
  }

  /// Handler for UpdateEventRequested event
  Future<void> _onUpdateEventRequested(
    UpdateEventRequested event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());

    final result = await updateEvent(event.params);

    result.fold(
      (failure) => emit(EventError(failure.message)),
      (updatedEvent) =>
          emit(const EventOperationSuccess('Evento actualizado exitosamente')),
    );
  }

  /// Handler for DeleteEventRequested event
  Future<void> _onDeleteEventRequested(
    DeleteEventRequested event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());

    final result = await deleteEvent(event.eventId);

    result.fold(
      (failure) => emit(EventError(failure.message)),
      (_) => emit(const EventOperationSuccess('Evento eliminado exitosamente')),
    );
  }

  /// Handler for UploadImageRequested event
  Future<void> _onUploadImageRequested(
    UploadImageRequested event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());

    final result = await uploadEventImage(event.imageFile);

    result.fold(
      (failure) => emit(EventError(failure.message)),
      (imageUrl) => emit(ImageUploaded(imageUrl)),
    );
  }
}
