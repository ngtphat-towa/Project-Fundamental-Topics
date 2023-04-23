part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoadingState extends ProductListState {}

class ProductListLoadedState extends ProductListState {
  final List<ProductModel?>? products;

  const ProductListLoadedState({required this.products});
  @override
  List<Object?> get props => [products];
}

class ProductListErrorState extends ProductListState {
  final String? message;

  const ProductListErrorState({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}
