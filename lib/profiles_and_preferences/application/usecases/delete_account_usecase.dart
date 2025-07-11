import '../../domain/interfaces/profile_repository.dart';

class DeleteAccountUseCase {
  final ProfileRepository repo;
  DeleteAccountUseCase(this.repo);

  Future<void> call() => repo.deleteAccount();
}