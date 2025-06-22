import 'app_exception.dart';

class ApiException extends AppException {
  ApiException({required super.message, super.prefix = "Error de API: "});
}

class ServerException extends ApiException {
  ServerException({required String message}) : super(message: message, prefix: "Error del Servidor: ");
}

class NotFoundException extends ApiException {
  NotFoundException({required String message}) : super(message: message, prefix: "No Encontrado: ");
}