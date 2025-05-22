import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/core/widgets/texts.dart';
import 'package:wander_wallet/features/auth/presentation/providers/splash_provider.dart';
import 'package:wander_wallet/features/auth/presentation/screens/login_screen.dart';
import 'package:wander_wallet/features/dashboard/presentation/screens/user_dashboard.dart';
import 'package:wander_wallet/features/admin/presentation/screens/admin_dashboard.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    ref.listenManual(splashProvider, (prev, next) {
      next.when(
        data: (data) {
          if (data is SplashSuccess) {
            // Navigate based on user role
            if (data.userPayload.user.role == 'admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => AdminDashboard()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => UserDashboard()),
              );
            }
          }
        },
        error: (error, stackTrace) {
          // If not authenticated, go to LoginScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        },
        loading: () {},
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashState = ref.watch(splashProvider);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          children: [
                            Hero(
                              tag: 'splash_logo',
                              child: Image.asset(
                                'images/wander_wallet_hero.png',
                                height: size.height * 0.25,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Wander Wallet',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                splashState.when(
                  data: (data) {
                    if (data is SplashError) {
                      return Column(
                        children: [
                          Text(
                            data.messageError.message ?? 'Something went wrong',
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          RectangularButton(
                            text: 'Retry',
                            onPressed: () {
                              ref.read(splashProvider.notifier).refresh();
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  error: (error, _) {
                    if (error is SplashError) {
                      return Column(
                        children: [
                          Text(
                            error.messageError.message ??
                                'Something went wrong',
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          RectangularButton(
                            text: 'Retry',
                            onPressed: () {
                              ref.read(splashProvider.notifier).refresh();
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading:
                      () => CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
