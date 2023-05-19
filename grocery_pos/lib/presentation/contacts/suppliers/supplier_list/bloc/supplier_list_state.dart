part of 'supplier_list_bloc.dart';

abstract class SupplierListState extends Equatable {
  final List<SupplierModel?>? suppliers;

  const SupplierListState({this.suppliers});

  @override
  List<Object?> get props => [];
}

class SupplierListInitial extends SupplierListState {}

class SupplierListLoadingState extends SupplierListState {}

class SupplierListLoadedState extends SupplierListState {
  const SupplierListLoadedState({required List<SupplierModel?> suppliers})
      : super(suppliers: suppliers);
  @override
  List<Object?> get props => [suppliers];
}

class SupplierListErrorState extends SupplierListState {
  final String? errorMessage;

  const SupplierListErrorState({
    required this.errorMessage,
  });
  @override
  List<Object?> get props => [errorMessage];
}
