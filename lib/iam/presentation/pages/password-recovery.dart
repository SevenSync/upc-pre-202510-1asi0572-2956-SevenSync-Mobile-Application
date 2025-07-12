import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../application/usecases/recover_password_usecase.dart';
import '../../infrastructure/services/password_api_service.dart';
import '../../../main.dart'; // para usar MyApp.setLocale

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final RecoverPasswordUseCase _recoverPasswordUseCase;
  String _lang = 'en';

  @override
  void initState() {
    super.initState();
    _recoverPasswordUseCase = RecoverPasswordUseCase(PasswordApiService());
  }

  Future<void> _handleRecovery() async {
    if (_formKey.currentState!.validate()) {
      try {
        final success = await _recoverPasswordUseCase.execute(emailController.text);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.passwordResetSuccessTitle)),
          );
          Navigator.pushNamed(context, '/recovery-sent');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.passwordResetEmailInvalid)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _languageToggle(),
                    const Icon(Icons.account_circle_outlined, size: 80),
                    const SizedBox(height: 30),
                    Text(
                      loc.passwordResetTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF296244),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      loc.passwordResetSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    Text(loc.loginEmailLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: loc.passwordResetEmailLabelExample,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return loc.passwordResetEmailMandatory;
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        return emailRegex.hasMatch(value)
                            ? null
                            : loc.loginEmailInvalid;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ECC71),
                        ),
                        onPressed: _handleRecovery,
                        child: Text(loc.passwordResetButton),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
