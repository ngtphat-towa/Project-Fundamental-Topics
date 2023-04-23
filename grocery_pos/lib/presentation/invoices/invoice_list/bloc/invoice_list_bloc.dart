import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_model.dart';
import 'package:grocery_pos/domain_data/pos/invoices/repositories/invoice_repository.dart';

part 'invoice_list_event.dart';
part 'invoice_list_state.dart';

class InvoiceListBloc extends Bloc<InvoiceListEvent, InvoiceListState> {
  final InvoiceRepository invoiceRepository;
  InvoiceListBloc({required this.invoiceRepository})
      : super(InvoiceListInitial()) {
    on<LoadInvoiceListEvent>(_loadInvoicesEvent);
    on<DeleteInvoiceListEvent>(_deleteInvoicesEvent);
  }

  Future<void> _loadInvoicesEvent(
      LoadInvoiceListEvent event, Emitter<InvoiceListState> emit) async {
    emit(InvoiceListLoadingState());
    try {
      List<InvoiceModel>? invoices;
      if (event.searchValue == null || event.searchValue!.isEmpty) {
        invoices = await invoiceRepository.getAllInvoices();
      } else {
        final model =
            await invoiceRepository.getInvoiceByID(event.searchValue!);
        if (model == null) {
          invoices = null;
        } else {
          invoices = [model];
        }
      }
      if (invoices == null || invoices.isEmpty) {
        emit(const InvoiceListErrorState(
            message: "Couldn't find any invoices!"));
      } else {
        emit(InvoiceListLoadedState(invoices: invoices));
      }
    } catch (e) {
      emit(InvoiceListErrorState(message: "Error occoured! ${e.toString()}"));
    }
  }

  Future<void> _deleteInvoicesEvent(
      DeleteInvoiceListEvent event, Emitter<InvoiceListState> emit) async {
    try {
      await invoiceRepository.deleteInvoice(event.invoice);
    } catch (e) {
      emit(InvoiceListErrorState(
          message: "Couldn't delete invoice! ${e.toString()}"));
    }
  }
}
