part of 'supplier_list_bloc.dart';

abstract class SupplierListEvent extends Equatable {
  const SupplierListEvent();

  @override
  List<Object?> get props => [];
}

class LoadSupplierListEvent extends SupplierListEvent {
  final String? searchValue;
  const LoadSupplierListEvent({this.searchValue});
  @override
  List<Object?> get props => [searchValue];
}

class DeleteSupplierListEvent extends SupplierListEvent {
  final SupplierModel supplier;
  const DeleteSupplierListEvent({required this.supplier});
  @override
  List<Object?> get props => [supplier];
}
