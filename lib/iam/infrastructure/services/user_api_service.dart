import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user_entity.dart';
import '../../domain/interfaces/user_repository.dart';

class UserApiService implements UserRepository {
  final String _baseUrl = 'https://macetech.azurewebsites.net';

  @override
  Future<bool> register(UserEntity user) async {
    final url = Uri.parse('$_baseUrl/api/v1/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': user.email.trim(),
        'password': user.password.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['created'] == true;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
