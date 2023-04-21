import 'package:equatable/equatable.dart';

import 'package:grocery_pos/domain_data/contacts/suppliers/model/supplier_model.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';
import 'package:grocery_pos/domain_data/inventories/stocks/models/quantity_model.dart';

class ProductModel extends Equatable {
  //required
  final String? id;
  final String name;
  // needs
  final String measureUnit;
  final double unitPrice;
  final Quantity quantity;
  //metadata
  final String? barcode;
  final SupplierModel? supplier;
  final CategoryModel? category;
  final String? photoURL;
  final bool? isInventoryEnable;

  const ProductModel({
    this.id,
    required this.name,
    required this.measureUnit,
    required this.unitPrice,
    required this.quantity,
    this.barcode,
    this.supplier,
    this.category,
    this.photoURL,
    this.isInventoryEnable,
  });

  Map<String, dynamic> toJson() => {
        ProductModelMapping.idKeyKey: id,
        ProductModelMapping.nameKey: name,
        ProductModelMapping.measureUnitKey: measureUnit,
        ProductModelMapping.unitPriceKey: unitPrice,
        ProductModelMapping.quantityKey: quantity.toJson(),
        ProductModelMapping.barcodeKey: barcode,
        ProductModelMapping.supplierKey: supplier?.toJson(),
        ProductModelMapping.categoryKey: category?.toJson(),
        ProductModelMapping.photoURLKey: photoURL,
        ProductModelMapping.isInventoryEnableKey: isInventoryEnable,
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json[ProductModelMapping.idKeyKey],
        name: json[ProductModelMapping.nameKey],
        measureUnit: json[ProductModelMapping.measureUnitKey],
        unitPrice: json[ProductModelMapping.unitPriceKey],
        quantity: Quantity.fromJson(json[ProductModelMapping.quantityKey]),
        barcode: json[ProductModelMapping.barcodeKey],
        supplier: json[ProductModelMapping.supplierKey] != null
            ? SupplierModel.fromJson(json[ProductModelMapping.supplierKey])
            : null,
        category: json[ProductModelMapping.categoryKey] != null
            ? CategoryModel.fromJson(json[ProductModelMapping.categoryKey])
            : null,
        photoURL: json[ProductModelMapping.photoURLKey],
        isInventoryEnable: json[ProductModelMapping.isInventoryEnableKey],
      );

  ProductModel copyWith({
    String? id,
    String? name,
    String? measureUnit,
    double? unitPrice,
    Quantity? quantity,
    String? barcode,
    SupplierModel? supplier,
    CategoryModel? category,
    String? photoURL,
    bool? isInventoryEnable,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        measureUnit: measureUnit ?? this.measureUnit,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        barcode: barcode ?? this.barcode,
        supplier: supplier ?? this.supplier,
        category: category ?? this.category,
        photoURL: photoURL ?? this.photoURL,
        isInventoryEnable: isInventoryEnable ?? this.isInventoryEnable,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        measureUnit,
        unitPrice,
        quantity,
        barcode,
        supplier,
        category,
        photoURL,
        isInventoryEnable,
      ];
}

class ProductModelMapping {
  //required
  static const collectionName = "Products";
  static const idFormat = "P";
  static const idKeyKey = 'id';
  static const nameKey = 'name';
  //nees
  static const measureUnitKey = 'measureUnit';
  static const quantityKey = 'quantity';
  static const unitPriceKey = 'unitPrice';
  //metadata
  static const barcodeKey = 'barcode';
  static const supplierKey = 'supplier';
  static const categoryKey = 'category';
  static const photoURLKey = 'photoURL';
  static const isInventoryEnableKey = 'isInventoryEnable';
}