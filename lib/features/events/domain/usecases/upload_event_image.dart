import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../repositories/event_repository.dart';

/// Use case for uploading an event image to storage
class UploadEventImage extends UseCase<String, File> {
  final EventRepository repository;

  UploadEventImage(this.repository);

  @override
  Future<Either<Failure, String>> call(File imageFile) {
    return repository.uploadEventImage(imageFile);
  }
}
