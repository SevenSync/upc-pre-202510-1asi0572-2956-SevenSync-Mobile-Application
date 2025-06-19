class UserProfileEntity {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;

  UserProfileEntity({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  UserProfileEntity copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
  }) {
    return UserProfileEntity(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }
}
