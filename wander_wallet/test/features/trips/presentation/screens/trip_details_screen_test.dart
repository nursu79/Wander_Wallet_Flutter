import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/utils/util_funcs.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trip_details_provider.dart';
import 'package:wander_wallet/features/trips/presentation/screens/trip_details_screen.dart';

import 'trip_details_screen_test.mocks.dart';

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
    imgUrl: null,
    expenses: [
      Expense(id: 'e1', name: 'Sushi', amount: 150, category: Category.FOOD, date: DateTime.now(), tripId: 't1')
    ]
  );
  final testTripPayload = TripPayload(trip: testTrip, totalExpenditure: 150, expensesByCategory: [ExpenseByCategory(sum: AmountMap(amount: 150), category: Category.FOOD)]);

  setUp(() {
    mockObserver = MockNavigatorObserver();
    when(mockObserver.navigator).thenReturn(null);
  });

  Future<void> pumpTripDetailsScreen(
    WidgetTester tester,
    AsyncValue<TripDetailsScreenState> tripsState
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripDetailsProvider.overrideWith(() => FakeTripDetailsScreenNotifier(tripsState))
        ],
        child: MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/editTrip': (context) {
              return const Scaffold(body: Text('Edit Trip Screen'));
            },
            '/trips': (context) {
              return const Scaffold(body: Text('Trips Screen'),);
            }
          },
          home: TripDetailsScreen(id: testTrip.id),
        ),
      )
    );
  }

  group('Trip Details Screen widget tests', () {
    testWidgets('displays trip budget and expenses info on success', (tester) async {
      final tripsState = AsyncValue.data(
        TripDetailsSuccess(testTripPayload)
      );

      await pumpTripDetailsScreen(tester, tripsState);
      await tester.pumpAndSettle();

      expect(find.text("\$${testTrip.budget}"), findsOneWidget);
      expect(find.text("\$${testTripPayload.totalExpenditure}"), findsAtLeast(1));
    });

    testWidgets('displays the expenses section', (tester) async {
      final tripsState = AsyncValue.data(
        TripDetailsSuccess(testTripPayload)
      );

      await pumpTripDetailsScreen(tester, tripsState);
      await tester.pumpAndSettle();

      expect(find.text("Expenses"), findsOneWidget);
      testTripPayload.expensesByCategory?.forEach((category) {
        expect(find.text("${category.category.name[0]}${category.category.name.toLowerCase().substring(1)}"), findsOneWidget);
        expect(find.byIcon(getIconForCategory(category.category)), findsOneWidget);
        expect(find.text("\$${category.sum.amount}"), findsAtLeast(1));
      });
    });

    testWidgets('displays edit screen on click', (tester) async {
      final tripsState = AsyncValue.data(
        TripDetailsSuccess(testTripPayload)
      );

      await pumpTripDetailsScreen(tester, tripsState);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Trip Screen'), findsOneWidget);
    });

    testWidgets('displays trips screen on successful delete', (tester) async {
      final tripsState = AsyncValue.data(
        TripDetailsDeleteSuccess(MessagePayload(message: 'Successful'))
      );

      await pumpTripDetailsScreen(tester, tripsState);
      await tester.pumpAndSettle();

      expect(find.text('Trips Screen'), findsOneWidget);
    });
  });
}

class FakeTripDetailsScreenNotifier extends TripDetailsScreenNotifier {
  final AsyncValue<TripDetailsScreenState> tripsState;

  FakeTripDetailsScreenNotifier(this.tripsState);

  @override
  Future<TripDetailsScreenState> build(String id) async {
    state = tripsState;
    return tripsState.value!;
  }
}

