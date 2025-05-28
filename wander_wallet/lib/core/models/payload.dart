import 'package:json_annotation/json_annotation.dart';
import 'package:wander_wallet/core/models/success.dart';

part 'payload.g.dart';

@JsonSerializable()
class UserPayload {
  final User user;

  UserPayload({
    required this.user,
  });
  factory UserPayload.fromJson(Map<String, dynamic> json) => _$UserPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$UserPayloadToJson(this);
}

@JsonSerializable()
class LoginPayload {
  final String accessToken;
  final String refreshToken;
  final User? user;

  LoginPayload({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });
  factory LoginPayload.fromJson(Map<String, dynamic> json) => _$LoginPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$LoginPayloadToJson(this);
}

@JsonSerializable()
class TripPayload {
  final Trip trip;
  final num? totalExpenditure;
  final List<ExpenseByCategory>? expensesByCategory;

  TripPayload({
    required this.trip,
    required this.totalExpenditure,
    required this.expensesByCategory
  });
  factory TripPayload.fromJson(Map<String, dynamic> json) => _$TripPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$TripPayloadToJson(this);
}

@JsonSerializable()
class TripsPayload {
  final List<Trip> trips;

  TripsPayload({
    required this.trips,
  });
  factory TripsPayload.fromJson(Map<String, dynamic> json) => _$TripsPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$TripsPayloadToJson(this);
} 

@JsonSerializable()
class NotificationsPayload {
  final List<Notification> notifications;

  NotificationsPayload({
    required this.notifications,
  });
  factory NotificationsPayload.fromJson(Map<String, dynamic> json) => _$NotificationsPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsPayloadToJson(this);
}

@JsonSerializable()
class MessagePayload {
  final String message;

  MessagePayload({
    required this.message,
  });
  factory MessagePayload.fromJson(Map<String, dynamic> json) => _$MessagePayloadFromJson(json);
  Map<String, dynamic> toJson() => _$MessagePayloadToJson(this);
}
