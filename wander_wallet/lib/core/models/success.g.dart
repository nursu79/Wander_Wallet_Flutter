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

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
  id: json['id'] as String,
  userId: json['userId'] as String,
  tripId: json['tripId'] as String,
  trip:
      json['trip'] == null
          ? null
          : Trip.fromJson(json['trip'] as Map<String, dynamic>),
  surplus: json['surplus'] as num,
);

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
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
