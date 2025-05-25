import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/error.dart';
import '../../domain/auth_repository.dart';

sealed class SignupScreenState {
  SignupScreenState();
}

class SignupWaiting extends SignupScreenState {
  SignupWaiting();
}

class SignupLoading extends SignupScreenState {
  SignupLoading();
}

class SignupSuccess extends SignupScreenState {
  final LoginPayload loginPayload;

  SignupSuccess(this.loginPayload);
}

class SignupError extends SignupScreenState {
  final UserError userError;

  SignupError(this.userError);
}

class SignupState extends StateNotifier<SignupScreenState> {
  final AuthRepository _authRepository;
  String? _role;

  SignupState(this._authRepository) : super(SignupWaiting());

  String? get role => _role;

  Future<void> signup(String username, String email, String password, File? avatar) async {
    state = SignupLoading();
    try {
      final result = await _authRepository.register(username, email, password, avatar);

      if (result is Success<LoginPayload, UserError>) {
        state = SignupSuccess(
          (result as Success).data,
        );
      } else if (result is Error<LoginPayload, UserError>) {
        state = SignupError((result as Error).error);
      } else {
        state = SignupError(
          UserError(message: 'An unexpected result type from register.'),
        );
      }
    } catch (e) {
      state = SignupError(
        UserError(message: 'An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}

final signupProvider = StateNotifierProvider<SignupState, SignupScreenState>((
  ref,
) {
  return SignupState(ref.read(authRepositoryProvider));
});
