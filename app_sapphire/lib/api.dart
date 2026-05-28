import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://mobile-ios-login.zani0x03.eti.br/api/auth/login";
  final String chatUrl = "https://mobile-ios-ia.zani0x03.eti.br/api/ai/chat";

  Future<String?> login(String usuario, String senha) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": usuario,
        "password": senha,
        "sistemaId": "95bc4a2f-2fed-4aaf-81a5-3dc05b3dee6c"
      }),
    );

    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data['access_token'];
    }
    else{
      return null;
    }
  }

  Future<bool> register({
    required String name,
    required String surname,
    required String login,
    required String email,
    required String password,
    required String sistemaId,
  }) async {
    final response = await http.post(
      Uri.parse('https://mobile-ios-login.zani0x03.eti.br/api/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': name,
        'surname': surname,
        'login': login,
        'email': email,
        'password': password,
        'sistemaId': sistemaId,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<String?> chat(String prompt, String token) async {
    final response = await http.post(
      Uri.parse(chatUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"prompt": prompt}),
    );

    if (response.statusCode == 200) {
      final content = response.body;
      try {
        final data = jsonDecode(content);
        if (data is Map && data.containsKey('response')) {
          return data['response'].toString();
        }
      } catch (_) {
        // não é JSON ou não tem campo response
      }
      return content;
    }

    return null;
  }
}