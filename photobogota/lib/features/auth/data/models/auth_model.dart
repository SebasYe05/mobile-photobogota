import '../../domain/entities/auth_entity.dart';

class AuthModel {
  final String token;
  final String username;

  const AuthModel({required this.token, required this.username});

  // JSON que llega del servidor → AuthModel
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'] as String,
      username: json['username'] as String,
    );
  }

  // AuthModel → AuthEntity (lo que usa el BLoC)
  AuthEntity toEntity() {
    return AuthEntity(token: token, username: username);
  }
}
