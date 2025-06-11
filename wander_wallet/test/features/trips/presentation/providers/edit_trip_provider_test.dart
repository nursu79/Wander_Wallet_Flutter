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
import 'package:wander_wallet/features/trips/presentation/providers/edit_trip_provider.dart';

import 'edit_trip_provider_test.mocks.dart';

@GenerateMocks([TripsRepository])
void main() {
  late MockTripsRepository mockTripsRepository;
  late ProviderContainer container;

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
  final testTripError = TripError(
    name: 'An invalid name'
  );
  final testMessageError = MessageError(message: 'Operation failed');

  setUpAll(() {
    provideDummy<Result<TripPayload, TripError>>(
      Success(testTripPayload)
    );
  });

  setUpAll(() {
    provideDummy<Result<TripPayload, MessageError>>(
      Success(testTripPayload)
    );
  });

  setUp(() {
    mockTripsRepository = MockTripsRepository();
    container = ProviderContainer(
      overrides: [
        tripsRepositoryProvider.overrideWithValue(mockTripsRepository)
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Edit Trip provider', () {
    test('initial state is Loading', () {
      final state = container.read(editTripProvider(testTrip.id));
      expect(state, isA<AsyncLoading>());
    });

    test('emits EditTripLoading then EditTripGetSuccess on successful retrieval', () async {
      when(mockTripsRepository.getTrip(any))
          .thenAnswer((_) async => Success<TripPayload, MessageError>(testTripPayload));

      final notifier = container.read(editTripProvider(testTrip.id).notifier);

      await notifier.build(testTrip.id);
      final state = container.read(editTripProvider(testTrip.id));

      expect(state.value, isA<EditTripGetSuccess>());
    });

    test('emits EditTripLoading then EditTripGetError on failed retrieval', () async {
      when(mockTripsRepository.getTrip(any))
          .thenAnswer((_) async => Error<TripPayload, MessageError>(error: testMessageError));

      final notifier = container.read(editTripProvider(testTrip.id).notifier);

      expect(
        notifier.build(testTrip.id),
        throwsA(isA<EditTripGetError>())
      );
    });

    test('emits EditTripLoading then EditTripUpdateSuccess on successful update', () async {
      when(mockTripsRepository.updateTrip(any, any, any, any, any, any, any))
          .thenAnswer((_) async => Success<TripPayload, TripError>(testTripPayload));

      final notifier = container.read(editTripProvider(testTrip.id).notifier);

      await notifier.updateTrip(testTrip.name, testTrip.destination, testTrip.budget, testTrip.startDate, testTrip.endDate, null);
      final state = container.read(editTripProvider(testTrip.id));

      expect(state.value, isA<EditTripUpdateSuccess>());
    });

    test('emits EditTripLoading then EditTripUpdateError on failed update', () async {
      when(mockTripsRepository.updateTrip(any, any, any, any, any, any, any))
          .thenAnswer((_) async => Error<TripPayload, TripError>(error: testTripError));

      final notifier = container.read(editTripProvider(testTrip.id).notifier);
      await notifier.updateTrip(testTrip.name, testTrip.destination, testTrip.budget, testTrip.startDate, testTrip.endDate, null);
      final state = container.read(editTripProvider(testTrip.id));

      expect(state.error, isA<EditTripUpdateError>());    });
  });
}