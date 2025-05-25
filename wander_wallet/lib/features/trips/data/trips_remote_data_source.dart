import 'package:dio/dio.dart';
import 'package:wander_wallet/core/constants/api_constants.dart';

class TripsRemoteDataSource {
  final Dio dio;
  TripsRemoteDataSource(this.dio);

  Future<Response<dynamic>> getAllTrips() async {
    final res = await dio.get(ApiConstants.allTrips);

    return res;
  }

  Future<Response<dynamic>> getPastTrips() async {
    final res = await dio.get(ApiConstants.pastTrips);

    return res;
  }

  Future<Response<dynamic>> getCurrentTrips() async {
    final res = await dio.get(ApiConstants.currentTrips);

    return res;
  }

  Future<Response<dynamic>> getPendingTrips() async {
    final res = await dio.get(ApiConstants.pendingTrips);

    return res;
  }

  Future<Response<dynamic>> getTrip(String id) async {
    final res = await dio.get(ApiConstants.getTripPath(id));

    return res;
  }
}
