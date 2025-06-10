import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';

abstract class NotificationsRepository {
  Future<Result<NotificationsPayload, MessageError>> getNotifications();
  Future<Result<MessagePayload, MessageError>> deleteNotification(String id);
}