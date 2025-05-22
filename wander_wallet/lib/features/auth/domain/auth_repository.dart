import 'package:wander_wallet/features/auth/data/models.dart';

abstract class AuthRepository {
  Future<Result<TokenPayload, UserError>> login(String email, String password);
  Future<Result<UserPayload, MessageError>> getProfile();
  Future<Result<TokenPayload, UserError>> register(
    String username,
    String email,
    String password,
  );
  Future<Result<UserPayload, UserError>> promoteToAdmin(String userId);
}
