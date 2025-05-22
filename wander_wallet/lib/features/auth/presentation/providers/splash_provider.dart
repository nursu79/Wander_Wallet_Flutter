import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/features/auth/data/models.dart';
import '../../domain/auth_repository.dart';

sealed class SplashState {
  SplashState();
}

class SplashWaiting extends SplashState {
  SplashWaiting();
}

class SplashLoading extends SplashState {
  SplashLoading();
}

class SplashSuccess extends SplashState {
  final UserPayload userPayload;

  SplashSuccess(this.userPayload);

  bool get isAuthenticated => userPayload.user.id.isNotEmpty;
}

class SplashError extends SplashState {
  final MessageError messageError;

  SplashError(this.messageError);
}

class SplashNotifier extends StateNotifier<AsyncValue<SplashState>> {
  final AuthRepository _authRepository;

  SplashNotifier(this._authRepository) : super(const AsyncValue.loading()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    try {
      final result = await _authRepository.getProfile();
      if (result is Success<UserPayload, MessageError>) {
        state = AsyncValue.data(SplashSuccess(result.data));
      } else if (result is Error<UserPayload, MessageError>) {
        state = AsyncValue.data(SplashError(result.error));
      }
    } catch (e) {
      state = AsyncValue.data(
        SplashError(MessageError(message: 'Not authenticated')),
      );
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await checkAuth();
  }
}

final splashProvider =
    StateNotifierProvider<SplashNotifier, AsyncValue<SplashState>>((ref) {
      return SplashNotifier(ref.read(authRepositoryProvider));
    });
