import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/features/expenses/presentation/providers/create_expense_provider.dart';
import 'package:wander_wallet/features/expenses/presentation/providers/edit_expense_provider.dart';
import 'package:wander_wallet/features/expenses/presentation/providers/expense_details_provider.dart';
import 'package:wander_wallet/features/expenses/presentation/screens/create_expense_screen.dart';
import 'package:wander_wallet/features/expenses/presentation/screens/edit_expense_screen.dart';
import 'package:wander_wallet/features/expenses/presentation/screens/expense_details_screen.dart';
import 'package:wander_wallet/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:wander_wallet/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:wander_wallet/features/summary/presentation/providers/summary_provider.dart';
import 'package:wander_wallet/features/summary/presentation/screens/summary_screen.dart';
import 'package:wander_wallet/features/trips/presentation/providers/edit_trip_provider.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trip_details_provider.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trips_provider.dart';
import 'package:wander_wallet/features/trips/presentation/screens/create_trip_screen.dart';
import 'package:wander_wallet/features/trips/presentation/screens/edit_trip_screen.dart';
import 'package:wander_wallet/features/trips/presentation/screens/trip_details_screen.dart';
import 'package:wander_wallet/features/trips/presentation/screens/trips_screen.dart';

import '../../trips/presentation/providers/create_trip_provider.dart';

class UserDashboardNavigatorObserver extends NavigatorObserver {
  final WidgetRef ref;

  UserDashboardNavigatorObserver(this.ref);

  @override
  void didPop(Route route, Route? previousRoute) {
    _updateTitleFromRoute(previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _updateTitleFromRoute(route);
    super.didPush(route, previousRoute);
  }

  void _updateTitleFromRoute(Route? route) {
    final name = route?.settings.name;
    if (name == null) return;

    final title = switch (name) {
      '/createTrip' => 'Create Trip',
      '/trips' => 'Trips',
      '/tripDetails' => 'Trip Details',
      '/editTrip' => 'Edit Trip',
      '/createExpense' => 'Add Expense',
      '/expenseDetails' => 'Expense',
      '/editExpense' => 'Edit Expense',
      '/notifications' => 'Notifications',
      '/summary' => 'Summary',
      '/profile' => 'Profile',
      _ => 'WanderWallet',
    };

    final provider = switch (name) {
      '/createTrip' => createTripProvider,
      '/trips' => tripsProvider,
      '/tripDetails' => tripDetailsProvider,
      '/editTrip' => editTripProvider,
      '/createExpense' => createExpenseProvider,
      '/expenseDetails' => expenseDetailsProvider,
      '/editExpense' => editExpenseProvider,
      '/notifications' => notificationsScreenProvider,
      '/summary' => summaryProvider,
      _ => tripsProvider,
    };

    Future.microtask(() {
      ref.read(screenTitleProvider.notifier).state = title;
      ref.invalidate(provider);
    });
  }
}

class UserDashboardNavigator extends ConsumerWidget {
  const UserDashboardNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Navigator(
      initialRoute: '/trips',
      key: ref.read(innerNavigatorKeyProvider),
      observers: [UserDashboardNavigatorObserver(ref)],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (settings.name) {
              case '/createTrip':
                return  const CreateTripScreen();
              case '/trips':
                return const TripsScreen();
              case '/tripDetails':
                final tripId = settings.arguments;
                return TripDetailsScreen(id: (tripId as String));
              case '/editTrip':
                final tripId = settings.arguments;
                return EditTripScreen(id: (tripId as String));
              case '/createExpense':
                final tripId = settings.arguments;
                return CreateExpenseScreen(tripId: (tripId as String));
              case '/expenseDetails':
                final map = (settings.arguments as Map);
                return ExpenseDetailsScreen(id: (map['id'] as String), tripId: (map['tripId'] as String));
              case '/editExpense':
                final id = settings.arguments;
                return EditExpenseScreen(id: (id as String));
              case '/notifications':
                return NotificationsScreen();
              case '/summary':
                return SummaryScreen();
              default:
                return const TripsScreen();
            }
          },
          settings: settings 
        );
      },
    );
  }
}