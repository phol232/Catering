import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

/// Base class for all event-related states
abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the BLoC is first created
class EventInitial extends EventState {}

/// State indicating an event operation is in progress
class EventLoading extends EventState {}

/// State when events have been successfully loaded
class EventsLoaded extends EventState {
  final List<EventEntity> events;

  const EventsLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

/// State when an event operation (create/update/delete) completes successfully
class EventOperationSuccess extends EventState {
  final String message;

  const EventOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when an image has been successfully uploaded
class ImageUploaded extends EventState {
  final String imageUrl;

  const ImageUploaded(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

/// State when an error occurs during an event operation
class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}
