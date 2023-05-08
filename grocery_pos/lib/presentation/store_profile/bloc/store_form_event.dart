part of 'store_form_bloc.dart';

abstract class StoreFormEvent extends Equatable {
  const StoreFormEvent();

  @override
  List<Object?> get props => [];
}

class LoadToEditStoreEvent extends StoreFormEvent {
  final StoreProfileModel model;
  final bool? isValueChanged;
  const LoadToEditStoreEvent(
      {required this.model, this.isValueChanged = false});
  @override
  List<Object?> get props => [model];
}

class UpdateStoreEvent extends StoreFormEvent {
  final StoreProfileModel model;

  const UpdateStoreEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class BackCategroyFormEvent extends StoreFormEvent {}
