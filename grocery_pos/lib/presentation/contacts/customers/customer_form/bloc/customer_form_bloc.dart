import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/customers/model/customer_model.dart';
import 'package:grocery_pos/domain_data/contacts/customers/repository/customer_repository.dart';

part 'customer_form_event.dart';
part 'customer_form_state.dart';

class CustomerFormBloc extends Bloc<CustomerFormEvent, CustomerFormState> {
  final CustomerRepository customerRepository;
  CustomerFormBloc({required this.customerRepository})
      : super(CustomerFormInitial()) {
    on<AddCustomerEvent>(_addCustomerEvent);
    on<UpdateCustomerEvent>(_updateCustomerEvent);
    on<LoadToEditCustomerEvent>(_loadToEditCustomerEvent);
    on<BackCategroyFormEvent>(_backCategroyFormEvent);
  }

  Future<void> _updateCustomerEvent(
      UpdateCustomerEvent event, Emitter<CustomerFormState> emit) async {
    emit(CustomerFormLoadingState());
    try {
      await customerRepository.updateCustomer(event.model);
      emit(const CustomerFormSuccessState(
          successMessage: "Update customer succesfully!"));
    } catch (e) {
      emit(CustomerFormErrorState(message: e.toString()));
    }
  }

  Future<void> _addCustomerEvent(
      AddCustomerEvent event, Emitter<CustomerFormState> emit) async {
    emit(CustomerFormLoadingState());
    try {
      final String newId = await customerRepository.getNewCustomerID();
      await customerRepository.createCustomer(event.model.copyWith(id: newId));
      emit(const CustomerFormSuccessState(
          successMessage: "Update customer succesfully!"));
    } catch (e) {
      emit(CustomerFormErrorState(message: e.toString()));
    }
  }

  Future<void> _loadToEditCustomerEvent(
      LoadToEditCustomerEvent event, Emitter<CustomerFormState> emit) async {
    emit(CustomerFormLoadingState());
    try {
      if (event.type == CustomerFormType.edit) {
        final latestModel =
            await customerRepository.getCustomerByID(event.model.id!);
        emit(CustomerFormLoadedState(latestModel, CustomerFormType.edit));
      } else {
        emit(CustomerFormLoadedState(
            CustomerModel.empty, CustomerFormType.createNew));
      }
    } catch (e) {
      emit(CustomerFormErrorState(message: e.toString()));
    }
  }

  Future<void> _backCategroyFormEvent(
      BackCategroyFormEvent event, Emitter<CustomerFormState> emit) async {
    emit(CustomerFormInitial());
  }
}
