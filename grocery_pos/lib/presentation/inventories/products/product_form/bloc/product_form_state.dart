// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_form_bloc.dart';

abstract class ProductFormState extends Equatable {
  final ProductModel? model;
  final ProductFormType? type;
  final List<CategoryModel>? categories;
  final List<SupplierModel>? suppliers;

  const ProductFormState({
    this.model,
    this.type,
    this.categories,
    this.suppliers,
  });
  @override
  List<Object?> get props => [model, type, categories, suppliers];
}

class ProductFormInitial extends ProductFormState {}

class ProductFormLoadingState extends ProductFormState {}

class ProductFormLoadedState extends ProductFormState {
  const ProductFormLoadedState({
    ProductModel? model,
    ProductFormType? type,
    List<CategoryModel>? categories,
    List<SupplierModel>? suppliers,
  }) : super(
          model: model,
          type: type,
          categories: categories,
          suppliers: suppliers,
        );
  @override
  List<Object?> get props => [model, type, categories, suppliers];
}

class ProductFormValueChangedState extends ProductFormState {
  final bool? isValid;
  const ProductFormValueChangedState({
    ProductModel? model,
    ProductFormType? type,
    List<CategoryModel>? categories,
    List<SupplierModel>? suppliers,
    this.isValid,
  }) : super(
            model: model,
            type: type,
            categories: categories,
            suppliers: suppliers);
  @override
  List<Object?> get props => [model, type, isValid];
}

class ProductFormSuccessState extends ProductFormState {
  final String? successMessage;
  const ProductFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class ProductFormErrorState extends ProductFormState {
  final String? errorMessage;
  const ProductFormErrorState({this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
