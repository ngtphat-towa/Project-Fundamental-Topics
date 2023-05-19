import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/contacts/suppliers/services.dart';

part 'supplier_list_event.dart';
part 'supplier_list_state.dart';

class SupplierListBloc extends Bloc<SupplierListEvent, SupplierListState> {
  final SupplierRepository supplierRepository;
  SupplierListBloc({required this.supplierRepository})
      : super(SupplierListInitial()) {
    on<LoadSupplierListEvent>(_loadSuppliersEvent);
    on<DeleteSupplierListEvent>(_deleteSuppliersEvent);
  }

  Future<void> _loadSuppliersEvent(
      LoadSupplierListEvent event, Emitter<SupplierListState> emit) async {
    emit(SupplierListLoadingState());
    try {
      List<SupplierModel?>? suppliers;
      if (event.searchValue == null || event.searchValue!.isEmpty) {
        suppliers = await supplierRepository.getAllSuppliers();
      } else {
        final model =
            await supplierRepository.getSupplierByID(event.searchValue!);
        if (model == null) {
          suppliers = null;
        } else {
          suppliers = [model];
        }
      }
      if (suppliers == null || suppliers.isEmpty) {
        emit(const SupplierListErrorState(
            errorMessage: "Couldn't find any suppliers!"));
      } else {
        emit(SupplierListLoadedState(suppliers: suppliers));
      }
    } catch (e) {
      emit(SupplierListErrorState(
          errorMessage: "Couldn't find any suppliers! ${e.toString()}"));
    }
  }

  Future<void> _deleteSuppliersEvent(
      DeleteSupplierListEvent event, Emitter<SupplierListState> emit) async {
    try {
      await supplierRepository.deleteSupplier(event.model);
    } catch (e) {
      emit(SupplierListErrorState(
          errorMessage: "Couldn't delete supplier! ${e.toString()}"));
    }
  }
}
