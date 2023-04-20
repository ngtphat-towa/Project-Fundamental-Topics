import 'package:equatable/equatable.dart';
import 'package:grocery_pos/domain_data/contacts/customers/model/customer_model.dart';

import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_detail_model.dart';

enum InvoiceType { retail, customer }

class InvoiceModel extends Equatable {
  final String? id;
  final String createdDate;
  final double total;
  final double discount;
  final InvoiceType invoiceType;
  final List<InvoiceDetail> invoiceDetails;
  final String note;
  final CustomerModel? customer;

  const InvoiceModel({
    this.id,
    required this.createdDate,
    required this.total,
    required this.discount,
    required this.invoiceType,
    required this.invoiceDetails,
    required this.note,
    this.customer,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      InvoiceModelMapping.idKey: id,
      InvoiceModelMapping.createdDateKey: createdDate,
      InvoiceModelMapping.totalKey: total,
      InvoiceModelMapping.discountKey: discount,
      InvoiceModelMapping.invoiceTypeKey: invoiceType.index,
      InvoiceModelMapping.invoiceDetailsKey:
          invoiceDetails.map((detail) => detail.toJson()).toList(),
      InvoiceModelMapping.noteKey: note,
    };
    if (invoiceType == InvoiceType.customer) {
      json[InvoiceModelMapping.customerKey] = customer?.toJson();
    }
    return json;
  }

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json[InvoiceModelMapping.idKey],
        createdDate: json[InvoiceModelMapping.createdDateKey],
        total: json[InvoiceModelMapping.totalKey],
        discount: json[InvoiceModelMapping.discountKey],
        invoiceType:
            InvoiceType.values[json[InvoiceModelMapping.invoiceTypeKey]],
        invoiceDetails: (json[InvoiceModelMapping.invoiceDetailsKey] as List)
            .map((detail) => InvoiceDetail.fromJson(detail))
            .toList(),
        note: json[InvoiceModelMapping.noteKey],
        customer: json[InvoiceModelMapping.customerKey] != null
            ? CustomerModel.fromJson(json[InvoiceModelMapping.customerKey])
            : null,
      );

  InvoiceModel copyWith({
    String? id,
    String? createdDate,
    double? total,
    double? discount,
    InvoiceType? invoiceType,
    List<InvoiceDetail>? invoiceDetails,
    String? note,
    CustomerModel? customer,
  }) =>
      InvoiceModel(
        id: id ?? this.id,
        createdDate: createdDate ?? this.createdDate,
        total: total ?? this.total,
        discount: discount ?? this.discount,
        invoiceType: invoiceType ?? this.invoiceType,
        invoiceDetails: invoiceDetails ?? this.invoiceDetails,
        note: note ?? this.note,
        customer: customer ?? this.customer,
      );

  @override
  List<Object?> get props => [
        id,
        createdDate,
        total,
        discount,
        invoiceType,
        invoiceDetails,
        note,
        customer
      ];
}

class InvoiceModelMapping {
  static const collectionName = 'Invoices';
  static const idFormat = 'OID';
  static const idKey = 'id';
  static const createdDateKey = 'createdDate';
  static const totalKey = 'total';
  static const discountKey = 'discount';
  static const invoiceTypeKey = 'invoiceType';
  static const invoiceDetailsKey = 'invoiceDetails';
  static const customerKey = 'customer';
  static const noteKey = 'note';
}
