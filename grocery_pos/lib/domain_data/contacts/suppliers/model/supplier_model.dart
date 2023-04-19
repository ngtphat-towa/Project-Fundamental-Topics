import 'package:equatable/equatable.dart';
import 'package:grocery_pos/common/models/models.dart';

class SupplierModel extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? description;
  final Address? address;

  const SupplierModel(
      {required this.id,
      required this.name,
      this.email,
      this.phone,
      this.description,
      this.address});

  SupplierModel.fromJson(Map<String, dynamic> json)
      : id = json[SupplierModelMapping.idKey],
        name = json[SupplierModelMapping.nameKey],
        email = json[SupplierModelMapping.emailKey],
        phone = json[SupplierModelMapping.phoneKey],
        description = json[SupplierModelMapping.descriptionKey],
        address = json[SupplierModelMapping.addressKey] != null
            ? Address.fromJson(json[SupplierModelMapping.addressKey])
            : null;

  Map<String, dynamic> toJson() => {
        SupplierModelMapping.idKey: id,
        SupplierModelMapping.nameKey: name,
        SupplierModelMapping.emailKey: email,
        SupplierModelMapping.phoneKey: phone,
        SupplierModelMapping.descriptionKey: description,
        SupplierModelMapping.addressKey: address?.toJson(),
      };

  @override
  List<Object?> get props => [id, name, phone, address, description];
}

class SupplierModelMapping {
  static const collectionName = 'Suppliers';
  static const idForamt = 'SL';
  static const idKey = 'id';
  static const nameKey = 'name';
  static const emailKey = 'email';
  static const phoneKey = 'phone';
  static const descriptionKey = 'description';
  static const addressKey = 'address';
}
