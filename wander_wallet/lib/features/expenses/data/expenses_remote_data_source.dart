import 'package:dio/dio.dart';
import 'package:wander_wallet/core/constants/api_constants.dart';
import 'package:wander_wallet/core/models/success.dart';

class ExpensesRemoteDataSource {
  final Dio dio;

  ExpensesRemoteDataSource(this.dio);

}