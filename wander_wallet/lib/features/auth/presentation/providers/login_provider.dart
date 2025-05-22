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
  final String? role;

  LoginSuccess(this.tokenPayload, {this.role});
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

    if (loginResult is Success<TokenPayload, UserError>) {
      final userRole = loginResult.data.user?.role;
      state = LoginSuccess(loginResult.data, role: userRole);
    } else if (loginResult is Error<TokenPayload, UserError>) {
      state = LoginError(loginResult.error);
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
