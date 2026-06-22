import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/auth_repository.dart';

// ==========================================
// 1. LOS EVENTOS (Acciones que vienen de la Vista)
// ==========================================
/// Clase base abstracta. Todos los eventos de autenticación heredarán de ella.
abstract class AuthEvent {}

/// Evento para verificar si el usuario ya tiene sesión iniciada al abrir la app.
class AuthCheckRequested extends AuthEvent {}

/// Evento que se dispara cuando el usuario llena el formulario y presiona "Iniciar Sesión".
class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;
  
  // Recibe las credenciales que el usuario escribió en los inputs text
  LoginSubmitted(this.username, this.password);
}

/// Evento que se dispara cuando el usuario presiona el botón de "Cerrar Sesión".
class LogoutRequested extends AuthEvent {}


// ==========================================
// 2. LOS ESTADOS (Lo que el BLoC le responde a la Vista)
// ==========================================
/// Clase base abstracta de la cual heredan todos los estados posibles en la pantalla.
abstract class AuthState {}

/// Estado inicial: La app no sabe si estás logueado o no (pantalla de carga inicial).
class AuthInitial extends AuthState {}

/// Estado de carga: Muestra un spinner o indicador de carga mientras el servidor responde.
class AuthLoading extends AuthState {}

/// Estado de éxito: El usuario inició sesión correctamente. La vista redirige al Home.
class Authenticated extends AuthState {}

/// Estado de salida: El usuario no está autenticado. La vista muestra el login.
class Unauthenticated extends AuthState {}

/// Estado de error: Algo salió mal (ej. contraseña incorrecta). La vista muestra un SnackBar con el mensaje.
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}


// ==========================================
// 3. EL BLOC (El "Controller" que une todo)
// ==========================================
/// Esta clase es el cerebro de la pantalla. Recibe [AuthEvent] y emite [AuthState].
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Inyección de dependencias: El BLoC NO sabe cómo hablar con internet, 
  // le pide ayuda al Repositorio (Capa de Domain).
  final AuthRepository authRepository;

  // Al inicializar el BLoC, definimos que el primer estado de la pantalla será 'AuthInitial'
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    
    // ------------------------------------------
    // MANEJADOR DEL EVENTO: AuthCheckRequested
    // ------------------------------------------
    on<AuthCheckRequested>((event, emit) async {
      // Le pedimos al repositorio el token que guardamos en el almacenamiento seguro
      final token = await authRepository.getToken();
      
      if (token != null) {
        // Si hay un token guardado, le decimos a la vista: "¡Ya está autenticado!"
        emit(Authenticated());
      } else {
        // Si no hay token, le decimos a la vista: "Muestra la pantalla de Login"
        emit(Unauthenticated());
      }
    });

    // ------------------------------------------
    // MANEJADOR DEL EVENTO: LoginSubmitted
    // ------------------------------------------
    on<LoginSubmitted>((event, emit) async {
      // Pasito 1: Inmediatamente le avisamos a la vista que ponga un spinner de carga
      emit(AuthLoading());
      
      try {
        // Pasito 2: Mandamos los datos que venían en el evento hacia el repositorio
        await authRepository.login(event.username, event.password);
        
        // Pasito 3: Si el repositorio no falló, emitimos éxito
        emit(Authenticated());
      } catch (e) {
        // Pasito 4: Si el repositorio atrapó un error de red o credenciales, 
        // emitimos el fallo con el mensaje correspondiente para avisar al usuario.
        emit(AuthFailure(e.toString()));
      }
    });

    // ------------------------------------------
    // MANEJADOR DEL EVENTO: LogoutRequested
    // ------------------------------------------
    on<LogoutRequested>((event, emit) async {
      // Ponemos la app en estado de carga mientras borramos los datos locales
      emit(AuthLoading());
      
      // Borramos el JWT Token del FlutterSecureStorage a través del repositorio
      await authRepository.logout();
      
      // Le avisamos a la vista que regrese al flujo de desautenticado (pantalla de login)
      emit(Unauthenticated());
    });
  }
}