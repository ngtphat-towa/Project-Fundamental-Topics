part of 'user_form_bloc.dart';

abstract class UserFormEvent extends Equatable {
  const UserFormEvent();

  @override
  List<Object?> get props => [];
}

class LoadToEditUserEvent extends UserFormEvent {
  final UserModel model;
  final bool? isValueChanged;
  const LoadToEditUserEvent({required this.model, this.isValueChanged = false});
  @override
  List<Object?> get props => [model];
}

class UpdateUserEvent extends UserFormEvent {
  final UserModel model;

  const UpdateUserEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class BackCategroyFormEvent extends UserFormEvent {}
