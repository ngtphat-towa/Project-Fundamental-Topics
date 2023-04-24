import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_pos/domain_data/contacts/customers/model/customer_model.dart';

import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_detail_model.dart';

enum InvoiceType { retail, customer }

extension InvoiceTypeExtension on InvoiceType {
  String get displayString {
    String shortString = toString().split('.').last;
    return shortString[0].toUpperCase() + shortString.substring(1);
  }

  int get number {
    return index;
  }
}

class InvoiceModel extends Equatable {
  final String? id;
  final DateTime? createdDate;
  final double? total;
  final double? discount;
  final InvoiceType invoiceType;
  final List<InvoiceDetail>? invoiceDetails;
  final String? note;
  final CustomerModel? customer;

  const InvoiceModel({
    this.id,
    this.createdDate,
    this.total,
    this.discount,
    required this.invoiceType,
    this.invoiceDetails,
    this.note,
    this.customer,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      InvoiceModelMapping.idKey: id,
      InvoiceModelMapping.createdDateKey: Timestamp.fromDate(createdDate!),
      InvoiceModelMapping.totalKey: total,
      InvoiceModelMapping.discountKey: discount,
      InvoiceModelMapping.invoiceTypeKey: invoiceType.index,
      InvoiceModelMapping.invoiceDetailsKey:
          invoiceDetails!.map((detail) => detail.toJson()).toList(),
      InvoiceModelMapping.noteKey: note,
    };
    if (invoiceType == InvoiceType.customer) {
      json[InvoiceModelMapping.customerKey] = customer?.toJson();
    }
    return json;
  }

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json[InvoiceModelMapping.idKey],
        createdDate:
            (json[InvoiceModelMapping.createdDateKey] as Timestamp).toDate(),
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
    DateTime? createdDate,
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

  static get empty => InvoiceModel(
        id: '',
        createdDate: null,
        total: 0.0,
        discount: 0.0,
        invoiceType: InvoiceType.retail,
        invoiceDetails: null,
        note: '',
        customer: CustomerModel.empty,
      );
  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;

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

extension InoiceDetialX on List<InvoiceDetail> {
  double get totalCost =>
      fold(0, (sum, item) => sum! + item.product.unitPrice * item.quantity) ??
      0;
}
