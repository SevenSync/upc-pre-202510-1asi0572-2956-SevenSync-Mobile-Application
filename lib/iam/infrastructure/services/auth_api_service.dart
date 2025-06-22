import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user_credentials_entity.dart';
import '../../domain/interfaces/auth_repository.dart';

class AuthApiService implements AuthRepository {
  final String _baseUrl = 'https://macetech.azurewebsites.net';

  @override
  Future<Map<String, String>> signIn(UserCredentialsEntity credentials) async {
    final url = Uri.parse('$_baseUrl/api/users/sign-in');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': credentials.email.trim(),
        'password': credentials.password.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'uid': data['uid'],
        'token': data['token'],
      };
    } else {
      throw Exception('Credenciales inválidas');
    }
  }

  @override
  Future<bool> hasProfile(String token) async {
    final url = Uri.parse('$_baseUrl/api/profiles/has-profile');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['hasProfile'] == true;
    } else {
      throw Exception('Error al verificar perfil');
    }
  }
}
