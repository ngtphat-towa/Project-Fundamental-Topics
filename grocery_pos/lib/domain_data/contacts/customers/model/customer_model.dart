import 'package:equatable/equatable.dart';
import 'package:grocery_pos/common/models/models.dart';

class CustomerModel extends Equatable {
  final String? id;
  final String name;
  final String? email;
  final String? phone;
  final String? description;
  final Address? address;

  const CustomerModel(
      {this.id,
      required this.name,
      this.email,
      this.phone,
      this.description,
      this.address});

  CustomerModel.fromJson(Map<String, dynamic> json)
      : id = json[CustomerModelMapping.idKey],
        name = json[CustomerModelMapping.nameKey],
        email = json[CustomerModelMapping.emailKey],
        phone = json[CustomerModelMapping.phoneKey],
        description = json[CustomerModelMapping.descriptionKey],
        address = json[CustomerModelMapping.addressKey] != null
            ? Address.fromJson(json[CustomerModelMapping.addressKey])
            : null;

  Map<String, dynamic> toJson() => {
        CustomerModelMapping.idKey: id,
        CustomerModelMapping.nameKey: name,
        CustomerModelMapping.emailKey: email,
        CustomerModelMapping.phoneKey: phone,
        CustomerModelMapping.descriptionKey: description,
        CustomerModelMapping.addressKey: address?.toJson(),
      };
  CustomerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? description,
    Address? address,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      address: address ?? this.address,
    );
  }

  static get empty => const CustomerModel(
        id: '',
        name: '',
        email: '',
        phone: '',
        description: '',
      );
  static get none => const CustomerModel(name: 'none');

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
  @override
  List<Object?> get props => [id, name, email, phone, address, description];
}

class CustomerModelMapping {
  static const collectionName = 'Customers';
  static const idFormat = 'SL';
  static const idKey = 'id';
  static const nameKey = 'name';
  static const emailKey = 'email';
  static const phoneKey = 'phone';
  static const descriptionKey = 'description';
  static const addressKey = 'address';
}
