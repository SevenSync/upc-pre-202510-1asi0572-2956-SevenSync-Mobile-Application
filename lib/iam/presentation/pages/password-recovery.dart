import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../application/usecases/recover_password_usecase.dart';
import '../../infrastructure/services/password_api_service.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final RecoverPasswordUseCase _recoverPasswordUseCase;

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
            const SnackBar(content: Text('Correo enviado correctamente')),
          );
          Navigator.pushNamed(context, '/recovery-sent');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo enviar el correo')),
          );
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
                    const Icon(Icons.account_circle_outlined, size: 80),
                    const SizedBox(height: 30),
                    const Text(
                      "Recuperar contraseña",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF296244),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "No te preocupes, te ayudaremos a\nrecuperar tu cuenta\nIntroduce tu correo electrónico para\nrecibir instrucciones",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Correo electrónico',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'ejemplo@correo.com',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'El correo es obligatorio';
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        return emailRegex.hasMatch(value) ? null : 'Formato de correo inválido';
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
                        child: const Text("Siguiente"),
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
