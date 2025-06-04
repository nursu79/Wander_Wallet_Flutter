import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/error.dart';

sealed class SplashState {
  SplashState();
}

class SplashSuccess extends SplashState {
  final UserPayload userPayload;

  SplashSuccess(this.userPayload);

  bool get isAuthenticated => userPayload.user.id.isNotEmpty;
}

class SplashError extends SplashState {
  final MessageError messageError;
  final bool loggedOut;

  SplashError(this.messageError, this.loggedOut);
}

class SplashNotifier extends AsyncNotifier<SplashState> {
  SplashNotifier();

  @override
  Future<SplashState> build() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = AsyncValue.loading();
    final res = await authRepository.getProfile();
    if (res is Success<UserPayload, MessageError>) {
      return SplashSuccess(res.data);
    } else {
      throw SplashError((res as Error).error, (res as Error).loggedOut);
    }
  }

  Future<void> refresh() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = AsyncValue.loading();
    final res = await authRepository.getProfile();
    if (res is Success<UserPayload, MessageError>) {
      state = AsyncValue.data(SplashSuccess(res.data));
    } else {
      state = AsyncValue.error(
        SplashError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current
      );
    }
  }
}

final splashProvider =
    AsyncNotifierProvider<SplashNotifier, SplashState>(
      SplashNotifier.new
    );
