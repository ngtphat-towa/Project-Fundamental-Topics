import 'package:equatable/equatable.dart';
import 'package:grocery_pos/common/models/models.dart';

class SupplierModel extends Equatable {
  final String? id;
  final String name;
  final String? email;
  final String? phone;
  final String? description;
  final Address? address;

  const SupplierModel(
      {this.id,
      required this.name,
      this.email,
      this.phone,
      this.description,
      this.address});

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
        id: json[SupplierModelMapping.idKey],
        name: json[SupplierModelMapping.nameKey],
        email: json[SupplierModelMapping.emailKey],
        phone: json[SupplierModelMapping.phoneKey],
        description: json[SupplierModelMapping.descriptionKey],
        address: json[SupplierModelMapping.addressKey] != null
            ? Address.fromJson(json[SupplierModelMapping.addressKey])
            : null);
  }

  factory SupplierModel.fromProductJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json[SupplierModelMapping.idKey],
      name: json[SupplierModelMapping.nameKey],
    );
  }

  Map<String, dynamic> toJson() => {
        SupplierModelMapping.idKey: id,
        SupplierModelMapping.nameKey: name,
        SupplierModelMapping.emailKey: email,
        SupplierModelMapping.phoneKey: phone,
        SupplierModelMapping.descriptionKey: description,
        SupplierModelMapping.addressKey: address?.toJson(),
      };

  Map<String, dynamic> toProductJson() => {
        SupplierModelMapping.idKey: id,
        SupplierModelMapping.nameKey: name,
      };
  SupplierModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? description,
    Address? address,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      address: address ?? this.address,
    );
  }

  static get empty =>  SupplierModel(
        id: '',
        name: '',
        address: Address.empty
      );
  static get none => const SupplierModel(name: 'none');

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
  @override
  List<Object?> get props => [id, name, email, phone, address, description];
}

class SupplierModelMapping {
  static const collectionName = 'Suppliers';
  static const idFormat = 'SL';
  static const idKey = 'id';
  static const nameKey = 'name';
  static const emailKey = 'email';
  static const phoneKey = 'phone';
  static const descriptionKey = 'description';
  static const addressKey = 'address';
}
