// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Address extends Equatable {
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

  // ignore: prefer_const_constructors
  static Address get empty => Address(street: '', city: '', country: '');

  get full => '$street $city, ${country!}';

  @override
  List<Object?> get props => [street, city, country];

  Address copyWith({
    String? street,
    String? city,
    String? country,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }
}
