import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/usecases/create_profile_usecase.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../infrastructure/services/profile_api_service.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final countryCodeController = TextEditingController(text: '+51');
  final phoneNumberController = TextEditingController();

  late final CreateProfileUseCase _createProfileUseCase;

  @override
  void initState() {
    super.initState();
    _createProfileUseCase = CreateProfileUseCase(ProfileApiService());
  }

  Future<void> _handleCreateProfile() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesión no válida')),
        );
        return;
      }

      final addressParts = addressController.text.trim().split(',');
      final streetAndNumber = addressParts[0].trim().split(' ');
      final city = addressParts.length > 1 ? addressParts[1].trim() : '';
      final postalCode = addressParts.length > 2 ? addressParts[2].trim() : '';

      final number = streetAndNumber.isNotEmpty ? streetAndNumber.removeLast() : '';
      final street = streetAndNumber.join(' ');

      final profile = UserProfileEntity(
        firstName: nameController.text.trim(),
        lastName: lastNameController.text.trim(),
        street: street,
        buildingNumber: number,
        city: city,
        postalCode: postalCode,
        country: "Perú",
        countryCode: countryCodeController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
      );

      try {
        final success = await _createProfileUseCase.execute(profile, token);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil creado con éxito')),
          );
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo crear el perfil')),
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
                    const SizedBox(height: 20),
                    const Text(
                      "Crear perfil",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF296244)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Ingresa tus datos personales para tu perfil",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    // Nombre
                    const Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'John',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Debe agregar un nombre válido' : null,
                    ),
                    const SizedBox(height: 20),

                    // Apellido
                    const Text("Apellido", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        hintText: 'Doe',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Debe agregar un apellido válido' : null,
                    ),
                    const SizedBox(height: 20),

                    // Dirección
                    const Text("Dirección", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        hintText: 'Av. Alameda Sur 560, Lima, 15067',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Debe agregar una dirección válida';
                        }
                        final parts = value.split(',');
                        if (parts.length < 3) {
                          return 'Formato: calle número, ciudad, postal';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Teléfono
                    const Text("Número de celular", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            controller: countryCodeController,
                            decoration: const InputDecoration(
                              hintText: '+51',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                            value == null || value.trim().isEmpty ? '' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                            controller: phoneNumberController,
                            decoration: const InputDecoration(
                              hintText: '123-456-789',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Debe agregar un número de celular válido';
                              }
                              final digits = value.replaceAll(RegExp(r'\D'), '');
                              if (digits.length < 7) {
                                return 'Número muy corto';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Botón Registrarse
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ECC71),
                        ),
                        onPressed: _handleCreateProfile ,
                        child: const Text("Crear Perfil"),
                      ),
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
