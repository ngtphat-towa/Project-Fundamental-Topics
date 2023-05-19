import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/store/models/store_profile_model.dart';
import 'package:grocery_pos/domain_data/store/repositories/store_profile_repository.dart';

part 'store_form_event.dart';
part 'store_form_state.dart';

class StoreFormBloc extends Bloc<StoreFormEvent, StoreFormState> {
  final StoreProfileRepository storeProfileRepository;
  StoreFormBloc({required this.storeProfileRepository})
      : super(StoreFormInitial()) {
    on<UpdateStoreEvent>(_updateStoreEvent);
    on<LoadToEditStoreEvent>(_loadToEditStoreEvent);
    on<BackCategroyFormEvent>(_backCategroyFormEvent);
  }

  Future<void> _updateStoreEvent(
      UpdateStoreEvent event, Emitter<StoreFormState> emit) async {
    emit(StoreFormLoadingState());
    try {
      await storeProfileRepository.updateStoreProfile(event.model);
      emit(const StoreFormSuccessState(
          successMessage: "Update storeProfile succesfully!"));
    } catch (e) {
      emit(StoreFormErrorState(message: e.toString()));
    }
  }

  Future<void> _loadToEditStoreEvent(
      LoadToEditStoreEvent event, Emitter<StoreFormState> emit) async {
    emit(StoreFormLoadingState());
    try {
      final latestModel = await storeProfileRepository.getStoreProfile();
      if (latestModel != null) {
        emit(StoreFormLoaded(model: latestModel, isValueChanged: false));
      } else {
        emit(StoreFormLoaded(
            model: StoreProfileModel.empty, isValueChanged: false));
      }
    } catch (e) {
      emit(StoreFormErrorState(message: e.toString()));
    }
  }

  Future<void> _backCategroyFormEvent(
      BackCategroyFormEvent event, Emitter<StoreFormState> emit) async {
    emit(StoreFormInitial());
  }
}
