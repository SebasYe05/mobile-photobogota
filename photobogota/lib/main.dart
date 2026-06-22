import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';
import 'core/network/dio_client.dart';          // ← nuevo import
import 'features/auth/data/auth_remote_data_source.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/controllers/auth_bloc.dart';
import 'features/auth/presentation/screens/auth_wrapper.dart';

void main() {
  runApp(const PhotoBogotaApp());
}

class PhotoBogotaApp extends StatelessWidget {
  const PhotoBogotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        authRepository: AuthRepositoryImpl(
          remoteDataSource: AuthRemoteDataSource(createDioClient()), 
        ),
      )..add(AuthCheckRequested()), // Chequea token guardado al arrancar
      child: MaterialApp(
        title: 'Photo Bogotá',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}