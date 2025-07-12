import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
  ];

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginWelcomeTitle;

  /// No description provided for @loginWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access MaceTech.'**
  String get loginWelcomeSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailLabelExample.
  ///
  /// In en, this message translates to:
  /// **'example@example.com'**
  String get loginEmailLabelExample;

  /// No description provided for @loginEmailMandatory.
  ///
  /// In en, this message translates to:
  /// **'Email is mandatory'**
  String get loginEmailMandatory;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordMandatory.
  ///
  /// In en, this message translates to:
  /// **'Password is mandatory'**
  String get loginPasswordMandatory;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSignup.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get loginSignup;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to register on the platform.'**
  String get registerSubtitle;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailLabelExample.
  ///
  /// In en, this message translates to:
  /// **'example@example.com'**
  String get registerEmailLabelExample;

  /// No description provided for @registerEmailMandatory.
  ///
  /// In en, this message translates to:
  /// **'Email is mandatory'**
  String get registerEmailMandatory;

  /// No description provided for @registerEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get registerEmailInvalid;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordMandatory.
  ///
  /// In en, this message translates to:
  /// **'Password is mandatory'**
  String get registerPasswordMandatory;

  /// No description provided for @registerPasswordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerPasswordConfirmLabel;

  /// No description provided for @registerPasswordConfirmMandatory.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation is mandatory'**
  String get registerPasswordConfirmMandatory;

  /// No description provided for @registerPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get registerPasswordInvalid;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registerButton;

  /// No description provided for @registerSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registerSuccessTitle;

  /// No description provided for @registerFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration failed!'**
  String get registerFailedTitle;

  /// No description provided for @registerLoginOption.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get registerLoginOption;

  /// No description provided for @registerLoginLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get registerLoginLink;

  /// No description provided for @passwordResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get passwordResetTitle;

  /// No description provided for @passwordResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry, we\'ll help you reset your password. We\'ll send a link to your email.'**
  String get passwordResetSubtitle;

  /// No description provided for @passwordResetEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get passwordResetEmailLabel;

  /// No description provided for @passwordResetEmailLabelExample.
  ///
  /// In en, this message translates to:
  /// **'example@example.com'**
  String get passwordResetEmailLabelExample;

  /// No description provided for @passwordResetEmailMandatory.
  ///
  /// In en, this message translates to:
  /// **'Email is mandatory'**
  String get passwordResetEmailMandatory;

  /// No description provided for @passwordResetEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get passwordResetEmailInvalid;

  /// No description provided for @passwordResetButton.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get passwordResetButton;

  /// No description provided for @passwordResetSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'A link has been sent to your email'**
  String get passwordResetSuccessTitle;

  /// No description provided for @passwordResetSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check your email to reset your password. The link will expire in 24 hours.'**
  String get passwordResetSuccessSubtitle;

  /// No description provided for @passwordResetConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get passwordResetConfirmationTitle;

  /// No description provided for @createProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Create profile'**
  String get createProfileTitle;

  /// No description provided for @createProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your personal information for your profile'**
  String get createProfileSubtitle;

  /// No description provided for @createProfileFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get createProfileFirstNameLabel;

  /// No description provided for @createProfileFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'John'**
  String get createProfileFirstNameHint;

  /// No description provided for @createProfileLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get createProfileLastNameLabel;

  /// No description provided for @createProfileLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Doe'**
  String get createProfileLastNameHint;

  /// No description provided for @createProfileAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get createProfileAddressLabel;

  /// No description provided for @createProfileAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Av. Alameda Sur 560, Lima, 15067'**
  String get createProfileAddressHint;

  /// No description provided for @createProfilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get createProfilePhoneLabel;

  /// No description provided for @createProfileCountryCodeHint.
  ///
  /// In en, this message translates to:
  /// **'+51'**
  String get createProfileCountryCodeHint;

  /// No description provided for @createProfilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'123-456-789'**
  String get createProfilePhoneHint;

  /// No description provided for @createProfileFirstNameMandatory.
  ///
  /// In en, this message translates to:
  /// **'You must enter a valid first name'**
  String get createProfileFirstNameMandatory;

  /// No description provided for @createProfileLastNameMandatory.
  ///
  /// In en, this message translates to:
  /// **'You must enter a valid last name'**
  String get createProfileLastNameMandatory;

  /// No description provided for @createProfileAddressMandatory.
  ///
  /// In en, this message translates to:
  /// **'You must enter a valid address'**
  String get createProfileAddressMandatory;

  /// No description provided for @createProfileAddressFormat.
  ///
  /// In en, this message translates to:
  /// **'Format: street number, city, postal code'**
  String get createProfileAddressFormat;

  /// No description provided for @createProfilePhoneMandatory.
  ///
  /// In en, this message translates to:
  /// **'You must enter a valid phone number'**
  String get createProfilePhoneMandatory;

  /// No description provided for @createProfilePhoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Number too short'**
  String get createProfilePhoneTooShort;

  /// No description provided for @createProfileSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create profile'**
  String get createProfileSubmit;

  /// No description provided for @createProfileInvalidSession.
  ///
  /// In en, this message translates to:
  /// **'Invalid session'**
  String get createProfileInvalidSession;

  /// No description provided for @createProfileSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile created successfully'**
  String get createProfileSuccess;

  /// No description provided for @createProfileFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not create profile'**
  String get createProfileFailure;

  /// No description provided for @createProfileGenericError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String createProfileGenericError(Object error);

  /// No description provided for @appNavBarPot.
  ///
  /// In en, this message translates to:
  /// **'Pots'**
  String get appNavBarPot;

  /// No description provided for @appNavBarSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get appNavBarSettings;

  /// No description provided for @appNavBarLogout.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get appNavBarLogout;

  /// No description provided for @potsTitle.
  ///
  /// In en, this message translates to:
  /// **'My smart pots'**
  String get potsTitle;

  /// No description provided for @potsWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, '**
  String get potsWelcome;

  /// No description provided for @potsAddPotTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new pot'**
  String get potsAddPotTitle;

  /// No description provided for @potsAddPotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect a new pot to your collection'**
  String get potsAddPotSubtitle;

  /// No description provided for @potsAddPotButton.
  ///
  /// In en, this message translates to:
  /// **'Add pot'**
  String get potsAddPotButton;

  /// No description provided for @potsPotCardLastWatered.
  ///
  /// In en, this message translates to:
  /// **'Last watered: '**
  String get potsPotCardLastWatered;

  /// No description provided for @potsPotCardLastWateredDays.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get potsPotCardLastWateredDays;

  /// No description provided for @potsPotCardLastWateredNever.
  ///
  /// In en, this message translates to:
  /// **'Never watered'**
  String get potsPotCardLastWateredNever;

  /// No description provided for @potsPotCardSoilMoisture.
  ///
  /// In en, this message translates to:
  /// **'Soil moisture'**
  String get potsPotCardSoilMoisture;

  /// No description provided for @potsPotCardEnvironmentLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get potsPotCardEnvironmentLight;

  /// No description provided for @potsPotCardDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get potsPotCardDetails;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get profileTitle;

  /// No description provided for @profileActiveMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Active member since: '**
  String get profileActiveMemberSince;

  /// No description provided for @profileOwnedPots.
  ///
  /// In en, this message translates to:
  /// **' registered pot(s)'**
  String get profileOwnedPots;

  /// No description provided for @profileFreePlan.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get profileFreePlan;

  /// No description provided for @profilePremiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium plan'**
  String get profilePremiumPlan;

  /// No description provided for @profileUpgradeToPremiumCta.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to premium'**
  String get profileUpgradeToPremiumCta;

  /// No description provided for @profileTAndC.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get profileTAndC;

  /// No description provided for @profileAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccountTitle;

  /// No description provided for @profileAccountFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileAccountFullName;

  /// No description provided for @profileAccountEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileAccountEmail;

  /// No description provided for @profileAccountPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profileAccountPhoneNumber;

  /// No description provided for @profileAccountAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileAccountAddress;

  /// No description provided for @profileAccountChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileAccountChangePassword;

  /// No description provided for @profileAccountUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update profile'**
  String get profileAccountUpdateProfile;

  /// No description provided for @profileNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotificationsTitle;

  /// No description provided for @profileNotificationsWateringAlerts.
  ///
  /// In en, this message translates to:
  /// **'Watering alerts'**
  String get profileNotificationsWateringAlerts;

  /// No description provided for @profileNotificationsWateringAlertsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when your pots need watering.'**
  String get profileNotificationsWateringAlertsDescription;

  /// No description provided for @profileNotificationsSensorsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Sensor alerts'**
  String get profileNotificationsSensorsAlerts;

  /// No description provided for @profileNotificationsSensorsAlertsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when the sensors in your pots detect unusual conditions.'**
  String get profileNotificationsSensorsAlertsDescription;

  /// No description provided for @profileNotificationsWeeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly report'**
  String get profileNotificationsWeeklyReport;

  /// No description provided for @profileNotificationsWeeklyReportDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive a weekly report on the status of your pots and plants.'**
  String get profileNotificationsWeeklyReportDescription;

  /// No description provided for @profileNotificationsByEmail.
  ///
  /// In en, this message translates to:
  /// **'Email notifications'**
  String get profileNotificationsByEmail;

  /// No description provided for @profileNotificationsByEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications by email.'**
  String get profileNotificationsByEmailDescription;

  /// No description provided for @profileBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get profileBilling;

  /// No description provided for @profileCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get profileCurrentPlan;

  /// No description provided for @profileBillingFreePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get profileBillingFreePlanTitle;

  /// No description provided for @profileBillingFreePlanDescription.
  ///
  /// In en, this message translates to:
  /// **'Basic features'**
  String get profileBillingFreePlanDescription;

  /// No description provided for @profileBillingPremiumPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium plan'**
  String get profileBillingPremiumPlanTitle;

  /// No description provided for @profileBillingPremiumPlanDescription.
  ///
  /// In en, this message translates to:
  /// **'All features'**
  String get profileBillingPremiumPlanDescription;

  /// No description provided for @profileFunctionalitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get profileFunctionalitiesTitle;

  /// No description provided for @profileFunctionalitiesFreePlanOne.
  ///
  /// In en, this message translates to:
  /// **'Up to 4 pots'**
  String get profileFunctionalitiesFreePlanOne;

  /// No description provided for @profileFunctionalitiesFreePlanTwo.
  ///
  /// In en, this message translates to:
  /// **'Basic sensor monitoring'**
  String get profileFunctionalitiesFreePlanTwo;

  /// No description provided for @profileFunctionalitiesFreePlanThree.
  ///
  /// In en, this message translates to:
  /// **'Full watering alerts'**
  String get profileFunctionalitiesFreePlanThree;

  /// No description provided for @profileFunctionalitiesFreePlanFour.
  ///
  /// In en, this message translates to:
  /// **'Data history and analysis for 7 days'**
  String get profileFunctionalitiesFreePlanFour;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get profileDeleteAccountConfirmation;

  /// No description provided for @profileDeleteAccountConfirmationDescription.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted.'**
  String get profileDeleteAccountConfirmationDescription;

  /// No description provided for @profileDeleteAccountConfirmationYes.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileDeleteAccountConfirmationYes;

  /// No description provided for @profileDeleteAccountConfirmationNo.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileDeleteAccountConfirmationNo;

  /// No description provided for @profileDeleteAccountSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get profileDeleteAccountSuccessTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
