import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/model/supplier_model.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/repository/supplier_repository.dart';

part 'supplier_form_event.dart';
part 'supplier_form_state.dart';

class SupplierFormBloc extends Bloc<SupplierFormEvent, SupplierFormState> {
  final SupplierRepository supplierRepository;
  SupplierFormBloc({required this.supplierRepository})
      : super(SupplierFormInitial()) {
    on<AddSupplierEvent>(_addSupplierEvent);
    on<UpdateSupplierEvent>(_updateSupplierEvent);
    on<LoadToEditSupplierEvent>(_loadToEditSupplierEvent);
    on<BackCategroyFormEvent>(_backCategroyFormEvent);
  }

  Future<void> _updateSupplierEvent(
      UpdateSupplierEvent event, Emitter<SupplierFormState> emit) async {
    emit(SupplierFormLoadingState());
    try {
      await supplierRepository.updateSupplier(event.model);
      emit(const SupplierFormSuccessState(
          successMessage: "Update supplier succesfully!"));
    } catch (e) {
      emit(SupplierFormErrorState(message: e.toString()));
    }
  }

  Future<void> _addSupplierEvent(
      AddSupplierEvent event, Emitter<SupplierFormState> emit) async {
    emit(SupplierFormLoadingState());
    try {
      final String newId = await supplierRepository.getNewSupplierID();
      await supplierRepository.createSupplier(event.model.copyWith(id: newId));
      emit(const SupplierFormSuccessState(
          successMessage: "Update supplier succesfully!"));
    } catch (e) {
      emit(SupplierFormErrorState(message: e.toString()));
    }
  }

  Future<void> _loadToEditSupplierEvent(
      LoadToEditSupplierEvent event, Emitter<SupplierFormState> emit) async {
    emit(SupplierFormLoadingState());
    try {
      if (event.type == SupplierFormType.edit) {
        final latestModel =
            await supplierRepository.getSupplierByID(event.model.id!);
        emit(SupplierFormLoadedState(latestModel, SupplierFormType.edit));
      } else {
        emit(SupplierFormLoadedState(
            SupplierModel.empty, SupplierFormType.createNew));
      }
    } catch (e) {
      emit(SupplierFormErrorState(message: e.toString()));
    }
  }

  Future<void> _backCategroyFormEvent(
      BackCategroyFormEvent event, Emitter<SupplierFormState> emit) async {
    emit(SupplierFormInitial());
  }
}
