part of 'invoice_form_bloc.dart';

abstract class InvoiceFormState extends Equatable {
  const InvoiceFormState({this.customers, this.formType, this.invoice});
  final InvoiceModel? invoice;
  final InvoiceFormType? formType;
  final List<CustomerModel>? customers;

  @override
  List<Object?> get props => [];
}

class InvoiceFormInitial extends InvoiceFormState {}

class InvoiceFormLoadingState extends InvoiceFormState {}

class InvoiceFormLoadedState extends InvoiceFormState {
  const InvoiceFormLoadedState({
    required List<CustomerModel>? customers,
    required InvoiceFormType formType,
    InvoiceModel? invoice,
  }) : super(
          invoice: invoice,
          formType: formType,
          customers: customers,
        );
  @override
  List<Object?> get props => [
        invoice,
        formType,
        customers,
      ];
}

class InvoiceFormValueChangedState extends InvoiceFormState {
  const InvoiceFormValueChangedState({
    required List<CustomerModel>? customers,
    required InvoiceFormType formType,
    InvoiceModel? invoice,
  }) : super(
          invoice: invoice,
          formType: formType,
          customers: customers,
        );
  @override
  List<Object?> get props => [
        invoice,
        formType,
        customers,
      ];
}

class InvoiceFormSuccessState extends InvoiceFormState {
  final String? successMessage;
  const InvoiceFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class InvoiceFormErrorState extends InvoiceFormState {
  final String? message;
  const InvoiceFormErrorState({this.message});
  @override
  List<Object?> get props => [message];
}
