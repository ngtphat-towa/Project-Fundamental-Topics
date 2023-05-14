part of 'category_list_bloc.dart';

abstract class CategoryListState extends Equatable {
  const CategoryListState();

  @override
  List<Object?> get props => [];
}

class CategoryListInitial extends CategoryListState {}

class CategoryListLoadingState extends CategoryListState {}

class CategoryListLoadedState extends CategoryListState {
  final List<CategoryModel>? models;

  const CategoryListLoadedState({this.models});

  @override
  List<Object?> get props => [models];
}

class CategoryListErrorState extends CategoryListState {
  final String? message;

  const CategoryListErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
