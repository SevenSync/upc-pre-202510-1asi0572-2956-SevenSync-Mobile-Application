import '../../domain/entities/user_entity.dart';
import '../../domain/interfaces/user_repository.dart';

class RegisterUserUseCase {
  final UserRepository repository;

  RegisterUserUseCase(this.repository);

  Future<bool> execute(String email, String password) async {
    final user = UserEntity(email: email, password: password);
    return await repository.register(user);
  }
}
