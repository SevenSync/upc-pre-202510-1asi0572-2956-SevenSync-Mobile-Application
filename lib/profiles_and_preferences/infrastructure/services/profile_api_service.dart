import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileApiService implements ProfileRepository {
  final _baseUrl = 'https://macetech.azurewebsites.net';

  @override
  Future<UserProfileEntity> getProfile(String token, String uid) async {
    final profileResponse = await http.get(
      Uri.parse('$_baseUrl/api/profiles/get'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final userResponse = await http.get(
      Uri.parse('$_baseUrl/api/users/$uid'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (profileResponse.statusCode == 200 && userResponse.statusCode == 200) {
      final profile = jsonDecode(profileResponse.body);
      final user = jsonDecode(userResponse.body);

      return UserProfileEntity(
        fullName: profile['fullName'] ?? '',
        phoneNumber: profile['phoneNumber'] ?? '',
        address: profile['streetAddress'] ?? '',
        email: user['email'] ?? '',
      );
    } else {
      throw Exception("No se pudo cargar el perfil");
    }
  }

  @override
  Future<bool> updateProfile(Map<String, dynamic> data, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/profiles/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  @override
  Future<bool> changePassword(String newPassword, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/users/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'newPassword': newPassword}),
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> deleteAccount(String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/users/delete-account'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      final result = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      return result['deleted'] == true || response.statusCode == 204;
    }

    return false;
  }
}
