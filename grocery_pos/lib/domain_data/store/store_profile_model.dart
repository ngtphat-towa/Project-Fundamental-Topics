import 'package:equatable/equatable.dart';
import 'package:grocery_pos/common/models/models.dart';

class StoreProfileModel extends Equatable {
  final Address? address;
  final String? email;
  final String? phone;
  final String? storeName;
  final String? ownerName;

  const StoreProfileModel({
    this.address,
    this.email,
    this.phone,
    this.storeName,
    this.ownerName,
  });

  StoreProfileModel.fromJson(Map<String, dynamic> json)
      : address = json[StoreProfileModelMapping.addressKey] != null
            ? Address.fromJson(json[StoreProfileModelMapping.addressKey])
            : null,
        email = json[StoreProfileModelMapping.emailKey],
        phone = json[StoreProfileModelMapping.phoneKey],
        storeName = json[StoreProfileModelMapping.storeNameKey],
        ownerName = json[StoreProfileModelMapping.ownerNameKey];

  Map<String, dynamic> toJson() => {
        StoreProfileModelMapping.addressKey: address?.toJson(),
        StoreProfileModelMapping.emailKey: email,
        StoreProfileModelMapping.phoneKey: phone,
        StoreProfileModelMapping.storeNameKey: storeName,
        StoreProfileModelMapping.ownerNameKey: ownerName,
      };

  StoreProfileModel copyWith({
    Address? address,
    String? email,
    String? phone,
    String? storeName,
    String? ownerName,
  }) {
    return StoreProfileModel(
      address: address ?? this.address,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      storeName: storeName ?? this.storeName,
      ownerName: ownerName ?? this.ownerName,
    );
  }

  static get empty => const StoreProfileModel(
        email: '',
        phone: '',
        storeName: '',
        ownerName: '',
      );
  bool get isEmpty => this == StoreProfileModel.empty;
  bool get isNotEmpty => this != StoreProfileModel.empty;

  @override
  List<Object?> get props => [address, email, phone, storeName, ownerName];
}

class StoreProfileModelMapping {
  //Document
  static const collectionName = 'Store';
  static const documentID = 'StoreInf';
  //Feilds
  static const addressKey = 'address';
  static const emailKey = 'email';
  static const phoneKey = 'phone';
  static const storeNameKey = 'name';
  static const ownerNameKey = 'owner_name';
}
