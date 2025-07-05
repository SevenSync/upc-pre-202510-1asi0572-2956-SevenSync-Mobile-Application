// Un enum simple como Value Object para el estado de salud.
enum HealthStatus {
  healthy('Saludable'),
  needsWater('Necesita Agua'),
  overwatered('Exceso de Agua');
  
  const HealthStatus(this.displayName);
  final String displayName;
}