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
      print(data['access_token']);
      return data['access_token'];
    }
    else{
      return null;
    }
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
        if (data is Map && data.containsKey('answer')) {
          return data['answer'].toString();
        }
      } catch (_) {
        // não é JSON ou não tem campo answer
      }
      return content;
    }

    print('Chat API retornou status ${response.statusCode}: ${response.body}');
    return null;
  }
}