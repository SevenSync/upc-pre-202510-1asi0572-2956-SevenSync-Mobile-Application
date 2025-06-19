import 'package:macetech_mobile_app/profiles_and_preferences/domain/entities/user_profile_entity.dart';

import '../../domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repo;
  UpdateProfileUseCase(this.repo);

  Future<void> call(UserProfileEntity profile) => repo.updateProfile(profile);
}