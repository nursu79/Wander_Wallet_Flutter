import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/features/auth/presentation/providers/admin_provider.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Management', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            if (adminState is AdminError)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  adminState.userError.message ?? 'An error occurred',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            if (adminState is AdminSuccess)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'User ${adminState.userPayload.user.username} promoted to admin successfully!',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            // TODO: Add a list of users that can be promoted
            // This will be implemented when we have the user list API
            const Center(child: Text('User list will be displayed here')),
          ],
        ),
      ),
    );
  }
}
