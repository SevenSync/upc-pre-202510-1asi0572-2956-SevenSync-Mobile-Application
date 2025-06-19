import '../../domain/repositories/profile_repository.dart';

class SignOutUseCase {
  final ProfileRepository repo;
  SignOutUseCase(this.repo);

  Future<void> call() => repo.signOut();
}
