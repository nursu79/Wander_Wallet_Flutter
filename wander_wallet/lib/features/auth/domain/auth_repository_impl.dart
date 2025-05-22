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

      // Check if the response contains an error message
      if (res.data['message'] != null) {
        return Error(error: UserError(message: res.data['message']));
      }

      final tokenPayload = TokenPayload.fromJson(res.data);
      print(
        'AuthRepositoryImpl: Token payload parsed: accessToken=${tokenPayload.accessToken}, refreshToken=${tokenPayload.refreshToken}',
      );

      // Save both tokens
      await storage.saveToken(tokenPayload.accessToken);
      await storage.saveRefreshToken(tokenPayload.refreshToken);
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
          return Error(error: UserError(message: 'Invalid email or password'));
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

      // Check for duplicate email error first
      if (res.data['email'] == 'User already exists') {
        return Error(
          error: UserError(message: 'This email is already registered'),
        );
      }

      // Check for other error messages
      if (res.data['message'] != null) {
        return Error(error: UserError(message: res.data['message']));
      }

      final tokenPayload = TokenPayload.fromJson(res.data);
      print(
        'AuthRepositoryImpl: Token payload parsed: accessToken=${tokenPayload.accessToken}, refreshToken=${tokenPayload.refreshToken}',
      );

      // Don't save token on registration - user should explicitly log in
      print(
        'AuthRepositoryImpl: Registration successful, redirecting to login',
      );

      return Success(tokenPayload);
    } on DioException catch (e) {
      print('AuthRepositoryImpl: DioException during register: ${e.message}');
      if (e.response != null) {
        print('AuthRepositoryImpl: Error response: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          final responseData = e.response?.data as Map<String, dynamic>;

          // Check for duplicate email error
          if (responseData['email'] == 'User already exists') {
            return Error(
              error: UserError(message: 'This email is already registered'),
            );
          }

          final userError = UserError.fromJson(responseData);
          return Error(error: userError);
        } else {
          return Error(
            error: UserError(message: 'Registration failed. Please try again.'),
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

  @override
  Future<Result<UserPayload, UserError>> promoteToAdmin(String userId) async {
    try {
      print(
        'AuthRepositoryImpl: Attempting to promote user $userId to admin...',
      );
      final res = await remote.promoteToAdmin(userId);
      print('AuthRepositoryImpl: Promote response received: ${res.data}');

      if (res.data is! Map<String, dynamic>) {
        print('AuthRepositoryImpl: Invalid response format: ${res.data}');
        return Error(error: UserError(message: 'Invalid server response'));
      }

      final userPayload = UserPayload.fromJson(res.data);
      print('AuthRepositoryImpl: User promoted successfully');
      return Success(userPayload);
    } on DioException catch (e) {
      print('AuthRepositoryImpl: DioException during promote: ${e.message}');
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
      print('AuthRepositoryImpl: Unexpected error during promote: $e');
      final userError = UserError(message: 'An unexpected error occurred');
      return Error(error: userError);
    }
  }
}
