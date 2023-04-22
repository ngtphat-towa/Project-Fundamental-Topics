part of 'customer_form_bloc.dart';

enum CustomerFormType { createNew, edit }

abstract class CustomerFormEvent extends Equatable {
  const CustomerFormEvent();

  @override
  List<Object?> get props => [];
}

class AddCustomerEvent extends CustomerFormEvent {
  final CustomerModel model;

  const AddCustomerEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class LoadToEditCustomerEvent extends CustomerFormEvent {
  final CustomerModel model;
  final CustomerFormType type;
  const LoadToEditCustomerEvent(this.model, this.type);
  @override
  List<Object?> get props => [model];
}

class UpdateCustomerEvent extends CustomerFormEvent {
  final CustomerModel model;

  const UpdateCustomerEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class BackCategroyFormEvent extends CustomerFormEvent {}
