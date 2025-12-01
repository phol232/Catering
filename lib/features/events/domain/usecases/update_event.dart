import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

/// Use case for updating an existing event
class UpdateEvent extends UseCase<EventEntity, UpdateEventParams> {
  final EventRepository repository;

  UpdateEvent(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(UpdateEventParams params) {
    return repository.updateEvent(params);
  }
}
