part of 'category_form_bloc.dart';

enum CategoryFormType { createNew, edit }

abstract class CategoryFormEvent extends Equatable {
  final CategoryModel? model;
  final CategoryFormType? type;
  const CategoryFormEvent({this.model, this.type});

  @override
  List<Object?> get props => [];
}

class LoadToEditCategoryEvent extends CategoryFormEvent {
  const LoadToEditCategoryEvent({
    CategoryModel? model,
    CategoryFormType? type = CategoryFormType.createNew,
  }) : super(model: model, type: type);
  @override
  List<Object?> get props => [model, type];
}

class AddCategoryEvent extends CategoryFormEvent {
  const AddCategoryEvent({required CategoryModel model}) : super(model: model);
  @override
  List<Object?> get props => [model];
}

class UpdateCategoryEvent extends CategoryFormEvent {
  const UpdateCategoryEvent({required CategoryModel model})
      : super(model: model);
  @override
  List<Object?> get props => [model];
}

class BackCategroyFormEvent extends CategoryFormEvent {}
