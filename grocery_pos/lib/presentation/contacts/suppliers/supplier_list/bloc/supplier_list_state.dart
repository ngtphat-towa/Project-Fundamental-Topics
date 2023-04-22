part of 'supplier_list_bloc.dart';

abstract class SupplierListState extends Equatable {
  const SupplierListState();

  @override
  List<Object?> get props => [];
}

class SupplierListInitial extends SupplierListState {}

class SupplierListLoadingState extends SupplierListState {}

class SupplierListLoadedState extends SupplierListState {
  final List<SupplierModel?>? suppliers;

  const SupplierListLoadedState({required this.suppliers});
  @override
  List<Object?> get props => [suppliers];
}

class SupplierListErrorState extends SupplierListState {
  final String? message;

  const SupplierListErrorState({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}
