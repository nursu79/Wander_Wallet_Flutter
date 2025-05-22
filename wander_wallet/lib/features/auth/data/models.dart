import 'dart:ffi';

sealed class Result<SuccessType, ErrorType> {
  Result();
}

class Success<SuccessType, ErrorType> extends Result<SuccessType, ErrorType> {
  final SuccessType data;

  Success(this.data);
}

class Error<SuccessType, ErrorType> extends Result<SuccessType, ErrorType> {
  final ErrorType error;
  final bool loggedOut;

  Error({required this.error, this.loggedOut = false});
}

class UserError {
  final String? username;
  final String? email;
  final String? password;
  final String? message;

  UserError({this.username, this.email, this.password, this.message});

  factory UserError.fromJson(Map<String, dynamic> json) => UserError(
    username: json['username'],
    email: json['email'],
    password: json['password'],
    message: json['message'],
  );
}

class MessageError {
  final String message;

  MessageError({required this.message});

  factory MessageError.fromJson(Map<String, dynamic> json) =>
      MessageError(message: json['message']);
}

class TokenPayload {
  final String accessToken;
  final String refreshToken;
  final String? role;
  final User? user;

  TokenPayload({
    required this.accessToken,
    required this.refreshToken,
    this.role,
    this.user,
  });

  factory TokenPayload.fromJson(Map<String, dynamic> json) => TokenPayload(
    accessToken: json['accessToken'] ?? '',
    refreshToken: json['refreshToken'] ?? '',
    role: json['role'],
    user: json['user'] != null ? User.fromJson(json['user']) : null,
  );
}

class Notification {
  final String id;
  final String userId;
  final User? user;
  final String tripId;
  final Trip? trip;
  final Float surplus;

  Notification({
    required this.id,
    required this.userId,
    required this.tripId,
    this.user,
    this.trip,
    required this.surplus,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json['id'],
    userId: json['userId'],
    tripId: json['tripId'],
    surplus: json['surplus'],
    trip: json['trip'] != null ? Trip.fromJson(json['trip']) : null,
    user: json['user'] != null ? User.fromJson(json['user']) : null,
  );
}

class User {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? role;
  final List<Notification>? notifications;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.role,
    this.notifications,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    avatarUrl: json['avatarUrl'],
    role: json['role'],
    notifications:
        (json['notifications'] as List<dynamic>?)
            ?.map((item) => Notification.fromJson(item as Map<String, dynamic>))
            .toList(),
  );
}

class UserPayload {
  final User user;

  UserPayload({required this.user});

  factory UserPayload.fromJson(Map<String, dynamic> json) =>
      UserPayload(user: User.fromJson(json['user'] as Map<String, dynamic>));
}

class Trip {
  final String id;
  final String name;
  final String destination;
  final Float budget;
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

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
    id: json['id'],
    name: json['name'],
    destination: json['destination'],
    budget: json['budget'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    userId: json['userId'],
    imgUrl: json['imgUrl'],
    expenses:
        (json['expenses'] as List<dynamic>?)
            ?.map((item) => Expense.fromJson(item as Map<String, dynamic>))
            .toList(),
  );
}

class Expense {
  final String id;
  final String name;
  final Float amount;
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
    this.notes,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'],
    name: json['name'],
    amount: json['amount'],
    category: Category.values.firstWhere((e) => e.name == json['category']),
    date: DateTime.parse(json['date']),
    tripId: json['tripId'],
    notes: json['notes'],
  );
}

enum Category {
  FOOD,
  ACCOMMODATION,
  TRANSPORTATION,
  ENTERTAINMENT,
  SHOPPING,
  OTHER,
}
