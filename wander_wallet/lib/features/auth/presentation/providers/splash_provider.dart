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


final splashProvider = FutureProvider.autoDispose((ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  final res = await authRepository.getProfile();

  if (res is Success) {
    return SplashSuccess((res as Success).data);
  } else {
    return SplashError((res as Error).error, (res as Error).loggedOut);
  }
});