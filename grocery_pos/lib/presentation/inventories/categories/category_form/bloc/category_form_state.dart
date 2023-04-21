part of 'category_form_bloc.dart';

abstract class CategoryFormState extends Equatable {
  const CategoryFormState();

  @override
  List<Object?> get props => [];
}

class CategoryFormInitial extends CategoryFormState {}

class CategoryFormLoadingState extends CategoryFormState {}

class CategoryFormLoaded extends CategoryFormState {
  final CategoryModel? category;
  final CategoryFormType type;
  const CategoryFormLoaded(this.category, this.type);
  @override
  List<Object?> get props => [category];
}

class CategoryFormSuccessState extends CategoryFormState {
  final String? successMessage;
  const CategoryFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class CategoryFormErrorState extends CategoryFormState {
  final String? message;
  const CategoryFormErrorState({this.message});
  @override
  List<Object?> get props => [message];
}
