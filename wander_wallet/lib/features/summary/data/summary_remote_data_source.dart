import 'package:dio/dio.dart';
import 'package:wander_wallet/core/constants/api_constants.dart';

class SummaryRemoteDataSource {
  final Dio dio;

  SummaryRemoteDataSource(this.dio);

  Future<Response<dynamic>> getTotalSpending() async {
    final res = await dio.get(ApiConstants.getTotalSpending);

    return res;
  }

  Future<Response<dynamic>> getAvgSpendingPerTrip() async {
    final res = await dio.get(ApiConstants.getAvgSpendingPerTrip);

    return res;
  }

  Future<Response<dynamic>> getAvgSpendingPerDay() async {
    final res = await dio.get(ApiConstants.getAvgSpendingPerDay);

    return res;
  }

  Future<Response<dynamic>> getSpendingByCategory() async {
    final res = await dio.get(ApiConstants.getSpendingByCategory);

    return res;
  }

  Future<Response<dynamic>> getSpendingByMonth() async {
    final res = await dio.get(ApiConstants.getSpendingByMonth);

    return res;
  }

  Future<Response<dynamic>> getBudgetComparison() async {
    final res = await dio.get(ApiConstants.getBudgetComparison);

    return res;
  }

  Future<Response<dynamic>> getMostExpensiveTrip() async {
    final res = await dio.get(ApiConstants.getMostExpensiveTrip);

    return res;
  }

  Future<Response<dynamic>> getLeastExpensiveTrip() async {
    final res = await dio.get(ApiConstants.getLeastExpensiveTrip);

    return res;
  }
}