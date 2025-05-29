import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/features/trips/data/trips_remote_data_source.dart';
import 'trips_repository.dart';

class TripsRepositoryImpl implements TripsRepository {
  final TripsRemoteDataSource remote;

  TripsRepositoryImpl(this.remote);

  @override
  Future<Result<TripsPayload, MessageError>> getAllTrips() async {
    try {
      final res = await remote.getAllTrips();
      final trips = TripsPayload.fromJson(res.data);
      return Success(trips);
    } on DioException catch (e) {
      if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: MessageError(message: 'Please check your internet connection and/or api address'),
          loggedOut: false,
        );
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }

  @override
  Future<Result<TripsPayload, MessageError>> getCurrentTrips() async {
    try {
      final res = await remote.getCurrentTrips();
      final trips = TripsPayload.fromJson(res.data);
      return Success(trips);
    } on DioException catch (e) {
      if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: MessageError(message: 'Please check your internet connection and/or api address'),
          loggedOut: false,
        );
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }

  @override
  Future<Result<TripsPayload, MessageError>> getPastTrips() async {
    try {
      final res = await remote.getPastTrips();
      final trips = TripsPayload.fromJson(res.data);
      return Success(trips);
    } on DioException catch (e) {
      if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: MessageError(message: 'Please check your internet connection and/or api address'),
          loggedOut: false,
        );
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }

  @override
  Future<Result<TripsPayload, MessageError>> getPendingTrips() async {
    try {
      final res = await remote.getPendingTrips();
      final trips = TripsPayload.fromJson(res.data);
      return Success(trips);
    } on DioException catch (e) {
      if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: MessageError(message: 'Please check your internet connection and/or api address'),
          loggedOut: false,
        );
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }

  @override
  Future<Result<TripPayload, MessageError>> getTrip(String id) async {
    try {
      final res = await remote.getTrip(id);
      final tripPayload = TripPayload.fromJson(res.data);
      return Success(tripPayload);
    } on DioException catch (e) {
      if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: MessageError(message: 'Please check your internet connection and/or api address'),
          loggedOut: e.response?.statusCode == 401
        );
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }

  @override
  Future<Result<TripPayload, TripError>> createTrip(String name, String destination, num budget, DateTime startDate, DateTime endDate, File? tripImage) async {
    try {
      final res = await remote.createTrip(name, destination, budget, startDate, endDate, tripImage);
      final tripPayload = TripPayload.fromJson(res.data);
      return Success(tripPayload);
    } on DioException catch (e) {
      if (e.response != null) {
        final tripError = TripError.fromJson(e.response?.data);
        return Error(error: tripError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: TripError(message: 'Please check your internet connection and/or api address'),
          loggedOut: e.response?.statusCode == 401
        );
      }
    } on Exception {
      final tripError = TripError(message: 'An unexpected error occurred');
      return Error(error: tripError);
    }
  }
  
  @override
  Future<Result<MessagePayload, MessageError>> deleteTrip(String id) async {
    try {
      final res = await remote.deleteTrip(id);
      final messagePayload = MessagePayload.fromJson(res.data);
      return Success(messagePayload);
    } on DioException catch (e) {
      if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: MessageError(message: 'Please check your internet connection and/or api address'),
          loggedOut: e.response?.statusCode == 401
        );
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }
  
  @override
  Future<Result<TripPayload, TripError>> updateTrip(String id, String name, String destination, num budget, DateTime startDate, DateTime endDate, File? tripImage) async {
    try {
      final res = await remote.updateTrip(id, name, destination, budget, startDate, endDate, tripImage);
      final tripPayload = TripPayload.fromJson(res.data);
      return Success(tripPayload);
    } on DioException catch (e) {
      if (e.response != null) {
        final tripError = TripError.fromJson(e.response?.data);
        return Error(error: tripError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: TripError(message: 'Please check your internet connection and/or api address'),
          loggedOut: e.response?.statusCode == 401
        );
      }
    } on Exception {
      final tripError = TripError(message: 'An unexpected error occurred');
      return Error(error: tripError);
    }
  }
}
