import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/misc.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/trips/domain/trips_repository.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trips_provider.dart';

import 'trips_provider_test.mocks.dart';

@GenerateMocks([TripsRepository])
void main() {
  late ProviderContainer container;
  late MockTripsRepository mockTripsRepository;
  late TripsScreenNotifier notifier;

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
  final testTripsPayload = TripsPayload(trips: [testTrip, testTrip]);
  final testMessageError = MessageError(message: 'Operation failed');

  setUpAll(() {
    provideDummy<Result<TripsPayload, MessageError>>(
      Success(testTripsPayload)
    );
  });

  setUp(() {
    mockTripsRepository = MockTripsRepository();
    container = ProviderContainer(
      overrides: [
        tripsRepositoryProvider.overrideWithValue(mockTripsRepository)
      ]
    );
    notifier = container.read(tripsProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('build', () {
    test('should return TripsSuccess when getCurrentTrips Succeeds', () async {
      when(mockTripsRepository.getCurrentTrips()).thenAnswer(
        (_) async => Success(testTripsPayload)
      );

      final result = await notifier.build();

      expect(result, isA<TripsSuccess>());
      expect((result as TripsSuccess).trips, testTripsPayload);
    });

    test('Shpuld throw TripsError when getCurrentTrips fails', () async {
      when(mockTripsRepository.getCurrentTrips()).thenAnswer(
        (_) async => Error(error: testMessageError)
      );

      expect(
        notifier.build(),
        throwsA(isA<TripsError>())
      );
    });
  });

  group('getTrips', () {
    test('should return TripsSuccess when tab type is past and getPastTrips Succeeds', () async {
      when(mockTripsRepository.getPastTrips()).thenAnswer(
        (_) async => Success(testTripsPayload)
      );

      await notifier.getTrips(TabType.past);

      expect(notifier.state.value, isA<TripsSuccess>());
      expect((notifier.state.value as TripsSuccess).trips, testTripsPayload);

      verify(mockTripsRepository.getPastTrips()).called(1);
    });

    test('should return TripsSuccess when tab type is pending and getPendingTrips Succeeds', () async {
      when(mockTripsRepository.getPendingTrips()).thenAnswer(
        (_) async => Success(testTripsPayload)
      );

      await notifier.getTrips(TabType.pending);

      expect(notifier.state.value, isA<TripsSuccess>());
      expect((notifier.state.value as TripsSuccess).trips, testTripsPayload);

      verify(mockTripsRepository.getPendingTrips()).called(1);
    });

    test('should return TripsSuccess when tab type is current and getCurrentTrips Succeeds', () async {
      when(mockTripsRepository.getCurrentTrips()).thenAnswer(
        (_) async => Success(testTripsPayload)
      );

      await notifier.getTrips(TabType.current);

      expect(notifier.state.value, isA<TripsSuccess>());
      expect((notifier.state.value as TripsSuccess).trips, testTripsPayload);

      verify(mockTripsRepository.getCurrentTrips()).called(2);
    });
  });
}
