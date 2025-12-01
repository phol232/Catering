import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register_with_email.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail loginWithEmail;
  final RegisterWithEmail registerWithEmail;
  final LoginWithGoogle loginWithGoogle;
  final Logout logout;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.loginWithEmail,
    required this.registerWithEmail,
    required this.loginWithGoogle,
    required this.logout,
    required this.getCurrentUser,
  }) : super(const AuthInitial()) {
    on<AuthLoginWithEmailRequested>(_onLoginWithEmail);
    on<AuthRegisterWithEmailRequested>(_onRegisterWithEmail);
    on<AuthLoginWithGoogleRequested>(_onLoginWithGoogle);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthCheckStatusRequested>(_onCheckStatus);
  }

  Future<void> _onLoginWithEmail(
    AuthLoginWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🟢 AuthBloc: Login requested for ${event.email}');
    emit(const AuthLoading());

    final result = await loginWithEmail(
      LoginWithEmailParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        print('🔴 AuthBloc: Login failed - ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        print('🟢 AuthBloc: Login success - ${user.email}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onRegisterWithEmail(
    AuthRegisterWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🟢 AuthBloc: Register requested for ${event.email}');
    emit(const AuthLoading());

    final result = await registerWithEmail(
      RegisterWithEmailParams(
        email: event.email,
        password: event.password,
        nombre: event.nombre,
      ),
    );

    result.fold(
      (failure) {
        print('🔴 AuthBloc: Register failed - ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        print('🟢 AuthBloc: Register success - ${user.email}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onLoginWithGoogle(
    AuthLoginWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginWithGoogle(NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logout(NoParams());
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUser(NoParams());

    result.fold((failure) => emit(const AuthUnauthenticated()), (user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }
}
