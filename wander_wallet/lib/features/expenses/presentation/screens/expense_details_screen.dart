import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/core/widgets/expense_info.dart';
import 'package:wander_wallet/features/expenses/presentation/providers/edit_expense_provider.dart';
import 'package:wander_wallet/features/expenses/presentation/providers/expense_details_provider.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trip_details_provider.dart';

class ExpenseDetailsScreen extends ConsumerStatefulWidget {
  final String id;
  final String tripId;

  const ExpenseDetailsScreen({ super.key, required this.id, required this.tripId });

  @override
  ConsumerState<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends ConsumerState<ExpenseDetailsScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(expenseDetailsProvider(widget.id), (prev, next) {
      next.when(
        data: (data) {
          if (data is ExpenseDetailsDeleteSuccess) {
            ref.invalidate(tripDetailsProvider(widget.tripId));
            Navigator.pushNamed(context, '/tripDetails', arguments: widget.tripId);
          }
        },
        loading: () {},
        error: (error, _) {
          if (error is ExpenseDetailsError && error.loggedOut) {
            Navigator.pushNamed(context, '/login');
          }
        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseDetailsState = ref.watch(expenseDetailsProvider(widget.id));
    final theme = Theme.of(context);

    return expenseDetailsState.when(
      data: (data) {
        if (data is ExpenseDetailsDeleteSuccess) {
          return Center(
            child: Text('Expense deleted successfully!'),
          );
        } else {
          final expense = (data as ExpenseDetailsGetSuccess).expensePayload.expense;

          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 28,
              children: [
                ExpenseInfo(expense: expense),
                Row(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RectangularButton(
                      onPressed: () {
                        ref.invalidate(editExpenseProvider(expense.id));
                        Navigator.pushNamed(context, '/editExpense', arguments: expense.id);
                      },
                      text: 'Edit',
                    ),
                    RectangularButton(
                      color: theme.colorScheme.error,
                      textColor: theme.colorScheme.onError,
                      onPressed: () {
                        ref.read(expenseDetailsProvider(widget.id).notifier).deleteExpense();
                      },
                      text: 'Delete',
                    )
                  ],
                ),
              ],
            ),
          );
        }
      },
      error: (err, _) => Center(
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text((err as ExpenseDetailsError).error.message),
            RectangularButton(
              onPressed: () {
                ref.read(expenseDetailsProvider(widget.id).notifier).refresh();
              },
              text: 'Retry',
            )
          ],
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator())
    );
  }
}
