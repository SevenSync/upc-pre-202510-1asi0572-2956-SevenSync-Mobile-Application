// Un Value Object: inmutable y sin identidad propia. Representa una medición.
class SensorData {
  final double soilMoisture; // Porcentaje de humedad del suelo (ej: 55.5)
  final double temperature; // Grados Celsius (ej: 21.3)
  final double lightLevel; // Nivel de luz (ej: en lux)
  final double waterTankLevel; // Nivel del tanque de agua (ej: 80.0)
  final DateTime lastWatered; // Cuándo fue la última vez que se regó

  SensorData({
    required this.soilMoisture,
    required this.temperature,
    required this.lightLevel,
    required this.waterTankLevel,
    required this.lastWatered,
  });
}