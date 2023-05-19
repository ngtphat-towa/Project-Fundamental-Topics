import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/models/supplier_model.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/repositories/supplier_repository.dart';
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
    on<BackProductFormEvent>(_backCategroyFormEvent);
    // on<LoadToDropDownListsEvent>(_loadToDropDownListsEvent);
    on<ValueChangedProductEvent>(_valueChangedProductEvent);
  }

  Future<void> _updateProductEvent(
      UpdateProductEvent event, Emitter<ProductFormState> emit) async {
    emit(ProductFormLoadingState());
    try {
      await productRepository.updateProduct(event.model!);
      emit(const ProductFormSuccessState(
          successMessage: "Update product succesfully!"));
    } catch (e) {
      emit(ProductFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _addProductEvent(
      AddProductEvent event, Emitter<ProductFormState> emit) async {
    emit(ProductFormLoadingState());
    try {
      final String newId = await productRepository.getNewProductID();
      await productRepository.createProduct(event.model!.copyWith(id: newId));
      emit(const ProductFormSuccessState(
          successMessage: "Add product succesfully!"));
    } catch (e) {
      emit(ProductFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _loadToEditProductEvent(
      LoadToEditProductEvent event, Emitter<ProductFormState> emit) async {
    emit(ProductFormLoadingState());
    try {
      List<CategoryModel>? categories = <CategoryModel>[
        CategoryModel.empty,
        ...?(await categoryRepository.getAllCategoryNames()),
      ];
      List<SupplierModel>? suppliers = <SupplierModel>[
        SupplierModel.emptyName,
        ...?(await supplierRepository.getAllSupplierNames())
      ];

      if (event.type == ProductFormType.edit) {
        final latestModel = event.model ??
            await productRepository.getProductByID(event.model!.id!);
        emit(ProductFormLoadedState(
            model: latestModel,
            type: ProductFormType.edit,
            categories: categories,
            suppliers: suppliers));
      } else {
        emit(ProductFormLoadedState(
            model: ProductModel.empty,
            type: ProductFormType.createNew,
            categories: categories,
            suppliers: suppliers));
      }
    } catch (e) {
      emit(ProductFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _backCategroyFormEvent(
      BackProductFormEvent event, Emitter<ProductFormState> emit) async {
    emit(ProductFormInitial());
  }

  // Future<void> _loadToDropDownListsEvent(
  //     LoadToDropDownListsEvent event, Emitter<ProductFormState> emit) async {
  //   emit(const ProductFormLoadingState());

  //   try {
  //     List<CategoryModel>? categories = <CategoryModel>[
  //       CategoryModel.empty,
  //       ...?(await categoryRepository.getAllCategoryNames()),
  //     ];
  //     List<SupplierModel>? suppliers = [
  //       SupplierModel.empty,
  //       ...?(await supplierRepository.getAllSupplierNames())
  //     ];

  //     emit(ProductFormLoadingState(
  //         categories: categories, suppliers: suppliers));
  //   } catch (e) {
  //     emit(ProductFormErrorState(
  //         errorMessage:
  //             "Cant load category or supplier list: ${e.toString()}"));
  //   }
  // }

  Future<void> _valueChangedProductEvent(
      ValueChangedProductEvent event, Emitter<ProductFormState> emit) async {
    try {
      List<CategoryModel>? categories = state.categories;
      List<SupplierModel>? suppliers = state.suppliers;
      final bool isValid = _validateModel(event.model!);
      emit(ProductFormValueChangedState(
        model: event.model,
        type: event.type,
        isValid: isValid,
        suppliers: suppliers,
        categories: categories,
      ));
    } catch (e) {
      emit(ProductFormErrorState(errorMessage: e.toString()));
    }
  }

  /// TODO: handle validation this form

  bool _validateModel(ProductModel model) {
    //if (model.name.isEmpty) return false;
    return true;
  }
}
