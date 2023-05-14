part of 'supplier_form_bloc.dart';

abstract class SupplierFormState extends Equatable {
  final SupplierModel? model;
  final SupplierFormType? type;
  final bool? isValid;
  const SupplierFormState({this.model, this.type, this.isValid});

  @override
  List<Object?> get props => [model];
}

class SupplierFormInitial extends SupplierFormState {}

class SupplierFormLoadingState extends SupplierFormState {}

class SupplierFormLoadedState extends SupplierFormState {
  const SupplierFormLoadedState({
    SupplierModel? model,
    SupplierFormType? type,
  }) : super(model: model, type: type);
  @override
  List<Object?> get props => [model, type];
}

class SupplierFormValueChangedState extends SupplierFormState {
  const SupplierFormValueChangedState({
    SupplierModel? model,
    SupplierFormType? type,
    bool? isValid,
  }) : super(model: model, type: type, isValid: isValid);
  @override
  List<Object?> get props => [model, type, isValid];
}

class SupplierFormSuccessState extends SupplierFormState {
  final String? successMessage;
  const SupplierFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class SupplierFormErrorState extends SupplierFormState {
  final String? errorMessage;
  const SupplierFormErrorState({this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
