import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      final userModel = await remoteDataSource.signInWithPassword(
        email,
        password,
      );
      return Right(userModel.toEntity());
    } on Exception catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('Invalid login credentials') ||
          errorMessage.contains('invalid') ||
          errorMessage.contains('credentials')) {
        return const Left(
          AuthFailure('Correo electrónico o contraseña incorrectos'),
        );
      }
      return Left(AuthFailure(errorMessage));
    } catch (e) {
      return const Left(AuthFailure('Ocurrió un error inesperado'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail(
    String email,
    String password,
    String nombre,
  ) async {
    try {
      final userModel = await remoteDataSource.signUp(email, password, nombre);
      return Right(userModel.toEntity());
    } on Exception catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('already registered') ||
          errorMessage.contains('duplicate') ||
          errorMessage.contains('already exists') ||
          errorMessage.contains('User already registered')) {
        return const Left(
          AuthFailure('Este correo electrónico ya está registrado'),
        );
      }
      if (errorMessage.contains('Password should be at least')) {
        return const Left(
          AuthFailure('La contraseña debe tener al menos 6 caracteres'),
        );
      }
      return Left(AuthFailure(errorMessage));
    } catch (e) {
      return const Left(AuthFailure('Ocurrió un error inesperado'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    try {
      final userModel = await remoteDataSource.signInWithOAuth();
      return Right(userModel.toEntity());
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.currentSession();
      return Right(userModel?.toEntity());
    } catch (e) {
      return const Right(null);
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.asyncMap((authState) async {
      try {
        if (authState.session == null) {
          return null;
        }
        final userModel = await remoteDataSource.currentSession();
        return userModel?.toEntity();
      } catch (e) {
        return null;
      }
    });
  }
}
