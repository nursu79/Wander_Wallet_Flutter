import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/widgets/notification_card.dart';
import 'package:wander_wallet/features/notifications/presentation/providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({ super.key });

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(notificationsScreenProvider, (prev, next) {
      next.when(
        data: (data) {
          if (data is NotificationsScreenDeleteSuccess) {
            ref.read(notificationsScreenProvider.notifier).refresh();
          }
        },
        error: (error, _) {
          if (error is NotificationsScreenGetError) {
            if (error.loggedOut) {
              Navigator.pushNamed(context, '/login');
            }
          } else if (error is NotificationsScreenDeleteError) {
            if (error.loggedOut) {
              Navigator.pushNamed(context, '/login');
            }
          }
        }, 
        loading: () {}
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsScreenProvider);
    final theme = Theme.of(context);
    List<TripNotification> cachedNotifications = [];

    return notificationsState.when(
      data: (data) {
        if (data is NotificationsScreenGetSuccess) {
          final notifications = (data).notificationsPayload.notifications;
          cachedNotifications = notifications;

          return Padding(
            padding: EdgeInsets.all(16),
            child: (cachedNotifications.isEmpty) ? Center(child: Text("No notifications yet.")) : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onDismiss: () {
                    ref.read(notificationsScreenProvider.notifier).deleteNotification(notification.id);
                    ref.read(notificationsScreenProvider.notifier).refresh();
                  },
                );
              },
            ),
          );
        } else {
          return Center(
            child: Text('Notification Dismissed Successfully!'),
          );
        }
      },
      error: (error, _) {
        if (error is NotificationsScreenGetError) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(error.error.message, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error), textAlign: TextAlign.center),
                RectangularButton(
                  onPressed: () {
                    ref.read(notificationsScreenProvider.notifier).refresh();
                  },
                  text: 'Retry',
                )
              ],
            ),
          );
        } else if (error is NotificationsScreenDeleteError) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(error.error.message, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error), textAlign: TextAlign.center),
                SizedBox(height: 12),
                ListView.builder(
                  itemCount: cachedNotifications.length,
                  itemBuilder: (context, index) {
                    return NotificationCard(
                      notification: cachedNotifications[index],
                      onDismiss: () {
                        ref.read(notificationsScreenProvider.notifier).refresh();
                      },
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Text('An unexpected error occurred', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error), textAlign: TextAlign.center),
          );
        }
      },
      loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }
}
