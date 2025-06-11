import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/trips/domain/trips_repository.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trip_details_provider.dart';

import 'trip_details_provider_test.mocks.dart';

@GenerateMocks([TripsRepository])
void main() {
  late ProviderContainer container;
  late MockTripsRepository mockTripsRepository;
  late TripDetailsScreenNotifier notifier;

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
  final testMessagePayload = MessagePayload(message: 'Operation failed');
  final testMessageError = MessageError(message: 'Operation failed');

  setUpAll(() {
    provideDummy<Result<TripPayload, MessageError>>(
      Success(testTripPayload)
    );

    provideDummy<Result<MessagePayload, MessageError>>(
      Success(testMessagePayload)
    );
  });

  setUp(() {
    mockTripsRepository = MockTripsRepository();
    container = ProviderContainer(
      overrides: [
        tripsRepositoryProvider.overrideWithValue(mockTripsRepository)
      ]
    );
    notifier = container.read(tripDetailsProvider(testTrip.id).notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('build', () {
    test('should return TripDetailsGetSuccess', () async {
      when(mockTripsRepository.getTrip(any)).thenAnswer(
        (_) async => Success(testTripPayload)
      );

      final result = await notifier.build(testTrip.id);

      expect(result, isA<TripDetailsSuccess>());
    });

    test('should throw TripDetailsError', () async {
      when(mockTripsRepository.getTrip(any)).thenAnswer(
        (_) async => Error(error: testMessageError)
      );

      expect(
        notifier.build(testTrip.id),
        throwsA(isA<TripDetailsError>())
      );
    });
  });

  group('deleteTrip', () {
    test('should return TripDetailsDeleteSuccess when deletion is successful', () async {
      when(mockTripsRepository.deleteTrip(any)).thenAnswer(
        (_) async => Success(testMessagePayload)
      );

      await notifier.deleteTrip();

      final state = notifier.state;

      expect(state.value, isA<TripDetailsDeleteSuccess>());
    });

    test('should throw TripDetailsError on deletion failure', () async {
      when(mockTripsRepository.deleteTrip(any)).thenAnswer(
        (_) async => Error(error: testMessageError)
      );

      await notifier.deleteTrip();
      final state = notifier.state;

      expect(state.error, isA<TripDetailsError>());
    });
  });
}