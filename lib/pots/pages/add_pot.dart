import 'package:flutter/material.dart';

/// Pantalla “Vincula tu maceta”
/// Se abre desde el botón “Añadir maceta” y, cuando el backend confirma
/// la creación, hace `Navigator.pop(context)` mostrando un SnackBar de éxito.
class AddPotPage extends StatefulWidget {
  const AddPotPage({super.key});

  @override
  State<AddPotPage> createState() => _AddPotPageState();
}

class _AddPotPageState extends State<AddPotPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  /* ------------------------------------------------------------------ */
  /*                             ENVÍO                                  */
  /* ------------------------------------------------------------------ */
  Future<void> _submit() async {
    // Valida formulario
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // ⇢ Simulación de llamada a tu backend (reemplázala por la real) ⚙️
    await Future.delayed(const Duration(seconds: 2));
    final bool ok = true; // ← respuesta simulada
    // ------------------------------------------------------------------

    if (!mounted) return;

    setState(() => _loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vinculación exitosa ✅'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context); // vuelve a la lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo vincular la maceta ❌'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /* ------------------------------------------------------------------ */
  /*                              UI                                    */
  /* ------------------------------------------------------------------ */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  /// ENCABEZADO (flecha + título centrado)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Vincula tu maceta',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 48), // simula espacio del IconButton
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// ICONO GRANDE
                  const Icon(Icons.local_florist, size: 140, color: Colors.grey),
                  const SizedBox(height: 32),

                  /// FORMULARIO
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _label('Nombre'),
                        _input(
                          controller: _nameCtrl,
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 16),
                        _label('Ubicación'),
                        _input(
                          controller: _locationCtrl,
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 16),
                        _label('Identificador de la maceta'),
                        _input(
                          controller: _idCtrl,
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 32),

                        /// BOTÓN VINCULAR
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: _loading ? null : _submit,
                            child: _loading
                                ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 3, color: Colors.white),
                            )
                                : const Text('Vincular maceta'),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* -------------------------- HELPERS UI ---------------------------- */
  Widget _label(String text) => Text(text,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.bold));

  Widget _input(
      {required TextEditingController controller,
        required FormFieldValidator<String> validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  /// Validador genérico “campo obligatorio”
  String? _requiredValidator(String? value) =>
      (value == null || value.trim().isEmpty)
          ? 'Este campo no puede estar vacío'
          : null;
}

/* -------------------------------------------------------------------- */
/*               EJEMPLO DE USO RÁPIDO / TEST MANUAL                    */
/* -------------------------------------------------------------------- */
/*
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AddPotPage(),
  ));
}
*/
