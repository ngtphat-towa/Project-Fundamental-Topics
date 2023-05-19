part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  final List<ProductModel?>? products;

  const ProductListState({this.products});

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoadingState extends ProductListState {}

class ProductListLoadedState extends ProductListState {
  const ProductListLoadedState({List<ProductModel?>? products})
      : super(products: products);
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
