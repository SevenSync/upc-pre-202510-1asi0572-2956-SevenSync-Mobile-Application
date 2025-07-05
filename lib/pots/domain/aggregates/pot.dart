import '../value_objects/sensor_data.dart';
import '../value_objects/health_status.dart'; 

// La entidad Pot es la RAÍZ de nuestro Agregado.
class Pot {
  final String _id;
  String _name;
  String _plantType;
  String _imageUrl;
  
  // La data de los sensores es parte del estado interno del agregado.
  SensorData _lastSensorData;
  // El historial también es parte del agregado.
  final List<SensorData> _sensorHistory;

  // Propiedades públicas (getters) para exponer el estado de forma segura.
  String get id => _id;
  String get name => _name;
  String get plantType => _plantType;
  String get imageUrl => _imageUrl;
  SensorData get lastSensorData => _lastSensorData;
  HealthStatus get healthStatus => _calculateHealthStatus();

  // Constructor
  Pot({
    required String id,
    required String name,
    required String plantType,
    required String imageUrl,
    required SensorData initialSensorData,
  })  : _id = id,
        _name = name,
        _plantType = plantType,
        _imageUrl = imageUrl,
        _lastSensorData = initialSensorData,
        _sensorHistory = [initialSensorData];

  // --- MÉTODOS DE NEGOCIO (Aquí está la magia de los Agregados) ---

  // En lugar de un setter, un método que encapsula la regla de negocio.
  void rename(String newName) {
    if (newName.isEmpty) {
      throw ArgumentError("El nombre de la maceta no puede estar vacío.");
    }
    _name = newName;
  }

  // Actualiza los datos de los sensores y mantiene el historial.
  void updateSensorData(SensorData newData) {
    _lastSensorData = newData;
    _sensorHistory.add(newData);
    // Aquí se podrían disparar eventos de dominio si, por ejemplo,
    // la humedad es críticamente baja.
  }

  // El método de negocio para regar. ES EL GUARDIÁN DE LAS REGLAS.
  void water() {
    // INVARIANTE: No regar si el tanque está casi vacío.
    if (_lastSensorData.waterTankLevel < 10.0) {
      throw DomainException("No se puede regar, el tanque de agua está casi vacío.");
    }
    // INVARIANTE: No regar si la tierra ya está muy húmeda.
    if (_lastSensorData.soilMoisture > 80.0) {
      throw DomainException("La tierra ya está suficientemente húmeda.");
    }

    // Si todas las reglas pasan, aquí se ejecutaría la lógica
    // que finalmente se traduce en un comando de hardware.
    // (El repositorio se encargará de la comunicación).
    print("Lógica de riego para la maceta $_id ejecutada dentro del agregado.");
  }

  // Lógica interna para calcular un estado derivado.
  HealthStatus _calculateHealthStatus() {
    if (_lastSensorData.soilMoisture < 20) {
      return HealthStatus.needsWater;
    }
    if (_lastSensorData.soilMoisture > 85) {
      return HealthStatus.overwatered;
    }
    return HealthStatus.healthy;
  }
}

// Excepción de dominio específica
class DomainException implements Exception {
  final String message;
  DomainException(this.message);
}