import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/contacts/customers/services.dart';

part 'customer_form_event.dart';
part 'customer_form_state.dart';

class CustomerFormBloc extends Bloc<CustomerFormEvent, CustomerFormState> {
  final CustomerRepository customerRepository;
  CustomerFormBloc({required this.customerRepository})
      : super(CustomerFormInitial()) {
    on<AddCustomerEvent>(_addCustomerEvent);
    on<UpdateCustomerEvent>(_updateCustomerEvent);
    on<LoadCustomerFormEvent>(_loadCustomerFormEvent);
    on<ValueChangedCustomerEvent>(_valueChangedCustomerEvent);
    on<BackCustomerFormEvent>(_backCustomerFormEvent);
  }

  Future<void> _updateCustomerEvent(
      UpdateCustomerEvent event, Emitter<CustomerFormState> emit) async {
    final model = event.model;
    final currentModel =
        await customerRepository.getCustomerByID(event.model!.id!);
    if (model == currentModel) return;
    emit(CustomerFormLoadingState());

    try {
      await customerRepository.updateCustomer(event.model!);
      emit(const CustomerFormSuccessState(
          successMessage: "Update customer succesfully!"));
    } catch (e) {
      emit(CustomerFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _addCustomerEvent(
      AddCustomerEvent event, Emitter<CustomerFormState> emit) async {
    if (event.model! == CustomerModel.empty) return;

    emit(CustomerFormLoadingState());
    try {
      final String newId = await customerRepository.getNewCustomerID();
      await customerRepository.createCustomer(event.model!.copyWith(id: newId));
      emit(const CustomerFormSuccessState(
          successMessage: "Add new customer succesfully!"));
    } catch (e) {
      emit(CustomerFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _loadCustomerFormEvent(
      LoadCustomerFormEvent event, Emitter<CustomerFormState> emit) async {
    emit(CustomerFormLoadingState());

    try {
      if (event.type == CustomerFormType.edit) {
        /// check current model changed
        final latestModel = event.model ??
            await customerRepository.getCustomerByID(event.model!.id!);

        /// Reload the UI
        emit(CustomerFormLoadedState(
            model: latestModel, type: CustomerFormType.edit));
      } else if (event.type == CustomerFormType.createNew) {
        /// Check current model is default or not
        emit(CustomerFormLoadedState(
          model: CustomerModel.empty,
          type: CustomerFormType.createNew,
        ));
      }
    } catch (e) {
      /// Simple catch
      emit(CustomerFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _backCustomerFormEvent(
      BackCustomerFormEvent event, Emitter<CustomerFormState> emit) async {
    emit(CustomerFormInitial());
  }

  Future<void> _valueChangedCustomerEvent(
      ValueChangedCustomerEvent event, Emitter<CustomerFormState> emit) async {
    /// check current model changed

    try {
      final bool isValid = _validateModel(event.model!);
      emit(CustomerFormValueChangedState(
        model: event.model,
        type: event.type,
        isValid: isValid,
      ));
    } catch (e) {
      /// Simple catch
      emit(CustomerFormErrorState(errorMessage: e.toString()));
    }
  }

  /// TODO: handle validation this form
  bool _validateModel(CustomerModel model) {
    // //if (model.name.isEmpty) return false;
    return true;
  }
}
