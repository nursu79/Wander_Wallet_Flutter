import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trips_provider.dart';
import 'package:wander_wallet/features/trips/presentation/screens/trips_screen.dart';

import 'trips_screen_test.mocks.dart';

@GenerateMocks([NavigatorObserver])
void main() {
  late MockNavigatorObserver mockObserver;

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
  final testTripsPayload = TripsPayload(trips: [testTrip]);
  final testMessageError = MessageError(message: 'Operation failed');

  setUp(() {
    mockObserver = MockNavigatorObserver();
    when(mockObserver.navigator).thenReturn(null);
  });

  Future<void> pumpTripsScreen(
    WidgetTester tester,
    AsyncValue<TripsScreenState> tripsState
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripsProvider.overrideWith(() => FakeTripsScreenNotifier(tripsState))
        ],
        child: MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/tripDetails': (context) {
              return const Scaffold(body: Text('Trip Details'));
            },
            '/createTrip': (context) {
              return const Scaffold(body: Text('Create Trip'),);
            }
          },
          home: const TripsScreen(),
        ),
      )
    );
  }

  group('Trips Screen widget tests', () {
    testWidgets('displays trip info on success', (tester) async {
      final tripsState = AsyncValue.data(
        TripsSuccess(testTripsPayload)
      );

      await pumpTripsScreen(tester, tripsState);
      await tester.pumpAndSettle();

      expect(find.text(testTrip.name), findsOneWidget);
    });

    testWidgets('displays error on error', (tester) async {
      final tripsState = AsyncValue<TripsScreenState>.error(
        TripsError(testMessageError, false),
        StackTrace.current
      );

      await pumpTripsScreen(tester, tripsState);
      await tester.pumpAndSettle();

      expect(find.text(testMessageError.message), findsOneWidget);
    });

    testWidgets('navigates to details screen on click', (tester) async {
      final tripsState = AsyncValue.data(
        TripsSuccess(testTripsPayload)
      );

      await pumpTripsScreen(tester, tripsState);
      await tester.pumpAndSettle();

      await tester.tap(find.text('View Details'));
      await tester.pumpAndSettle();

      expect(find.text('Trip Details'), findsOneWidget);
    });

    testWidgets('navigates to create trip screen on click', (tester) async {
      final tripsState = AsyncValue.data(
        TripsSuccess(testTripsPayload)
      );

      await pumpTripsScreen(tester, tripsState);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Create Trip'), findsOneWidget);
    });
  });
}

class FakeTripsScreenNotifier extends TripsScreenNotifier {
  final AsyncValue<TripsScreenState> tripsState;

  FakeTripsScreenNotifier(this.tripsState);

  @override
  Future<TripsScreenState> build() async {
    state = tripsState;
    return tripsState.value!;
  }
}

