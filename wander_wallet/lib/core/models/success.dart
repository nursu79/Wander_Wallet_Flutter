import 'package:json_annotation/json_annotation.dart';
import 'package:wander_wallet/core/models/payload.dart';

part 'success.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String email;
  final String role;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Trip {
  final String id;
  final String name;
  final String destination;
  final num budget;
  final DateTime startDate;
  final DateTime endDate;
  final String userId;
  final String? imgUrl;
  final List<Expense>? expenses;

  Trip({
    required this.id,
    required this.name,
    required this.destination,
    required this.budget,
    required this.startDate,
    required this.endDate,
    required this.userId,
    this.imgUrl,
    this.expenses,
  });
  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  Map<String, dynamic> toJson() => _$TripToJson(this);
}

@JsonSerializable()
class ConciseTrip {
  final String id;
  final String name;
  final num budget;

  ConciseTrip({
    required this.id,
    required this.name,
    required this.budget
  });

  factory ConciseTrip.fromJson(Map<String, dynamic> json) => _$ConciseTripFromJson(json);
  Map<String, dynamic> toJson() => _$ConciseTripToJson(this);
}

@JsonSerializable()
class Expense {
  final String id;
  final String name;
  final num amount;
  final Category category;
  final DateTime date;
  final String tripId;
  final String? notes;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    required this.tripId,
    this.notes
  });

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}

enum Category {
  FOOD,
  TRANSPORTATION,
  ACCOMMODATION,
  ENTERTAINMENT,
  SHOPPING,
  OTHER
}

@JsonSerializable()
class TripNotification {
  final String id;
  final String userId;
  final String tripId;
  final Trip? trip;
  final num surplus;

  TripNotification({
    required this.id,
    required this.userId,
    required this.tripId,
    this.trip,
    required this.surplus,
  });
  factory TripNotification.fromJson(Map<String, dynamic> json) => _$TripNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$TripNotificationToJson(this);
}

@JsonSerializable()
class AmountMap {
  final num amount;

  AmountMap({ required this.amount });
  factory AmountMap.fromJson(Map<String, dynamic> json) => _$AmountMapFromJson(json);
  Map<String, dynamic> toJson() => _$AmountMapToJson(this);
}

@JsonSerializable()
class ExpenseByCategory {
  @JsonKey(name: '_sum')
  final AmountMap sum;
  final Category category;

  ExpenseByCategory({ required this.sum, required this.category });
  factory ExpenseByCategory.fromJson(Map<String, dynamic> json) => _$ExpenseByCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseByCategoryToJson(this);
}

@JsonSerializable()
class CategorySpending {
  final Category category;
  final num amount;

  CategorySpending({ required this.category, required this.amount });

  factory CategorySpending.fromJson(Map<String, dynamic> json) => _$CategorySpendingFromJson(json);
  Map<String, dynamic> toJson() => _$CategorySpendingToJson(this);
}

@JsonSerializable()
class TotalSpending {
  final num totalSpending;
  final num totalBudget;

  TotalSpending({ required this.totalSpending, required this.totalBudget });

  factory TotalSpending.fromJson(Map<String, dynamic> json) => _$TotalSpendingFromJson(json);
  Map<String, dynamic> toJson() => _$TotalSpendingToJson(this);
}

@JsonSerializable()
class AvgSpending {
  final num avgSpending;

  AvgSpending({ required this.avgSpending});

  factory AvgSpending.fromJson(Map<String, dynamic> json) => _$AvgSpendingFromJson(json);
  Map<String, dynamic> toJson() => _$AvgSpendingToJson(this);
}

@JsonSerializable()
class SpendingByCategory {
  final List<CategorySpending> categories;

  SpendingByCategory({ required this.categories });

  factory SpendingByCategory.fromJson(Map<String, dynamic> json) => _$SpendingByCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$SpendingByCategoryToJson(this);
}

@JsonSerializable()
class SpendingByMonth {
  final List<Map<String, num>> expensesByMonth;

  SpendingByMonth({ required this.expensesByMonth});

  factory SpendingByMonth.fromJson(Map<String, dynamic> json) => _$SpendingByMonthFromJson(json);
  Map<String, dynamic> toJson() => _$SpendingByMonthToJson(this);
}

@JsonSerializable()
class BudgetComparison {
  final String tripId;
  final String name;
  final num budget;
  final num expenditure;

  BudgetComparison({ required this.tripId, required this.name, required this.budget, required this.expenditure });

  factory BudgetComparison.fromJson(Map<String, dynamic> json) => _$BudgetComparisonFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetComparisonToJson(this);
}

@JsonSerializable()
class BudgetComparisons {
  final List<BudgetComparison> budgetComparison;

  BudgetComparisons({ required this.budgetComparison });

  factory BudgetComparisons.fromJson(Map<String, dynamic> json) => _$BudgetComparisonsFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetComparisonsToJson(this);
}

class AllStats {
  final num totalSpending;
  final num totalBudget;
  final num avgSpendingPerTrip;
  final num avgSpendingPerDay;
  final List<CategorySpending> spendingByCategory;
  final List<Map<String, num>> monthlySpending;
  final List<BudgetComparison> budgetComparisons;
  final ConciseTripPayload mostExpensiveTrip;
  final ConciseTripPayload leastExpensiveTrip;

  AllStats({
    required this.totalSpending,
    required this.totalBudget,
    required this.avgSpendingPerTrip,
    required this.avgSpendingPerDay,
    required this.spendingByCategory,
    required this.monthlySpending,
    required this.budgetComparisons,
    required this.mostExpensiveTrip,
    required this.leastExpensiveTrip
  });
}
