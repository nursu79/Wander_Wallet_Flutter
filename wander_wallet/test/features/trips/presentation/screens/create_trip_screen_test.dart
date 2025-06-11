import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/trips/presentation/providers/create_trip_provider.dart';
import 'package:wander_wallet/features/trips/presentation/screens/create_trip_screen.dart';

import 'create_trip_screen_test.mocks.dart';

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
  final testTripPayload = TripPayload(trip: testTrip, totalExpenditure: null, expensesByCategory: null);

  setUp(() {
    mockObserver = MockNavigatorObserver();
    when(mockObserver.navigator).thenReturn(null);
  });

  Future<void> pumpCreateTripScreen(
    WidgetTester tester,
    AsyncValue<CreateTripScreenState> createTripState
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          createTripProvider.overrideWith(() => FakeCreateTripScreenNotifier(createTripState))
        ],
        child: MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/tripDetails': (context) {
              return const Scaffold(body: Text('Trip Details'),);
            }
          },
          home: Scaffold(
            body: CreateTripScreen(),
          ),
        ),
      )
    );
  }

  group('Create Trip Screen widget tests', () {
    testWidgets('navigates to trip details page on success', (tester) async {
      final createTripState = AsyncValue.data(
        CreateTripSuccess(testTripPayload)
      );

      await pumpCreateTripScreen(tester, createTripState);
      await tester.pumpAndSettle();

      expect(find.text('Trip Details'), findsOneWidget);
    });

    testWidgets('displays error on invalid submit', (tester) async {
      final createTripState = AsyncValue.data(
        CreateTripWaiting()
      );

      await pumpCreateTripScreen(tester, createTripState);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a trip name'), findsOneWidget);
      expect(find.text('Please enter a destination'), findsOneWidget);
      expect(find.text('Please enter a budget'), findsOneWidget);
    });
  });
}

class FakeCreateTripScreenNotifier extends CreateTripScreenNotifier {
  final AsyncValue<CreateTripScreenState> createTripState;

  FakeCreateTripScreenNotifier(this.createTripState);

  @override
  Future<CreateTripScreenState> build() async {
    state = createTripState;
    return createTripState.value!;
  }
}

