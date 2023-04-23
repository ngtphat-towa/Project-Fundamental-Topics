part of 'invoice_list_bloc.dart';

abstract class InvoiceListEvent extends Equatable {
  const InvoiceListEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvoiceListEvent extends InvoiceListEvent {
  final String? searchValue;
  const LoadInvoiceListEvent({this.searchValue});
  @override
  List<Object?> get props => [searchValue];
}

class DeleteInvoiceListEvent extends InvoiceListEvent {
  final InvoiceModel invoice;
  const DeleteInvoiceListEvent({required this.invoice});
  @override
  List<Object?> get props => [invoice];
}
