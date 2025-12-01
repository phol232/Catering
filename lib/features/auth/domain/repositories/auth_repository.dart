import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmail(
    String email,
    String password,
  );

  Future<Either<Failure, UserEntity>> registerWithEmail(
    String email,
    String password,
    String nombre,
  );

  Future<Either<Failure, UserEntity>> loginWithGoogle();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Stream of authentication state changes
  /// Emits UserEntity when user is authenticated, null when unauthenticated
  Stream<UserEntity?> get authStateChanges;
}
