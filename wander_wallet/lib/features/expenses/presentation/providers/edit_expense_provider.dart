import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';

sealed class EditExpenseScreenState {
  EditExpenseScreenState();
}

class EditExpenseGetSuccess extends EditExpenseScreenState {
  final ExpensePayload expensePayload;

  EditExpenseGetSuccess(this.expensePayload);
}

class EditExpenseUpdateSuccess extends EditExpenseScreenState {
  final ExpensePayload expensePayload;

  EditExpenseUpdateSuccess(this.expensePayload);
}

class EditExpenseGetError extends EditExpenseScreenState {
  final MessageError error;
  final bool logggeOut;

  EditExpenseGetError(this.error, this.logggeOut);
}

class EditExpenseUpdateError extends EditExpenseScreenState {
  final ExpenseError error;
  final bool loggedOut;

  EditExpenseUpdateError(this.error, this.loggedOut);
}

class EditExpenseScreenNotifier extends FamilyAsyncNotifier<EditExpenseScreenState, String> {
  EditExpenseScreenNotifier();

  @override
  FutureOr<EditExpenseScreenState> build(String id) async {
    final expensesRepository = ref.read(expensesRepositoryProvider);
    state = AsyncValue.loading();
    final res = await expensesRepository.getExpense(arg);
    if (res is Success) {
      return EditExpenseGetSuccess((res as Success).data);
    } else {
      throw EditExpenseGetError((res as Error).error, (res as Error).loggedOut);
    }
  }

  Future<void> updateTrip(String name, num amount, Category category, DateTime date, String? notes) async  {
    final expensesRepository = ref.read(expensesRepositoryProvider);
    final res = await expensesRepository.updateExpense(arg, name, amount, category, date, notes);
    if (res is Success) {
      state = AsyncValue.data(EditExpenseUpdateSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
        EditExpenseUpdateError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current
      );
    }
  }

  Future<void> refresh() async {
    final expensesRepository = ref.read(expensesRepositoryProvider);
    state = AsyncValue.loading();
    final res = await expensesRepository.getExpense(arg);
    if (res is Success) {
      state = AsyncValue.data(EditExpenseGetSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
        EditExpenseGetError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current
      );
    }
  }
}

final editExpenseProvider = AsyncNotifierProvider.family<EditExpenseScreenNotifier, EditExpenseScreenState, String>(
  EditExpenseScreenNotifier.new
);
