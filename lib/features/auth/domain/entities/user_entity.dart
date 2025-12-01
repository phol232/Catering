import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String nombre;
  final String email;
  final String? telefono;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    required this.role,
  });

  @override
  List<Object?> get props => [id, nombre, email, telefono, role];
}

enum UserRole {
  cliente,
  admin,
  logistica,
  cocina,
  gestor;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name.toUpperCase() == value.toUpperCase(),
    );
  }

  String toUpperCaseString() {
    return name.toUpperCase();
  }
}
