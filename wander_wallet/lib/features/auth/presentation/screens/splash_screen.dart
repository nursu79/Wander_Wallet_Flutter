import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/features/auth/presentation/providers/splash_provider.dart';
import 'package:wander_wallet/features/auth/presentation/screens/login_screen.dart';
import 'package:wander_wallet/features/auth/presentation/screens/welcome_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({ super.key });

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(splashProvider, (prev, next) {
      next.whenData((data) {
        if (data is SplashSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => WelcomeScreen())
          );
        } else if (data is SplashError && data.loggedOut) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen())
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<SplashScreenState> state = ref.watch(splashProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Image.asset(
              "images/wander_wallet_hero.png",
              height: 400,
              width: 400,
            ),
            SizedBox(height: 24),
            state.when(
              data: (_) => Text('Redirecting...', style: Theme.of(context).textTheme.bodySmall),
              error: (_, _) => Text('An unknown error occurred'),
              loading: () => CircularProgressIndicator()
            )
          ],
        )
      )
    );
  }
} 
