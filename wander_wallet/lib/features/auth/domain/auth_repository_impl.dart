import 'package:dio/dio.dart';
import 'package:wander_wallet/features/auth/data/models.dart';

import 'auth_repository.dart';
import '../data/auth_remote_data_source.dart';
import '../../../core/local/token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorage storage;

  AuthRepositoryImpl(this.remote, this.storage);

  @override
  Future<Result<TokenPayload, UserError>> login(String email, String password) async {
    try {
      final res = await remote.login(email, password);
      final tokenPayload = TokenPayload.fromJson(res.data);

      storage.saveAccessToken(tokenPayload.accessToken);
      return Success(tokenPayload);
    } on DioException catch (e) {
      if (e.response != null) {
        final userError = UserError.fromJson(e.response?.data);
        return Error(error: userError);
      } else {
        final userError = UserError(message: 'Please check your internet connection and/or api address');
        return Error(error: userError);
      }
    } on Exception {
      final userError = UserError(message: 'An unexpected error occurred');
      return Error(error: userError);
    }
  }
  
  @override
  Future<Result<UserPayload, MessageError>> getProfile() async {
    try {
      final res = await remote.getProfile();
      final userPayload = UserPayload.fromJson(res.data);

      return Success(userPayload);
    } on DioException catch (e) {
      if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: true);
      } else {
        final messageError = MessageError(message: 'Please check your internet connection and/or api address');
        return Error(error: messageError);
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }
}