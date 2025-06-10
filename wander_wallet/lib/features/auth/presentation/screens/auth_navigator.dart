import 'package:flutter/material.dart';
import 'package:wander_wallet/features/admin/presentation/screens/admin_dashboard.dart';
import 'package:wander_wallet/features/auth/presentation/screens/login_screen.dart';
import 'package:wander_wallet/features/auth/presentation/screens/main_content_screen.dart';
import 'package:wander_wallet/features/auth/presentation/screens/splash_screen.dart';
import 'package:wander_wallet/features/auth/presentation/screens/welcome_screen.dart';
import 'package:wander_wallet/features/auth/presentation/screens/signup_screen.dart';
import 'package:wander_wallet/features/dashboard/presentation/screens/user_dashboard.dart';
import 'package:wander_wallet/features/notifications/presentation/screens/notifications_screen.dart';

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
          
          // case '/main':
          //   return MaterialPageRoute(builder: (_) => MainContentScreen());

          case '/signup':
            return MaterialPageRoute(builder: (_) => SignupScreen());

          case '/user_dashboard':
            return MaterialPageRoute(builder: (_) => UserDashboard());
          
          case '/admin_dashboard':
            return MaterialPageRoute(builder: (_) => AdminDashboard());

          case '/notifications':
            return MaterialPageRoute(builder: (_) => NotificationsScreen());

          default:
            return MaterialPageRoute(builder: (_) => SplashScreen());
        }
      },
    );
  }
}
