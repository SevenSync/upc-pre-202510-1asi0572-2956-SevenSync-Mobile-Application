import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/app_localizations.dart';
import '../../application/usecases/create_profile_usecase.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../infrastructure/services/profile_api_service.dart';
import '../../../main.dart'; // Para usar MyApp.setLocale

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

  String _lang = 'en';

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
          SnackBar(content: Text(AppLocalizations.of(context)!.createProfileInvalidSession)),
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
            SnackBar(content: Text(AppLocalizations.of(context)!.createProfileSuccess)),
          );
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.createProfileFailure)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _languageToggle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(20),
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.green,
        fillColor: Colors.green.withOpacity(0.1),
        isSelected: [_lang == 'en', _lang == 'es'],
        onPressed: (index) {
          final newLang = index == 0 ? 'en' : 'es';
          final newLocale = Locale(newLang);
          setState(() => _lang = newLang);
          MyApp.setLocale(context, newLocale);
        },
        children: const [
          Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('En')),
          Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Es')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
                    _languageToggle(),
                    const Icon(Icons.account_circle_outlined, size: 80),
                    const SizedBox(height: 20),
                    Text(
                      loc.createProfileTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF296244),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      loc.createProfileSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    Text(loc.createProfileFirstNameLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'John',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.trim().isEmpty ? loc.createProfileFirstNameMandatory : null,
                    ),
                    const SizedBox(height: 20),

                    Text(loc.createProfileLastNameLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Doe',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.trim().isEmpty ? loc.createProfileLastNameMandatory : null,
                    ),
                    const SizedBox(height: 20),

                    Text(loc.createProfileAddressLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: 'Av. Alameda Sur 560, Lima, 15067',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return loc.createProfileAddressMandatory;
                        }
                        final parts = value.split(',');
                        if (parts.length < 3) {
                          return loc.createProfileAddressFormat;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    Text(loc.createProfilePhoneLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                return loc.createProfilePhoneMandatory;
                              }
                              final digits = value.replaceAll(RegExp(r'\D'), '');
                              if (digits.length < 7) {
                                return loc.createProfilePhoneTooShort;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ECC71),
                        ),
                        onPressed: _handleCreateProfile,
                        child: Text(loc.createProfileSubmit),
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
