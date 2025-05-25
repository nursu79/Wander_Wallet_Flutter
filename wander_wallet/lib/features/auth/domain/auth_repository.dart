import 'dart:io';

import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/error.dart';

abstract class AuthRepository {
  Future<Result<LoginPayload, UserError>> login(String email, String password);
  Future<Result<UserPayload, MessageError>> getProfile();
  Future<Result<LoginPayload, UserError>> register(
    String username,
    String email,
    String password,
    File? avatar
  );
  Future<Result<UserPayload, UserError>> promoteToAdmin(String userId);
}
