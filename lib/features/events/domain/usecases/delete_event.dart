import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../repositories/event_repository.dart';

/// Use case for deleting an event by ID
class DeleteEvent extends UseCase<void, int> {
  final EventRepository repository;

  DeleteEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(int eventId) {
    return repository.deleteEvent(eventId);
  }
}
