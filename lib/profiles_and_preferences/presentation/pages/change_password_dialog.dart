import 'package:flutter/material.dart';
import '../../application/usecases/change_password_usecase.dart';
import '../../application/usecases/sign_out_usecase.dart';

class ChangePasswordDialog extends StatefulWidget {
  final ChangePasswordUseCase changePassword;
  final SignOutUseCase signOut;

  const ChangePasswordDialog({
    super.key,
    required this.changePassword,
    required this.signOut,
  });

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final currentPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await widget.changePassword(newPasswordController.text.trim());
      await widget.signOut();

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacementNamed('/login');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña cambiada. Inicia sesión nuevamente.')),
      );
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
            // Actual
            TextFormField(
              controller: currentPasswordController,
              obscureText: obscureCurrent,
              decoration: InputDecoration(
                labelText: 'Contraseña actual',
                suffixIcon: IconButton(
                  icon: Icon(obscureCurrent ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscureCurrent = !obscureCurrent),
                ),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 10),

            // Nueva
            TextFormField(
              controller: newPasswordController,
              obscureText: obscureNew,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                suffixIcon: IconButton(
                  icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscureNew = !obscureNew),
                ),
              ),
              validator: (value) => value != null && value.length >= 8 ? null : 'Mínimo 8 caracteres',
            ),
            const SizedBox(height: 10),

            // Confirmar
            TextFormField(
              controller: confirmPasswordController,
              obscureText: obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                suffixIcon: IconButton(
                  icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                ),
              ),
              validator: (value) =>
              value == newPasswordController.text ? null : 'Las contraseñas no coinciden',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: isLoading ? null : submit,
          child: isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Guardar"),
        ),
      ],
    );
  }
}
