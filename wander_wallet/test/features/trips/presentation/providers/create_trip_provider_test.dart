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
import 'package:wander_wallet/features/trips/presentation/providers/create_trip_provider.dart';

import 'create_trip_provider_test.mocks.dart';

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

  setUpAll(() {
    provideDummy<Result<TripPayload, TripError>>(
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

  group('CreateTripState', () {
    test('initial state is Loading', () {
      final state = container.read(createTripProvider);
      expect(state, isA<AsyncLoading>());
    });

    test('emits CreateTripLoading then CreateTripSuccess on successful login', () async {
      when(mockTripsRepository.createTrip(any, any, any, any, any, any))
          .thenAnswer((_) async => Success<TripPayload, TripError>(testTripPayload));

      final notifier = container.read(createTripProvider.notifier);

      await notifier.createTrip(testTrip.name, testTrip.destination, testTrip.budget, testTrip.startDate, testTrip.endDate, null);
      final state = container.read(createTripProvider);

      expect(state.value, isA<CreateTripSuccess>());
    });

    test('emits CreateTripLoading then CreateTripError on known error', () async {
      when(mockTripsRepository.createTrip(any, any, any, any, any, any))
          .thenAnswer((_) async => Error<TripPayload, TripError>(error: testTripError));

      final notifier = container.read(createTripProvider.notifier);

      await notifier.createTrip(testTrip.name, testTrip.destination, testTrip.budget, testTrip.startDate, testTrip.endDate, null);
      final state = container.read(createTripProvider);

      expect(state.error, isA<CreateTripError>());
      expect((state.error as CreateTripError).error, testTripError);
    });
  });
}