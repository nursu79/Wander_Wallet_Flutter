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
class TripError {
  final String? name;
  final String? destination;
  final String? budget;
  final String? startDate;
  final String? endDate;
  final String? message;

  TripError({this.name, this.destination, this.budget, this.startDate, this.endDate, this.message});
  factory TripError.fromJson(Map<String, dynamic> json) => _$TripErrorFromJson(json);
  Map<String, dynamic> toJson() => _$TripErrorToJson(this);
}

@JsonSerializable()
class MessageError {
  final String message;

  MessageError({required this.message});
  factory MessageError.fromJson(Map<String, dynamic> json) => _$MessageErrorFromJson(json);
  Map<String, dynamic> toJson() => _$MessageErrorToJson(this);
}
