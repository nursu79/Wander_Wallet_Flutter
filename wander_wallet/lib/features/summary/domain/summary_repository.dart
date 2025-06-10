import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/models/error.dart';

abstract class SummaryRepository {
  // Future<Result<TotalSpending, MessageError>> getTotalSpending();
  // Future<Result<AvgSpending, MessageError>> getAvgSpendingPerTrip();
  // Future<Result<AvgSpending, MessageError>> getAvgSpendingPerDay();
  // Future<Result<SpendingByCategory, MessageError>> getSpendingByCategory();
  // Future<Result<SpendingByMonth, MessageError>> getSpendingByMonth();
  // Future<Result<BudgetComparisons, MessageError>> getBudgetComparison();
  // Future<Result<TripPayload, MessageError>> getMostExpensiveTrip();
  // Future<Result<TripPayload, MessageError>> getLeastExpensiveTrip();
  Future<Result<AllStats, MessageError>> getAllStats();
}
