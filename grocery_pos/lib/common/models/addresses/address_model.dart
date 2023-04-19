class Address {
  static const streetKey = 'street';
  static const cityKey = 'city';
  static const countryKey = 'country';

  final String? street;
  final String? city;
  final String? country;

  const Address({this.street, this.city, this.country});

  Address.fromJson(Map<String, dynamic> json)
      : street = json[streetKey],
        city = json[cityKey],
        country = json[countryKey];

  Map<String, dynamic> toJson() => {
        streetKey: street,
        cityKey: city,
        countryKey: country,
      };
}
