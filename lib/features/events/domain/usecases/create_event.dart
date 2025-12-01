import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

/// Use case for creating a new event
class CreateEvent extends UseCase<EventEntity, CreateEventParams> {
  final EventRepository repository;

  CreateEvent(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(CreateEventParams params) {
    return repository.createEvent(params);
  }
}
