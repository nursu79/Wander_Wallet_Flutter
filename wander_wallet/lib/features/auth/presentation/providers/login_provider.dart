import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/error.dart';
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
  final LoginPayload loginPayload;

  LoginSuccess(this.loginPayload);
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
    final loginResult = await _authRepository.login(email, password);

    if (loginResult is Success<LoginPayload, UserError>) {
      state = LoginSuccess((loginResult as Success).data);
    } else if (loginResult is Error<LoginPayload, UserError>) {
      state = LoginError((loginResult as Error).error);
    } else {
      state = LoginError(
        UserError(message: 'An unexpected error occurred during login.'),
      );
    }
  }
}

final loginProvider = StateNotifierProvider<LoginState, LoginScreenState>((
  ref,
) {
  return LoginState(ref.read(authRepositoryProvider));
});
