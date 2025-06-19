import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/usecases/update_profile_usecase.dart';
import '../../infrastructure/services/profile_api_service.dart';


class EditProfileDialog extends StatefulWidget {
  final String fullName;
  final String address;
  final String phone;

  const EditProfileDialog({
    super.key,
    required this.fullName,
    required this.address,
    required this.phone,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;

  final _formKey = GlobalKey<FormState>();
  late final UpdateProfileUseCase _updateProfileUseCase;

  @override
  void initState() {
    super.initState();
    final nameParts = widget.fullName.split(' ');
    firstNameController = TextEditingController(text: nameParts.first);
    lastNameController = TextEditingController(text: nameParts.skip(1).join(' '));
    addressController = TextEditingController(text: widget.address);
    phoneController = TextEditingController(text: widget.phone);
    _updateProfileUseCase = UpdateProfileUseCase(ProfileApiService());
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final parts = addressController.text.split(',').map((e) => e.trim()).toList();
    final street = parts.isNotEmpty ? parts[0] : '';
    final number = parts.length > 1 ? parts[1] : '';
    final city = parts.length > 2 ? parts[2] : '';
    final postalCode = parts.length > 3 ? parts[3] : '';
    final country = parts.length > 4 ? parts[4] : '';

    final data = {
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "street": street,
      "number": number,
      "city": city,
      "postalCode": postalCode,
      "country": country,
      "countryCode": "+51",
      "phoneNumber": phoneController.text.trim()
    };

    try {
      final success = await _updateProfileUseCase.execute(data, token);
      if (!mounted) return;

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado con éxito')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo actualizar el perfil')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Perfil'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Nombre requerido' : null,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Apellido requerido' : null,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección completa',
                  hintText: 'Ej: Calle 123, Nro 45, Lima, 15000, Perú',
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Dirección requerida' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Teléfono requerido' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(onPressed: _handleUpdate, child: const Text('Guardar')),
      ],
    );
  }
}
