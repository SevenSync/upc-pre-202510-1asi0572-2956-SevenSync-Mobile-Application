import '../entities/user_credentials_entity.dart';

abstract class AuthRepository {
  Future<Map<String, String>> signIn(UserCredentialsEntity credentials);
  Future<bool> hasProfile(String token);
}
