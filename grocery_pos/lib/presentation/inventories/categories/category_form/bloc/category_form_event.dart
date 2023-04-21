part of 'category_form_bloc.dart';

enum CategoryFormType { createNew, edit }

abstract class CategoryFormEvent extends Equatable {
  const CategoryFormEvent();

  @override
  List<Object?> get props => [];
}

class AddCategoryEvent extends CategoryFormEvent {
  final CategoryModel model;

  const AddCategoryEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class LoadToEditCategoryEvent extends CategoryFormEvent {
  final CategoryModel model;
  final CategoryFormType type;
  const LoadToEditCategoryEvent(this.model, this.type);
  @override
  List<Object?> get props => [model];
}

class UpdateCategoryEvent extends CategoryFormEvent {
  final CategoryModel model;

  const UpdateCategoryEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class BackCategroyEvent extends CategoryFormEvent {}
