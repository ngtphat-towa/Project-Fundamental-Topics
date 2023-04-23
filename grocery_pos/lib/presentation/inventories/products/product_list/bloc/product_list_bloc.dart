import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
import 'package:grocery_pos/domain_data/inventories/products/repositories/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository productRepository;
  ProductListBloc({required this.productRepository})
      : super(ProductListInitial()) {
    on<LoadProductListEvent>(_loadProductsEvent);
    on<DeleteProductListEvent>(_deleteProductsEvent);
  }

  Future<void> _loadProductsEvent(
      LoadProductListEvent event, Emitter<ProductListState> emit) async {
    emit(ProductListLoadingState());
    try {
      List<ProductModel?>? products;
      if (event.searchValue == null || event.searchValue!.isEmpty) {
        products = await productRepository.getAllProducts();
      } else {
        final model =
            await productRepository.getProductByID(event.searchValue!);
        if (model == null) {
          products = null;
        } else {
          products = [model];
        }
      }
      if (products == null || products.isEmpty) {
        emit(const ProductListErrorState(
            message: "Couldn't find any products!"));
      } else {
        emit(ProductListLoadedState(products: products));
      }
    } catch (e) {
      emit(ProductListErrorState(
          message: "Couldn't find any products! ${e.toString()}"));
    }
  }

  Future<void> _deleteProductsEvent(
      DeleteProductListEvent event, Emitter<ProductListState> emit) async {
    try {
      await productRepository.deleteProduct(event.product);
    } catch (e) {
      emit(ProductListErrorState(
          message: "Couldn't delete product! ${e.toString()}"));
    }
  }
}
