import '../../domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String nombre;
  final String email;
  final String? telefono;
  final UserRole role;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      role: UserRole.fromString(json['role'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'role': role.toUpperCaseString(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      nombre: nombre,
      email: email,
      telefono: telefono,
      role: role,
    );
  }
}
