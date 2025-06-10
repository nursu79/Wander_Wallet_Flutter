// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPayload _$UserPayloadFromJson(Map<String, dynamic> json) =>
    UserPayload(user: User.fromJson(json['user'] as Map<String, dynamic>));

Map<String, dynamic> _$UserPayloadToJson(UserPayload instance) =>
    <String, dynamic>{'user': instance.user};

LoginPayload _$LoginPayloadFromJson(Map<String, dynamic> json) => LoginPayload(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  user:
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LoginPayloadToJson(LoginPayload instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };

TripPayload _$TripPayloadFromJson(Map<String, dynamic> json) => TripPayload(
  trip: Trip.fromJson(json['trip'] as Map<String, dynamic>),
  totalExpenditure: json['totalExpenditure'] as num?,
  expensesByCategory:
      (json['expensesByCategory'] as List<dynamic>?)
          ?.map((e) => ExpenseByCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$TripPayloadToJson(TripPayload instance) =>
    <String, dynamic>{
      'trip': instance.trip,
      'totalExpenditure': instance.totalExpenditure,
      'expensesByCategory': instance.expensesByCategory,
    };

ConciseTripPayload _$ConciseTripPayloadFromJson(Map<String, dynamic> json) =>
    ConciseTripPayload(
      trip: ConciseTrip.fromJson(json['trip'] as Map<String, dynamic>),
      totalExpenditure: json['totalExpenditure'] as num?,
    );

Map<String, dynamic> _$ConciseTripPayloadToJson(ConciseTripPayload instance) =>
    <String, dynamic>{
      'trip': instance.trip,
      'totalExpenditure': instance.totalExpenditure,
    };

TripsPayload _$TripsPayloadFromJson(Map<String, dynamic> json) => TripsPayload(
  trips:
      (json['trips'] as List<dynamic>)
          .map((e) => Trip.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$TripsPayloadToJson(TripsPayload instance) =>
    <String, dynamic>{'trips': instance.trips};

ExpensePayload _$ExpensePayloadFromJson(Map<String, dynamic> json) =>
    ExpensePayload(
      expense: Expense.fromJson(json['expense'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExpensePayloadToJson(ExpensePayload instance) =>
    <String, dynamic>{'expense': instance.expense};

NotificationsPayload _$NotificationsPayloadFromJson(
  Map<String, dynamic> json,
) => NotificationsPayload(
  notifications:
      (json['notifications'] as List<dynamic>)
          .map((e) => TripNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$NotificationsPayloadToJson(
  NotificationsPayload instance,
) => <String, dynamic>{'notifications': instance.notifications};

MessagePayload _$MessagePayloadFromJson(Map<String, dynamic> json) =>
    MessagePayload(message: json['message'] as String);

Map<String, dynamic> _$MessagePayloadToJson(MessagePayload instance) =>
    <String, dynamic>{'message': instance.message};
