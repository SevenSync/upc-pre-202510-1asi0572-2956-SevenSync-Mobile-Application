import 'package:flutter/material.dart';

import '../../common/widgets/navbar/app_bottom_nav_bar.dart';

class PotsPage extends StatelessWidget {
  const PotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pots = <PlantPot>[ // mock data
      const PlantPot(
        name: 'Fycus Lirata',
        lastWateredDays: 3,
        humidityPercent: 65,
        lightKlux: 22.5,
        imageUrl: "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1747403361-81X0RENBWpL.jpg",
      ),
      const PlantPot(
        name: 'Suculenta Echevaria',
        lastWateredDays: 6,
        humidityPercent: 45,
        lightKlux: 12.5,
        needsWater: true,
        imageUrl: "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1747403361-81X0RENBWpL.jpg",
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              sliver: SliverToBoxAdapter(
                child: _Header(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.builder(
                itemCount: pots.length + 1,
                itemBuilder: (context, index) {
                  if (index < pots.length) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PlantPotCard(pot: pots[index]),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32, top: 8),
                    child: const AddPotCard(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

/// Top title + subtitle.
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis macetas inteligentes',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Bienvenido, John Doe',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

/// Reusable model to keep sample concise.
class PlantPot {
  final String name;
  final int lastWateredDays; // days ago
  final int humidityPercent; // 0‑100
  final double lightKlux; // kLux
  final bool needsWater;
  final String? imageUrl; // can be null for placeholder

  const PlantPot({
    required this.name,
    required this.lastWateredDays,
    required this.humidityPercent,
    required this.lightKlux,
    this.needsWater = false,
    this.imageUrl,
  });
}

/// Card representing a single plant pot.
class PlantPotCard extends StatelessWidget {
  const PlantPotCard({super.key, required this.pot});
  final PlantPot pot;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Material(
      elevation: 2,
      borderRadius: borderRadius,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: pot.imageUrl == null
                  ? Container(
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.image, size: 48, color: Colors.black26)),
              )
                  : Image.network(pot.imageUrl!, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pot.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (pot.needsWater)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Necesita agua',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Última vez regada: Hace ${pot.lastWateredDays} días'),
                  const SizedBox(height: 12),

                  // Humidity
                  _LabeledProgress(
                    icon: Icons.opacity, // drop icon
                    label: 'Humedad',
                    value: pot.humidityPercent / 100,
                    trailing: '${pot.humidityPercent}% (vol%)',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),

                  // Light
                  _LabeledProgress(
                    icon: Icons.wb_sunny_outlined,
                    label: 'Luz',
                    value: (pot.lightKlux / 100).clamp(0.0, 1.0), // fake normalisation
                    trailing: '${pot.lightKlux.toStringAsFixed(2)} kLux',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green.shade700),
                      ),
                      child: const Text('Ver detalles'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Progress bar with icon + label + trailing value.
class _LabeledProgress extends StatelessWidget {
  const _LabeledProgress({
    required this.icon,
    required this.label,
    required this.value,
    required this.trailing,
    required this.color,
  });
  final IconData icon;
  final String label;
  final double value; // 0‑1
  final String trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(label),
            const Spacer(),
            Text(trailing),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          minHeight: 4,
          color: color,
          backgroundColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}

/// Special card at the end of the list inviting the user to add a new pot.
class AddPotCard extends StatelessWidget {
  const AddPotCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade300,
          child: Icon(Icons.eco, size: 40, color: Colors.green.shade700),
        ),
        const SizedBox(height: 20),
        Text(
          'Añadir nueva maceta',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Conecta una nueva maceta inteligente a\n tu colección',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _DummyAddPage()));
            },
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.green.shade700)),
            child: const Text('Añadir maceta'),
          ),
        ),
      ],
    );
  }
}

/// Placeholder page to navigate to when adding a pot.
class _DummyAddPage extends StatelessWidget {
  const _DummyAddPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva maceta')),
      body: const Center(child: Text('Aquí va el formulario de configuración.')),
    );
  }
}
