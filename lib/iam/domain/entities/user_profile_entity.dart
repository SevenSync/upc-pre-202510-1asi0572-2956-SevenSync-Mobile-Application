class UserProfileEntity {
  final String firstName;
  final String lastName;
  final String street;
  final String number;
  final String city;
  final String postalCode;
  final String country;
  final String countryCode;
  final String phoneNumber;

  UserProfileEntity({
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.number,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.countryCode,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "street": street,
    "number": number,
    "city": city,
    "postalCode": postalCode,
    "country": country,
    "countryCode": countryCode,
    "phoneNumber": phoneNumber,
  };
}
