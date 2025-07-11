// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginWelcomeTitle => 'Welcome back!';

  @override
  String get loginWelcomeSubtitle => 'Please log in to access MaceTech.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailLabelExample => 'example@example.com';

  @override
  String get loginEmailMandatory => 'Email is mandatory';

  @override
  String get loginEmailInvalid => 'Invalid email address';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordMandatory => 'Password is mandatory';

  @override
  String get loginButton => 'Log in';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginSignup => 'Don\'t have an account? Sign up';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle =>
      'Enter your details to register on the platform.';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailLabelExample => 'example@example.com';

  @override
  String get registerEmailMandatory => 'Email is mandatory';

  @override
  String get registerEmailInvalid => 'Invalid email address';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordMandatory => 'Password is mandatory';

  @override
  String get registerPasswordConfirmLabel => 'Confirm password';

  @override
  String get registerPasswordConfirmMandatory =>
      'Password confirmation is mandatory';

  @override
  String get registerPasswordInvalid => 'At least 8 characters';

  @override
  String get registerButton => 'Sign up';

  @override
  String get registerSuccessTitle => 'Registration successful!';

  @override
  String get registerLoginOption => 'Already have an account? ';

  @override
  String get registerLoginLink => 'Log in';

  @override
  String get passwordResetTitle => 'Reset your password';

  @override
  String get passwordResetSubtitle =>
      'Don\'t worry, we\'ll help you reset your password. We\'ll send a link to your email.';

  @override
  String get passwordResetEmailLabel => 'Email';

  @override
  String get passwordResetEmailLabelExample => 'example@example.com';

  @override
  String get passwordResetEmailMandatory => 'Email is mandatory';

  @override
  String get passwordResetEmailInvalid => 'Invalid email address';

  @override
  String get passwordResetButton => 'Send reset link';

  @override
  String get passwordResetSuccessTitle => 'A link has been sent to your email';

  @override
  String get passwordResetSuccessSubtitle =>
      'Please check your email to reset your password. The link will expire in 24 hours.';

  @override
  String get createProfileTitle => 'Create profile';

  @override
  String get createProfileSubtitle =>
      'Enter your personal information for your profile';

  @override
  String get createProfileFirstNameLabel => 'First name';

  @override
  String get createProfileFirstNameHint => 'John';

  @override
  String get createProfileLastNameLabel => 'Last name';

  @override
  String get createProfileLastNameHint => 'Doe';

  @override
  String get createProfileAddressLabel => 'Address';

  @override
  String get createProfileAddressHint => 'Av. Alameda Sur 560, Lima, 15067';

  @override
  String get createProfilePhoneLabel => 'Phone number';

  @override
  String get createProfileCountryCodeHint => '+51';

  @override
  String get createProfilePhoneHint => '123-456-789';

  @override
  String get createProfileFirstNameMandatory =>
      'You must enter a valid first name';

  @override
  String get createProfileLastNameMandatory =>
      'You must enter a valid last name';

  @override
  String get createProfileAddressMandatory => 'You must enter a valid address';

  @override
  String get createProfileAddressFormat =>
      'Format: street number, city, postal code';

  @override
  String get createProfilePhoneMandatory =>
      'You must enter a valid phone number';

  @override
  String get createProfilePhoneTooShort => 'Number too short';

  @override
  String get createProfileSubmit => 'Create profile';

  @override
  String get createProfileInvalidSession => 'Invalid session';

  @override
  String get createProfileSuccess => 'Profile created successfully';

  @override
  String get createProfileFailure => 'Could not create profile';

  @override
  String createProfileGenericError(Object error) {
    return 'Error: $error';
  }

  @override
  String get appNavBarPot => 'Pots';

  @override
  String get appNavBarSettings => 'Notifications';

  @override
  String get appNavBarLogout => 'Profile';

  @override
  String get potsTitle => 'My smart pots';

  @override
  String get potsWelcome => 'Welcome, ';

  @override
  String get potsAddPotTitle => 'Add a new pot';

  @override
  String get potsAddPotSubtitle => 'Connect a new pot to your collection';

  @override
  String get potsAddPotButton => 'Add pot';

  @override
  String get potsPotCardLastWatered => 'Last watered: ';

  @override
  String get potsPotCardLastWateredDays => 'days ago';

  @override
  String get potsPotCardLastWateredNever => 'Never watered';

  @override
  String get potsPotCardSoilMoisture => 'Soil moisture';

  @override
  String get potsPotCardEnvironmentLight => 'Light';

  @override
  String get potsPotCardDetails => 'View details';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileActiveMemberSince => 'Active member since: ';

  @override
  String get profileOwnedPots => ' registered pot(s)';

  @override
  String get profileFreePlan => 'Free plan';

  @override
  String get profilePremiumPlan => 'Premium plan';

  @override
  String get profileUpgradeToPremiumCta => 'Upgrade to premium';

  @override
  String get profileTAndC => 'Terms and conditions';

  @override
  String get profileAccountTitle => 'Account';

  @override
  String get profileAccountFullName => 'Full name';

  @override
  String get profileAccountEmail => 'Email';

  @override
  String get profileAccountPhoneNumber => 'Phone number';

  @override
  String get profileAccountAddress => 'Address';

  @override
  String get profileAccountChangePassword => 'Change password';

  @override
  String get profileAccountUpdateProfile => 'Update profile';

  @override
  String get profileNotificationsTitle => 'Notifications';

  @override
  String get profileNotificationsWateringAlerts => 'Watering alerts';

  @override
  String get profileNotificationsWateringAlertsDescription =>
      'Receive notifications when your pots need watering.';

  @override
  String get profileNotificationsSensorsAlerts => 'Sensor alerts';

  @override
  String get profileNotificationsSensorsAlertsDescription =>
      'Receive notifications when the sensors in your pots detect unusual conditions.';

  @override
  String get profileNotificationsWeeklyReport => 'Weekly report';

  @override
  String get profileNotificationsWeeklyReportDescription =>
      'Receive a weekly report on the status of your pots and plants.';

  @override
  String get profileNotificationsByEmail => 'Email notifications';

  @override
  String get profileNotificationsByEmailDescription =>
      'Receive notifications by email.';

  @override
  String get profileBilling => 'Billing';

  @override
  String get profileBillingFreePlanTitle => 'Free plan';

  @override
  String get profileBillingFreePlanDescription => 'Basic features';

  @override
  String get profileBillingPremiumPlanTitle => 'Premium plan';

  @override
  String get profileBillingPremiumPlanDescription => 'All features';

  @override
  String get profileFunctionalitiesTitle => 'Features';

  @override
  String get profileFunctionalitiesFreePlanOne => 'Up to 4 pots';

  @override
  String get profileFunctionalitiesFreePlanTwo => 'Basic sensor monitoring';

  @override
  String get profileFunctionalitiesFreePlanThree => 'Full watering alerts';

  @override
  String get profileFunctionalitiesFreePlanFour =>
      'Data history and analysis for 7 days';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileDeleteAccountConfirmation => 'Are you sure?';

  @override
  String get profileDeleteAccountConfirmationDescription =>
      'This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get profileDeleteAccountConfirmationYes => 'Delete';

  @override
  String get profileDeleteAccountConfirmationNo => 'Cancel';

  @override
  String get profileDeleteAccountSuccessTitle => 'Account deleted';
}
