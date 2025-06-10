import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/storage/token_storage.dart';
import 'package:wander_wallet/features/auth/data/auth_remote_data_source.dart';
import 'package:wander_wallet/features/auth/domain/auth_repository_impl.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, TokenStorage])
void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockTokenStorage mockTokenStorage;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testUsername = 'testuser';
  const testUserId = 'user123';
  final testFile = File('test_path.jpg');

  final testLoginPayload = LoginPayload(
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
  );
  final testUser = User(id: 'user123', username: 'testuser', email: 'test@example.com', role: 'USER', createdAt: DateTime.now(), updatedAt: DateTime.now());
  final testUserPayload = UserPayload(user: testUser);

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockTokenStorage = MockTokenStorage();
    authRepository = AuthRepositoryImpl(mockRemoteDataSource, mockTokenStorage);
  });

  group('login', () {
    test('should return Success with LoginPayload when login is successful', () async {
      // Arrange
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testLoginPayload.toJson(),
      );
      when(mockRemoteDataSource.login(any, any)).thenAnswer((_) async => testResponse);
      when(mockTokenStorage.saveToken(any)).thenAnswer((_) async => null);
      when(mockTokenStorage.saveRefreshToken(any)).thenAnswer((_) async => null);

      // Act
      final result = await authRepository.login(testEmail, testPassword);

      // Assert
      expect(result, isA<Success<LoginPayload, UserError>>());

      final data = (result as Success).data as LoginPayload;
      expect(data.accessToken, testLoginPayload.accessToken);
      expect(data.user?.id, testLoginPayload.user?.id);
      verify(mockTokenStorage.saveToken(testLoginPayload.accessToken)).called(1);
      verify(mockTokenStorage.saveRefreshToken(testLoginPayload.refreshToken)).called(1);
    });

    test('should return Error with UserError when server returns error message', () async {
      // Arrange
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 401,
        data: {'message': 'Invalid credentials'},
      );
      when(mockRemoteDataSource.login(any, any)).thenAnswer((_) async => testResponse);

      // Act
      final result = await authRepository.login(testEmail, testPassword);

      // Assert
      expect(result, isA<Error<LoginPayload, UserError>>());
      expect((result as Error).error.message, 'Invalid credentials');
      verifyNever(mockTokenStorage.saveToken(any));
      verifyNever(mockTokenStorage.saveRefreshToken(any));
    });

    test('should return Error with UserError when DioException occurs with response', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Account locked'},
          statusCode: 401
        ),
      );
      when(mockRemoteDataSource.login(any, any)).thenThrow(dioError);

      // Act
      final result = await authRepository.login(testEmail, testPassword);

      // Assert
      expect(result, isA<Error<LoginPayload, UserError>>());
      expect((result as Error).error.message, 'Account locked');
    });

    test('should return Error with UserError when DioException occurs without response', () async {
      // Arrange
      final dioError = DioException(requestOptions: RequestOptions(path: ''));
      when(mockRemoteDataSource.login(any, any)).thenThrow(dioError);

      // Act
      final result = await authRepository.login(testEmail, testPassword);

      // Assert
      expect(result, isA<Error<LoginPayload, UserError>>());
      expect(
        (result as Error).error.message,
        'Please check your internet connection and/or api address',
      );
    });

    test('should return Error with UserError when unexpected exception occurs', () async {
      // Arrange
      when(mockRemoteDataSource.login(any, any)).thenThrow(Exception('Unexpected'));

      // Act
      final result = await authRepository.login(testEmail, testPassword);

      // Assert
      expect(result, isA<Error<LoginPayload, UserError>>());
      expect((result as Error).error.message, 'An unexpected error occurred');
    });
  });

  group('getProfile', () {
    test('should return Success with UserPayload when request is successful', () async {
      // Arrange
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testUserPayload.toJson(),
      );
      when(mockRemoteDataSource.getProfile()).thenAnswer((_) async => testResponse);

      // Act
      final result = await authRepository.getProfile();

      // Assert
      expect(result, isA<Success<UserPayload, MessageError>>());
      expect(((result as Success).data as UserPayload).user.id, testUserPayload.user.id);
    });

    test('should return Error with MessageError when server returns error', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Account locked'},
          statusCode: 401
        ),
      );
      when(mockRemoteDataSource.getProfile()).thenThrow(dioError);

      // Act
      final result = await authRepository.getProfile();

      // Assert
      expect(result, isA<Error<UserPayload, MessageError>>());
      expect((result as Error).error.message, 'Account locked');
    });

    test('should return Error with loggedOut=true when unauthorized', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
          data: {'message': 'Unauthorized'},
        ),
      );
      when(mockRemoteDataSource.getProfile()).thenThrow(dioError);

      // Act
      final result = await authRepository.getProfile();

      // Assert
      expect(result, isA<Error<UserPayload, MessageError>>());
      expect((result as Error).loggedOut, isTrue);
    });
  });

  group('register', () {
    test('should return Success with LoginPayload when registration is successful', () async {
      // Arrange
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testLoginPayload.toJson(),
      );
      when(mockRemoteDataSource.register(any, any, any, any)).thenAnswer((_) async => testResponse);

      // Act
      final result = await authRepository.register(testUsername, testEmail, testPassword, testFile);

      // Assert
      expect(result, isA<Success<LoginPayload, UserError>>());
      expect(((result as Success).data as LoginPayload).accessToken, testLoginPayload.accessToken);
    });

    test('should return Error for duplicate email', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {'message': 'This email is already registered'},
        ),
      );
      when(mockRemoteDataSource.register(any, any, any, any)).thenThrow(dioError);

      // Act
      final result = await authRepository.register(testUsername, testEmail, testPassword, testFile);

      // Assert
      expect(result, isA<Error<LoginPayload, UserError>>());
      expect((result as Error).error.message, 'This email is already registered');
    });

    test('should handle DioException with duplicate email in response', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          data: {'email': 'User already exists'},
        ),
      );
      when(mockRemoteDataSource.register(any, any, any, any)).thenThrow(dioError);

      // Act
      final result = await authRepository.register(testUsername, testEmail, testPassword, testFile);

      // Assert
      expect(result, isA<Error<LoginPayload, UserError>>());
      expect((result as Error).error.message, 'This email is already registered');
    });
  });

  group('promoteToAdmin', () {
    test('should return Success with UserPayload when promotion is successful', () async {
      // Arrange
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testUserPayload.toJson(),
      );
      when(mockRemoteDataSource.promoteToAdmin(any)).thenAnswer((_) async => testResponse);

      // Act
      final result = await authRepository.promoteToAdmin(testUserId);

      // Assert
      expect(result, isA<Success<UserPayload, UserError>>());
      expect(((result as Success).data as UserPayload).user.id, testUserPayload.user.id);
    });

    test('should return Error with UserError when promotion fails', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Promotion failed'},
        ),
      );
      when(mockRemoteDataSource.promoteToAdmin(any)).thenThrow(dioError);

      // Act
      final result = await authRepository.promoteToAdmin(testUserId);

      // Assert
      expect(result, isA<Error<UserPayload, UserError>>());
      expect((result as Error).error.message, 'Promotion failed');
    });
  });
}