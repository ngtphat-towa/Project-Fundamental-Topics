part of 'category_list_bloc.dart';

abstract class CategoryListEvent extends Equatable {
  const CategoryListEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoryListEvent extends CategoryListEvent {
  final List<CategoryModel>? categories;

  const LoadCategoryListEvent({this.categories});

  @override
  List<Object?> get props => [categories];
}

class DeleteCategoryEvent extends CategoryListEvent {
  final CategoryModel model;

  const DeleteCategoryEvent(this.model);
  @override
  List<Object?> get props => [model];
}
