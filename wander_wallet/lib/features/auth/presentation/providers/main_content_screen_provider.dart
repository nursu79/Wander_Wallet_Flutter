import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/features/auth/domain/auth_repository.dart';

sealed class MainContentScreenState {
  MainContentScreenState();
}

class MainContentLoading extends MainContentScreenState {
  MainContentLoading();
}

class MainContentSuccess extends MainContentScreenState {
  final UserPayload userPayload;

  MainContentSuccess(this.userPayload);
}

class MainContentError extends MainContentScreenState {
  final MessageError messageError;
  final bool loggedOut;

  MainContentError(this.messageError, this.loggedOut);
}

class MainContentScreenNotifier extends AsyncNotifier<MainContentScreenState> {
  late final AuthRepository authRepository;

  MainContentScreenNotifier();
  @override
  Future<MainContentScreenState> build() async {
    authRepository = ref.read(authRepositoryProvider);
    state = AsyncValue.loading();
    final res = await authRepository.getProfile();

    if (res is Success) {
      return MainContentSuccess((res as Success).data);
    } else {
      throw MainContentError((res as Error).error, (res as Error).loggedOut);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final res = await authRepository.getProfile();

    if (res is Success) {
      state = AsyncValue.data(MainContentSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
        MainContentError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current,
      );
    }
  }
}

final mainContentProvider = AsyncNotifierProvider<MainContentScreenNotifier, MainContentScreenState>(
  MainContentScreenNotifier.new
);
