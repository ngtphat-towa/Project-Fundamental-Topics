part of 'store_form_bloc.dart';

abstract class StoreFormState extends Equatable {
  const StoreFormState();

  @override
  List<Object?> get props => [];
}

class StoreFormInitial extends StoreFormState {}

class StoreFormLoadingState extends StoreFormState {}

class StoreFormLoaded extends StoreFormState {
  final StoreProfileModel? model;
  final bool? isValueChanged;
  const StoreFormLoaded({this.model, this.isValueChanged});
  @override
  List<Object?> get props => [model, isValueChanged];
}

class StoreFormSuccessState extends StoreFormState {
  final String? successMessage;
  const StoreFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class StoreFormErrorState extends StoreFormState {
  final String? message;
  const StoreFormErrorState({this.message});
  @override
  List<Object?> get props => [message];
}
