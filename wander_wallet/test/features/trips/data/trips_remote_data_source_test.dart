import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/constants/api_constants.dart';
import 'package:wander_wallet/features/trips/data/trips_remote_data_source.dart';

import 'trips_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late TripsRemoteDataSource tripsRemoteDataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    tripsRemoteDataSource = TripsRemoteDataSource(mockDio);
  });

  group('createTrip', () {
    final testTrip = {
      'name': 'My trip to Paris',
      'destination': 'Paris',
      'budget': 1500,
      'startDate': DateTime.now(),
      'endDate': DateTime.now(),
      'tripImage': null
    };
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.login),
      statusCode: 200,
      data: { 'trip': testTrip },
    );

    test('should make POST request to /trips endpoint with correct data', () async {
      // Arrange
      when(mockDio.post(
        ApiConstants.createTrip,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await tripsRemoteDataSource.createTrip(testTrip['name'] as String, testTrip['destination'] as String, testTrip['budget'] as num, testTrip['startDate'] as DateTime, testTrip['endDate'] as DateTime, null);

      // Assert
      verify(mockDio.post(
        ApiConstants.createTrip,
        data: isA<FormData>()
      )).called(1);
    });

    test('should return response when request is successful', () async {
      // Arrange
      when(mockDio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      final result = await tripsRemoteDataSource.createTrip(testTrip['name'] as String, testTrip['destination'] as String, testTrip['budget'] as num, testTrip['startDate'] as DateTime, testTrip['endDate'] as DateTime, null);

      // Assert
      expect(result, testResponse);
    });

    test('should throw when Dio throws an exception', () async {
      // Arrange
      when(mockDio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.login),
      ));

      // Act & Assert
      expect(
        () => tripsRemoteDataSource.createTrip(testTrip['name'] as String, testTrip['destination'] as String, testTrip['budget'] as num, testTrip['startDate'] as DateTime, testTrip['endDate'] as DateTime, null),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('getAllTrips', () {
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.profile),
      statusCode: 200,
      data: {
        'trips': [
          {
            'name': 't1',
            'destination': 'd1',
            'budget': 1250,
            'startDate': DateTime.now(),
            'endDate': DateTime.now()
          },
          {
            'name': 't2',
            'destination': 'd2',
            'budget': 1250,
            'startDate': DateTime.now(),
            'endDate': DateTime.now()
          }
        ]
      },
    );

    test('should make GET request to getAllTrips endpoint', () async {
      // Arrange
      when(mockDio.get(
        ApiConstants.allTrips,
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      final res = await tripsRemoteDataSource.getAllTrips();

      expect(res.data['trips'], isA<List>());
      // Assert
      verify(mockDio.get(
        ApiConstants.allTrips,
        options: anyNamed('options'),
      )).called(1);
    });
  });

  group('getPastTrips', () {
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.profile),
      statusCode: 200,
      data: {
        'trips': [
          {
            'name': 't1',
            'destination': 'd1',
            'budget': 1250,
            'startDate': DateTime.now(),
            'endDate': DateTime.now()
          },
          {
            'name': 't2',
            'destination': 'd2',
            'budget': 1250,
            'startDate': DateTime.now(),
            'endDate': DateTime.now()
          }
        ]
      },
    );

    test('should make GET request to getPastTrips endpoint', () async {
      // Arrange
      when(mockDio.get(
        ApiConstants.pastTrips,
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      final res = await tripsRemoteDataSource.getPastTrips();

      expect(res.data['trips'], isA<List>());
      expect(res.data['trips'].length, 2);
      // Assert
      verify(mockDio.get(
        ApiConstants.pastTrips,
        options: anyNamed('options'),
      )).called(1);
    });
  });

  group('getCurrentTrips', () {
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.profile),
      statusCode: 200,
      data: {
        'trips': [
          {
            'name': 't1',
            'destination': 'd1',
            'budget': 1250,
            'startDate': DateTime.now(),
            'endDate': DateTime.now()
          },
          {
            'name': 't2',
            'destination': 'd2',
            'budget': 1250,
            'startDate': DateTime.now(),
            'endDate': DateTime.now()
          }
        ]
      },
    );

    test('should make GET request to getCurrentTrips endpoint', () async {
      // Arrange
      when(mockDio.get(
        ApiConstants.currentTrips,
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      final res = await tripsRemoteDataSource.getCurrentTrips();

      expect(res.data['trips'], isA<List>());
      expect(res.data['trips'].length, 2);
      // Assert
      verify(mockDio.get(
        ApiConstants.currentTrips,
        options: anyNamed('options'),
      )).called(1);
    });
  });

  group('getPendingTrips', () {
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.profile),
      statusCode: 200,
      data: {
        'trips': [
          {
            'name': 't1',
            'destination': 'd1',
            'budget': 1250,
            'startDate': DateTime.now(),
            'endDate': DateTime.now()
          },
          {
            'name': 't2',
            'destination': 'd2',
            'budget': 1250,
            'startDate': DateTime.now(),
            'endDate': DateTime.now()
          }
        ]
      },
    );

    test('should make GET request to getPendingTrips endpoint', () async {
      // Arrange
      when(mockDio.get(
        ApiConstants.pendingTrips,
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      final res = await tripsRemoteDataSource.getPendingTrips();

      expect(res.data['trips'], isA<List>());
      expect(res.data['trips'].length, 2);
      // Assert
      verify(mockDio.get(
        ApiConstants.pendingTrips,
        options: anyNamed('options'),
      )).called(1);
    });
  });

  group('getTrip', () {
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.profile),
      statusCode: 200,
      data: {
        'name': 't1',
        'destination': 'd1',
        'budget': 1250,
        'startDate': DateTime.now(),
        'endDate': DateTime.now()
      }
    );

    test('should make GET request to getTrip endpoint', () async {
      // Arrange
      when(mockDio.get(
        ApiConstants.getTripPath('t1'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await tripsRemoteDataSource.getTrip('t1');

      // Assert
      verify(mockDio.get(
        ApiConstants.getTripPath('t1'),
        options: anyNamed('options'),
      )).called(1);
    });
  });

  group('updateTrip', () {
    final testTrip = {
      'name': 't1',
      'destination': 'd1',
      'budget': 1250,
      'startDate': DateTime.now(),
      'endDate': DateTime.now()
    };
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.profile),
      statusCode: 200,
      data: testTrip
    );

    test('should make PUT request to updateTrip endpoint', () async {
      // Arrange
      when(mockDio.put(
        ApiConstants.getTripPath('t1'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await tripsRemoteDataSource.updateTrip('t1', testTrip['name'] as String, testTrip['destination'] as String, testTrip['budget'] as num, testTrip['startDate'] as DateTime, testTrip['endDate'] as DateTime, null);

      // Assert
      verify(mockDio.put(
        ApiConstants.getTripPath('t1'),
        data: isA<FormData>(),
        options: anyNamed('options'),
      )).called(1);
    });
  });

  group('deleteTrip', () {
    final testTrip = {
      'name': 't1',
      'destination': 'd1',
      'budget': 1250,
      'startDate': DateTime.now(),
      'endDate': DateTime.now()
    };
    final testResponse = Response<dynamic>(
      requestOptions: RequestOptions(path: ApiConstants.profile),
      statusCode: 200,
      data: testTrip
    );

    test('should make DELETE request to updateTrip endpoint', () async {
      // Arrange
      when(mockDio.delete(
        ApiConstants.getTripPath('t1'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => testResponse);

      // Act
      await tripsRemoteDataSource.deleteTrip('t1');

      // Assert
      verify(mockDio.delete(
        ApiConstants.getTripPath('t1'),
        options: anyNamed('options'),
      )).called(1);
    });
  });
}