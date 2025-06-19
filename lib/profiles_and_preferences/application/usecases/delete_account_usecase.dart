import '../../domain/repositories/profile_repository.dart';

class DeleteAccountUseCase {
  final ProfileRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<bool> execute(String token) {
    return repository.deleteAccount(token);
  }
}
