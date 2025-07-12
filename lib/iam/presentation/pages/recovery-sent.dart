import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart'; // Para usar MyApp.setLocale

class RecoveryEmailSentPage extends StatefulWidget {
  const RecoveryEmailSentPage({super.key});

  @override
  State<RecoveryEmailSentPage> createState() => _RecoveryEmailSentPageState();
}

class _RecoveryEmailSentPageState extends State<RecoveryEmailSentPage> {
  String _lang = 'en';

  Widget _languageToggle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _languageToggle(),
                  const Icon(Icons.account_circle_outlined, size: 80),
                  const SizedBox(height: 30),
                  Text(
                    loc.passwordResetSuccessTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF296244),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    loc.passwordResetSuccessSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2ECC71),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(loc.passwordResetConfirmationTitle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
