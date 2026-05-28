import 'package:shared_preferences/shared_preferences.dart';

class AppRoute {
  static const String telaInicial = 'TelaInicial';
  static const String chatAI = 'ChatAI';
  static const String cadastroMidia = 'CadastroMidia';
}

class TokenStorage {
  static const String _tokenKey = 'token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _currentUserKey = 'current_user';
  static const String _lastRouteKey = 'last_route';
  static const Duration _tokenLifetime = Duration(hours: 24);

  Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryMillis = DateTime.now()
        .add(_tokenLifetime)
        .millisecondsSinceEpoch;
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_tokenExpiryKey, expiryMillis);
  }

  Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expiryMillis = prefs.getInt(_tokenExpiryKey);

    if (token == null || expiryMillis == null) {
      await clear();
      return null;
    }

    final expiry = DateTime.fromMillisecondsSinceEpoch(expiryMillis);
    if (DateTime.now().isAfter(expiry)) {
      await clear();
      return null;
    }

    return token;
  }

  Future<void> saveCurrentUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, user);
  }

  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  Future<void> saveLastRoute(String route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRouteKey, route);
  }

  Future<String?> getLastRoute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastRouteKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenExpiryKey);
    await prefs.remove(_currentUserKey);
    await prefs.remove(_lastRouteKey);
  }
}
