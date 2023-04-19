import 'package:equatable/equatable.dart';

class InvoiceDetail extends Equatable {
  final String? id;
  final String name;
  final String measureUnit;
  final double unitPrice;
  final double quantity;

  const InvoiceDetail({
    this.id,
    required this.name,
    required this.measureUnit,
    required this.unitPrice,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        InvoiceDetailMapping.productKey: {
          InvoiceDetailMapping.idKey: id,
          InvoiceDetailMapping.nameKey: name,
        },
        InvoiceDetailMapping.measureUnitKey: measureUnit,
        InvoiceDetailMapping.unitPriceKey: unitPrice,
        InvoiceDetailMapping.quantityKey: quantity,
      };

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> productJson = json[InvoiceDetailMapping.productKey];
    return InvoiceDetail(
      id: productJson[InvoiceDetailMapping.idKey] ?? "",
      name: productJson[InvoiceDetailMapping.nameKey] ?? "",
      measureUnit: json[InvoiceDetailMapping.measureUnitKey],
      unitPrice: json[InvoiceDetailMapping.unitPriceKey],
      quantity: json[InvoiceDetailMapping.quantityKey],
    );
  }
  InvoiceDetail copyWith({
    String? id,
    String? name,
    String? measureUnit,
    double? unitPrice,
    double? quantity,
  }) =>
      InvoiceDetail(
        id: id ?? this.id,
        name: name ?? this.name,
        measureUnit: measureUnit ?? this.measureUnit,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
      );
  @override
  List<Object?> get props => [
        id,
        name,
        measureUnit,
        unitPrice,
        quantity,
      ];
}

class InvoiceDetailMapping {
  static const mapCollectionKey = 'invoiceDetials';
  static const productKey = 'product';
  static const idKey = 'id';
  static const nameKey = 'name';
  static const measureUnitKey = 'measureUnit';
  static const unitPriceKey = 'unitPrice';
  static const quantityKey = 'quantity';
}
