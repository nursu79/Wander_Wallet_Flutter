import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/features/auth/data/models.dart';
import '../../domain/auth_repository.dart';

sealed class LoginScreenState {
  LoginScreenState();
}

class LoginWaiting extends LoginScreenState {
  LoginWaiting();
}

class LoginLoading extends LoginScreenState {
  LoginLoading();
}

class LoginSuccess extends LoginScreenState {
  final TokenPayload tokenPayload;

  LoginSuccess(this.tokenPayload);
}

class LoginError extends LoginScreenState {
  final UserError userError;

  LoginError(this.userError);
}

class LoginState extends StateNotifier<LoginScreenState> {
  final AuthRepository _authRepository;

  LoginState(this._authRepository) : super(LoginWaiting());

  Future<void> login(String email, String password) async {
    state = LoginLoading();
    final result = await _authRepository.login(email, password);

    if (result is Success) {
      state = LoginSuccess((result as Success<TokenPayload, UserError>).data);
    } else {
      state = LoginError((result as Error<TokenPayload, UserError>).error);
    }
  }
}

final loginProvider = StateNotifierProvider<LoginState, LoginScreenState>((ref) {
  return LoginState(ref.read(authRepositoryProvider));
});