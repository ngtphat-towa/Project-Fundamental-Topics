part of 'supplier_form_bloc.dart';

abstract class SupplierFormState extends Equatable {
  const SupplierFormState();

  @override
  List<Object?> get props => [];
}

class SupplierFormInitial extends SupplierFormState {}

class SupplierFormLoadingState extends SupplierFormState {}

class SupplierFormLoadedState extends SupplierFormState {
  final SupplierModel? supplier;
  final SupplierFormType type;
  const SupplierFormLoadedState(this.supplier, this.type);
  @override
  List<Object?> get props => [supplier, type];
}

class SupplierFormSuccessState extends SupplierFormState {
  final String? successMessage;
  const SupplierFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class SupplierFormErrorState extends SupplierFormState {
  final String? message;
  const SupplierFormErrorState({this.message});
  @override
  List<Object?> get props => [message];
}
