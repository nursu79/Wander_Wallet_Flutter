import 'package:dio/dio.dart';
import 'package:wander_wallet/core/constants/constants.dart'
    as Constants; // Renamed alias to avoid conflict
import 'package:wander_wallet/core/constants/api_constants.dart'; // Import ApiConstants
import 'package:wander_wallet/core/storage/token_storage.dart'; // Corrected import path

class DioClient {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  DioClient(this._dio, this._tokenStorage) {
    _dio
      ..options.baseUrl =
          Constants
              .baseUrl // Use baseUrl from constants.dart
      ..options.connectTimeout = const Duration(seconds: 30) // 30 seconds
      ..options.receiveTimeout = const Duration(seconds: 30) // 30 seconds
      ..options.responseType = ResponseType.json
      ..interceptors.add(
        InterceptorsWrapper(
          // Request Interceptor: Add token to headers
          onRequest: (options, handler) async {
            // Exclude auth endpoints from token requirement using ApiConstants
            if (options.path != ApiConstants.login &&
                options.path != ApiConstants.register &&
                options.path != ApiConstants.refreshToken) {
              final token =
                  await _tokenStorage.getToken(); // Corrected method call
              if (token != null && token.isNotEmpty) {
                // Added empty check
                print('DioClient Interceptor: Adding Authorization header');
                options.headers['Authorization'] = 'Bearer $token';
              } else {
                print(
                  'DioClient Interceptor: No token found or token is empty, not adding header',
                );
              }
            } else {
              print(
                'DioClient Interceptor: Auth endpoint, skipping token header',
              );
            }
            handler.next(options); // Continue with the request
          },

          // Response Interceptor: Handle success responses (optional for now)
          onResponse: (response, handler) {
            print(
              'DioClient Interceptor: Received response for: ${response.requestOptions.uri}',
            );
            print(
              'DioClient Interceptor: Response status code: ${response.statusCode}',
            );
            handler.next(response); // Continue with the response
          },

          // Error Interceptor: Handle errors (optional for now, repo handles DioException)
          onError: (DioException e, handler) {
            // You could add logic here to refresh token on 401 errors, etc.
            print('DioClient Interceptor: Error for: ${e.requestOptions.uri}');
            print('DioClient Interceptor: Error message: ${e.message}');
            handler.next(e); // Continue with the error
          },
        ),
      );
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String url, {dynamic data}) async {
    try {
      final Response response = await _dio.post(url, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Add other HTTP methods like put, delete, etc. as needed
}

// Note: Ensure this DioClient is used in your dependency injection setup (e.g., providers.dart)
// The current setup in providers.dart configures Dio and adds TokenInterceptor directly.
// You might need to adjust providers.dart to use this DioClient if you intend to use this class structure.
