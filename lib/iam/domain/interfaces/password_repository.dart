import '../value_objects/email_vo.dart';

abstract class PasswordRepository {
  Future<bool> recoverPassword(Email email);
}
