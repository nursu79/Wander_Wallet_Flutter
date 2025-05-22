import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/features/auth/data/models.dart';
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
  final TokenPayload tokenPayload;
  final String? role;

  SignupSuccess(this.tokenPayload, {this.role});
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

  Future<void> signup(String username, String email, String password) async {
    print("---> signupProvider: signup method called <---");
    state = SignupLoading();
    try {
      print("---> signupProvider: Calling authRepository.register <---");
      final result = await _authRepository.register(username, email, password);
      print("---> signupProvider: authRepository.register returned <---");
      print(
        "---> signupProvider: Result runtimeType: ${result.runtimeType} <---",
      );

      if (result is Success<TokenPayload, UserError>) {
        print("---> signupProvider: Result is Success <---");
        // Successfully registered. No need to call getProfile here. Redirect to login.
        state = SignupSuccess(
          result.data,
        ); // Transition to success state immediately
        print("---> signupProvider: State set to SignupSuccess <---");
      } else if (result is Error<TokenPayload, UserError>) {
        print("---> signupProvider: Result is Error <---");
        // Registration failed with a specific error
        print(
          "---> signupProvider: Error message: ${result.error.message} <---",
        );
        state = SignupError(result.error);
        print("---> signupProvider: State set to SignupError <---");
      } else {
        print("---> signupProvider: Unexpected Result Type <---");
        // Handle unexpected result from register
        state = SignupError(
          UserError(message: 'An unexpected result type from register.'),
        );
        print(
          "---> signupProvider: State set to SignupError (unexpected type) <---",
        );
      }
    } catch (e) {
      print("---> signupProvider: Caught unhandled exception <---");
      // Catch any other unexpected errors during the process
      print("---> signupProvider: Exception: ${e.toString()} <---");
      state = SignupError(
        UserError(message: 'An unexpected error occurred: ${e.toString()}'),
      );
      print(
        "---> signupProvider: State set to SignupError (caught exception) <---",
      );
    }
  }
}

final signupProvider = StateNotifierProvider<SignupState, SignupScreenState>((
  ref,
) {
  return SignupState(ref.read(authRepositoryProvider));
});
