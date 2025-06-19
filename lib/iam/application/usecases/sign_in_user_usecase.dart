import '../../domain/entities/user_credentials_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class SignInUserUseCase {
  final AuthRepository repository;

  SignInUserUseCase(this.repository);

  Future<Map<String, String>> execute(String email, String password) async {
    final credentials = UserCredentialsEntity(email: email, password: password);
    return await repository.signIn(credentials);
  }

  Future<bool> checkIfUserHasProfile(String token) async {
    return await repository.hasProfile(token);
  }
}
