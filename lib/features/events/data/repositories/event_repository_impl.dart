import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_datasource.dart';
import '../datasources/image_upload_service.dart';

/// Implementation of EventRepository
class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final ImageUploadService imageUploadService;

  EventRepositoryImpl({
    required this.remoteDataSource,
    required this.imageUploadService,
  });

  @override
  Future<Either<Failure, List<EventEntity>>> getAllEvents() async {
    try {
      final eventModels = await remoteDataSource.getAllEvents();
      final entities = eventModels.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(DatabaseFailure('Error al obtener eventos: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> getEventById(int id) async {
    try {
      final eventModel = await remoteDataSource.getEventById(id);
      return Right(eventModel.toEntity());
    } catch (e) {
      if (e.toString().contains('not found') ||
          e.toString().contains('no rows')) {
        return Left(NotFoundFailure('Evento no encontrado'));
      }
      return Left(DatabaseFailure('Error al obtener evento: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> createEvent(
    CreateEventParams params,
  ) async {
    try {
      // Validate required fields
      if (params.nombreEvento.trim().isEmpty) {
        return const Left(
          ValidationFailure('El nombre del evento es requerido'),
        );
      }
      if (params.numInvitados < 1) {
        return const Left(ValidationFailure('Debe haber al menos 1 invitado'));
      }

      final eventModel = await remoteDataSource.createEvent(params);
      return Right(eventModel.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Error al crear evento: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> updateEvent(
    UpdateEventParams params,
  ) async {
    try {
      // Validate fields if provided
      if (params.nombreEvento != null && params.nombreEvento!.trim().isEmpty) {
        return const Left(
          ValidationFailure('El nombre del evento es requerido'),
        );
      }
      if (params.numInvitados != null && params.numInvitados! < 1) {
        return const Left(ValidationFailure('Debe haber al menos 1 invitado'));
      }

      final eventModel = await remoteDataSource.updateEvent(params);
      return Right(eventModel.toEntity());
    } catch (e) {
      if (e.toString().contains('not found') ||
          e.toString().contains('no rows')) {
        return Left(NotFoundFailure('Evento no encontrado'));
      }
      return Left(
        DatabaseFailure('Error al actualizar evento: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(int id) async {
    try {
      // Get event to check if it has an image
      final eventResult = await getEventById(id);

      await eventResult.fold((failure) => throw Exception(failure.message), (
        event,
      ) async {
        // Delete image if exists
        if (event.imageUrl != null && event.imageUrl!.isNotEmpty) {
          await deleteEventImage(event.imageUrl!);
        }
      });

      await remoteDataSource.deleteEvent(id);
      return const Right(null);
    } catch (e) {
      if (e.toString().contains('not found') ||
          e.toString().contains('no rows')) {
        return Left(NotFoundFailure('Evento no encontrado'));
      }
      return Left(DatabaseFailure('Error al eliminar evento: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadEventImage(File imageFile) async {
    try {
      // Validate file exists
      if (!await imageFile.exists()) {
        return const Left(ValidationFailure('El archivo de imagen no existe'));
      }

      // Validate file extension
      final extension = imageFile.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        return const Left(
          ValidationFailure('Formato de imagen no válido. Use jpg, png o webp'),
        );
      }

      final imageUrl = await imageUploadService.uploadEventImage(imageFile);
      return Right(imageUrl);
    } on SocketException {
      return const Left(
        NetworkFailure('Error de conexión. Verifique su conexión a internet'),
      );
    } catch (e) {
      return Left(DatabaseFailure('Error al subir imagen: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEventImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty) {
        return const Left(ValidationFailure('URL de imagen inválida'));
      }

      await imageUploadService.deleteEventImage(imageUrl);
      return const Right(null);
    } on SocketException {
      return const Left(
        NetworkFailure('Error de conexión. Verifique su conexión a internet'),
      );
    } catch (e) {
      return Left(DatabaseFailure('Error al eliminar imagen: ${e.toString()}'));
    }
  }
}
