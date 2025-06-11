import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/trips/data/trips_remote_data_source.dart';
import 'package:wander_wallet/features/trips/domain/trips_repository_impl.dart';

import 'trips_repository_impl_test.mocks.dart';

@GenerateMocks([TripsRemoteDataSource])
void main() {
  late TripsRepositoryImpl tripsRepository;
  late MockTripsRemoteDataSource mockRemoteDataSource;

  final testTrip = Trip(
    id: 't1',
    userId: 'u1',
    name: 'My trip to Paris',
    destination: 'Paris',
    budget: 1500,
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    imgUrl: null
  );

  final testTripPayload = TripPayload(trip: testTrip, totalExpenditure: null, expensesByCategory: null);
  final testTripsPayload = TripsPayload(trips: [testTrip, testTrip]);
  final testMessagePayload = MessagePayload(message: 'Operation successful');
  final testTripError = TripError(
    name: 'An invalid name'
  );
  final testMessageError = MessageError(message: 'Operation failed');

  setUp(() {
    mockRemoteDataSource = MockTripsRemoteDataSource();
    tripsRepository = TripsRepositoryImpl(mockRemoteDataSource);
  });

  group('createTrip', () {
    test('should return Success with TripPayload when creation is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testTripPayload.toJson()
      );

      when(mockRemoteDataSource.createTrip(any, any, any, any, any, any)).thenAnswer((_) async => testResponse);

      final result = await tripsRepository.createTrip(testTrip.name, testTrip.destination, testTrip.budget, testTrip.startDate, testTrip.endDate, null);

      expect(result, isA<Success<TripPayload, TripError>>());
      expect((result as Success<TripPayload, TripError>).data.trip.id, testTrip.id);
    });

    test('should return Error with TripError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testTripError.toJson()
        )
      );

      when(mockRemoteDataSource.createTrip(any, any, any, any, any, any)).thenThrow(dioError);

      final result = await tripsRepository.createTrip(testTrip.name, testTrip.destination, testTrip.budget, testTrip.startDate, testTrip.endDate, null);

      expect(result, isA<Error<TripPayload, TripError>>());
      expect((result as Error).error.name, 'An invalid name');
    });
  });

  group('getAllTrips', () {
    test('should return Success with TripsPayload when read/get is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testTripsPayload.toJson()
      );

      when(mockRemoteDataSource.getAllTrips()).thenAnswer((_) async => testResponse);

      final result = await tripsRepository.getAllTrips();

      expect(result, isA<Success<TripsPayload, MessageError>>());
      expect((result as Success<TripsPayload, MessageError>).data.trips.length, 2);
    });

    test('should return Error with MessageError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testMessageError.toJson()
        )
      );

      when(mockRemoteDataSource.getAllTrips()).thenThrow(dioError);

      final result = await tripsRepository.getAllTrips();

      expect(result, isA<Error<TripsPayload, MessageError>>());
      expect((result as Error).error.message, 'Operation failed');
    });
  });

  group('getPastTrips', () {
    test('should return Success with TripsPayload when read/get is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testTripsPayload.toJson()
      );

      when(mockRemoteDataSource.getPastTrips()).thenAnswer((_) async => testResponse);

      final result = await tripsRepository.getPastTrips();

      expect(result, isA<Success<TripsPayload, MessageError>>());
      expect((result as Success<TripsPayload, MessageError>).data.trips.length, 2);
    });

    test('should return Error with MessageError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testMessageError.toJson()
        )
      );

      when(mockRemoteDataSource.getPastTrips()).thenThrow(dioError);

      final result = await tripsRepository.getPastTrips();

      expect(result, isA<Error<TripsPayload, MessageError>>());
      expect((result as Error).error.message, 'Operation failed');
    });
  });

  group('getCurrentTrips', () {
    test('should return Success with TripsPayload when read/get is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testTripsPayload.toJson()
      );

      when(mockRemoteDataSource.getCurrentTrips()).thenAnswer((_) async => testResponse);

      final result = await tripsRepository.getCurrentTrips();

      expect(result, isA<Success<TripsPayload, MessageError>>());
      expect((result as Success<TripsPayload, MessageError>).data.trips.length, 2);
    });

    test('should return Error with MessageError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testMessageError.toJson()
        )
      );

      when(mockRemoteDataSource.getCurrentTrips()).thenThrow(dioError);

      final result = await tripsRepository.getCurrentTrips();

      expect(result, isA<Error<TripsPayload, MessageError>>());
      expect((result as Error).error.message, 'Operation failed');
    });
  });

  group('getPendingTrips', () {
    test('should return Success with TripsPayload when read/get is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testTripsPayload.toJson()
      );

      when(mockRemoteDataSource.getPendingTrips()).thenAnswer((_) async => testResponse);

      final result = await tripsRepository.getPendingTrips();

      expect(result, isA<Success<TripsPayload, MessageError>>());
      expect((result as Success<TripsPayload, MessageError>).data.trips.length, 2);
    });

    test('should return Error with MessageError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testMessageError.toJson()
        )
      );

      when(mockRemoteDataSource.getPendingTrips()).thenThrow(dioError);

      final result = await tripsRepository.getPendingTrips();

      expect(result, isA<Error<TripsPayload, MessageError>>());
      expect((result as Error).error.message, 'Operation failed');
    });
  });

  group('getTrip', () {
    test('should return Success with TripsPayload when read/get is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testTripPayload.toJson()
      );

      when(mockRemoteDataSource.getTrip(any)).thenAnswer((_) async => testResponse);

      final result = await tripsRepository.getTrip('t1');

      expect(result, isA<Success<TripPayload, MessageError>>());
      expect((result as Success<TripPayload, MessageError>).data.trip.id, 't1');
    });

    test('should return Error with MessageError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testMessageError.toJson()
        )
      );

      when(mockRemoteDataSource.getTrip(any)).thenThrow(dioError);

      final result = await tripsRepository.getTrip('t1');

      expect(result, isA<Error<TripPayload, MessageError>>());
      expect((result as Error).error.message, 'Operation failed');
    });
  });

  group('updateTrip', () {
    test('should return Success with TripPayload when creation is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testTripPayload.toJson()
      );

      when(mockRemoteDataSource.updateTrip(any, any, any, any, any, any, any)).thenAnswer((_) async => testResponse);

      final result = await tripsRepository.updateTrip('t1', testTrip.name, testTrip.destination, testTrip.budget, testTrip.startDate, testTrip.endDate, null);

      expect(result, isA<Success<TripPayload, TripError>>());
      expect((result as Success<TripPayload, TripError>).data.trip.id, testTrip.id);
    });

    test('should return Error with TripError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testTripError.toJson()
        )
      );

      when(mockRemoteDataSource.updateTrip(any, any, any, any, any, any, any)).thenThrow(dioError);

      final result = await tripsRepository.updateTrip('t1', testTrip.name, testTrip.destination, testTrip.budget, testTrip.startDate, testTrip.endDate, null);

      expect(result, isA<Error<TripPayload, TripError>>());
      expect((result as Error).error.name, 'An invalid name');
    });
  });

  group('deleteTrip', () {
    test('should return Success with TripsPayload when read/get is successful', () async {
      final testResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: testMessagePayload.toJson()
      );

      when(mockRemoteDataSource.deleteTrip(any)).thenAnswer((_) async => testResponse);

      final result = await tripsRepository.deleteTrip('t1');

      expect(result, isA<Success<MessagePayload, MessageError>>());
      expect((result as Success<MessagePayload, MessageError>).data.message, 'Operation successful');
    });

    test('should return Error with MessageError when server returns error message', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: testMessageError.toJson()
        )
      );

      when(mockRemoteDataSource.deleteTrip(any)).thenThrow(dioError);

      final result = await tripsRepository.deleteTrip('t1');

      expect(result, isA<Error<MessagePayload, MessageError>>());
      expect((result as Error).error.message, 'Operation failed');
    });
  });
}