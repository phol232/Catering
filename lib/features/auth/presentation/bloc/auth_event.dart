import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginWithEmailRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  final String nombre;

  const AuthRegisterWithEmailRequested({
    required this.email,
    required this.password,
    required this.nombre,
  });

  @override
  List<Object?> get props => [email, password, nombre];
}

class AuthLoginWithGoogleRequested extends AuthEvent {
  const AuthLoginWithGoogleRequested();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}
