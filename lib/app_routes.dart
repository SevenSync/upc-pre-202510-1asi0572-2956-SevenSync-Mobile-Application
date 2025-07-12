import 'package:flutter/material.dart';
import 'package:macetech_mobile_app/iam/presentation/pages/create-profile.dart';
import 'package:macetech_mobile_app/iam/presentation/pages/login.dart';
import 'package:macetech_mobile_app/iam/presentation/pages/password-recovery.dart';
import 'package:macetech_mobile_app/iam/presentation/pages/recovery-sent.dart';
import 'package:macetech_mobile_app/iam/presentation/pages/register.dart';
import 'package:macetech_mobile_app/pots/pages/add_pot.dart';
import 'package:macetech_mobile_app/pots/pages/pot_information.dart';
import 'package:macetech_mobile_app/pots/pages/pots.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/presentation/pages/profile.dart';
import 'injections.dart'; 

class AppRoutes {
  
  static const String login = '/login';
  static const String register = '/register';
  static const String recoverPassword = '/recover';
  static const String recoverySent = '/recovery-sent';
  static const String createProfile = '/create-profile';
  static const String profile = '/profile';
  static const String pots = '/pot';
  static const String potInfo = '/pot-info';
  static const String addPot = '/add-pot';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case recoverPassword:
        return MaterialPageRoute(builder: (_) => const RecoverPasswordPage());

      case recoverySent:
        return MaterialPageRoute(builder: (_) => const RecoveryEmailSentPage());

      case createProfile:
        return MaterialPageRoute(builder: (_) => const CreateProfilePage());

      case profile:
        return MaterialPageRoute(
          builder: (_) => ProfilePage(
            getProfile: getIt(),
            signOut: getIt(),
            deleteAccount: getIt(),
            updateProfile: getIt(),
            changePassword: getIt(),
          ),
        );

      case pots:
        return MaterialPageRoute(
          builder: (_) => const PotsPage(),
        );

      case potInfo:
        final pot = settings.arguments as PlantPot;
        return MaterialPageRoute(
          builder: (_) => PotInformationPage(pot: SmartPot(name: "Planti la maceta", humidity: 45.0, light: 45.0, temperature: 15.0, ph: 7.0, salinity: 45.0, battery: 78.0, location: "Lima, Peru", model: "ModeloA1", serial: "XD92659139712")),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}