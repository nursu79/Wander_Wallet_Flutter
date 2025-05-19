import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSource(this.dio);

  Future<Response<dynamic>> login(String email, String password) async {
    final res = dio.post('/login', data: {
      'email': email,
      'password': password
    });

    return res;
  }

  Future<Response<dynamic>> getProfile() async {
    final res = dio.get('/profile');

    return res;
  }
}
