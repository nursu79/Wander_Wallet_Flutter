import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final innerNavigator = ref.watch(innerNavigatorKeyProvider);
    return BottomAppBar(
      padding: EdgeInsets.all(0),
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () {
                innerNavigator.currentState?.pushNamed('/profile');
              },
            ),
            IconButton(
              icon: Icon(Icons.home, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () {
                innerNavigator.currentState?.pushNamed('/trips');
              },
            ),
            IconButton(
              icon: Icon(Icons.line_axis, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () {
                innerNavigator.currentState?.pushNamed('/summary');
              },
            )
          ],
        ),
      )
    );
  }
}