import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/interfaces/profile_repository.dart';

class ProfileApiService {
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<String> _getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') ?? '';
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('https://macetech.azurewebsites.net/api/v1/profiles/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) throw Exception('Error al obtener perfil');
    return jsonDecode(response.body);
  }

  Future<String> fetchEmail() async {
    final token = await _getToken();
    final uid = await _getUid();
    final response = await http.get(
      Uri.parse('https://macetech.azurewebsites.net/api/v1/users/$uid'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) throw Exception('Error al obtener email');
    final body = jsonDecode(response.body);
    return body['email'] ?? '';
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('https://macetech.azurewebsites.net/api/v1/profilees/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al actualizar perfil');
    }
  }

  Future<void> changePassword(String newPassword) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('https://macetech.azurewebsites.net/api/users/change-password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({ 'newPassword': newPassword }),
    );

    if (response.statusCode != 200) throw Exception('Error al cambiar contraseña');
  }

  Future<void> deleteAccount() async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('https://macetech.azurewebsites.net/api/users/delete-account'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar cuenta');
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('https://macetech.azurewebsites.net/api/users/sign-out'),
      headers: { 'Authorization': 'Bearer $token' },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al cerrar sesión');
    }

    await prefs.clear();
  }
}

