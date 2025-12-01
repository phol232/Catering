abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message, 'NETWORK_ERROR');
}

class AuthFailure extends Failure {
  const AuthFailure(String message, [String? code]) : super(message, code);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message) : super(message, 'DATABASE_ERROR');
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message, 'VALIDATION_ERROR');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message, 'NOT_FOUND');
}

class PermissionFailure extends Failure {
  const PermissionFailure(String message) : super(message, 'PERMISSION_DENIED');
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message, 'SERVER_ERROR');
}
