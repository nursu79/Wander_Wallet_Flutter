import 'package:flutter/material.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';

class NotificationCard extends StatelessWidget {
  final TripNotification notification;
  final VoidCallback onDismiss;
  const NotificationCard({super.key, required this.notification, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          children: [
            Text("The budget for '${notification.trip?.name}' was exceeded by ${notification.surplus}"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  RectangularButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/tripDetails', arguments: notification.tripId);
                    },
                    text: 'View',
                  ),
                  RectangularButton(
                    onPressed: onDismiss,
                    text: 'Dismiss',
                    color: theme.colorScheme.error,
                    textColor: theme.colorScheme.onError,
                  )
                ],
              ),
            )
          ],
        )
      )
    );
  }
}