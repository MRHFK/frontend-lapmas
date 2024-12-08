// lib/services/auth_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<bool> isLoggedIn() async {
    String? token = await _storage.read(key: 'token');
    return token != null;
  }
}
