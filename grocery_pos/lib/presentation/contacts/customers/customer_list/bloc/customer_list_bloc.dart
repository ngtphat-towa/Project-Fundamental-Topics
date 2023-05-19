import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/contacts/customers/services.dart';

part 'customer_list_event.dart';
part 'customer_list_state.dart';

class CustomerListBloc extends Bloc<CustomerListEvent, CustomerListState> {
  final CustomerRepository customerRepository;
  CustomerListBloc({required this.customerRepository})
      : super(CustomerListInitial()) {
    on<LoadCustomerListEvent>(_loadCustomersEvent);
    on<DeleteCustomerListEvent>(_deleteCustomersEvent);
  }

  Future<void> _loadCustomersEvent(
      LoadCustomerListEvent event, Emitter<CustomerListState> emit) async {
    emit(CustomerListLoadingState());
    try {
      List<CustomerModel?>? customers;
      if (event.searchValue == null || event.searchValue!.isEmpty) {
        customers = await customerRepository.getAllCustomers();
      } else {
        final model =
            await customerRepository.getCustomerByID(event.searchValue!);
        if (model == null) {
          customers = null;
        } else {
          customers = [model];
        }
      }
      if (customers == null || customers.isEmpty) {
        emit(const CustomerListErrorState(
            errorMessage: "Couldn't find any customers!"));
      } else {
        emit(CustomerListLoadedState(customers: customers));
      }
    } catch (e) {
      emit(CustomerListErrorState(
          errorMessage: "Couldn't find any customers! ${e.toString()}"));
    }
  }

  Future<void> _deleteCustomersEvent(
      DeleteCustomerListEvent event, Emitter<CustomerListState> emit) async {
    try {
      await customerRepository.deleteCustomer(event.model);
    } catch (e) {
      emit(CustomerListErrorState(
          errorMessage: "Couldn't delete customer! ${e.toString()}"));
    }
  }
}
