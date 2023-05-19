part of 'customer_form_bloc.dart';

enum CustomerFormType { createNew, edit }

abstract class CustomerFormEvent extends Equatable {
  final CustomerModel? model;
  final CustomerFormType? type;

  const CustomerFormEvent({this.model, this.type});

  @override
  List<Object?> get props => [];
}

class AddCustomerEvent extends CustomerFormEvent {
  const AddCustomerEvent({CustomerModel? model}) : super(model: model);
  @override
  List<Object?> get props => [model];
}

class LoadCustomerFormEvent extends CustomerFormEvent {
  const LoadCustomerFormEvent({
    CustomerModel? model,
    CustomerFormType? type = CustomerFormType.createNew,
  }) : super(model: model, type: type);
  @override
  List<Object?> get props => [model, type];
}

class ValueChangedCustomerEvent extends CustomerFormEvent {
  const ValueChangedCustomerEvent({
    CustomerModel? model,
    CustomerFormType? type = CustomerFormType.createNew,
  }) : super(model: model, type: type);
  @override
  List<Object?> get props => [model, type];
}

class UpdateCustomerEvent extends CustomerFormEvent {
  const UpdateCustomerEvent({required CustomerModel model})
      : super(model: model);
  @override
  List<Object?> get props => [model];
}

class BackCustomerFormEvent extends CustomerFormEvent {}
