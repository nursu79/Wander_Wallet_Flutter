import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';

sealed class NotificationsScreenState {
  NotificationsScreenState();
}

class NotificationsScreenGetSuccess extends NotificationsScreenState {
  final NotificationsPayload notificationsPayload;

  NotificationsScreenGetSuccess(this.notificationsPayload);
}

class NotificationsScreenDeleteSuccess extends NotificationsScreenState {
  final MessagePayload messagePayload;

  NotificationsScreenDeleteSuccess(this.messagePayload);
}

class NotificationsScreenGetError extends NotificationsScreenState {
  final MessageError error;
  final bool loggedOut;

  NotificationsScreenGetError(this.error, this.loggedOut);
}

class NotificationsScreenDeleteError extends NotificationsScreenState {
  final MessageError error;
  final bool loggedOut;

  NotificationsScreenDeleteError(this.error, this.loggedOut);
}

class NotificationsScreenNotifier extends AsyncNotifier<NotificationsScreenState> {
  NotificationsScreenNotifier();

  @override
  Future<NotificationsScreenState> build() async {
    final notificationsRepository = ref.read(notificationsRepositoryProvider);
    state = AsyncValue.loading();
    final res = await notificationsRepository.getNotifications();

    if (res is Success<NotificationsPayload, MessageError>) {
      return NotificationsScreenGetSuccess(res.data);
    } else {
      throw NotificationsScreenGetError(
        (res as Error).error,
        (res as Error).loggedOut
      );
    }
  }

  Future<void> refresh() async {
    final notificationsRepository = ref.read(notificationsRepositoryProvider);
    state = AsyncValue.loading();
    final res = await notificationsRepository.getNotifications();

    if (res is Success<NotificationsPayload, MessageError>) {
      state = AsyncValue.data(NotificationsScreenGetSuccess(res.data));
    } else {
      state = AsyncValue.error(
        NotificationsScreenGetError(
          (res as Error).error,
          (res as Error).loggedOut
        ),
        StackTrace.current
      );
    }
  }

  Future<void> deleteNotification(String id) async {
    final notificationsRepository = ref.read(notificationsRepositoryProvider);
    state = AsyncValue.loading();
    final res = await notificationsRepository.deleteNotification(id);

    if (res is Success<MessagePayload, MessageError>) {
      state = AsyncValue.data(NotificationsScreenDeleteSuccess(res.data));
    } else {
      state = AsyncValue.error(
        NotificationsScreenGetError(
          (res as Error).error,
          (res as Error).loggedOut
        ),
        StackTrace.current
      );
    }
  }
}

final notificationsScreenProvider = AsyncNotifierProvider<NotificationsScreenNotifier, NotificationsScreenState>(
  NotificationsScreenNotifier.new
);
