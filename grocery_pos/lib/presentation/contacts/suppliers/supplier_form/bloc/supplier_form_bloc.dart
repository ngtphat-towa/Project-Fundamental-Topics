import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/contacts/suppliers/services.dart';

part 'supplier_form_event.dart';
part 'supplier_form_state.dart';

class SupplierFormBloc extends Bloc<SupplierFormEvent, SupplierFormState> {
  final SupplierRepository supplierRepository;
  SupplierFormBloc({required this.supplierRepository})
      : super(SupplierFormInitial()) {
    on<AddSupplierEvent>(_addSupplierEvent);
    on<UpdateSupplierEvent>(_updateSupplierEvent);
    on<LoadSupplierFormEvent>(_loadSupplierFormEvent);
    on<ValueChangedSupplierEvent>(_valueChangedSupplierEvent);
    on<BackSupplierFormEvent>(_backSupplierFormEvent);
  }

  Future<void> _updateSupplierEvent(
      UpdateSupplierEvent event, Emitter<SupplierFormState> emit) async {
    final model = event.model;
    final currentModel =
        await supplierRepository.getSupplierByID(event.model!.id!);
    if (model == currentModel) return;
    emit(SupplierFormLoadingState());

    try {
      await supplierRepository.updateSupplier(event.model!);
      emit(const SupplierFormSuccessState(
          successMessage: "Update supplier succesfully!"));
    } catch (e) {
      emit(SupplierFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _addSupplierEvent(
      AddSupplierEvent event, Emitter<SupplierFormState> emit) async {
    if (event.model! == SupplierModel.empty) return;

    emit(SupplierFormLoadingState());
    try {
      final String newId = await supplierRepository.getNewSupplierID();
      await supplierRepository.createSupplier(event.model!.copyWith(id: newId));
      emit(const SupplierFormSuccessState(
          successMessage: "Add new supplier succesfully!"));
    } catch (e) {
      emit(SupplierFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _loadSupplierFormEvent(
      LoadSupplierFormEvent event, Emitter<SupplierFormState> emit) async {
    emit(SupplierFormLoadingState());

    try {
      if (event.type == SupplierFormType.edit) {
        /// check current model changed
        final latestModel = event.model ??
            await supplierRepository.getSupplierByID(event.model!.id!);

        /// Reload the UI
        emit(SupplierFormLoadedState(
            model: latestModel, type: SupplierFormType.edit));
      } else if (event.type == SupplierFormType.createNew) {
        /// Check current model is default or not
        emit(SupplierFormLoadedState(
          model: SupplierModel.empty,
          type: SupplierFormType.createNew,
        ));
      }
    } catch (e) {
      /// Simple catch
      emit(SupplierFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _backSupplierFormEvent(
      BackSupplierFormEvent event, Emitter<SupplierFormState> emit) async {
    emit(SupplierFormInitial());
  }

  Future<void> _valueChangedSupplierEvent(
      ValueChangedSupplierEvent event, Emitter<SupplierFormState> emit) async {
    /// check current model changed

    try {
      final bool isValid = _validateModel(event.model!);
      emit(SupplierFormValueChangedState(
        model: event.model,
        type: event.type,
        isValid: isValid,
      ));
    } catch (e) {
      /// Simple catch
      emit(SupplierFormErrorState(errorMessage: e.toString()));
    }
  }

  /// TODO: handle validation this form
  bool _validateModel(SupplierModel model) {
    // //if (model.name.isEmpty) return false;
    return true;
  }
}
