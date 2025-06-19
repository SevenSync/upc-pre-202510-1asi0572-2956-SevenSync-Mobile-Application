import '../../domain/repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository repo;
  ChangePasswordUseCase(this.repo);

  Future<void> call(String newPassword) => repo.changePassword(newPassword);
}
