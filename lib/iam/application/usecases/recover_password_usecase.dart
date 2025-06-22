import '../../domain/value_objects/email_vo.dart';
import '../../domain/interfaces/password_repository.dart';

class RecoverPasswordUseCase {
  final PasswordRepository repository;

  RecoverPasswordUseCase(this.repository);

  Future<bool> execute(String rawEmail) async {
    final email = Email(rawEmail.trim());
    return await repository.recoverPassword(email);
  }
}
