import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/inventories/products/services.dart';

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
        /// TODO: implement full text search instead of ID search
        final model =
            await productRepository.getProductByID(event.searchValue!);
        if (model == null) {
          products = null;
        } else {
          products = [model];
        }
      }
      emit(ProductListLoadedState(products: products));
      // }
    } catch (e) {
      emit(ProductListErrorState(
          message: "Couldn't find any products! ${e.toString()}"));
    }
  }

  Future<void> _deleteProductsEvent(
      DeleteProductListEvent event, Emitter<ProductListState> emit) async {
    final currentProducts = state.products?..remove(event.model);
    emit(ProductListLoadingState());
    try {
      /// Call Delete in Reposiotry
      await productRepository.deleteProduct(event.model);

      /// Use previous lists to avoid reloading many times
      final List<ProductModel?>? products =
          currentProducts ?? await productRepository.getAllProducts();

      /// Set the new event
      emit(ProductListLoadedState(products: products));
    } catch (e) {
      emit(ProductListErrorState(
          message: "Couldn't delete product! ${e.toString()}"));
    }
  }
}
