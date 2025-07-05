import 'package:macetech_mobile_app/pots/domain/aggregates/pot.dart';
import 'package:macetech_mobile_app/pots/domain/value_objects/sensor_data.dart';

// El CONTRATO que la capa de infraestructura DEBE implementar.
// Define QUÉ se puede hacer, pero no CÓMO se hace.
abstract class IPotRepository {
  // Obtiene la lista de macetas desde la fuente de datos (API, DB local, etc.)
  Future<List<Pot>> getUserPots();

  // Se suscribe para recibir actualizaciones de sensores en tiempo real para una maceta.
  // Esto probablemente usará Bluetooth.
  Stream<SensorData> getRealTimeSensorData(String potId);

  // Envía el comando de riego a la maceta.
  Future<void> waterPot(String potId);

  // Escanea dispositivos Bluetooth cercanos para encontrar nuevas macetas.
  // Devuelve una lista de dispositivos encontrados que parecen ser nuestras macetas.
  Stream<Map<String, String>> scanForPots(); // Devuelve Map<deviceId, deviceName>

  // Registra una maceta escaneada en nuestra fuente de datos.
  Future<void> registerNewPot({required String deviceId, required String name, required String plantType});
}