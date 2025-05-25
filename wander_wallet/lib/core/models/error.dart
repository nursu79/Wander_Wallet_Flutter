import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable()
class UserError {
  final String? username;
  final String? email;
  final String? password;
  final String? message;

  UserError({this.username, this.email, this.password, this.message});
  factory UserError.fromJson(Map<String, dynamic> json) => _$UserErrorFromJson(json);
  Map<String, dynamic> toJson() => _$UserErrorToJson(this);
}

@JsonSerializable()
class MessageError {
  final String message;

  MessageError({required this.message});
  factory MessageError.fromJson(Map<String, dynamic> json) => _$MessageErrorFromJson(json);
  Map<String, dynamic> toJson() => _$MessageErrorToJson(this);
}
