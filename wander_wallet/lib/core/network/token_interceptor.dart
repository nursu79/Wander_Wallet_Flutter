import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class TokenInterceptor extends Interceptor {
  final TokenStorage storage;

  TokenInterceptor(this.storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('TokenInterceptor: Intercepting request to ${options.path}');
    final token = await storage.getAccessToken();
    print(
      'TokenInterceptor: Retrieved token: ${token != null ? "Token exists" : "No token"}',
    );

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      print('TokenInterceptor: Added Authorization header');
    } else {
      print(
        'TokenInterceptor: No token available, proceeding without Authorization header',
      );
    }

    print('TokenInterceptor: Request headers: ${options.headers}');
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('TokenInterceptor: Error occurred: ${err.message}');
    print('TokenInterceptor: Error response: ${err.response?.data}');
    super.onError(err, handler);
  }
}
