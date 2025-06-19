import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<UserProfileEntity> execute(String token, String uid) {
    return repository.getProfile(token, uid);
  }
}
