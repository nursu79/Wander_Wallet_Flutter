import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/constants/api_constants.dart';
import 'package:wander_wallet/features/auth/data/auth_remote_data_source.dart';

import 'auth_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late AuthRemoteDataSource authRemoteDataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    authRemoteDataSource = AuthRemoteDataSource(mockDio);
  });

  group('login', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.login),
      statusCode: 200,
      data: {'token': 'test_token'},
    );

    test('should make POST request to login endpoint with correct data', () async {
      // Arrange
      when(mockDio.post(
        ApiConstants.login,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await authRemoteDataSource.login(testEmail, testPassword);

      // Assert
      verify(mockDio.post(
        ApiConstants.login,
        data: {'email': testEmail, 'password': testPassword},
        options: anyNamed('options'),
      )).called(1);
    });

    test('should return response when request is successful', () async {
      // Arrange
      when(mockDio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      final result = await authRemoteDataSource.login(testEmail, testPassword);

      // Assert
      expect(result, testResponse);
    });

    test('should throw when Dio throws an exception', () async {
      // Arrange
      when(mockDio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.login),
      ));

      // Act & Assert
      expect(
        () => authRemoteDataSource.login(testEmail, testPassword),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('getProfile', () {
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.profile),
      statusCode: 200,
      data: {'id': '123', 'name': 'Test User'},
    );

    test('should make GET request to profile endpoint', () async {
      // Arrange
      when(mockDio.get(
        ApiConstants.profile,
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await authRemoteDataSource.getProfile();

      // Assert
      verify(mockDio.get(
        ApiConstants.profile,
        options: anyNamed('options'),
      )).called(1);
    });

    test('should return profile data when request is successful', () async {
      // Arrange
      when(mockDio.get(
        any,
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      final result = await authRemoteDataSource.getProfile();

      // Assert
      expect(result, testResponse);
    });

    test('should throw when Dio throws an exception', () async {
      // Arrange
      when(mockDio.get(
        any,
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.profile),
      ));

      // Act & Assert
      expect(
        () => authRemoteDataSource.getProfile(),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('register', () {
    const testUsername = 'testuser';
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    final testFile = File('test_path.jpg');
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.register),
      statusCode: 201,
      data: {'id': '123', 'username': testUsername},
    );

    test('should make POST request to register endpoint with form data', () async {
      // Arrange
      when(mockDio.post(
        ApiConstants.register,
        data: anyNamed('data'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await authRemoteDataSource.register(testUsername, testEmail, testPassword, null);

      // Assert
      verify(mockDio.post(
        ApiConstants.register,
        data: isA<FormData>(),
      )).called(1);
    });

    test('should not include avatar in form data when not provided', () async {
      // Arrange
      when(mockDio.post(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await authRemoteDataSource.register(testUsername, testEmail, testPassword, null);

      // Assert
      final captured = verify(mockDio.post(
        any,
        data: captureAnyNamed('data'),
      )).captured.first as FormData;

      expect(captured.fields.any((field) => field.key == 'avatar'), isFalse);
    });
  });

  group('promoteToAdmin', () {
    const testUserId = 'user123';
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: '${ApiConstants.admin}/promote'),
      statusCode: 200,
      data: {'message': 'User promoted to admin'},
    );

    test('should make POST request to promote endpoint with user ID', () async {
      // Arrange
      when(mockDio.post(
        '${ApiConstants.admin}/promote',
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await authRemoteDataSource.promoteToAdmin(testUserId);

      // Assert
      verify(mockDio.post(
        '${ApiConstants.admin}/promote',
        data: {'userId': testUserId},
        options: anyNamed('options'),
      )).called(1);
    });

    test('should return response when promotion is successful', () async {
      // Arrange
      when(mockDio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      final result = await authRemoteDataSource.promoteToAdmin(testUserId);

      // Assert
      expect(result, testResponse);
    });
  });
}