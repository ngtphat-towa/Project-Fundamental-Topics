import 'package:equatable/equatable.dart';

import '../../../contacts/suppliers/models/models.dart';
import '../../categories/models/models.dart';
import '../../stocks/models/models.dart';

class ProductModel extends Equatable {
  //required
  final String? id;
  final String name;
  // needs
  final String? measureUnit;
  final double? unitPrice;
  final Quantity? quantity;
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
    this.quantity,
    this.barcode,
    this.supplier,
    this.category,
    this.photoURL,
    this.isInventoryEnable,
  });

  Map<String, dynamic> toJson() => {
        ProductModelMapping.idKey: id,
        ProductModelMapping.nameKey: name,
        ProductModelMapping.measureUnitKey: measureUnit,
        ProductModelMapping.unitPriceKey: unitPrice,
        ProductModelMapping.quantityKey: quantity!.toJson(),
        ProductModelMapping.barcodeKey: barcode,
        ProductModelMapping.supplierKey: supplier?.toProductJson(),
        ProductModelMapping.categoryKey: category?.toProductJson(),
        ProductModelMapping.photoURLKey: photoURL,
        ProductModelMapping.isInventoryEnableKey: isInventoryEnable,
      };
  Map<String, dynamic> toInvoiceDetailJson() => {
        ProductModelMapping.idKey: id,
        ProductModelMapping.nameKey: name,
        ProductModelMapping.measureUnitKey: measureUnit,
        ProductModelMapping.unitPriceKey: unitPrice,
        ProductModelMapping.isInventoryEnableKey: isInventoryEnable,
      };
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json[ProductModelMapping.idKey],
        name: json[ProductModelMapping.nameKey],
        measureUnit: json[ProductModelMapping.measureUnitKey],
        unitPrice: json[ProductModelMapping.unitPriceKey].toDouble(),
        quantity: Quantity.fromJson(json[ProductModelMapping.quantityKey]),
        barcode: json[ProductModelMapping.barcodeKey],
        supplier: json[ProductModelMapping.supplierKey] != null
            ? SupplierModel.fromProductJson(
                json[ProductModelMapping.supplierKey])
            : null,
        category: json[ProductModelMapping.categoryKey] != null
            ? CategoryModel.fromProductJson(
                json[ProductModelMapping.categoryKey])
            : null,
        photoURL: json[ProductModelMapping.photoURLKey],
        isInventoryEnable: json[ProductModelMapping.isInventoryEnableKey],
      );

  factory ProductModel.fromInvoiceDetailJson(Map<String, dynamic> json) =>
      ProductModel(
        id: json[ProductModelMapping.idKey],
        name: json[ProductModelMapping.nameKey],
        measureUnit: json[ProductModelMapping.measureUnitKey],
        unitPrice: json[ProductModelMapping.unitPriceKey].toDouble(),
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
  }) {
    return ProductModel(
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
  }

  static get empty => ProductModel(
        id: '',
        name: '',
        measureUnit: '',
        unitPrice: 0.0,
        quantity: Quantity.empty,
        barcode: '',
        supplier: SupplierModel.empty,
        category: CategoryModel.empty,
        photoURL: '',
        isInventoryEnable: false,
      );
  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
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
  static const idKey = 'id';
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
