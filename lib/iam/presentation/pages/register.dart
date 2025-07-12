import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../application/usecases/register_user_usecase.dart';
import '../../infrastructure/services/user_api_service.dart';
import '../../../main.dart'; // para usar MyApp.setLocale

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _lang = 'en';

  late final RegisterUserUseCase _registerUserUseCase;

  @override
  void initState() {
    super.initState();
    _registerUserUseCase = RegisterUserUseCase(UserApiService());
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        final success = await _registerUserUseCase.execute(
          emailController.text,
          passwordController.text,
        );
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.registerSuccessTitle)),
          );
          Navigator.pushNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.registerFailedTitle)),
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
      backgroundColor: const Color(0xFFEEF3EF),
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
                    const SizedBox(height: 10),
                    Text(
                      loc.registerTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF296244),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      loc.registerSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    Text(loc.loginEmailLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: loc.registerEmailLabelExample,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return loc.registerEmailMandatory;
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        return emailRegex.hasMatch(value)
                            ? null
                            : loc.loginEmailInvalid;
                      },
                    ),

                    const SizedBox(height: 20),
                    Text(loc.loginPasswordLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return loc.registerPasswordMandatory;
                        if (value.length < 8) return loc.registerPasswordInvalid;
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    Text(loc.registerPasswordConfirmLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return loc.registerPasswordConfirmMandatory;
                        if (value != passwordController.text) return loc.registerPasswordConfirmMandatory;
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ECC71),
                        ),
                        onPressed: _handleRegister,
                        child: Text(loc.registerButton),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(loc.registerLoginOption),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/login'),
                          child: Text(
                            loc.loginButton,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
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
