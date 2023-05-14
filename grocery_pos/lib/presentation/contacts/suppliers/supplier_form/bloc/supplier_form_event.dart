part of 'supplier_form_bloc.dart';

enum SupplierFormType { createNew, edit }

abstract class SupplierFormEvent extends Equatable {
  final SupplierModel? model;
  final SupplierFormType? type;

  const SupplierFormEvent({this.model, this.type});

  @override
  List<Object?> get props => [];
}

class AddSupplierEvent extends SupplierFormEvent {
  const AddSupplierEvent({SupplierModel? model}) : super(model: model);
  @override
  List<Object?> get props => [model];
}

class LoadSupplierFormEvent extends SupplierFormEvent {
  const LoadSupplierFormEvent({
    SupplierModel? model,
    SupplierFormType? type = SupplierFormType.createNew,
  }) : super(model: model, type: type);
  @override
  List<Object?> get props => [model, type];
}

class ValueChangedSupplierEvent extends SupplierFormEvent {
  const ValueChangedSupplierEvent({
    SupplierModel? model,
    SupplierFormType? type = SupplierFormType.createNew,
  }) : super(model: model, type: type);
  @override
  List<Object?> get props => [model, type];
}

class UpdateSupplierEvent extends SupplierFormEvent {
  const UpdateSupplierEvent({required SupplierModel model})
      : super(model: model);
  @override
  List<Object?> get props => [model];
}

class BackSupplierFormEvent extends SupplierFormEvent {}
