import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/interfaces/profile_repository.dart';

class ProfileApiService implements ProfileRepository {
  final String _baseUrl = 'https://macetech.azurewebsites.net';

  @override
  Future<bool> createProfile(UserProfileEntity profile, String token) async {
    final url = Uri.parse('$_baseUrl/api/profiles/create');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['created'] == true;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
