import 'package:equatable/equatable.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';

class InvoiceDetail extends Equatable {
  final ProductModel product;
  final double quantity;

  const InvoiceDetail({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        InvoiceDetailMapping.productKey: product.toInvoiceDetailJson(),
        InvoiceDetailMapping.quantityKey: quantity,
      };

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) {
    return InvoiceDetail(
      product: ProductModel.fromInvoiceDetailJson(
          json[InvoiceDetailMapping.productKey]),
      quantity: json[InvoiceDetailMapping.quantityKey],
    );
  }
  InvoiceDetail copyWith({
    ProductModel? product,
    double? quantity,
  }) =>
      InvoiceDetail(
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
      );
  @override
  List<Object?> get props => [
        product,
        quantity,
      ];
}

class InvoiceDetailMapping {
  static const mapCollectionKey = 'invoiceDetials';
  static const productKey = 'product';

  static const quantityKey = 'quantity';
  // static const idKey = 'id';
  // static const nameKey = 'name';
  // static const measureUnitKey = 'measureUnit';
  // static const unitPriceKey = 'unitPrice';
}
