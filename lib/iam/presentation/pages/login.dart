import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../l10n/app_localizations.dart';
import '../../application/usecases/sign_in_user_usecase.dart';
import '../../infrastructure/services/auth_api_service.dart';
import '../../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  late final SignInUserUseCase _signInUserUseCase;

  String _lang = 'en'; // idioma por defecto

  @override
  void initState() {
    super.initState();
    _signInUserUseCase = SignInUserUseCase(AuthApiService());
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authData = await _signInUserUseCase.execute(
          emailController.text,
          passwordController.text,
        );

        final uid = authData['uid']!;
        final token = authData['token']!;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uid);
        await prefs.setString('token', token);

        final hasProfile = await _signInUserUseCase.checkIfUserHasProfile(token);

        if (hasProfile) {
          Navigator.pushReplacementNamed(context, '/pot');
        } else {
          Navigator.pushReplacementNamed(context, '/create-profile');
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
                      loc.loginWelcomeTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF296244),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      loc.loginWelcomeSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    Text(loc.loginEmailLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: loc.loginEmailLabelExample,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return loc.loginEmailMandatory;
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        return emailRegex.hasMatch(value) ? null : loc.loginEmailInvalid;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(loc.loginPasswordLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/recover'),
                          child: Text(loc.loginForgotPassword),
                        ),
                      ],
                    ),
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
                      validator: (value) =>
                      value == null || value.isEmpty ? loc.loginPasswordMandatory : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71)),
                        onPressed: _handleLogin,
                        child: Text(loc.loginButton, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/register'),
                          child: Text(
                            loc.loginSignup,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
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


