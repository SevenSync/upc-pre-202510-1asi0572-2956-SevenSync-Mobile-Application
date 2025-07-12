import 'package:flutter/material.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/domain/entities/user_profile_entity.dart';
import 'package:macetech_mobile_app/common/widgets/navbar/app_bottom_nav_bar.dart';

import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../application/usecases/change_password_usecase.dart';
import '../../application/usecases/delete_account_usecase.dart';
import '../../application/usecases/get_profile_usecase.dart';
import '../../application/usecases/sign_out_usecase.dart';
import '../../application/usecases/update_profile_usecase.dart';

class ProfilePage extends StatefulWidget {
  final GetProfileUseCase getProfile;
  final SignOutUseCase signOut;
  final DeleteAccountUseCase deleteAccount;
  final UpdateProfileUseCase updateProfile;
  final ChangePasswordUseCase changePassword;

  const ProfilePage({
    super.key,
    required this.getProfile,
    required this.signOut,
    required this.deleteAccount,
    required this.updateProfile,
    required this.changePassword,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ValueNotifier<UserProfileEntity?> _profileNotifier = ValueNotifier(null);
  bool expandAccount = false;
  bool expandNotifications = false;
  bool expandBilling = false;

  bool wateringAlerts = false;
  bool sensorAlerts = false;
  bool weeklyReports = false;
  bool emailNotifications = false;

  String _lang = 'en';
  late AppLocalizations loc;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => loadProfile());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loc = AppLocalizations.of(context)!;
  }

  Future<void> loadProfile() async {
    try {
      final profile = await widget.getProfile();
      _profileNotifier.value = profile;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar perfil: $e')),
      );
    }
  }

  Future<void> handleSignOut() async {
    await widget.signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> handleDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.profileDeleteAccount),
        content: Text(loc.profileDeleteAccountConfirmationDescription),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(loc.profileDeleteAccountConfirmationNo)),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(loc.profileDeleteAccountConfirmationYes),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    try {
      await widget.deleteAccount();
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.profileDeleteAccountSuccessTitle)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar cuenta: $e")),
      );
    }
  }

  void _showEditDialog(UserProfileEntity profile) async {
    await showDialog(
      context: context,
      builder: (_) => _EditProfileDialog(
        profile: profile,
        onSave: (updated) async {
          await widget.updateProfile(updated);
          await loadProfile();
        },
      ),
    );
  }

  void _showChangePasswordDialog() async {
    await showDialog(
      context: context,
      builder: (_) => _ChangePasswordDialog(
        changePassword: widget.changePassword,
        signOut: widget.signOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFEEF3EF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/pot', (route) => false,);
          },
        ),
        title: Text(loc.profileTitle, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              borderColor: Colors.transparent,
              selectedBorderColor: Colors.green,
              fillColor: Colors.green.withOpacity(0.1),
              isSelected: [ _lang=='en', _lang=='es' ],
              onPressed: (index) {
                final newLang = index == 0 ? 'en' : 'es';
                final newLocale = Locale(newLang);

                setState(() => _lang = newLang);
                MyApp.setLocale(context, newLocale);
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('En'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Es'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<UserProfileEntity?>(
        valueListenable: _profileNotifier,
        builder: (context, profile, _) {
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
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
                      child: const CircleAvatar(radius: 50, backgroundColor: Colors.grey),
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
                Text(profile.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(profile.email,
                    style: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.workspace_premium_outlined, color: Colors.white),
                  label: const Text("Actualizar a Premium"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.description_outlined, color: Colors.green),
                  label: const Text("Términos y Condiciones", style: TextStyle(color: Colors.green)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 20),
                ExpansionPanelList(
                  expansionCallback: (_, __) => setState(() => expandAccount = !expandAccount),
                  children: [
                    ExpansionPanel(
                      isExpanded: expandAccount,
                      headerBuilder: (_, __) => const ListTile(title: Text("Cuenta", style: TextStyle(fontWeight: FontWeight.bold))),
                      body: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow("Nombre completo:", profile.fullName),
                            _infoRow("Correo electrónico:", profile.email),
                            _infoRow("Número de celular:", profile.phoneNumber),
                            _infoRow("Dirección:", profile.address),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _showChangePasswordDialog,
                                    icon: const Icon(Icons.lock_outline),
                                    label: const Text("Cambiar Contraseña"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _showEditDialog(profile),
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text("Editar Perfil"),
                                  ),
                                ),
                              ],
                            )
                          ],

                        ),

                      ),
                    ),
                  ],
                ),
                ExpansionPanelList(
                  expansionCallback: (_, __) => setState(() => expandNotifications = !expandNotifications),
                  children: [
                    ExpansionPanel(
                      isExpanded: expandNotifications,
                      headerBuilder: (_, __) => const ListTile(title: Text("Notificaciones", style: TextStyle(fontWeight: FontWeight.bold))),
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
                              description: "Sensores detecten condiciones anormales",
                              value: sensorAlerts,
                              onChanged: (val) => setState(() => sensorAlerts = val),
                            ),
                            _notificationOption(
                              title: "Reportes semanales",
                              description: "Resúmenes semanales de tus plantas",
                              value: weeklyReports,
                              onChanged: (val) => setState(() => weeklyReports = val),
                            ),
                            _notificationOption(
                              title: "Notificaciones por correo",
                              description: "También por correo electrónico",
                              value: emailNotifications,
                              onChanged: (val) => setState(() => emailNotifications = val),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ExpansionPanelList(
                  expansionCallback: (_, __) => setState(() => expandBilling = !expandBilling),
                  children: [
                    ExpansionPanel(
                      isExpanded: expandBilling,
                      headerBuilder: (_, __) => const ListTile(title: Text("Facturación", style: TextStyle(fontWeight: FontWeight.bold))),
                      body: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Plan actual", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16),
                              ),
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
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text("Funcionalidades", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16),
                              ),
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: handleSignOut,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: handleDeleteAccount,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text("Eliminar Cuenta", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2)
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline))),
          Expanded(flex: 3, child: Text(value)),
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
          Checkbox(value: value, onChanged: (val) => onChanged(val ?? false)),
        ],
      ),
    );
  }
}


