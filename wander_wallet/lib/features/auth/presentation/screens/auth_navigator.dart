import 'package:flutter/material.dart';
import 'package:wander_wallet/features/auth/presentation/screens/login_screen.dart';
import 'package:wander_wallet/features/auth/presentation/screens/splash_screen.dart';
import 'package:wander_wallet/features/auth/presentation/screens/welcome_screen.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => SplashScreen());
  
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());

          case '/welcome':
            return MaterialPageRoute(builder: (_) => WelcomeScreen());

          default:
            return MaterialPageRoute(builder: (_) => SplashScreen());
        }
      },
    );
  }
}