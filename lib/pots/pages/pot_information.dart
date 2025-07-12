import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// MODELO DE DATOS  (sustituye por tu entidad o provider)
/// ---------------------------------------------------------------------------
class SmartPot {
  final String name;
  final double humidity;      // %
  final double light;         // kLux
  final double temperature;   // °C
  final double ph;            // pH
  final double salinity;      // dS/m
  final double battery;       // 0-100 %
  final String location;
  final String model;
  final String serial;

  const SmartPot({
    required this.name,
    required this.humidity,
    required this.light,
    required this.temperature,
    required this.ph,
    required this.salinity,
    required this.battery,
    required this.location,
    required this.model,
    required this.serial,
  });
}

/// ---------------------------------------------------------------------------
/// PANTALLA PRINCIPAL
/// ---------------------------------------------------------------------------
class PotInformationPage extends StatefulWidget {
  const PotInformationPage({super.key, required this.pot});
  final SmartPot pot;

  @override
  State<PotInformationPage> createState() => _PotInformationPageState();
}

class _PotInformationPageState extends State<PotInformationPage> {
  bool _watering = false;

  /* ------------------------------ ACCIONES -------------------------------- */

  Future<void> _waterNow() async {
    setState(() => _watering = true);

    // ⇢ Simulación de llamada a tu backend (reemplázalo por la real)
    await Future.delayed(const Duration(seconds: 2));
    final bool ok = true; // ← respuesta simulada
    // ----------------------------------------------------------------------

    if (mounted) {
      setState(() => _watering = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Riego exitoso' : 'Falla al regar'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showPlantInfo() {
    showDialog(
      context: context,
      builder: (_) => _PlantInfoDialog(onDelete: _showDeleteConfirm),
    );
  }

  void _showDeleteConfirm() {
    Navigator.pop(context); // cierra info
    showDialog(context: context, builder: (_) => const _DeleteConfirmDialog());
  }

  /* ------------------------------- UI ------------------------------------ */

  @override
  Widget build(BuildContext context) {
    final pot = widget.pot;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// ENCABEZADO
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      pot.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, size: 28),
                    onPressed: _showPlantInfo,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              /// IMAGEN (placeholder)
              const Icon(Icons.local_florist, size: 120),
              const SizedBox(height: 16),

              /// BOTÓN REGAR
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  icon: _watering
                      ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.water_drop_outlined),
                  label: Text(_watering ? 'Regando…' : 'Regar ahora'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  onPressed: _watering ? null : _waterNow,
                ),
              ),
              const SizedBox(height: 24),

              /// HUMEDAD
              _BigMetricCard(
                icon: Icons.water_drop_outlined,
                label: 'Humedad',
                value: '${pot.humidity.toStringAsFixed(0)}% (vol%)',
                progress: pot.humidity / 100,
                optimal: 'Óptimo: 40-60 % (vol%)',
                color: Colors.blue,
              ),
              const SizedBox(height: 16),

              /// SCROLLER DE 4 TARJETAS (nuevo)
              _metricsScroller(pot),
              const SizedBox(height: 24),

