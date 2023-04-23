import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/model/supplier_model.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/repository/supplier_repository.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';
import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
import 'package:grocery_pos/domain_data/inventories/products/repositories/product_repository.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;
  final SupplierRepository supplierRepository;
  ProductFormBloc(
      {required this.productRepository,
      required this.categoryRepository,
      required this.supplierRepository})
      : super(ProductFormInitial()) {
    on<AddProductEvent>(_addProductEvent);
    on<UpdateProductEvent>(_updateProductEvent);
    on<LoadToEditProductEvent>(_loadToEditProductEvent);
    on<BackCategroyFormEvent>(_backCategroyFormEvent);
    on<LoadToDropDownListsEvent>(_loadToDropDownListsEvent);
    on<ProductValueChangedEvent>(_productValueChangedEvent);
  }

  Future<void> _updateProductEvent(
      UpdateProductEvent event, Emitter<ProductFormState> emit) async {
    emit(const ProductFormLoadingState());
    try {
      await productRepository.updateProduct(event.model);
      emit(const ProductFormSuccessState(
          successMessage: "Update product succesfully!"));
    } catch (e) {
      emit(ProductFormErrorState(message: e.toString()));
    }
  }

  Future<void> _addProductEvent(
      AddProductEvent event, Emitter<ProductFormState> emit) async {
    emit(const ProductFormLoadingState());
    try {
      final String newId = await productRepository.getNewProductID();
      await productRepository.createProduct(event.model.copyWith(id: newId));
      emit(const ProductFormSuccessState(
          successMessage: "Update product succesfully!"));
    } catch (e) {
      emit(ProductFormErrorState(message: e.toString()));
    }
  }

  Future<void> _loadToEditProductEvent(
      LoadToEditProductEvent event, Emitter<ProductFormState> emit) async {
    emit(const ProductFormLoadingState());
    try {
      List<CategoryModel>? categories = <CategoryModel>[
        CategoryModel.empty,
        ...?(await categoryRepository.getAllCategoryNames()),
      ];
      List<SupplierModel>? suppliers = [
        SupplierModel.empty,
        ...?(await supplierRepository.getAllSupplierNames())
      ];

      if (event.type == ProductFormType.edit) {
        final latestModel =
            await productRepository.getProductByID(event.model!.id!);
        emit(ProductFormLoadedState(
            product: latestModel,
            type: ProductFormType.edit,
            categories: categories,
            suppliers: suppliers));
      } else {
        emit(ProductFormLoadedState(
            product: ProductModel.empty,
            type: ProductFormType.createNew,
            categories: categories,
            suppliers: suppliers));
      }
    } catch (e) {
      emit(ProductFormErrorState(message: e.toString()));
    }
  }

  Future<void> _backCategroyFormEvent(
      BackCategroyFormEvent event, Emitter<ProductFormState> emit) async {
    emit(ProductFormInitial());
  }

  Future<void> _loadToDropDownListsEvent(
      LoadToDropDownListsEvent event, Emitter<ProductFormState> emit) async {
    emit(const ProductFormLoadingState());

    try {
      final categories = await categoryRepository.getAllCategoryNames();
      final suppliers = await supplierRepository.getAllSupplierNames();
      if (categories == null || suppliers == null) {
        emit(const ProductFormErrorState(
            message: "Cant load category or supplier list"));
      } else {
        emit(ProductFormLoadingState(
            categories: categories, suppliers: suppliers));
      }
    } catch (e) {
      emit(ProductFormErrorState(
          message: "Cant load category or supplier list: ${e.toString()}"));
    }
  }

  Future<void> _productValueChangedEvent(
      ProductValueChangedEvent event, Emitter<ProductFormState> emit) async {
    emit(ProductFormValueChangedState(event.model));
  }
}
