import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

/// Use case for retrieving all events from the repository
class GetAllEvents extends UseCase<List<EventEntity>, NoParams> {
  final EventRepository repository;

  GetAllEvents(this.repository);

  @override
  Future<Either<Failure, List<EventEntity>>> call(NoParams params) {
    return repository.getAllEvents();
  }
}
