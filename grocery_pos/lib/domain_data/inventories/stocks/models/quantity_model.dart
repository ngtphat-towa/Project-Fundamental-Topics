import 'package:equatable/equatable.dart';

class Quantity extends Equatable {
  final double? sku;
  final double? soldUnit;

  const Quantity({this.sku, this.soldUnit});

  Map<String, dynamic> toJson() => {
        'sku': sku,
        'soldUnit': soldUnit,
      };

  factory Quantity.fromJson(Map<String, dynamic> json) => Quantity(
        sku: json['sku'],
        soldUnit: json['soldUnit'],
      );

  Quantity copyWith({double? sku, double? soldUnit}) => Quantity(
        sku: sku ?? this.sku,
        soldUnit: soldUnit ?? this.soldUnit,
      );
  static get empty => const Quantity(sku: 0.0, soldUnit: 0.0);
  @override
  List<Object?> get props => [sku, soldUnit];
}
