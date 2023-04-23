part of 'invoice_list_bloc.dart';

abstract class InvoiceListState extends Equatable {
  const InvoiceListState();

  @override
  List<Object?> get props => [];
}

class InvoiceListInitial extends InvoiceListState {}

class InvoiceListLoadingState extends InvoiceListState {}

class InvoiceListLoadedState extends InvoiceListState {
  final List<InvoiceModel>? invoices;

  const InvoiceListLoadedState({this.invoices});
  @override
  List<Object?> get props => [invoices];
}

class InvoiceListErrorState extends InvoiceListState {
  final String? message;

  const InvoiceListErrorState({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}
