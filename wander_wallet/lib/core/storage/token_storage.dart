import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenStorage extends StateNotifier<String?> {
  final FlutterSecureStorage _storage;

  TokenStorage() : _storage = const FlutterSecureStorage(), super(null) {
    _init();
  }

  Future<void> _init() async {
    state = await getToken();
  }

  Future<void> saveToken(String token) async {
    print('TokenStorage: Saving token...');
    await _storage.write(key: 'jwt_token', value: token);
    state = token;
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
    state = null;
    print('TokenStorage: Token deleted.');
  }

  // Alias methods for backward compatibility
  Future<void> saveAccessToken(String token) => saveToken(token);
  Future<String?> getAccessToken() => getToken();
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> clear() async {
    await _storage.deleteAll();
    state = null;
  }
}
