import 'package:flutter/material.dart';
import 'package:macetech_mobile_app/iam/presentation/pages/create-profile.dart';
import 'package:macetech_mobile_app/iam/presentation/pages/login.dart';
import 'package:macetech_mobile_app/iam/presentation/pages/password-recovery.dart';
import 'package:macetech_mobile_app/iam/presentation/pages/recovery-sent.dart';
import 'package:macetech_mobile_app/iam/presentation/pages/register.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/presentation/pages/profile.dart';
import 'injections.dart'; 

class AppRoutes {
  
  static const String login = '/login';
  static const String register = '/register';
  static const String recoverPassword = '/recover';
  static const String recoverySent = '/recovery-sent';
  static const String createProfile = '/create-profile';
  static const String profile = '/profile';

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