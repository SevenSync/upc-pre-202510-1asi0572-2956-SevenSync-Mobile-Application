import '../entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getProfile();
  Future<void> updateProfile(UserProfileEntity profile);
  Future<void> changePassword(String newPassword);
  Future<void> deleteAccount();
  Future<void> signOut();
}

