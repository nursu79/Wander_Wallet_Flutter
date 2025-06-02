import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/expenses/domain/expenses_repository.dart';

sealed class CreateExpenseScreenState {
  CreateExpenseScreenState();
}

class CreateExpenseWaiting extends CreateExpenseScreenState {
  CreateExpenseWaiting();
}

class CreateExpenseSuccess extends CreateExpenseScreenState {
  final ExpensePayload expensePayload;

  CreateExpenseSuccess(this.expensePayload);
}

class CreateExpenseError extends CreateExpenseScreenState {
  final ExpenseError error;
  final bool loggedOut;

  CreateExpenseError(this.error, this.loggedOut);
}

class CreateExpenseScreenNotifier extends FamilyAsyncNotifier<CreateExpenseScreenState, String> {
  late final ExpensesRepository expensesRepository;

  CreateExpenseScreenNotifier();

  @override
  Future<CreateExpenseScreenState> build(String id) async {
    expensesRepository = ref.read(expensesRepositoryProvider);
    return CreateExpenseWaiting();
  }

  Future<void> createExpense(String name, num amount, Category category, DateTime date, String? notes) async {
    state = AsyncValue.loading();
    final res = await expensesRepository.createExpense(arg, name, amount, category, date, notes);

    if (res is Success) {
      state = AsyncValue.data(CreateExpenseSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
        CreateExpenseError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current
      );
    }
  }
}

final createExpenseProvider = AsyncNotifierProvider
    .family<CreateExpenseScreenNotifier, CreateExpenseScreenState, String>(
  CreateExpenseScreenNotifier.new
);
