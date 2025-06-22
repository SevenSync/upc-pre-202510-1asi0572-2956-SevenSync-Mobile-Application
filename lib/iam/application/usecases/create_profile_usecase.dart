import '../../domain/entities/user_profile_entity.dart';
import '../../domain/interfaces/profile_repository.dart';

class CreateProfileUseCase {
  final ProfileRepository repository;

  CreateProfileUseCase(this.repository);

  Future<bool> execute(UserProfileEntity profile, String token) {
    return repository.createProfile(profile, token);
  }
}
