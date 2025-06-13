import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  final _formKey = GlobalKey<FormState>(); // clave del formulario

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF3EF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Form( // ← Aquí va el Form
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

                    // Email
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El correo es obligatorio';
                        }
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Correo inválido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Contraseña
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Contraseña',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/recover');
                          },
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
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña es obligatoria';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Botón iniciar sesión
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ECC71),
                        ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final loginUrl = Uri.parse('https://macetech.azurewebsites.net/api/users/sign-in');

                                final response = await http.post(
                                  loginUrl,
                                  headers: {'Content-Type': 'application/json'},
                                  body: jsonEncode({
                                    'email': emailController.text.trim(),
                                    'password': passwordController.text.trim(),
                                  }),
                                );

                                debugPrint('Login Status: ${response.statusCode}');
                                debugPrint('Login Body: ${response.body}');

                                if (response.statusCode == 200) {
                                  final data = jsonDecode(response.body);
                                  final uid = data['uid'];
                                  final token = data['token'];

                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('uid', uid);
                                  await prefs.setString('token', token);

                                  // Verificar si ya tiene perfil
                                  final hasProfileUrl = Uri.parse('https://macetech.azurewebsites.net/api/profiles/has-profile');
                                  final profileResponse = await http.get(
                                    hasProfileUrl,
                                    headers: {
                                      'Content-Type': 'application/json',
                                      'Authorization': 'Bearer $token',
                                    },
                                  );

                                  debugPrint('Profile Status: ${profileResponse.statusCode}');
                                  debugPrint('Profile Body: ${profileResponse.body}');

                                  if (profileResponse.statusCode == 200) {
                                    final profileData = jsonDecode(profileResponse.body);
                                    final hasProfile = profileData['hasProfile'] == true;

                                    if (hasProfile) {
                                      Navigator.pushReplacementNamed(context, '/register');
                                    } else {
                                      Navigator.pushReplacementNamed(context, '/create-profile');
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Error al verificar el perfil')),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Credenciales inválidas')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                        child: const Text(
                          "Iniciar Sesión",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Link a registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Aún no tienes una cuenta? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            "Registrate",
                            style: TextStyle(
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

