import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wander_wallet/core/constants/api_constants.dart';

class AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSource(this.dio);

  Future<Response<dynamic>> login(String email, String password) async {
    print(
      'AuthRemoteDataSource: Making login request to ${ApiConstants.login}',
    );
    print('AuthRemoteDataSource: Request data: email=$email, password=****');

    try {
      final res = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => true, // Don't throw on any status code
        ),
      );

      print('AuthRemoteDataSource: Response status: ${res.statusCode}');
      print('AuthRemoteDataSource: Response headers: ${res.headers}');
      print('AuthRemoteDataSource: Response data: ${res.data}');

      return res;
    } catch (e) {
      print('AuthRemoteDataSource: Error during login request: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> getProfile() async {
    print(
      'AuthRemoteDataSource: Making profile request to ${ApiConstants.profile}',
    );
    try {
      final res = await dio.get(
        ApiConstants.profile,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }, // Don't throw on any status code
        ),
      );

      print('AuthRemoteDataSource: Profile response status: ${res.statusCode}');
      print('AuthRemoteDataSource: Profile response headers: ${res.headers}');
      print('AuthRemoteDataSource: Profile response data: ${res.data}');

      return res;
    } catch (e) {
      print('AuthRemoteDataSource: Error during profile request: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> register(
    String username,
    String email,
    String password,
    File? avatar
  ) async {
    print(
      'AuthRemoteDataSource: Making register request to ${ApiConstants.register}',
    );
    try {
      final formData = FormData.fromMap({
        'username': username,
        'email': email,
        'password': password,
        'role': 'user', // Default role is user
        if (avatar != null) 'avatar': await MultipartFile.fromFile(avatar.path, contentType: DioMediaType.parse('image/jpeg')),
      });
    
      final res = await dio.post(
        ApiConstants.register,
        data: formData
      );

      print(
        'AuthRemoteDataSource: Register response status: ${res.statusCode}',
      );
      print('AuthRemoteDataSource: Register response headers: ${res.headers}');
      print('AuthRemoteDataSource: Register response data: ${res.data}');

      return res;
    } catch (e) {
      print('AuthRemoteDataSource: Error during register request: $e');
      rethrow;
    }
  }

  // New method for admin to promote users
  Future<Response<dynamic>> promoteToAdmin(String userId) async {
    print(
      'AuthRemoteDataSource: Making promote to admin request for user $userId',
    );
    try {
      final res = await dio.post(
        '${ApiConstants.admin}/promote',
        data: {'userId': userId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => true,
        ),
      );

      print('AuthRemoteDataSource: Promote response status: ${res.statusCode}');
      print('AuthRemoteDataSource: Promote response headers: ${res.headers}');
      print('AuthRemoteDataSource: Promote response data: ${res.data}');

      return res;
    } catch (e) {
      print('AuthRemoteDataSource: Error during promote request: $e');
      rethrow;
    }
  }
}
