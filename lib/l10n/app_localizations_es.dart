// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginWelcomeTitle => '¡Bienvenido de nuevo!';

  @override
  String get loginWelcomeSubtitle =>
      'Por favor inicia sesión para acceder a MaceTech.';

  @override
  String get loginEmailLabel => 'Correo electrónico';

  @override
  String get loginEmailLabelExample => 'ejemplo@ejemplo.com';

  @override
  String get loginEmailMandatory => 'El correo electrónico es obligatorio';

  @override
  String get loginEmailInvalid => 'El correo electrónico no es válido';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginPasswordMandatory => 'La contraseña es obligatoria';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginSignup => '¿No tienes una cuenta? Regístrate';

  @override
  String get registerTitle => 'Crea tu cuenta';

  @override
  String get registerSubtitle =>
      'Ingresa tus datos para registrate en la plataforma.';

  @override
  String get registerEmailLabel => 'Correo electrónico';

  @override
  String get registerEmailLabelExample => 'ejemplo@ejemplo.com';

  @override
  String get registerEmailMandatory => 'El correo electrónico es obligatorio';

  @override
  String get registerEmailInvalid => 'El correo electrónico no es válido';

  @override
  String get registerPasswordLabel => 'Contraseña';

  @override
  String get registerPasswordMandatory => 'La contraseña es obligatoria';

  @override
  String get registerPasswordConfirmLabel => 'Confirmar contraseña';

  @override
  String get registerPasswordConfirmMandatory =>
      'La confirmación de contraseña es obligatoria';

  @override
  String get registerPasswordInvalid => 'Mínimo 8 caracteres';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get registerSuccessTitle => '¡Registro exitoso!';

  @override
  String get registerFailedTitle => 'Registro fallido!';

  @override
  String get registerLoginOption => '¿Ya tienes una cuenta? ';

  @override
  String get registerLoginLink => 'Iniciar sesión';

  @override
  String get passwordResetTitle => 'Restablece tu contraseña';

  @override
  String get passwordResetSubtitle =>
      'No te preocupes, te ayudaremos a restablecer tu contraseña. Enviaremos un enlace a tu correo electrónico.';

  @override
  String get passwordResetEmailLabel => 'Correo electrónico';

  @override
  String get passwordResetEmailLabelExample => 'ejemplo@ejemplo.com';

  @override
  String get passwordResetEmailMandatory =>
      'El correo electrónico es obligatorio';

  @override
  String get passwordResetEmailInvalid => 'El correo electrónico no es válido';

  @override
  String get passwordResetButton => 'Enviar enlace de restablecimiento';

  @override
  String get passwordResetSuccessTitle => 'Se ha enviado un enlace a tu correo';

  @override
  String get passwordResetSuccessSubtitle =>
      'Por favor revisa tu correo para restablecer tu contraseña. El enlace expirará en 24 horas.';

  @override
  String get passwordResetConfirmationTitle => 'Entendido';

  @override
  String get createProfileTitle => 'Crear perfil';

  @override
  String get createProfileSubtitle =>
      'Ingresa tus datos personales para tu perfil';

  @override
  String get createProfileFirstNameLabel => 'Nombre';

  @override
  String get createProfileFirstNameHint => 'John';

  @override
  String get createProfileLastNameLabel => 'Apellido';

  @override
  String get createProfileLastNameHint => 'Doe';

  @override
  String get createProfileAddressLabel => 'Dirección';

  @override
  String get createProfileAddressHint => 'Av. Alameda Sur 560, Lima, 15067';

  @override
  String get createProfilePhoneLabel => 'Número de celular';

  @override
  String get createProfileCountryCodeHint => '+51';

  @override
  String get createProfilePhoneHint => '123-456-789';

  @override
  String get createProfileFirstNameMandatory => 'Debe agregar un nombre válido';

  @override
  String get createProfileLastNameMandatory =>
      'Debe agregar un apellido válido';

  @override
  String get createProfileAddressMandatory =>
      'Debe agregar una dirección válida';

  @override
  String get createProfileAddressFormat =>
      'Formato: calle número, ciudad, postal';

  @override
  String get createProfilePhoneMandatory =>
      'Debe agregar un número de celular válido';

  @override
  String get createProfilePhoneTooShort => 'Número muy corto';

  @override
  String get createProfileSubmit => 'Crear Perfil';

  @override
  String get createProfileInvalidSession => 'Sesión no válida';

  @override
  String get createProfileSuccess => 'Perfil creado con éxito';

  @override
  String get createProfileFailure => 'No se pudo crear el perfil';

  @override
  String createProfileGenericError(Object error) {
    return 'Error: $error';
  }

  @override
  String get appNavBarPot => 'Mis macetas';

  @override
  String get appNavBarSettings => 'Notificaciones';

  @override
  String get appNavBarLogout => 'Perfil';

  @override
  String get potsTitle => 'Mis macetas inteligentes';

  @override
  String get potsWelcome => 'Bienvenido, ';

  @override
  String get potsAddPotTitle => 'Agregar una nueva maceta';

  @override
  String get potsAddPotSubtitle => 'Conecta una nueva maceta a tu colección';

  @override
  String get potsAddPotButton => 'Agregar maceta';

  @override
  String get potsPotCardLastWatered => 'Último riego: ';

  @override
  String get potsPotCardLastWateredDays => 'días atrás';

  @override
  String get potsPotCardLastWateredNever => 'Nunca regada';

  @override
  String get potsPotCardSoilMoisture => 'Humedad del suelo';

  @override
  String get potsPotCardEnvironmentLight => 'Luz';

  @override
  String get potsPotCardDetails => 'Ver detalles';

  @override
  String get potsNeedsWater => 'Necesita riego';

  @override
  String get potLinkTitle => 'Vincula tu maceta';

  @override
  String get potLinkName => 'Nombre';

  @override
  String get potLinkLocation => 'Ubicación';

  @override
  String get potLinkIdentifier => 'Identificador de la maceta';

  @override
  String get potLinkButton => 'Vincular maceta';

  @override
  String get potLinkSuccess => 'Vinculación exitosa ';

  @override
  String get potLinkFailure => 'No se pudo vincular la maceta ';

  @override
  String get fieldRequired => 'Este campo no puede estar vacío';

  @override
  String get profileTitle => 'Mi perfil';

  @override
  String get profileActiveMemberSince => 'Miembro activo desde: ';

  @override
  String get profileOwnedPots => ' maceta(s) registrada(s)';

  @override
  String get profileFreePlan => 'Plan gratuito';

  @override
  String get profilePremiumPlan => 'Plan premium';

  @override
  String get profileUpgradeToPremiumCta => 'Actualizar a premium';

  @override
  String get profileTAndC => 'Términos y condiciones';

  @override
  String get profileAccountTitle => 'Cuenta';

  @override
  String get profileAccountFullName => 'Nombre completo';

  @override
  String get profileAccountEmail => 'Correo electrónico';

  @override
  String get profileAccountPhoneNumber => 'Número de teléfono';

  @override
  String get profileAccountAddress => 'Dirección';

  @override
  String get profileAccountChangePassword => 'Cambiar contraseña';

  @override
  String get profileAccountUpdateProfile => 'Actualizar perfil';

  @override
  String get profileNotificationsTitle => 'Notificaciones';

  @override
  String get profileNotificationsWateringAlerts => 'Alertas de riego';

  @override
  String get profileNotificationsWateringAlertsDescription =>
      'Recibe notificaciones cuando tus macetas necesiten riego.';

  @override
  String get profileNotificationsSensorsAlerts => 'Alertas de sensores';

  @override
  String get profileNotificationsSensorsAlertsDescription =>
      'Recibe notificaciones cuando los sensores de tus macetas detecten condiciones inusuales.';

  @override
  String get profileNotificationsWeeklyReport => 'Reporte semanal';

  @override
  String get profileNotificationsWeeklyReportDescription =>
      'Recibe un reporte semanal del estado de tus macetas y plantas.';

  @override
  String get profileNotificationsByEmail => 'Notificaciones por correo';

  @override
  String get profileNotificationsByEmailDescription =>
      'Recibe notificaciones por correo electrónico.';

  @override
  String get profileBilling => 'Facturación';

  @override
  String get profileCurrentPlan => 'Plan actual';

  @override
  String get profileBillingFreePlanTitle => 'Plan gratuito';

  @override
  String get profileBillingFreePlanDescription => 'Funcionalidades básicas';

  @override
  String get profileBillingPremiumPlanTitle => 'Plan premium';

  @override
  String get profileBillingPremiumPlanDescription =>
      'Todas las funcionalidades';

  @override
  String get profileFunctionalitiesTitle => 'Funcionalidades';

  @override
  String get profileFunctionalitiesFreePlanOne => 'Hasta 4 macetas';

  @override
  String get profileFunctionalitiesFreePlanTwo =>
      'Monitoreo básico de sensores';

  @override
  String get profileFunctionalitiesFreePlanThree =>
      'Alertas de riego completas';

  @override
  String get profileFunctionalitiesFreePlanFour =>
      'Historial de datos y análisis por 7 días';

  @override
  String get profileLogout => 'Cerrar sesión';

  @override
  String get profileDeleteAccount => 'Eliminar cuenta';

  @override
  String get profileDeleteAccountConfirmation => '¿Estás seguro?';

  @override
  String get profileDeleteAccountConfirmationDescription =>
      'Esta acción no se puede deshacer. Todos tus datos serán eliminados permanentemente.';

  @override
  String get profileDeleteAccountConfirmationYes => 'Eliminar';

  @override
  String get profileDeleteAccountConfirmationNo => 'Cancelar';

  @override
  String get profileDeleteAccountSuccessTitle => 'Cuenta eliminada';
}
