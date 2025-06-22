import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/interfaces/password_repository.dart';
import '../../domain/value_objects/email_vo.dart';

class PasswordApiService implements PasswordRepository {
  final String _baseUrl = 'https://macetech.azurewebsites.net';

  @override
  Future<bool> recoverPassword(Email email) async {
    final url = Uri.parse('$_baseUrl/api/users/password-recovery');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.value}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['sent'] == true;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
