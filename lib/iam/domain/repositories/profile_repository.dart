import '../entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<bool> createProfile(UserProfileEntity profile, String token);
}
