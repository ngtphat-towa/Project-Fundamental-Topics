part of 'category_list_bloc.dart';

abstract class CategoryListState extends Equatable {
  const CategoryListState();

  @override
  List<Object?> get props => [];
}

class CategoryListInitial extends CategoryListState {}

class CategoryListLoadingState extends CategoryListState {}

class CategoryListLoadedState extends CategoryListState {
  final List<CategoryModel>? categories;

  const CategoryListLoadedState({this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoryListErrorState extends CategoryListState {
  final String? message;

  const CategoryListErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
