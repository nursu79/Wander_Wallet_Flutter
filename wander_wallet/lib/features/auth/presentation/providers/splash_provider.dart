import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/features/auth/data/models.dart';

sealed class SplashScreenState {
  SplashScreenState();
}

class SplashLoading extends SplashScreenState {
  SplashLoading();
}

class SplashSuccess extends SplashScreenState {
  final UserPayload userPayload;

  SplashSuccess(this.userPayload);
}

class SplashError extends SplashScreenState {
  final MessageError messageError;
  final bool loggedOut;

  SplashError(this.messageError, this.loggedOut);
}

class SplashScreenNotifier extends AsyncNotifier<SplashScreenState> {
  @override
  Future<SplashScreenState> build() async {
    state = const AsyncValue.loading();
    final authRepository = ref.read(authRepositoryProvider);
    final res = await authRepository.getProfile();

    if (res is Success) {
      return SplashSuccess((res as Success).data);
    } else {
      throw SplashError((res as Error).error, (res as Error).loggedOut);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final authRepository = ref.read(authRepositoryProvider);
    final res = await authRepository.getProfile();

    if (res is Success) {
      state = AsyncValue.data(SplashSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(SplashError((res as Error).error, (res as Error).loggedOut), StackTrace.current);
    }
  }
}


final splashProvider = AsyncNotifierProvider<SplashScreenNotifier, SplashScreenState>(
  SplashScreenNotifier.new,
);