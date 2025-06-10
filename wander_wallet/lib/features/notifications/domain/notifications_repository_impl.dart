import 'package:dio/dio.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/features/notifications/data/notifications_remote_data_source.dart';
import 'package:wander_wallet/features/notifications/domain/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remote;

  NotificationsRepositoryImpl(this.remote);

  @override
  Future<Result<MessagePayload, MessageError>> deleteNotification(String id) async {
    try {
      final res = await remote.deleteNotification(id);
      final messagePayload = MessagePayload.fromJson(res.data);
      return Success(messagePayload);
    } on DioException catch (e) {
      if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: MessageError(message: 'Please check your internet connection and/or api address (in lib/core/constants/constants.dart) and make sure backend is running'),
          loggedOut: false
        );
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }

  @override
  Future<Result<NotificationsPayload, MessageError>> getNotifications() async {
    try {
      final res = await remote.getNotifications();
      final notificationsPayload = NotificationsPayload.fromJson(res.data);
      return Success(notificationsPayload);
    } on DioException catch (e) {
      if (e.response != null) {
        final messageError = MessageError.fromJson(e.response?.data);
        return Error(error: messageError, loggedOut: e.response?.statusCode == 401);
      } else {
        return Error(
          error: MessageError(message: 'Please check your internet connection and/or api address (in lib/core/constants/constants.dart) and make sure backend is running'),
          loggedOut: false
        );
      }
    } on Exception {
      final messageError = MessageError(message: 'An unexpected error occurred');
      return Error(error: messageError);
    }
  }

  
}