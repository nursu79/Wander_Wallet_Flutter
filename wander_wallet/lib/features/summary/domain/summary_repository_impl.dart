import 'package:dio/dio.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/summary/data/summary_remote_data_source.dart';
import 'package:wander_wallet/features/summary/domain/summary_repository.dart';

class SummaryRepositoryImpl implements SummaryRepository {
  final SummaryRemoteDataSource remote;

  SummaryRepositoryImpl(this.remote);

  @override
  Future<Result<AllStats, MessageError>> getAllStats() async {
    try {
      final totalSpending = TotalSpending.fromJson((await remote.getTotalSpending()).data);
      final avgSpendingPerTrip = AvgSpending.fromJson((await remote.getAvgSpendingPerTrip()).data);
      final avgSpendingPerDay = AvgSpending.fromJson((await remote.getAvgSpendingPerDay()).data);
      final spendingByCategory = SpendingByCategory.fromJson((await remote.getSpendingByCategory()).data);
      final spendingByMonth = SpendingByMonth.fromJson((await remote.getSpendingByMonth()).data);
      final budgetComparisons = BudgetComparisons.fromJson((await remote.getBudgetComparison()).data);
      final mostExpensiveTrip = ConciseTripPayload.fromJson((await remote.getMostExpensiveTrip()).data);
      final leastExpensiveTrip = ConciseTripPayload.fromJson((await remote.getLeastExpensiveTrip()).data);

      final allStats = AllStats(
        totalSpending: totalSpending.totalSpending,
        totalBudget: totalSpending.totalBudget,
        avgSpendingPerTrip: avgSpendingPerTrip.avgSpending,
        avgSpendingPerDay: avgSpendingPerDay.avgSpending,
        spendingByCategory: spendingByCategory.categories,
        monthlySpending: spendingByMonth.expensesByMonth,
        budgetComparisons: budgetComparisons.budgetComparison,
        mostExpensiveTrip: mostExpensiveTrip,
        leastExpensiveTrip: leastExpensiveTrip
      );

      return Success(allStats);
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