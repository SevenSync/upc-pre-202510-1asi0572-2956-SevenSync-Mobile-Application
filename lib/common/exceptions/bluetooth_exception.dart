import 'app_exception.dart';

class BluetoothException extends AppException {
  BluetoothException({required super.message, super.prefix = "Error de Bluetooth: "});
}

class DeviceNotFoundException extends BluetoothException {
  DeviceNotFoundException({required String message}) : super(message: message, prefix: "Dispositivo no encontrado: ");
}

class ConnectionFailedException extends BluetoothException {
  ConnectionFailedException({required String message}) : super(message: message, prefix: "Fallo la conexión: ");
}