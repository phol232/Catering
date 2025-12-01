import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/event_repository.dart';

/// Base class for all event-related events
abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all events from the repository
class LoadAllEvents extends EventEvent {}

/// Event to request creation of a new event
class CreateEventRequested extends EventEvent {
  final CreateEventParams params;

  const CreateEventRequested(this.params);

  @override
  List<Object?> get props => [params];
}

/// Event to request update of an existing event
class UpdateEventRequested extends EventEvent {
  final UpdateEventParams params;

  const UpdateEventRequested(this.params);

  @override
  List<Object?> get props => [params];
}

/// Event to request deletion of an event
class DeleteEventRequested extends EventEvent {
  final int eventId;

  const DeleteEventRequested(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

/// Event to request upload of an event image
class UploadImageRequested extends EventEvent {
  final File imageFile;

  const UploadImageRequested(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}
