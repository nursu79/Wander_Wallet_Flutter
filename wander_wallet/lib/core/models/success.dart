import 'package:json_annotation/json_annotation.dart';

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
class Notification {
  final String id;
  final String userId;
  final String tripId;
  final Trip? trip;
  final num surplus;

  Notification({
    required this.id,
    required this.userId,
    required this.tripId,
    this.trip,
    required this.surplus,
  });
  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
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
