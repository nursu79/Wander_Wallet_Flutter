import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/trips/presentation/providers/edit_trip_provider.dart';
import 'package:wander_wallet/features/trips/presentation/screens/edit_trip_screen.dart';

import 'edit_trip_screen_test.mocks.dart';

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

  Future<void> pumpEditTripScreen(
    WidgetTester tester,
    AsyncValue<EditTripScreenState> editTripState
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          editTripProvider.overrideWith(() => FakeEditTripScreenNotifier(editTripState))
        ],
        child: MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/tripDetails': (context) {
              return const Scaffold(body: Text('Trip Details'),);
            }
          },
          home: Scaffold(
            body: EditTripScreen(id: testTrip.id,),
          ),
        ),
      )
    );
  }

  group('Edit Trip Screen widget tests', () {
    testWidgets('displays trip info in the text fields on get success', (tester) async {
      final editTripState = AsyncValue.data(
        EditTripGetSuccess(testTripPayload)
      );

      await pumpEditTripScreen(tester, editTripState);
      await tester.pumpAndSettle();
      expect(find.text(testTrip.name), findsOneWidget);
      expect(find.text(testTrip.destination), findsOneWidget);
      expect(find.text(testTrip.budget.toString()), findsOneWidget);
    });

    testWidgets('displays error on invalid submit', (tester) async {
      final editTripState = AsyncValue.data(
        EditTripGetSuccess(testTripPayload)
      );

      await pumpEditTripScreen(tester, editTripState);
      await tester.pumpAndSettle();

      await tester.enterText(find.text(testTrip.name), '');
      await tester.enterText(find.text(testTrip.destination), '');
      await tester.enterText(find.text(testTrip.budget.toString()), '');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a trip name'), findsOneWidget);
      expect(find.text('Please enter a destination'), findsOneWidget);
      expect(find.text('Please enter a budget'), findsOneWidget);
    });

    testWidgets('navigates to trip details page on success', (tester) async {
      final editTripState = AsyncValue.data(
        EditTripUpdateSuccess(testTripPayload)
      );

      await pumpEditTripScreen(tester, editTripState);
      await tester.pumpAndSettle();

      expect(find.text('Trip Details'), findsOneWidget);
    });
  });
}

class FakeEditTripScreenNotifier extends EditTripScreenNotifier {
  final AsyncValue<EditTripScreenState> editTripState;

  FakeEditTripScreenNotifier(this.editTripState);

  @override
  Future<EditTripScreenState> build(String id) async {
    state = editTripState;
    return editTripState.value!;
  }
}

