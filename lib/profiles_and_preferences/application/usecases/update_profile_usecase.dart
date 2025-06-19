import '../../domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<bool> execute(Map<String, dynamic> data, String token) {
    return repository.updateProfile(data, token);
  }
}
