import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';

abstract class TripsRepository {
  Future<Result<TripsPayload, MessageError>> getAllTrips();
  Future<Result<TripsPayload, MessageError>> getPastTrips();
  Future<Result<TripsPayload, MessageError>> getCurrentTrips();
  Future<Result<TripsPayload, MessageError>> getPendingTrips();
  Future<Result<TripPayload, MessageError>> getTrip(String id);
}