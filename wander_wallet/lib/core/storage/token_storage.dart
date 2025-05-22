import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage;

  TokenStorage(this._storage);

  Future<void> saveToken(String token) async {
    print('TokenStorage: Saving token...');
    await _storage.write(key: 'jwt_token', value: token);
    print('TokenStorage: Token saved.');
  }

  Future<String?> getToken() async {
    print('TokenStorage: Attempting to retrieve token...');
    final token = await _storage.read(key: 'jwt_token');
    print('TokenStorage: Retrieved token: $token');
    return token;
  }

  Future<void> deleteToken() async {
    print('TokenStorage: Deleting token...');
    await _storage.delete(key: 'jwt_token');
    print('TokenStorage: Token deleted.');
  }
}
