import 'package:flutter/material.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/features/auth/presentation/screens/login_screen.dart';
import 'package:wander_wallet/features/auth/presentation/screens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Welcome to\nWander Wallet',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your personal travel companion for managing expenses and exploring the world.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Hero(
                    tag: 'welcome_image',
                    child: Image.asset(
                      'images/wander_wallet_hero.png',
                      height: size.height * 0.35,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            RectangularButton(
                              text: 'Get Started',
                              fillWidth: true,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                            ),
                          ]
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            RectangularButton(
                              text: 'Sign in',
                              fillWidth: true,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              color: theme.colorScheme.surface,
                              textColor: theme.colorScheme.primary,
                            ),
                          ]
                        )
                      ],
                    ),
                  )
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
