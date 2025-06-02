import 'package:dio/dio.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/expenses/data/expenses_remote_data_source.dart';
import 'package:wander_wallet/features/expenses/domain/expenses_repository.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesRemoteDataSource remote;

  ExpensesRepositoryImpl(this.remote);

  @override
  Future<Result<ExpensePayload, ExpenseError>> createExpense(String tripId, String name, num amount, Category category, DateTime date, String? notes) async {
    try {
      final res = await remote.createExpense(tripId, name, amount, category, date, notes);
      final expensePayload = ExpensePayload.fromJson(res.data);
      return Success(expensePayload);
    } on DioException catch (e) {
      if (e.response != null) {
        final expenseError = ExpenseError.fromJson(e.response?.data);
        return Error(error: expenseError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: ExpenseError(message: 'Please check your internet connection and/or api address'),
          loggedOut: false,
        );
      }
    } on Exception {
      final expenseError = ExpenseError(message: 'An unexpected error occurred');
      return Error(error: expenseError);
    }
  }
  
  @override
  Future<Result<MessagePayload, MessageError>> deleteExpense(String id) async {
    try {
      final res = await remote.deleteExpense(id);
      final messagePayload = MessagePayload.fromJson(res.data);
      return Success(messagePayload);
    } on DioException catch (e) {
       if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: MessageError(message: 'Please check your internet connection and/or api address'),
          loggedOut: false,
        );
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }

  @override
  Future<Result<ExpensePayload, MessageError>> getExpense(String id) async {
    try {
      final res = await remote.getExpense(id);
      final expensePayload = ExpensePayload.fromJson(res.data);
      return Success(expensePayload);
    } on DioException catch (e) {
      if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: MessageError(message: 'Please check your internet connection and/or api address'),
          loggedOut: false,
        );
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }

}