import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/features/auth/domain/auth_repository.dart';

sealed class UserDashBoardScreenState {
  UserDashBoardScreenState();
}

class UserDashBoardLoading extends UserDashBoardScreenState {
  UserDashBoardLoading();
}

class UserDashBoardSuccess extends UserDashBoardScreenState {
  final UserPayload userPayload;

  UserDashBoardSuccess(this.userPayload);
}

class UserDashBoardError extends UserDashBoardScreenState {
  final MessageError messageError;
  final bool loggedOut;

  UserDashBoardError(this.messageError, this.loggedOut);
}

class UserDashBoardScreenNotifier extends AsyncNotifier<UserDashBoardScreenState> {
  late final AuthRepository authRepository;

  UserDashBoardScreenNotifier();
  @override
  Future<UserDashBoardScreenState> build() async {
    authRepository = ref.read(authRepositoryProvider);
    state = AsyncValue.loading();
    final res = await authRepository.getProfile();

    if (res is Success) {
      return UserDashBoardSuccess((res as Success).data);
    } else {
      throw UserDashBoardError((res as Error).error, (res as Error).loggedOut);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final res = await authRepository.getProfile();

    if (res is Success) {
      state = AsyncValue.data(UserDashBoardSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
        UserDashBoardError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current,
      );
    }
  }
}

final userDashBoardProvider = AsyncNotifierProvider<UserDashBoardScreenNotifier, UserDashBoardScreenState>(
  UserDashBoardScreenNotifier.new
);
