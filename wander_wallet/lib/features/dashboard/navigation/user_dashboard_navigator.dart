import 'package:flutter/material.dart';
import 'package:wander_wallet/features/expenses/presentation/screens/create_expense_screen.dart';
import 'package:wander_wallet/features/expenses/presentation/screens/edit_expense_screen.dart';
import 'package:wander_wallet/features/expenses/presentation/screens/expense_details_screen.dart';
import 'package:wander_wallet/features/trips/presentation/screens/create_trip_screen.dart';
import 'package:wander_wallet/features/trips/presentation/screens/edit_trip_screen.dart';
import 'package:wander_wallet/features/trips/presentation/screens/trip_details_screen.dart';
import 'package:wander_wallet/features/trips/presentation/screens/trips_screen.dart';

class UserDashboardNavigator extends StatelessWidget {
  const UserDashboardNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/trips',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/createTrip':
            return MaterialPageRoute(builder: (_) => const CreateTripScreen());
          case '/trips':
            return MaterialPageRoute(builder: (_) => const TripsScreen());
          case '/tripDetails':
            return MaterialPageRoute(builder: (_) {
              final tripId = settings.arguments;
              return TripDetailsScreen(id: (tripId as String));
            });
          case '/editTrip':
            return MaterialPageRoute(builder: (_) {
              final tripId = settings.arguments;
              return EditTripScreen(id: (tripId as String));
            });
          case '/createExpense':
            return MaterialPageRoute(builder: (_) {
              final tripId = settings.arguments;
              return CreateExpenseScreen(tripId: (tripId as String));
            });
          case '/expenseDetails':
            return MaterialPageRoute(builder: (_) {
              final map = (settings.arguments as Map);
              return ExpenseDetailsScreen(id: (map['id'] as String), tripId: (map['tripId'] as String));
            });
          case '/editExpense':
            return MaterialPageRoute(builder: (_) {
              final id = settings.arguments;
              return EditExpenseScreen(id: (id as String));
            });
          default:
            return MaterialPageRoute(builder: (_) => const TripsScreen());
        }
      },
    );
  }
}