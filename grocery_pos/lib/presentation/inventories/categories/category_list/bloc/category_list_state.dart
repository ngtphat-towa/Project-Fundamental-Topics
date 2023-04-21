part of 'category_list_bloc.dart';

abstract class CategoryListState extends Equatable {
  const CategoryListState();

  @override
  List<Object?> get props => [];
}

class CategoryListInitial extends CategoryListState {}

class CategoryListLoading extends CategoryListState {}

class CategoryListLoaded extends CategoryListState {
  final List<CategoryModel>? categories;

  const CategoryListLoaded({this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoryListError extends CategoryListState {
  final String? message;

  const CategoryListError(this.message);
  @override
  List<Object?> get props => [message];
}
