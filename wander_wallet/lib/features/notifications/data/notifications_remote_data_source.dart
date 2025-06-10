import 'package:dio/dio.dart';
import 'package:wander_wallet/core/constants/api_constants.dart';

class NotificationsRemoteDataSource {
  final Dio dio;

  NotificationsRemoteDataSource(this.dio);

  Future<Response<dynamic>> getNotifications() async {
    final res = await dio.get(ApiConstants.notifications);

    return res;
  }

  Future<Response<dynamic>> deleteNotification(String id) async {
    final res = await dio.delete(ApiConstants.getNotificationPath(id));
    
    return res;
  }
}