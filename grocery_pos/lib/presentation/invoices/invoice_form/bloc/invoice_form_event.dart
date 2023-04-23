part of 'invoice_form_bloc.dart';

enum InvoiceFormType { createNew, edit }

abstract class InvoiceFormEvent extends Equatable {
  const InvoiceFormEvent();

  @override
  List<Object?> get props => [];
}

class AddInvoiceEvent extends InvoiceFormEvent {
  final InvoiceModel model;

  const AddInvoiceEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class InvoiceValueChangedEvent extends InvoiceFormEvent {
  final InvoiceModel? model;
  final InvoiceFormType type;
  final bool? isValueChanged;
  const InvoiceValueChangedEvent({
    required this.type,
    this.isValueChanged,
    required this.model,
  });
  @override
  List<Object?> get props => [model, type, isValueChanged];
}

class LoadToEditInvoiceEvent extends InvoiceFormEvent {
  final InvoiceModel? model;
  final InvoiceFormType type;
  final bool? isValueChanged;
  const LoadToEditInvoiceEvent(
      {this.model, required this.type, this.isValueChanged = false});
  @override
  List<Object?> get props => [model, type, isValueChanged];
}

class UpdateInvoiceEvent extends InvoiceFormEvent {
  final InvoiceModel model;

  const UpdateInvoiceEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class BackCategroyFormEvent extends InvoiceFormEvent {}
