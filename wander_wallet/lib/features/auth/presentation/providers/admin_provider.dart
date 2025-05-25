import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/error.dart';
import '../../domain/auth_repository.dart';

sealed class AdminScreenState {
  AdminScreenState();
}

class AdminWaiting extends AdminScreenState {
  AdminWaiting();
}

class AdminLoading extends AdminScreenState {
  AdminLoading();
}

class AdminSuccess extends AdminScreenState {
  final UserPayload userPayload;

  AdminSuccess(this.userPayload);
}

class AdminError extends AdminScreenState {
  final UserError userError;

  AdminError(this.userError);
}

class AdminState extends StateNotifier<AdminScreenState> {
  final AuthRepository _authRepository;

  AdminState(this._authRepository) : super(AdminWaiting());

  Future<void> promoteToAdmin(String userId) async {
    state = AdminLoading();
    try {
      final result = await _authRepository.promoteToAdmin(userId);
      if (result is Success<UserPayload, UserError>) {
        state = AdminSuccess((result as Success).data);
      } else if (result is Error<UserPayload, UserError>) {
        state = AdminError((result as Error).error);
      }
    } catch (e) {
      state = AdminError(UserError(message: 'An unexpected error occurred'));
    }
  }
}

final adminProvider = StateNotifierProvider<AdminState, AdminScreenState>((
  ref,
) {
  return AdminState(ref.read(authRepositoryProvider));
});
