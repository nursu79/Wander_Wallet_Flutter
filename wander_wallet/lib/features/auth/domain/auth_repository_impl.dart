import 'package:dio/dio.dart';
import 'package:wander_wallet/features/auth/data/models.dart';

import 'auth_repository.dart';
import '../data/auth_remote_data_source.dart';
import '../../../core/storage/token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorage storage;

  AuthRepositoryImpl(this.remote, this.storage);

  @override
  Future<Result<TokenPayload, UserError>> login(
    String email,
    String password,
  ) async {
    try {
      print('AuthRepositoryImpl: Attempting login...');
      final res = await remote.login(email, password);
      print('AuthRepositoryImpl: Login response received: ${res.data}');

      if (res.data is! Map<String, dynamic>) {
        print('AuthRepositoryImpl: Invalid response format: ${res.data}');
        return Error(error: UserError(message: 'Invalid server response'));
      }

      final tokenPayload = TokenPayload.fromJson(res.data);
      print(
        'AuthRepositoryImpl: Token payload parsed: accessToken=${tokenPayload.accessToken}, refreshToken=${tokenPayload.refreshToken}',
      );

      await storage.saveToken(tokenPayload.accessToken);
      print('AuthRepositoryImpl: Tokens saved to storage');

      return Success(tokenPayload);
    } on DioException catch (e) {
      print('AuthRepositoryImpl: DioException during login: ${e.message}');
      if (e.response != null) {
        print('AuthRepositoryImpl: Error response: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          final userError = UserError.fromJson(e.response?.data);
          return Error(error: userError);
        } else {
          return Error(
            error: UserError(
              message: 'Server error: ${e.response?.statusCode}',
            ),
          );
        }
      } else {
        final userError = UserError(
          message: 'Please check your internet connection and/or api address',
        );
        return Error(error: userError);
      }
    } on Exception catch (e) {
      print('AuthRepositoryImpl: Unexpected error during login: $e');
      final userError = UserError(message: 'An unexpected error occurred');
      return Error(error: userError);
    }
  }

  @override
  Future<Result<UserPayload, MessageError>> getProfile() async {
    try {
      print('AuthRepositoryImpl: Attempting to get profile...');
      final res = await remote.getProfile();
      print('AuthRepositoryImpl: Profile response received: ${res.data}');

      if (res.data is! Map<String, dynamic>) {
        print('AuthRepositoryImpl: Invalid response format: ${res.data}');
        return Error(error: MessageError(message: 'Invalid server response'));
      }

      final userPayload = UserPayload.fromJson(res.data);
      print('AuthRepositoryImpl: Profile parsed successfully');
      return Success(userPayload);
    } on DioException catch (e) {
      print('AuthRepositoryImpl: DioException during getProfile: ${e.message}');
      if (e.response != null) {
        print('AuthRepositoryImpl: Error response: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          final messageError = MessageError.fromJson(e.response?.data);
          return Error(error: messageError, loggedOut: true);
        } else {
          return Error(
            error: MessageError(
              message: 'Server error: ${e.response?.statusCode}',
            ),
          );
        }
      } else {
        final messageError = MessageError(
          message: 'Please check your internet connection and/or api address',
        );
        return Error(error: messageError);
      }
    } on Exception catch (e) {
      print('AuthRepositoryImpl: Unexpected error during getProfile: $e');
      final messageError = MessageError(
        message: 'An unexpected error occurred',
      );
      return Error(error: messageError);
    }
  }

  @override
  Future<Result<TokenPayload, UserError>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      print('AuthRepositoryImpl: Attempting registration...');
      final res = await remote.register(username, email, password);
      print('AuthRepositoryImpl: Register response received: ${res.data}');

      if (res.data is! Map<String, dynamic>) {
        print('AuthRepositoryImpl: Invalid response format: ${res.data}');
        return Error(error: UserError(message: 'Invalid server response'));
      }

      final tokenPayload = TokenPayload.fromJson(res.data);
      print(
        'AuthRepositoryImpl: Token payload parsed: accessToken=${tokenPayload.accessToken}, refreshToken=${tokenPayload.refreshToken}',
      );

      await storage.saveToken(tokenPayload.accessToken);
      print('AuthRepositoryImpl: Tokens saved to storage');

      return Success(tokenPayload);
    } on DioException catch (e) {
      print('AuthRepositoryImpl: DioException during register: ${e.message}');
      if (e.response != null) {
        print('AuthRepositoryImpl: Error response: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          final responseData = e.response?.data as Map<String, dynamic>;
          // Attempt to parse as UserError
          final userError = UserError.fromJson(responseData);

          // Check for specific duplicate email indicators from backend
          if (userError.email != null &&
              userError.email!.contains('already exists')) {
            // Example check based on email field
            return Error(
              error: UserError(message: 'This email already exists.'),
            );
          } else if (userError.message != null) {
            // Use generic message if available
            return Error(error: userError);
          } else {
            // Fallback for other map structures
            return Error(error: UserError(message: 'Registration failed.'));
          }
        } else {
          return Error(
            error: UserError(
              message: 'Server error: ${e.response?.statusCode}',
            ),
          );
        }
      } else {
        final userError = UserError(
          message: 'Please check your internet connection and/or api address',
        );
        return Error(error: userError);
      }
    } on Exception catch (e) {
      print('AuthRepositoryImpl: Unexpected error during register: $e');
      final userError = UserError(message: 'An unexpected error occurred');
      return Error(error: userError);
    }
  }
}
