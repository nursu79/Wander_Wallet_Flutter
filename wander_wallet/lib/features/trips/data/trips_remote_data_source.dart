import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wander_wallet/core/constants/api_constants.dart';

class TripsRemoteDataSource {
  final Dio dio;
  TripsRemoteDataSource(this.dio);

  Future<Response<dynamic>> createTrip(
    String name,
    String destination,
    num budget,
    DateTime startDate,
    DateTime endDate,
    File? tripImage,
  ) async {
    final formData = FormData.fromMap({
      'name': name,
      'destination': destination,
      'budget': budget,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      if (tripImage != null) 'tripImage': await MultipartFile.fromFile(tripImage.path, contentType: DioMediaType.parse('image/jpeg'))
    });

    final res = await dio.post(
      ApiConstants.createTrip,
      data: formData
    );

    return res;
  }

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

  Future<Response<dynamic>> deleteTrip(String id) async {
    final res = await dio.delete(ApiConstants.getTripPath(id));

    return res;
  }
}