              /// DATOS DE LA MACETA
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Datos de la maceta:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _DataRow('Ubicación', pot.location),
                    _DataRow('Modelo', pot.model),
                    _DataRow('Número de serie', pot.serial),
                    const SizedBox(height: 12),
                    Text('Nivel de batería',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: pot.battery / 100,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation(Colors.green),
                    ),
                    const SizedBox(height: 4),
                    Text('${pot.battery.toStringAsFixed(0)} %',
                        textAlign: TextAlign.right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// SCROLLER HORIZONTAL DE MÉTRICAS
/// ---------------------------------------------------------------------------
Widget _metricsScroller(SmartPot pot) {
  const double cardWidth = 155;

  return Column(
    children: [
      SizedBox(
        height: 155,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 4, right: 12),
          child: Row(
            children: [
              _MetricCard(
                icon: Icons.wb_sunny_outlined,
                label: 'Luz',
                value: '${pot.light.toStringAsFixed(1)} kLux',
                progress: pot.light / 10,
                optimal: 'Óptimo: 7-10 kLux',
                color: Colors.orange,
                width: cardWidth,
              ),
              _MetricCard(
                icon: Icons.thermostat_outlined,
                label: 'Temperatura',
                value: '${pot.temperature.toStringAsFixed(0)} °C',
                progress: (pot.temperature - 10) / 20,
                optimal: 'Óptimo: 18-27 °C',
                color: Colors.red,
                width: cardWidth,
              ),
              _MetricCard(
                icon: Icons.science_outlined,
                label: 'Acidez',
                value: '${pot.ph.toStringAsFixed(1)} pH',
                progress: (pot.ph - 5.5) / 1.5,
                optimal: 'Óptimo: 5.5-7.0 pH',
                color: Colors.teal,
                width: cardWidth,
              ),
              _MetricCard(
                icon: Icons.grass_outlined,
                label: 'Salinidad',
                value: '${pot.salinity.toStringAsFixed(1)} dS/m',
                progress: pot.salinity / 1.2,
                optimal: 'Óptimo: ≤ 1.2 dS/m',
                color: Colors.teal,
                width: cardWidth,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 8),
      /// Indicadores decorativos
      Container(height: 6, color: Colors.black),
      Container(height: 6, color: Colors.grey.shade300),
    ],
  );
}

/// ---------------------------------------------------------------------------
/// WIDGETS PEQUEÑOS
/// ---------------------------------------------------------------------------
class _BigMetricCard extends StatelessWidget {
  const _BigMetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.progress,
    required this.optimal,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final double progress;
  final String optimal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 4),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(color),
          ),
          const SizedBox(height: 4),
          Text(optimal, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.progress,
    required this.optimal,
    required this.color,
    this.width = 155,
  });

  final IconData icon;
  final String label;
  final String value;
  final double progress;
  final String optimal;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color),
            const SizedBox(width: 4),
            Expanded(
              child: Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
          const SizedBox(height: 4),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 4,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(color),
          ),
          const SizedBox(height: 4),
          Text(optimal, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow(this.keyName, this.value);
  final String keyName;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
                text: '$keyName: ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// DIÁLOGOS: info + confirmación de borrado
/// ---------------------------------------------------------------------------
class _PlantInfoDialog extends StatelessWidget {
  const _PlantInfoDialog({required this.onDelete});
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 180),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Información de la planta:',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _InfoRow(Icons.calendar_today_outlined, 'Horario de riego:',
                  'Cada 5-7 días'),
              _InfoRow(Icons.wb_sunny_outlined, 'Exposición al sol:',
                  'Sombra parcial / Luz indirecta'),
              _InfoRow(Icons.water_drop_outlined, 'Humedad óptima:',
                  '40-60 %'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: onDelete,
                  child: const Text('Eliminar Maceta'),
                ),
              ),
            ]),
          ),
          Positioned(
            right: -8,
            top: -8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                    text: '$title\n',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: subtitle),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _DeleteConfirmDialog extends StatelessWidget {
  const _DeleteConfirmDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 180),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('¿Estás seguro?',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Esta acción eliminará tu cuenta de maceta permanentemente',
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // TODO:🔗 Llama a tu backend para eliminar la maceta.
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Maceta eliminada')),
                  );
                },
                child: const Text('Eliminar'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// EJEMPLO DE USO RÁPIDO (puedes borrarlo si ya navegas desde otra página)
/// ---------------------------------------------------------------------------
/*
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PotInformationPage(
      pot: const SmartPot(
        name: 'Monstera Deliciosa',
        humidity: 49,
        light: 9.9,
        temperature: 22,
        ph: 6.7,
        salinity: 1.1,
        battery: 72,
        location: 'Sala de estar',
        model: 'Smartpot Macetech v2.1',
        serial: 'MT-P-632',
      ),
    ),
  ));
}
*/
