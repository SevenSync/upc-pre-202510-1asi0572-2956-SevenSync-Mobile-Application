import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../../main.dart'; // Para MyApp.setLocale

class AddPotPage extends StatefulWidget {
  const AddPotPage({super.key});

  @override
  State<AddPotPage> createState() => _AddPotPageState();
}

class _AddPotPageState extends State<AddPotPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  bool _loading = false;
  String _lang = 'en';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    await Future.delayed(const Duration(seconds: 2));
    final bool ok = true;

    if (!mounted) return;

    setState(() => _loading = false);

    final loc = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? loc.potLinkSuccess : loc.potLinkFailure),
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _languageToggle(),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          loc.potLinkTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Icon(Icons.local_florist, size: 140, color: Colors.grey),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _label(loc.potLinkName),
                        _input(controller: _nameCtrl, validator: _requiredValidator),
                        const SizedBox(height: 16),
                        _label(loc.potLinkLocation),
                        _input(controller: _locationCtrl, validator: _requiredValidator),
                        const SizedBox(height: 16),
                        _label(loc.potLinkIdentifier),
                        _input(controller: _idCtrl, validator: _requiredValidator),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: _loading ? null : _submit,
                            child: _loading
                                ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                            )
                                : Text(loc.potLinkButton),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
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

  Widget _label(String text) => Text(
    text,
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
  );

  Widget _input({
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    final loc = AppLocalizations.of(context)!;
    return (value == null || value.trim().isEmpty) ? loc.fieldRequired : null;
  }
}
