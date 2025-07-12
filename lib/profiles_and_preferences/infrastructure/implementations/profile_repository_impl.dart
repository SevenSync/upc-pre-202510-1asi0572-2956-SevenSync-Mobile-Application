import 'package:macetech_mobile_app/profiles_and_preferences/domain/entities/user_profile_entity.dart';
import '../../domain/interfaces/profile_repository.dart';
import '../services/profile_api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService api;

  ProfileRepositoryImpl(this.api);

  @override
  Future<UserProfileEntity> getProfile() async {
    final profile = await api.fetchProfile();
    final email = await api.fetchEmail();
    return UserProfileEntity(
      fullName: profile['fullName'] ?? '',
      phoneNumber: profile['phoneNumber'] ?? '',
      address: profile['streetAddress'] ?? '',
      email: email,
    );
  }

  @override
  Future<void> updateProfile(UserProfileEntity profile) {
    final addressParts = profile.address.split(',');
    final streetRaw = addressParts.isNotEmpty ? addressParts[0].trim() : '';
    final city = addressParts.length > 1 ? addressParts[1].trim() : '';
    final postalCode = addressParts.length > 2 ? addressParts[2].trim() : '';

    final streetParts = streetRaw.split(' ');
    final number = streetParts.isNotEmpty ? streetParts.removeLast() : '';
    final street = streetParts.join(' ');

    final digitsOnly = profile.phoneNumber.replaceAll(RegExp(r'\D'), '');
    final phoneNumber = digitsOnly.startsWith('51') && digitsOnly.length > 9
        ? digitsOnly.substring(2)
        : digitsOnly;

    final data = {
      'firstName': profile.fullName.split(' ').first,
      'lastName': profile.fullName.split(' ').skip(1).join(' '),
      'street': street,
      'number': number,
      'city': city,
      'postalCode': postalCode,
      'country': 'Perú',
      'countryCode': '+51',
      'phoneNumber': phoneNumber,
    };

    return api.updateProfile(data);
  }


  @override
  Future<void> changePassword(String newPassword) => api.changePassword(newPassword);

  @override
  Future<void> deleteAccount() => api.deleteAccount();

  @override
  Future<void> signOut() => api.signOut();
}