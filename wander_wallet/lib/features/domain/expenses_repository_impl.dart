import 'package:dio/dio.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/expenses/data/expenses_remote_data_source.dart';
import 'package:wander_wallet/features/expenses/domain/expenses_repository.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesRemoteDataSource remote;

  ExpensesRepositoryImpl(this.remote);
}