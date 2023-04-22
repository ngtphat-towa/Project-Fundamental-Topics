part of 'supplier_form_bloc.dart';

enum SupplierFormType { createNew, edit }

abstract class SupplierFormEvent extends Equatable {
  const SupplierFormEvent();

  @override
  List<Object?> get props => [];
}

class AddSupplierEvent extends SupplierFormEvent {
  final SupplierModel model;

  const AddSupplierEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class LoadToEditSupplierEvent extends SupplierFormEvent {
  final SupplierModel model;
  final SupplierFormType type;
  const LoadToEditSupplierEvent(this.model, this.type);
  @override
  List<Object?> get props => [model];
}

class UpdateSupplierEvent extends SupplierFormEvent {
  final SupplierModel model;

  const UpdateSupplierEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class BackCategroyFormEvent extends SupplierFormEvent {}
