import '../../domain/repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<bool> execute(String newPassword, String token) {
    return repository.changePassword(newPassword, token);
  }
}
