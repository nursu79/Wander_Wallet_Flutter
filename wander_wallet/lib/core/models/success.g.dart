// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'role': instance.role,
  'avatarUrl': instance.avatarUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
  id: json['id'] as String,
  name: json['name'] as String,
  destination: json['destination'] as String,
  budget: json['budget'] as num,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  userId: json['userId'] as String,
  imgUrl: json['imgUrl'] as String?,
  expenses:
      (json['expenses'] as List<dynamic>?)
          ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'destination': instance.destination,
  'budget': instance.budget,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'userId': instance.userId,
  'imgUrl': instance.imgUrl,
  'expenses': instance.expenses,
};

ConciseTrip _$ConciseTripFromJson(Map<String, dynamic> json) => ConciseTrip(
  id: json['id'] as String,
  name: json['name'] as String,
  budget: json['budget'] as num,
);

Map<String, dynamic> _$ConciseTripToJson(ConciseTrip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'budget': instance.budget,
    };

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
  id: json['id'] as String,
  name: json['name'] as String,
  amount: json['amount'] as num,
  category: $enumDecode(_$CategoryEnumMap, json['category']),
  date: DateTime.parse(json['date'] as String),
  tripId: json['tripId'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'amount': instance.amount,
  'category': _$CategoryEnumMap[instance.category]!,
  'date': instance.date.toIso8601String(),
  'tripId': instance.tripId,
  'notes': instance.notes,
};

const _$CategoryEnumMap = {
  Category.FOOD: 'FOOD',
  Category.TRANSPORTATION: 'TRANSPORTATION',
  Category.ACCOMMODATION: 'ACCOMMODATION',
  Category.ENTERTAINMENT: 'ENTERTAINMENT',
  Category.SHOPPING: 'SHOPPING',
  Category.OTHER: 'OTHER',
};

TripNotification _$TripNotificationFromJson(Map<String, dynamic> json) =>
    TripNotification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      tripId: json['tripId'] as String,
      trip:
          json['trip'] == null
              ? null
              : Trip.fromJson(json['trip'] as Map<String, dynamic>),
      surplus: json['surplus'] as num,
    );

Map<String, dynamic> _$TripNotificationToJson(TripNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'tripId': instance.tripId,
      'trip': instance.trip,
      'surplus': instance.surplus,
    };

AmountMap _$AmountMapFromJson(Map<String, dynamic> json) =>
    AmountMap(amount: json['amount'] as num);

Map<String, dynamic> _$AmountMapToJson(AmountMap instance) => <String, dynamic>{
  'amount': instance.amount,
};

ExpenseByCategory _$ExpenseByCategoryFromJson(Map<String, dynamic> json) =>
    ExpenseByCategory(
      sum: AmountMap.fromJson(json['_sum'] as Map<String, dynamic>),
      category: $enumDecode(_$CategoryEnumMap, json['category']),
    );

Map<String, dynamic> _$ExpenseByCategoryToJson(ExpenseByCategory instance) =>
    <String, dynamic>{
      '_sum': instance.sum,
      'category': _$CategoryEnumMap[instance.category]!,
    };

CategorySpending _$CategorySpendingFromJson(Map<String, dynamic> json) =>
    CategorySpending(
      category: $enumDecode(_$CategoryEnumMap, json['category']),
      amount: json['amount'] as num,
    );

Map<String, dynamic> _$CategorySpendingToJson(CategorySpending instance) =>
    <String, dynamic>{
      'category': _$CategoryEnumMap[instance.category]!,
      'amount': instance.amount,
    };

TotalSpending _$TotalSpendingFromJson(Map<String, dynamic> json) =>
    TotalSpending(
      totalSpending: json['totalSpending'] as num,
      totalBudget: json['totalBudget'] as num,
    );

Map<String, dynamic> _$TotalSpendingToJson(TotalSpending instance) =>
    <String, dynamic>{
      'totalSpending': instance.totalSpending,
      'totalBudget': instance.totalBudget,
    };

AvgSpending _$AvgSpendingFromJson(Map<String, dynamic> json) =>
    AvgSpending(avgSpending: json['avgSpending'] as num);

Map<String, dynamic> _$AvgSpendingToJson(AvgSpending instance) =>
    <String, dynamic>{'avgSpending': instance.avgSpending};

SpendingByCategory _$SpendingByCategoryFromJson(Map<String, dynamic> json) =>
    SpendingByCategory(
      categories:
          (json['categories'] as List<dynamic>)
              .map((e) => CategorySpending.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SpendingByCategoryToJson(SpendingByCategory instance) =>
    <String, dynamic>{'categories': instance.categories};

SpendingByMonth _$SpendingByMonthFromJson(Map<String, dynamic> json) =>
    SpendingByMonth(
      expensesByMonth:
          (json['expensesByMonth'] as List<dynamic>)
              .map((e) => Map<String, num>.from(e as Map))
              .toList(),
    );

Map<String, dynamic> _$SpendingByMonthToJson(SpendingByMonth instance) =>
    <String, dynamic>{'expensesByMonth': instance.expensesByMonth};

BudgetComparison _$BudgetComparisonFromJson(Map<String, dynamic> json) =>
    BudgetComparison(
      tripId: json['tripId'] as String,
      name: json['name'] as String,
      budget: json['budget'] as num,
      expenditure: json['expenditure'] as num,
    );

Map<String, dynamic> _$BudgetComparisonToJson(BudgetComparison instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'name': instance.name,
      'budget': instance.budget,
      'expenditure': instance.expenditure,
    };

BudgetComparisons _$BudgetComparisonsFromJson(Map<String, dynamic> json) =>
    BudgetComparisons(
      budgetComparison:
          (json['budgetComparison'] as List<dynamic>)
              .map((e) => BudgetComparison.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$BudgetComparisonsToJson(BudgetComparisons instance) =>
    <String, dynamic>{'budgetComparison': instance.budgetComparison};
