import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';

sealed class ExpenseDetailsScreenState {
  ExpenseDetailsScreenState();
}

class ExpenseDetailsGetSuccess extends ExpenseDetailsScreenState {
  final ExpensePayload expensePayload;

  ExpenseDetailsGetSuccess(this.expensePayload);
}

class ExpenseDetailsDeleteSuccess extends ExpenseDetailsScreenState {
  final MessagePayload messagePayload;

  ExpenseDetailsDeleteSuccess(this.messagePayload);
}

class ExpenseDetailsError extends ExpenseDetailsScreenState {
  final MessageError error;
  final bool loggedOut;

  ExpenseDetailsError(this.error, this.loggedOut);
}

class ExpenseDetailsScreenNotifier extends FamilyAsyncNotifier<ExpenseDetailsScreenState, String> {
  ExpenseDetailsScreenNotifier();
  @override
  Future<ExpenseDetailsScreenState> build(String id) async {
    final expensesRepository = ref.read(expensesRepositoryProvider);
    state = AsyncValue.loading();
    final res = await expensesRepository.getExpense(arg);
    if (res is Success) {
      return ExpenseDetailsGetSuccess((res as Success).data);
    } else {
      throw ExpenseDetailsError(
        (res as Error).error,
        (res as Error).loggedOut
      );
    }
  }

  Future<void> deleteExpense() async {
    final expensesRepository = ref.read(expensesRepositoryProvider);
    state = AsyncValue.loading();
    final res = await expensesRepository.deleteExpense(arg);
    if (res is Success) {
      state = AsyncValue.data(ExpenseDetailsDeleteSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
        ExpenseDetailsError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current
      );
    }
  }

  Future<void> refresh() async {
    final expensesRepository = ref.read(expensesRepositoryProvider);
    state = AsyncValue.loading();
    final res = await expensesRepository.getExpense(arg);
    if (res is Success) {
      state = AsyncValue.data(ExpenseDetailsGetSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
        ExpenseDetailsError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current
      );
    }
  }
}

final expenseDetailsProvider = AsyncNotifierProvider.family<ExpenseDetailsScreenNotifier, ExpenseDetailsScreenState, String>(
  ExpenseDetailsScreenNotifier.new
);
