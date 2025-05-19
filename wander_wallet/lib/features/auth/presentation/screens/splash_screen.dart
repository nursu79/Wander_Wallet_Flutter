import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/core/widgets/texts.dart';
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
      next
        .when(
          data: (data) {
            if (data is SplashSuccess) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
            }
          },
          error: (error, stackTrace) {
            if (error is SplashError) {
              if (error.loggedOut) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            }
          },
          loading: () {}
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<SplashScreenState> state = ref.watch(splashProvider);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Image.asset(
                "images/wander_wallet_hero.png",
                height: 300,
                width: 300,
              ),
              SizedBox(height: 24),
              state.when(
                data: (res) => (res is SplashSuccess) ? Text('Welcome back, ${res.userPayload.user.username}', style: Theme.of(context).textTheme.bodySmall) : Text('Welcome to Wander Wallet', style: Theme.of(context).textTheme.bodySmall),
                error: (err, _) => (err is SplashError && err.loggedOut) ? Text('You are logged out', style: Theme.of(context).textTheme.bodySmall) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SmallErrorText(text: (err is SplashError ? err.messageError.message : err.toString())),
                    SizedBox(height: 8),
                    RectangularButton(
                      onPressed: () {
                        ref.read(splashProvider.notifier).refresh();
                      },
                      text: 'Retry'
                    ),
                  ],
                ),
                loading: () => CircularProgressIndicator()
              )
            ],
          )
        ),
      )
    );
  }
} 
