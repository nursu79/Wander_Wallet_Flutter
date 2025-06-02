import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';

abstract class ExpensesRepository {
  Future<Result<ExpensePayload, ExpenseError>> createExpense(
    String tripId,
    String name,
    num amount,
    Category category,
    DateTime date,
    String? notes
  );
  Future<Result<ExpensePayload, MessageError>> getExpense(String id);
  Future<Result<ExpensePayload, ExpenseError>> updateExpense(
    String id,
    String name,
    num amount,
    Category category,
    DateTime date,
    String? notes
  );
  Future<Result<MessagePayload, MessageError>> deleteExpense(String id);
}