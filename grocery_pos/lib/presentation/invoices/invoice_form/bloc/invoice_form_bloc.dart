import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/customers/model/customer_model.dart';
import 'package:grocery_pos/domain_data/contacts/customers/repository/customer_repository.dart';
import 'package:grocery_pos/domain_data/inventories/products/repositories/product_repository.dart';
import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_model.dart';
import 'package:grocery_pos/domain_data/pos/invoices/repositories/invoice_repository.dart';

part 'invoice_form_event.dart';
part 'invoice_form_state.dart';

class InvoiceFormBloc extends Bloc<InvoiceFormEvent, InvoiceFormState> {
  final InvoiceRepository invoiceRepository;
  final ProductRepository productRepository;
  final CustomerRepository customerRepository;

  InvoiceFormBloc(
      {required this.invoiceRepository,
      required this.productRepository,
      required this.customerRepository})
      : super(InvoiceFormInitial()) {
    on<AddInvoiceEvent>(_addInvoiceEvent);
    on<UpdateInvoiceEvent>(_updateInvoiceEvent);
    on<LoadToEditInvoiceEvent>(_loadToEditInvoiceEvent);
    on<BackCategroyFormEvent>(_backCategroyFormEvent);

    // on<InvoiceValueChangedEvent>(_invoiceValueChangedEvent);
  }

  Future<void> _updateInvoiceEvent(
      UpdateInvoiceEvent event, Emitter<InvoiceFormState> emit) async {
    emit(InvoiceFormLoadingState());
    try {
      await invoiceRepository.updateInvoice(event.model);
      emit(const InvoiceFormSuccessState(
          successMessage: "Update invoice succesfully!"));
    } catch (e) {
      emit(InvoiceFormErrorState(message: e.toString()));
    }
  }

  Future<void> _addInvoiceEvent(
      AddInvoiceEvent event, Emitter<InvoiceFormState> emit) async {
    emit(InvoiceFormLoadingState());
    try {
      final newId = await invoiceRepository.getNewInvoiceID();
      await invoiceRepository.createInvoice(event.model.copyWith(id: newId));
      emit(const InvoiceFormSuccessState(
          successMessage: "Update invoice succesfully!"));
    } catch (e) {
      emit(InvoiceFormErrorState(message: e.toString()));
    }
  }

  Future<void> _loadToEditInvoiceEvent(
      LoadToEditInvoiceEvent event, Emitter<InvoiceFormState> emit) async {
    emit(InvoiceFormLoadingState());
    try {
      List<CustomerModel>? customers = event.customers ??
          [
            CustomerModel.empty,
            ...?(await customerRepository.getAllCustomerNames())
          ];

      if (event.type == InvoiceFormType.edit) {
        final latestModel = event.isValueChanged!
            ? event.model
            : await invoiceRepository.getInvoiceByID(event.model!.id!);
        emit(InvoiceFormLoadedState(
          invoice: latestModel,
          customers: customers,
          formType: event.type,
        ));
      } else {
        final latestModel =
            event.isValueChanged! ? event.model : InvoiceModel.empty;
        emit(InvoiceFormLoadedState(
            invoice: latestModel,
            formType: InvoiceFormType.createNew,
            customers: customers));
      }
    } catch (e) {
      emit(InvoiceFormErrorState(message: e.toString()));
    }
  }

  Future<void> _backCategroyFormEvent(
      BackCategroyFormEvent event, Emitter<InvoiceFormState> emit) async {
    emit(InvoiceFormInitial());
  }

//   Future<void> _invoiceValueChangedEvent(
//       InvoiceValueChangedEvent event, Emitter<InvoiceFormState> emit) async {
//     try {
//       List<CustomerModel>? customers = [
//         CustomerModel.empty,
//         ...?(await customerRepository.getAllCustomerNames())
//       ];
//       emit(InvoiceFormValueChangedState(
//           formType: event.formType,
//           invoice: event.model,
//           customers: customers));
//     } catch (e) {
//       emit(InvoiceFormErrorState(message: e.toString()));
//     }
//   }
}
