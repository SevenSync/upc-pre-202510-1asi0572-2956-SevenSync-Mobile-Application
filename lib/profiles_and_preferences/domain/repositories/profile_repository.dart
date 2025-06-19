import '../entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getProfile(String token, String uid);
  Future<bool> updateProfile(Map<String, dynamic> data, String token);
  Future<bool> changePassword(String newPassword, String token);
  Future<bool> deleteAccount(String token);
}
