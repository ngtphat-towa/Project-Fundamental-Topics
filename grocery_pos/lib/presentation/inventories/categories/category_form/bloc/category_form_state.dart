part of 'category_form_bloc.dart';

abstract class CategoryFormState extends Equatable {
  final CategoryModel? model;
  final CategoryFormType? type;
  const CategoryFormState({this.model, this.type});

  @override
  List<Object?> get props => [];
}

class CategoryFormInitial extends CategoryFormState {}

class CategoryFormLoadingState extends CategoryFormState {}

class CategoryFormLoadedState extends CategoryFormState {
  const CategoryFormLoadedState({
    CategoryModel? model,
    CategoryFormType? type = CategoryFormType.createNew,
  }) : super(model: model, type: type);
  @override
  List<Object?> get props => [model, type];
}

class CategoryFormValueChanged extends CategoryFormState {
  final bool? isValid;
  const CategoryFormValueChanged(
      {CategoryModel? model,
      CategoryFormType? type = CategoryFormType.createNew,
      this.isValid})
      : super(model: model, type: type);
  @override
  List<Object?> get props => [model, type, isValid];
}

class CategoryFormSuccessState extends CategoryFormState {
  final String? successMessage;
  const CategoryFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class CategoryFormErrorState extends CategoryFormState {
  final String? errorMessage;
  const CategoryFormErrorState({this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
