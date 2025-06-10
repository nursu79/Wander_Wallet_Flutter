import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/features/auth/presentation/providers/splash_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(splashProvider, (prev, next) {
      next.when(
        data: (data) {
          if (data is SplashSuccess && data.isAuthenticated) {
            if (data.userPayload.user.role == 'admin') {
              Navigator.pushNamed(context, '/admin_dashboard');
            } else {
              Navigator.pushNamed(context, '/user_dashboard');
            }
          } else {
            Navigator.pushNamed(context, '/welcome');
          }
        },
        error: (error, _) {
          if (error is SplashError && error.loggedOut) {
            Navigator.pushNamed(context, '/welcome');
          }
        },
        loading: () {}
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final splashState = ref.watch(splashProvider);
    final theme = Theme.of(context);

    return splashState.when(
      data: (_) {
        return const SizedBox.shrink();
      },
      loading:
          () => Scaffold(
            backgroundColor: theme.colorScheme.primary,
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
        if (error is SplashError && error.loggedOut) {
          return SizedBox.shrink();
        } else {
          return Scaffold(
            backgroundColor: theme.colorScheme.primary,
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
                  Text((error as SplashError).messageError.message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary
                  )),
                  const SizedBox(height: 12,),
                  RectangularButton(
                    onPressed: () {
                      ref.read(splashProvider.notifier).refresh();
                    },
                    text: 'Retry',
                    color: theme.colorScheme.onPrimary,
                    textColor: theme.colorScheme.primary,
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
