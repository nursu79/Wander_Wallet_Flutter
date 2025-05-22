import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/constants/constants.dart';
import 'package:wander_wallet/features/auth/data/auth_remote_data_source.dart';
import 'package:wander_wallet/features/auth/domain/auth_repository.dart';
import 'package:wander_wallet/features/auth/domain/auth_repository_impl.dart';
import '../storage/token_storage.dart';
import '../network/token_interceptor.dart';

final tokenStorageProvider = StateNotifierProvider<TokenStorage, String?>(
  (ref) => TokenStorage(),
);

final tokenInterceptorProvider = Provider<TokenInterceptor>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider.notifier);
  return TokenInterceptor(tokenStorage);
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    ),
  );
  final tokenInterceptor = ref.read(tokenInterceptorProvider);
  dio.interceptors.add(tokenInterceptor);
  return dio;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider.notifier);
  return AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider),
    tokenStorage,
  );
});
