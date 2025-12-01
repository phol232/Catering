import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterWithEmail
    implements UseCase<UserEntity, RegisterWithEmailParams> {
  final AuthRepository repository;

  RegisterWithEmail(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(
    RegisterWithEmailParams params,
  ) async {
    return await repository.registerWithEmail(
      params.email,
      params.password,
      params.nombre,
    );
  }
}

class RegisterWithEmailParams extends Equatable {
  final String email;
  final String password;
  final String nombre;

  const RegisterWithEmailParams({
    required this.email,
    required this.password,
    required this.nombre,
  });

  @override
  List<Object?> get props => [email, password, nombre];
}