class _EditProfileDialog extends StatefulWidget {
  final UserProfileEntity profile;
  final Future<void> Function(UserProfileEntity updated) onSave;

  const _EditProfileDialog({required this.profile, required this.onSave});

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController address;
  late TextEditingController phone;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final parts = widget.profile.fullName.split(' ');
    firstName = TextEditingController(text: parts.first);
    lastName = TextEditingController(text: parts.skip(1).join(' '));
    address = TextEditingController(text: widget.profile.address);
    phone = TextEditingController(text: widget.profile.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Perfil'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(controller: firstName, decoration: const InputDecoration(labelText: 'Nombre')),
            TextFormField(controller: lastName, decoration: const InputDecoration(labelText: 'Apellido')),
            TextFormField(controller: address, decoration: const InputDecoration(labelText: 'Dirección')),
            TextFormField(controller: phone, decoration: const InputDecoration(labelText: 'Teléfono')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final updated = widget.profile.copyWith(
                fullName: '${firstName.text} ${lastName.text}',
                address: address.text,
                phoneNumber: phone.text,
              );
              await widget.onSave(updated);
              if (!mounted) return;
              Navigator.pop(context);
            }
          },
          child: const Text('Guardar'),
        )
      ],
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  final ChangePasswordUseCase changePassword;
  final SignOutUseCase signOut;

  const _ChangePasswordDialog({required this.changePassword, required this.signOut});

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final current = TextEditingController();
  final newPass = TextEditingController();
  final confirm = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar Contraseña'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: current,
              decoration: const InputDecoration(labelText: 'Contraseña actual'),
              obscureText: true,
              validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: newPass,
              decoration: const InputDecoration(labelText: 'Nueva contraseña'),
              obscureText: true,
              validator: (val) => val == null || val.length < 8 ? 'Mínimo 8 caracteres' : null,
            ),
            TextFormField(
              controller: confirm,
              decoration: const InputDecoration(labelText: 'Confirmar contraseña'),
              obscureText: true,
              validator: (val) => val != newPass.text ? 'No coinciden' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: loading
              ? null
              : () async {
            if (!_formKey.currentState!.validate()) return;
            setState(() => loading = true);
            try {
              await widget.changePassword(newPass.text);
              await widget.signOut();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contraseña cambiada. Inicia sesión.')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            } finally {
              if (mounted) setState(() => loading = false);
            }
          },
          child: loading ? const CircularProgressIndicator() : const Text('Guardar'),
        )
      ],
    );
  }
}




