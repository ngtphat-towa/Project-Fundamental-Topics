part of 'customer_form_bloc.dart';

abstract class CustomerFormState extends Equatable {
  final CustomerModel? model;
  final CustomerFormType? type;
  final bool? isValid;
  const CustomerFormState({this.model, this.type, this.isValid});

  @override
  List<Object?> get props => [model];
}

class CustomerFormInitial extends CustomerFormState {}

class CustomerFormLoadingState extends CustomerFormState {}

class CustomerFormLoadedState extends CustomerFormState {
  const CustomerFormLoadedState({
    CustomerModel? model,
    CustomerFormType? type,
  }) : super(model: model, type: type);
  @override
  List<Object?> get props => [model, type];
}

class CustomerFormValueChangedState extends CustomerFormState {
  const CustomerFormValueChangedState({
    CustomerModel? model,
    CustomerFormType? type,
    bool? isValid,
  }) : super(model: model, type: type, isValid: isValid);
  @override
  List<Object?> get props => [model, type, isValid];
}

class CustomerFormSuccessState extends CustomerFormState {
  final String? successMessage;
  const CustomerFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class CustomerFormErrorState extends CustomerFormState {
  final String? errorMessage;
  const CustomerFormErrorState({this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
