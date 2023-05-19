part of 'product_list_bloc.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductListEvent extends ProductListEvent {
  final String? searchValue;
  const LoadProductListEvent({this.searchValue});
  @override
  List<Object?> get props => [searchValue];
}

class DeleteProductListEvent extends ProductListEvent {
  final ProductModel model;
  const DeleteProductListEvent({required this.model});
  @override
  List<Object?> get props => [model];
}
