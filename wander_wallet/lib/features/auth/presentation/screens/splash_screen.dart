import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/constants/constants.dart';
import 'package:wander_wallet/features/auth/presentation/providers/splash_provider.dart';
import 'package:wander_wallet/features/auth/presentation/screens/auth_navigator.dart';
import 'package:wander_wallet/features/dashboard/presentation/screens/user_dashboard.dart';
import 'package:wander_wallet/features/auth/presentation/screens/welcome_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a timeout to prevent infinite loading
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        ref.read(splashProvider.notifier).refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final splashState = ref.watch(splashProvider);

    return splashState.when(
      data: (state) {
        if (state is SplashSuccess && state.isAuthenticated) {
          // Only go to dashboard if user is authenticated
          return UserDashboard();
        } else {
          // Navigate to welcome screen for non-authenticated users
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            );
          });
          return const SizedBox.shrink();
        }
      },
      loading:
          () => Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/wander_wallet_hero.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
          ),
      error: (error, stack) {
        // Navigate to welcome screen on error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          );
        });
        return const SizedBox.shrink();
      },
    );
  }
}
