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
    final res = await dio.get(ApiConstants.profile);
    return res;
  }

  Future<Response<dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    final res = await dio.post(
      ApiConstants.register,
      data: {'username': username, 'email': email, 'password': password},
    );
    return res;
  }
}
