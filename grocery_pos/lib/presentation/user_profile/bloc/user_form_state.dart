part of 'user_form_bloc.dart';

abstract class UserFormState extends Equatable {
  const UserFormState();

  @override
  List<Object?> get props => [];
}

class UserFormInitial extends UserFormState {}

class UserFormLoadingState extends UserFormState {}

class UserFormLoaded extends UserFormState {
  final UserModel? model;
  final bool? isValueChanged;
  const UserFormLoaded({this.model, this.isValueChanged});
  @override
  List<Object?> get props => [model, isValueChanged];
}

class UserFormSuccessState extends UserFormState {
  final String? successMessage;
  const UserFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class UserFormErrorState extends UserFormState {
  final String? message;
  const UserFormErrorState({this.message});
  @override
  List<Object?> get props => [message];
}
