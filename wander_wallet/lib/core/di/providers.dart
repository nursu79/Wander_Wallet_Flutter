import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/constants.dart';
import 'package:wander_wallet/features/auth/data/auth_remote_data_source.dart';
import 'package:wander_wallet/features/auth/domain/auth_repository.dart';
import 'package:wander_wallet/features/auth/domain/auth_repository_impl.dart';
import '../local/token_storage.dart';
import '../network/token_interceptor.dart';

final tokenStorageProvider = Provider<TokenStorage>((_) => TokenStorage());

final tokenInterceptorProvider = Provider<TokenInterceptor>((ref) => TokenInterceptor(ref.read(tokenStorageProvider)));

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  final tokenInterceptor = ref.read(tokenInterceptorProvider);
  dio.interceptors.add(tokenInterceptor);

  return dio;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider), ref.read(tokenStorageProvider));
});

