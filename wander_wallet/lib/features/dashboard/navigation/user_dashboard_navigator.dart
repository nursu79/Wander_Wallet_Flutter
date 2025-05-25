import 'package:flutter/material.dart';
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
          case '/trips':
            return MaterialPageRoute(builder: (_) => const TripsScreen());
          case '/tripDetails':
            return MaterialPageRoute(builder: (_) {
              final tripId = settings.arguments;
              return TripDetailsScreen(id: (tripId as String));
            });
          default:
            return MaterialPageRoute(builder: (_) => const TripsScreen());
        }
      },
    );
  }
}