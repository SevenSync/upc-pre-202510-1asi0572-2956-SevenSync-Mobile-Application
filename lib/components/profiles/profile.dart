import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool expandAccount = false;
  bool expandNotifications = false;
  bool expandBilling = false;

  bool wateringAlerts = false;
  bool sensorAlerts = false;
  bool weeklyReports = false;
  bool emailNotifications = false;

  String fullName = '';
  String phone = '';
  String address = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  // 🔹 Aquí va el paso 2 (función completa)
  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final uid = prefs.getString('uid') ?? '';

    // Obtener perfil
    final profileResponse = await http.get(
      Uri.parse('https://macetech.azurewebsites.net/api/profiles/get'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (profileResponse.statusCode == 200) {
      final profile = jsonDecode(profileResponse.body);
      setState(() {
        fullName = profile['fullName'] ?? '';
        phone = profile['phoneNumber'] ?? '';
        address = profile['streetAddress'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener datos del perfil')),
      );
    }

    // Obtener correo por UID
    final userResponse = await http.get(
      Uri.parse('https://macetech.azurewebsites.net/api/users/$uid'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (userResponse.statusCode == 200) {
      final user = jsonDecode(userResponse.body);
      setState(() {
        email = user['email'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener correo del usuario')),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('https://macetech.azurewebsites.net/api/users/sign-out'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('Logout status: ${response.statusCode}');

    // Aun si retorna 204 (sin cuerpo), se considera exitoso
    if (response.statusCode == 200 || response.statusCode == 204) {
      await prefs.remove('token');
      await prefs.remove('uid');
      await prefs.remove('email');

      if (!context.mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: ${response.statusCode}')),
      );
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Estás seguro?"),
        content: const Text("Esta acción eliminará tu cuenta de forma permanente."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.delete(
      Uri.parse('https://macetech.azurewebsites.net/api/users/delete-account'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      final result = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      if (result['deleted'] == true || response.statusCode == 204) {
        await prefs.clear();

        if (!context.mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cuenta eliminada con éxito")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudo eliminar la cuenta")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar cuenta: ${response.statusCode}")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF3EF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Mi Perfil", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    // backgroundImage: NetworkImage('url') si tienes imagen
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              email,
              style: const TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna de íconos
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.person, color: Colors.green, size: 20),
                      SizedBox(height: 16),
                      Icon(Icons.local_florist, color: Colors.green, size: 20),
                      SizedBox(height: 16),
                      Icon(Icons.eco, color: Colors.green, size: 20),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Columna de textos
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Miembro desde abril de 2025"),
                      SizedBox(height: 16),
                      Text("4 macetas activas"),
                      SizedBox(height: 16),
                      Text("Plan gratuito"),
                    ],
                  ),
                ],
              ),
            ),


            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Acción premium
                },
                icon: const Icon(Icons.workspace_premium_outlined, color: Colors.white),
                label: const Text("Actualizar a Premium"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Acción Términos
                },
                icon: const Icon(Icons.description_outlined, color: Colors.green),
                label: const Text(
                  "Términos y Condiciones",
                  style: TextStyle(color: Colors.green),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // CUENTA
            ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                setState(() {
                  expandAccount = !expandAccount;
                });
              },
              children: [
                ExpansionPanel(
                  isExpanded: expandAccount,
                  headerBuilder: (_, __) => const ListTile(
                    title: Text("Cuenta", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow("Nombre completo:", fullName),
                        _infoRow("Correo electrónico:", email),
                        _infoRow("Número de celular:", phone),
                        _infoRow("Dirección:", address),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const ChangePasswordDialog(),
                                  );
                                },
                                icon: const Icon(Icons.lock_outline),
                                label: const Text("Cambiar Contraseña"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => EditProfileDialog(
                                      fullName: fullName,
                                      address: address,
                                      phone: phone,
                                    ),
                                  );
                                  loadProfileData();
                                },
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text("Editar Perfil"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 10),

            // NOTIFICACIONES
            ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                setState(() {
                  expandNotifications = !expandNotifications;
                });
              },
              children: [
                ExpansionPanel(
                  isExpanded: expandNotifications,
                  headerBuilder: (_, __) => const ListTile(
                    title: Text("Notificaciones", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        _notificationOption(
                          title: "Alertas de riego",
                          description: "Recibe notificaciones cuando tus plantas necesiten agua",
                          value: wateringAlerts,
                          onChanged: (val) => setState(() => wateringAlerts = val),
                        ),
                        _notificationOption(
                          title: "Alertas de sensores",
                          description: "Recibe notificaciones cuando los sensores detecten condiciones anormales",
                          value: sensorAlerts,
                          onChanged: (val) => setState(() => sensorAlerts = val),
                        ),
                        _notificationOption(
                          title: "Reportes semanales",
                          description: "Recibe resúmenes semanales de cada una de tus plantas",
                          value: weeklyReports,
                          onChanged: (val) => setState(() => weeklyReports = val),
                        ),
                        _notificationOption(
                          title: "Notificaciones por correo",
                          description: "Recibe todas las notificaciones también por correo electrónico",
                          value: emailNotifications,
                          onChanged: (val) => setState(() => emailNotifications = val),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 10),

            // FACTURACIÓN
            ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                setState(() {
                  expandBilling = !expandBilling;
                });
              },
              children: [
                ExpansionPanel(
                  isExpanded: expandBilling,
                  headerBuilder: (_, __) => const ListTile(
                    title: Text("Facturación", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Plan actual",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.eco, size: 36, color: Colors.green),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Plan gratuito", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Funcionalidades básicas"),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // lógica para actualizar plan
                                },
                                icon: const Icon(Icons.workspace_premium_outlined, color: Colors.white),
                                label: const Text("Actualizar"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber.shade600,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Funcionalidades",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("• Máximo de 4 macetas inteligentes"),
                                SizedBox(height: 4),
                                Text("• Monitoreo básico de sensores"),
                                SizedBox(height: 4),
                                Text("• Alertas de riego completas"),
                                SizedBox(height: 4),
                                Text("• Historial de datos hasta por 7 días"),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),


            const SizedBox(height: 20),

            // BOTONES FINALES
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => signOut(context),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Cerrar Sesión",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => deleteAccount(context),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  "Eliminar Cuenta",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // perfil
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: 'Macetas'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Notificaciones'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _notificationOption({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Checkbox(
            value: value,
            onChanged: (val) => onChanged(val ?? false),
          ),

        ],
      ),
    );
  }

}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});


  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}


class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final currentPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;


  bool isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('https://macetech.azurewebsites.net/api/users/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'newPassword': newPasswordController.text.trim(),
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';

        final logoutResponse = await http.post(
          Uri.parse('https://macetech.azurewebsites.net/api/users/sign-out'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        debugPrint('Logout status: ${logoutResponse.statusCode}');
        debugPrint('Logout body: ${logoutResponse.body}');


        if (logoutResponse.statusCode == 200 || logoutResponse.statusCode == 204) {
          await prefs.remove('token');
          await prefs.remove('uid');
          await prefs.remove('email');

          if (!mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacementNamed('/login');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contraseña cambiada correctamente. Inicia sesión de nuevo')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al cerrar sesión')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
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
            // Contraseña actual
            TextFormField(
              controller: currentPasswordController,
              obscureText: _obscureCurrentPassword,
              decoration: InputDecoration(
                labelText: 'Contraseña actual',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu contraseña actual';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Nueva contraseña
            TextFormField(
              controller: newPasswordController,
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'Mínimo 8 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Confirmar contraseña
            TextFormField(
              controller: confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value != newPasswordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : changePassword,
          child: isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Guardar"),
        ),
      ],
    );
  }
}


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

  @override
  void initState() {
    super.initState();

    final nameParts = widget.fullName.split(" ");
    firstNameController = TextEditingController(text: nameParts.first);
    lastNameController = TextEditingController(text: nameParts.skip(1).join(" "));
    addressController = TextEditingController(text: widget.address);
    phoneController = TextEditingController(text: widget.phone);
  }

  Future<void> submitProfileUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Separar la dirección completa en partes (asumiendo coma como separador)
    final parts = addressController.text.split(',').map((e) => e.trim()).toList();
    final street = parts.isNotEmpty ? parts[0] : '';
    final number = parts.length > 1 ? parts[1] : '';
    final city = parts.length > 2 ? parts[2] : '';
    final postalCode = parts.length > 3 ? parts[3] : '';
    final country = parts.length > 4 ? parts[4] : '';

    final response = await http.put(
      Uri.parse('https://macetech.azurewebsites.net/api/profiles/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "street": street,
        "number": number,
        "city": city,
        "postalCode": postalCode,
        "country": country,
        "countryCode": "+51",
        "phoneNumber": phoneController.text.trim()
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar perfil: ${response.statusCode}')),
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
              TextFormField(controller: firstNameController, decoration: const InputDecoration(labelText: 'Nombre')),
              TextFormField(controller: lastNameController, decoration: const InputDecoration(labelText: 'Apellido')),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección completa',
                  hintText: 'Ej: Calle 123, Nro 45, Lima, 15000, Perú',
                ),
              ),
              TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: 'Teléfono')),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(onPressed: submitProfileUpdate, child: const Text('Guardar'))
      ],
    );
  }
}


