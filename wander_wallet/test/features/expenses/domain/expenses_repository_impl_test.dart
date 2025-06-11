import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/expenses/data/expenses_remote_data_source.dart';
import 'package:wander_wallet/features/expenses/domain/expenses_repository_impl.dart';

import 'expenses_repository_impl_test.mocks.dart';

@GenerateMocks([ExpensesRemoteDataSource])
void main() {
  late ExpensesRepositoryImpl expensesRepository;
  late MockExpensesRemoteDataSource mockRemoteDataSource;

  final testExpense = Expense(
    id: 'e1',
    tripId: 't1',
    name: 'Taxi to the hotel',
    amount: 120,
    category: Category.TRANSPORTATION,
    date: DateTime.now(),
  );

  final testExpensePayload = ExpensePayload(expense: testExpense);
  final testMessagePayload = MessagePayload(message: 'Operation successful');
  final testExpenseError = ExpenseError(
    name: 'An invalid name'
  );
  final testMessageError = MessageError(message: 'Operation failed');

  setUp(() {
    mockRemoteDataSource = MockExpensesRemoteDataSource();
    expensesRepository = ExpensesRepositoryImpl(mockRemoteDataSource);
  });

  group('createExpense', () {
    test('should return Success with ExpensePayload when creation is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testExpensePayload.toJson()
      );

      when(mockRemoteDataSource.createExpense(any, any, any, any, any, any)).thenAnswer((_) async => testResponse);

      final result = await expensesRepository.createExpense(testExpense.tripId, testExpense.name, testExpense.amount, testExpense.category, testExpense.date, null);

      expect(result, isA<Success<ExpensePayload, ExpenseError>>());
      expect((result as Success<ExpensePayload, ExpenseError>).data.expense.id, testExpense.id);
    });

    test('should return Error with ExpenseError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testExpenseError.toJson()
        )
      );

      when(mockRemoteDataSource.createExpense(any, any, any, any, any, any)).thenThrow(dioError);

      final result = await expensesRepository.createExpense(testExpense.tripId, testExpense.name, testExpense.amount, testExpense.category, testExpense.date, null);

      expect(result, isA<Error<ExpensePayload, ExpenseError>>());
      expect((result as Error).error.name, 'An invalid name');
    });
  });

  group('getExpense', () {
    test('should return Success with ExpensePayload when read/get is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testExpensePayload.toJson()
      );

      when(mockRemoteDataSource.getExpense(any)).thenAnswer((_) async => testResponse);

      final result = await expensesRepository.getExpense('e1');

      expect(result, isA<Success<ExpensePayload, MessageError>>());
      expect((result as Success<ExpensePayload, MessageError>).data.expense.name, 'Taxi to the hotel');
    });

    test('should return Error with MessageError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testMessageError.toJson()
        )
      );

      when(mockRemoteDataSource.getExpense(any)).thenThrow(dioError);

      final result = await expensesRepository.getExpense('e1');

      expect(result, isA<Error<ExpensePayload, MessageError>>());
      expect((result as Error).error.message, 'Operation failed');
    });
  });

  group('updateExpense', () {
    test('should return Success with ExpensePayload when updation is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testExpensePayload.toJson()
      );

      when(mockRemoteDataSource.updateExpense(any, any, any, any, any, any)).thenAnswer((_) async => testResponse);

      final result = await expensesRepository.updateExpense(testExpense.tripId, testExpense.name, testExpense.amount, testExpense.category, testExpense.date, null);

      expect(result, isA<Success<ExpensePayload, ExpenseError>>());
      expect((result as Success<ExpensePayload, ExpenseError>).data.expense.id, testExpense.id);
    });

    test('should return Error with ExpenseError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testExpenseError.toJson()
        )
      );

      when(mockRemoteDataSource.updateExpense(any, any, any, any, any, any)).thenThrow(dioError);

      final result = await expensesRepository.updateExpense(testExpense.tripId, testExpense.name, testExpense.amount, testExpense.category, testExpense.date, null);

      expect(result, isA<Error<ExpensePayload, ExpenseError>>());
      expect((result as Error).error.name, 'An invalid name');
    });
  });

  group('deleteExpense', () {
    test('should return Success with MessagePayload when read/get is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testMessagePayload.toJson()
      );

      when(mockRemoteDataSource.deleteExpense(any)).thenAnswer((_) async => testResponse);

      final result = await expensesRepository.deleteExpense('e1');

      expect(result, isA<Success<MessagePayload, MessageError>>());
      expect((result as Success<MessagePayload, MessageError>).data.message, 'Operation successful');
    });

    test('should return Error with MessageError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testMessageError.toJson()
        )
      );

      when(mockRemoteDataSource.deleteExpense(any)).thenThrow(dioError);

      final result = await expensesRepository.deleteExpense('e1');

      expect(result, isA<Error<MessagePayload, MessageError>>());
      expect((result as Error).error.message, 'Operation failed');
    });
  });
}