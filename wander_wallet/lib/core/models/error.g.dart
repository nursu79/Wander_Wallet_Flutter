// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserError _$UserErrorFromJson(Map<String, dynamic> json) => UserError(
  username: json['username'] as String?,
  email: json['email'] as String?,
  password: json['password'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$UserErrorToJson(UserError instance) => <String, dynamic>{
  'username': instance.username,
  'email': instance.email,
  'password': instance.password,
  'message': instance.message,
};

TripError _$TripErrorFromJson(Map<String, dynamic> json) => TripError(
  name: json['name'] as String?,
  destination: json['destination'] as String?,
  budget: json['budget'] as String?,
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$TripErrorToJson(TripError instance) => <String, dynamic>{
  'name': instance.name,
  'destination': instance.destination,
  'budget': instance.budget,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'message': instance.message,
};

MessageError _$MessageErrorFromJson(Map<String, dynamic> json) =>
    MessageError(message: json['message'] as String);

Map<String, dynamic> _$MessageErrorToJson(MessageError instance) =>
    <String, dynamic>{'message': instance.message};
