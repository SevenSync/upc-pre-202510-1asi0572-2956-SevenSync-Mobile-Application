import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/usecases/change_password_usecase.dart';
import '../../infrastructure/services/profile_api_service.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  late final ChangePasswordUseCase _changePasswordUseCase;

  @override
  void initState() {
    super.initState();
    _changePasswordUseCase = ChangePasswordUseCase(ProfileApiService());
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final success = await _changePasswordUseCase.execute(
        newPasswordController.text.trim(),
        token,
      );

      if (success) {
        await prefs.clear();
        if (!mounted) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña cambiada. Inicia sesión nuevamente.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo cambiar la contraseña.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cambiar contraseña"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: currentPasswordController,
              obscureText: _obscureCurrent,
              decoration: InputDecoration(
                labelText: 'Contraseña actual',
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
              ),
              validator: (value) =>
              value == null || value.isEmpty ? 'Ingresa tu contraseña actual' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: newPasswordController,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
              ),
              validator: (value) =>
              value != null && value.length >= 8 ? null : 'Mínimo 8 caracteres',
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (value) =>
              value == newPasswordController.text ? null : 'Las contraseñas no coinciden',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: isLoading ? null : () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: isLoading ? null : _handleChangePassword,
          child: isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Guardar"),
        ),
      ],
    );
  }
}
