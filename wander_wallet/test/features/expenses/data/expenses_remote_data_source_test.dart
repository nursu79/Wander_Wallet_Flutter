import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/constants/api_constants.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/expenses/data/expenses_remote_data_source.dart';

import 'expenses_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late ExpensesRemoteDataSource expensesRemoteDataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    expensesRemoteDataSource = ExpensesRemoteDataSource(mockDio);
  });

  group('createExpense', () {
    final testExpense = {
      'name': 'Taxi from the Hotel',
      'amount': 150,
      'category': 'TRANSPORTATION',
      'date': DateTime.now(),
      'tripId': 't1'
    };
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.login),
      statusCode: 200,
      data: { 'expense': testExpense },
    );

    test('should make POST request to /expenses endpoint with correct data', () async {
      // Arrange
      when(mockDio.post(
        ApiConstants.getTripExpensePath('t1'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await expensesRemoteDataSource.createExpense(testExpense['tripId'] as String, testExpense['name'] as String, testExpense['amount'] as num, Category.TRANSPORTATION, testExpense['date'] as DateTime, null);

      // Assert
      verify(mockDio.post(
        ApiConstants.getTripExpensePath('t1'),
        data: anyNamed('data')
      )).called(1);
    });

    test('should return response when request is successful', () async {
      // Arrange
      when(mockDio.post(
        ApiConstants.getTripExpensePath('t1'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      final result = await expensesRemoteDataSource.createExpense(testExpense['tripId'] as String, testExpense['name'] as String, testExpense['amount'] as num, Category.TRANSPORTATION, testExpense['date'] as DateTime, null);

      // Assert
      expect(result, testResponse);
    });

    test('should throw when Dio throws an exception', () async {
      // Arrange
      when(mockDio.post(
        ApiConstants.getTripExpensePath('t1'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.login),
      ));

      // Act & Assert
      expect(
        () => expensesRemoteDataSource.createExpense(testExpense['tripId'] as String, testExpense['name'] as String, testExpense['amount'] as num, Category.TRANSPORTATION, testExpense['date'] as DateTime, null),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('getExpense', () {
    final testExpense = {
      'name': 'Taxi from the Hotel',
      'amount': 150,
      'category': 'TRANSPORTATION',
      'date': DateTime.now(),
      'tripId': 't1'
    };
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.login),
      statusCode: 200,
      data: { 'expense': testExpense },
    );

    test('should make GET request to /expenses endpoint with correct data', () async {
      // Arrange
      when(mockDio.get(
        ApiConstants.getExpensePath('e1'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await expensesRemoteDataSource.getExpense('e1');

      // Assert
      verify(mockDio.get(
        ApiConstants.getExpensePath('e1'),
      )).called(1);
    });

    test('should return response when request is successful', () async {
      // Arrange
      when(mockDio.get(
        ApiConstants.getExpensePath('e1'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);
      // Act
      final result = await expensesRemoteDataSource.getExpense('e1');

      // Assert
      expect(result, testResponse);
    });

    test('should throw when Dio throws an exception', () async {
      // Arrange
      when(mockDio.get(
        ApiConstants.getExpensePath('e1'),
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.login),
      ));

      // Act & Assert
      expect(
        () => expensesRemoteDataSource.getExpense('e1'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('updateExpense', () {
    final testExpense = {
      'name': 'Taxi from the Hotel',
      'amount': 150,
      'category': 'TRANSPORTATION',
      'date': DateTime.now(),
      'tripId': 't1'
    };
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.login),
      statusCode: 200,
      data: { 'expense': testExpense },
    );

    test('should make PUT request to /expenses endpoint with correct data', () async {
      // Arrange
      when(mockDio.put(
        ApiConstants.getExpensePath('e1'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await expensesRemoteDataSource.updateExpense('e1', testExpense['name'] as String, testExpense['amount'] as num, Category.TRANSPORTATION, testExpense['date'] as DateTime, null);

      // Assert
      verify(mockDio.put(
        ApiConstants.getExpensePath('e1'),
        data: anyNamed('data')
      )).called(1);
    });

    test('should return response when request is successful', () async {
      // Arrange
      when(mockDio.put(
        ApiConstants.getExpensePath('e1'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      final result = await expensesRemoteDataSource.updateExpense('e1', testExpense['name'] as String, testExpense['amount'] as num, Category.TRANSPORTATION, testExpense['date'] as DateTime, null);

      // Assert
      expect(result, testResponse);
    });

    test('should throw when Dio throws an exception', () async {
      // Arrange
      when(mockDio.put(
        ApiConstants.getExpensePath('e1'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.login),
      ));

      // Act & Assert
      expect(
        () => expensesRemoteDataSource.updateExpense('e1', testExpense['name'] as String, testExpense['amount'] as num, Category.TRANSPORTATION, testExpense['date'] as DateTime, null),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('deleteExpense', () {
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.login),
      statusCode: 200,
      data: { 'message': 'Operation successful' },
    );

    test('should make DELETE request to /expenses endpoint with correct data', () async {
      // Arrange
      when(mockDio.delete(
        ApiConstants.getExpensePath('e1'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await expensesRemoteDataSource.deleteExpense('e1');

      // Assert
      verify(mockDio.delete(
        ApiConstants.getExpensePath('e1'),
      )).called(1);
    });

    test('should return response when request is successful', () async {
      // Arrange
      when(mockDio.delete(
        ApiConstants.getExpensePath('e1'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);
      // Act
      final result = await expensesRemoteDataSource.deleteExpense('e1');

      // Assert
      expect(result, testResponse);
    });

    test('should throw when Dio throws an exception', () async {
      // Arrange
      when(mockDio.delete(
        ApiConstants.getExpensePath('e1'),
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.login),
      ));

      // Act & Assert
      expect(
        () => expensesRemoteDataSource.deleteExpense('e1'),
        throwsA(isA<DioException>()),
      );
    });
  });
}