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

MessageError _$MessageErrorFromJson(Map<String, dynamic> json) =>
    MessageError(message: json['message'] as String);

Map<String, dynamic> _$MessageErrorToJson(MessageError instance) =>
    <String, dynamic>{'message': instance.message};
