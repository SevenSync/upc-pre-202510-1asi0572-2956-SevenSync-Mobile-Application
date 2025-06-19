import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/usecases/sign_in_user_usecase.dart';
import '../../infrastructure/services/auth_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const LoginPage(),
    );
  }
}
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
          Navigator.pushReplacementNamed(context, '/profile');
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

  @override
  Widget build(BuildContext context) {
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
                    const Icon(Icons.account_circle_outlined, size: 80),
                    const SizedBox(height: 10),
                    const Text(
                      "Bienvenido de nuevo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF296244),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Ingresa tus credenciales para acceder a tu cuenta",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    const Text('Correo electrónico', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'ejemplo@correo.com',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'El correo es obligatorio';
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        return emailRegex.hasMatch(value) ? null : 'Correo inválido';
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/recover'),
                          child: const Text("¿Olvidaste tu contraseña?"),
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
                      validator: (value) => value == null || value.isEmpty ? 'La contraseña es obligatoria' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71)),
                        onPressed: _handleLogin,
                        child: const Text("Iniciar Sesión", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Aún no tienes una cuenta? "),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            "Registrate",
                            style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w500),
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

