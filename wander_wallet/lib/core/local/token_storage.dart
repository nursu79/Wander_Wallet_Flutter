import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: 'access_token');

    return token;
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: 'refresh_token');
    
    return token;
  }

  Future<void> clear() async {
    _storage.deleteAll();
  }
}
