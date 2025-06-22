import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<bool> register(UserEntity user);
}
