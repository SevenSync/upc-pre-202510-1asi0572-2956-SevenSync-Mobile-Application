import '../../domain/entities/user_profile_entity.dart';
import '../../domain/interfaces/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repo;
  GetProfileUseCase(this.repo);
  Future<UserProfileEntity> call() => repo.getProfile();
}