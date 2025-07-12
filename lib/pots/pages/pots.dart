import 'package:flutter/material.dart';
import '../../app_routes.dart';
import '../../common/widgets/navbar/app_bottom_nav_bar.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import 'add_pot.dart';

class PotsPage extends StatefulWidget {
  const PotsPage({super.key});

  @override
  State<PotsPage> createState() => _PotsPageState();
}

class _PotsPageState extends State<PotsPage> {
  String _lang = 'en';

  final pots = <PlantPot>[
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

  Widget _languageToggle() {
    return Align(
      alignment: Alignment.centerRight,
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(20),
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.green,
        fillColor: Colors.green.withOpacity(0.1),
        isSelected: [_lang == 'en', _lang == 'es'],
        onPressed: (index) {
          final newLang = index == 0 ? 'en' : 'es';
          final newLocale = Locale(newLang);
          setState(() => _lang = newLang);
          MyApp.setLocale(context, newLocale);
        },
        children: const [
          Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('En')),
          Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Es')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _languageToggle(),
                    const SizedBox(height: 16),
                    _Header(),
                  ],
                ),
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
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 32, top: 8),
                    child: AddPotCard(),
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

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.potsTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          loc.potsWelcome + 'John Doe',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class PlantPotCard extends StatelessWidget {
  const PlantPotCard({super.key, required this.pot});
  final PlantPot pot;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
                            loc.potsNeedsWater,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(loc.potsPotCardLastWatered + pot.lastWateredDays.toString()),
                  const SizedBox(height: 12),
                  _LabeledProgress(
                    icon: Icons.opacity,
                    label: loc.potsPotCardSoilMoisture,
                    value: pot.humidityPercent / 100,
                    trailing: '${pot.humidityPercent}% (vol%)',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _LabeledProgress(
                    icon: Icons.wb_sunny_outlined,
                    label: loc.potsPotCardEnvironmentLight,
                    value: (pot.lightKlux / 100).clamp(0.0, 1.0),
                    trailing: '${pot.lightKlux.toStringAsFixed(2)} kLux',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.potInfo, arguments: pot);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green.shade700),
                      ),
                      child: Text(loc.potsPotCardDetails),
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
  final double value;
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

class AddPotCard extends StatelessWidget {
  const AddPotCard({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
          loc.potsAddPotTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          loc.potsAddPotSubtitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPotPage()));
            },
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.green.shade700)),
            child: Text(loc.potsAddPotButton),
          ),
        ),
      ],
    );
  }
}

class PlantPot {
  final String name;
  final int lastWateredDays;
  final int humidityPercent;
  final double lightKlux;
  final bool needsWater;
  final String? imageUrl;

  const PlantPot({
    required this.name,
    required this.lastWateredDays,
    required this.humidityPercent,
    required this.lightKlux,
    this.needsWater = false,
    this.imageUrl,
  });
}
