import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/auth_repository.dart';

// --- EVENTOS ---
abstract class AuthEvent {}
class AuthCheckRequested extends AuthEvent {}
class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;
  LoginSubmitted(this.username, this.password);
}
class LogoutRequested extends AuthEvent {}

// --- ESTADOS ---
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {}
class Unauthenticated extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

// --- BLOC ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    
    on<AuthCheckRequested>((event, emit) async {
      final token = await authRepository.getToken();
      if (token != null) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(event.username, event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(Unauthenticated());
    });
  }
}