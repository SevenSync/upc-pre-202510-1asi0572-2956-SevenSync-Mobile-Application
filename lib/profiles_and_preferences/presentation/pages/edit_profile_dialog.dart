import 'package:flutter/material.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/domain/entities/user_profile_entity.dart';
import '../../application/usecases/update_profile_usecase.dart';

class EditProfileDialog extends StatefulWidget {
  final UserProfileEntity profile;
  final UpdateProfileUseCase updateProfile;

  const EditProfileDialog({
    super.key,
    required this.profile,
    required this.updateProfile,
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

  @override
  void initState() {
    super.initState();
    final parts = widget.profile.fullName.split(" ");
    firstNameController = TextEditingController(text: parts.first);
    lastNameController = TextEditingController(text: parts.skip(1).join(" "));
    addressController = TextEditingController(text: widget.profile.address);
    phoneController = TextEditingController(text: widget.profile.phoneNumber);
  }

  Future<void> submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = UserProfileEntity(
      fullName: '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
      email: widget.profile.email,
      phoneNumber: phoneController.text.trim(),
      address: addressController.text.trim(),
    );

    try {
      await widget.updateProfile(updated);
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil actualizado con éxito")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Perfil'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(controller: firstNameController, decoration: const InputDecoration(labelText: 'Nombre')),
              TextFormField(controller: lastNameController, decoration: const InputDecoration(labelText: 'Apellido')),
              TextFormField(controller: addressController, decoration: const InputDecoration(labelText: 'Dirección')),
              TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: 'Teléfono')),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(onPressed: submitUpdate, child: const Text('Guardar')),
      ],
    );
  }
}
