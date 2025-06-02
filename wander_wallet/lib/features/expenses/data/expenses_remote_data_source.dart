import 'package:dio/dio.dart';
import 'package:wander_wallet/core/constants/api_constants.dart';
import 'package:wander_wallet/core/models/success.dart';

class ExpensesRemoteDataSource {
  final Dio dio;

  ExpensesRemoteDataSource(this.dio);

  Future<Response<dynamic>> createExpense(
    String tripId,
    String name,
    num amount,
    Category category,
    DateTime date,
    String? notes
  ) async {
    final res = await dio.post(
      ApiConstants.getTripExpensePath(tripId),
      data: {
        'name': name,
        'amount': amount,
        'category': category.name,
        'date': date.toIso8601String()
      }
    );

    return res;
  }

  Future<Response<dynamic>> getExpense(
    String id
  ) async {
    final res = await dio.get(
      ApiConstants.getExpensePath(id)
    );

    return res;
  }

}