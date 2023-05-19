import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_data/authentications/models/models.dart';
import '../../../domain_data/authentications/repositories/user_repository.dart';


part 'user_form_event.dart';
part 'user_form_state.dart';

class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  final UserRepository userRepository;

  UserFormBloc({required this.userRepository}) : super(UserFormInitial()) {
    on<UpdateUserEvent>(_updateUserEvent);
    on<LoadToEditUserEvent>(_loadToEditUserEvent);
    on<BackCategroyFormEvent>(_backCategroyFormEvent);
  }

  Future<void> _updateUserEvent(
      UpdateUserEvent event, Emitter<UserFormState> emit) async {
    emit(UserFormLoadingState());
    try {
      await userRepository.updateUser(event.model);
      emit(const UserFormSuccessState(
          successMessage: "Update userProfile succesfully!"));
    } catch (e) {
      emit(UserFormErrorState(message: e.toString()));
    }
  }

  Future<void> _loadToEditUserEvent(
      LoadToEditUserEvent event, Emitter<UserFormState> emit) async {
    emit(UserFormLoadingState());
    try {
      final latestModel = await userRepository.getUser();
      if (latestModel != null) {
        emit(UserFormLoaded(model: latestModel, isValueChanged: false));
      } else {
        emit(const UserFormLoaded(
            model: UserModel.empty, isValueChanged: false));
      }
    } catch (e) {
      emit(UserFormErrorState(message: e.toString()));
    }
  }

  Future<void> _backCategroyFormEvent(
      BackCategroyFormEvent event, Emitter<UserFormState> emit) async {
    emit(UserFormInitial());
  }
}
