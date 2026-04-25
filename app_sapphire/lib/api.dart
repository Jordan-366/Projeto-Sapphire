import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://apiDoProfessor.com";

  Future<String?> login(String usuario, String senha) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario": usuario,
        "senha": senha,
      }),
    );

    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data['token'];
    }
    else{
      return null;
    }
  }
}