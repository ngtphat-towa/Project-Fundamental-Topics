part of 'customer_form_bloc.dart';

abstract class CustomerFormState extends Equatable {
  const CustomerFormState();

  @override
  List<Object?> get props => [];
}

class CustomerFormInitial extends CustomerFormState {}

class CustomerFormLoadingState extends CustomerFormState {}

class CustomerFormLoadedState extends CustomerFormState {
  final CustomerModel? customer;
  final CustomerFormType type;
  const CustomerFormLoadedState(this.customer, this.type);
  @override
  List<Object?> get props => [customer, type];
}

class CustomerFormSuccessState extends CustomerFormState {
  final String? successMessage;
  const CustomerFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class CustomerFormErrorState extends CustomerFormState {
  final String? message;
  const CustomerFormErrorState({this.message});
  @override
  List<Object?> get props => [message];
}
