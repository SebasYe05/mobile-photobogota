import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/auth_repository.dart';

// ==========================================
// 1. LOS EVENTOS (Acciones que vienen de la Vista)
// ==========================================
/// Clase base abstracta. Todos los eventos de recuperación heredarán de ella.
abstract class ForgotPasswordEvent {}

/// Evento que se dispara cuando el usuario ingresa su correo y presiona "Enviar código".
class ForgotPasswordRequested extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordRequested(this.email);
}

/// Evento que se dispara cuando el usuario ingresa el código recibido y presiona "Verificar código".
class VerifyCodeRequested extends ForgotPasswordEvent {
  final String email;
  final String code;
  VerifyCodeRequested(this.email, this.code);
}

/// Evento que se dispara cuando el usuario ingresa la nueva contraseña y presiona "Actualizar contraseña".
class ResetPasswordRequested extends ForgotPasswordEvent {
  final String email;
  final String code;
  final String newPassword;
  ResetPasswordRequested(this.email, this.code, this.newPassword);
}


// ==========================================
// 2. LOS ESTADOS (Lo que el BLoC le responde a la Vista)
// ==========================================
/// Clase base abstracta de la cual heredan todos los estados posibles.
abstract class ForgotPasswordState {}

/// Estado inicial: La pantalla de recuperación está lista para usarse.
class ForgotPasswordInitial extends ForgotPasswordState {}

/// Estado de carga: Muestra un spinner o indicador de carga mientras el servidor responde.
class ForgotPasswordLoading extends ForgotPasswordState {}

/// Estado de éxito: El correo fue enviado, el código fue verificado o la contraseña fue restablecida.
class ForgotPasswordSuccess extends ForgotPasswordState {}

/// Estado de error: Algo salió mal (ej. correo no registrado, código inválido, etc).
/// La vista muestra un SnackBar con el mensaje.
class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  ForgotPasswordFailure(this.message);
}


// ==========================================
// 3. EL BLOC (El "Controller" que une todo)
// ==========================================
/// Esta clase es el cerebro de la pantalla de recuperación. Recibe [ForgotPasswordEvent] y emite [ForgotPasswordState].
class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  // Inyección de dependencias: El BLoC NO sabe cómo hablar con internet,
  // le pide ayuda al Repositorio (Capa de Domain).
  final AuthRepository authRepository;

  // Al inicializar el BLoC, definimos que el primer estado de la pantalla será 'ForgotPasswordInitial'
  ForgotPasswordBloc({required this.authRepository}) : super(ForgotPasswordInitial()) {

    // ------------------------------------------
    // MANEJADOR DEL EVENTO: ForgotPasswordRequested
    // ------------------------------------------
    on<ForgotPasswordRequested>((event, emit) async {
      emit(ForgotPasswordLoading());

      try {
        await authRepository.forgotPassword(event.email);
        emit(ForgotPasswordSuccess());
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });

    // ------------------------------------------
    // MANEJADOR DEL EVENTO: VerifyCodeRequested
    // ------------------------------------------
    on<VerifyCodeRequested>((event, emit) async {
      emit(ForgotPasswordLoading());

      try {
        await authRepository.verifyCode(event.email, event.code);
        emit(ForgotPasswordSuccess());
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });

    // ------------------------------------------
    // MANEJADOR DEL EVENTO: ResetPasswordRequested
    // ------------------------------------------
    on<ResetPasswordRequested>((event, emit) async {
      emit(ForgotPasswordLoading());

      try {
        await authRepository.resetPassword(
          email: event.email,
          code: event.code,
          newPassword: event.newPassword,
        );
        emit(ForgotPasswordSuccess());
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });
  }
}
