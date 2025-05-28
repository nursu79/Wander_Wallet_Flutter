import 'dart:io';

import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';

abstract class TripsRepository {
  Future<Result<TripPayload, TripError>> createTrip(
    String name,
    String destination,
    num budget,
    DateTime startDate,
    DateTime endDate,
    File? tripImage,
  );
  Future<Result<TripsPayload, MessageError>> getAllTrips();
  Future<Result<TripsPayload, MessageError>> getPastTrips();
  Future<Result<TripsPayload, MessageError>> getCurrentTrips();
  Future<Result<TripsPayload, MessageError>> getPendingTrips();
  Future<Result<TripPayload, MessageError>> getTrip(String id);
  Future<Result<MessagePayload, MessageError>> deleteTrip(String id);
}