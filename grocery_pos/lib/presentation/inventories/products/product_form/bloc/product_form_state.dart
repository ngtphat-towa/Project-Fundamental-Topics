part of 'product_form_bloc.dart';

abstract class ProductFormState extends Equatable {
  const ProductFormState();

  @override
  List<Object?> get props => [];
}

class ProductFormInitial extends ProductFormState {}

class ProductFormLoadingState extends ProductFormState {
  final List<CategoryModel>? categories;
  final List<SupplierModel>? suppliers;

  const ProductFormLoadingState({this.categories, this.suppliers});
}

class ProductFormLoadedState extends ProductFormState {
  final List<CategoryModel?>? categories;
  final List<SupplierModel?>? suppliers;

  final ProductModel? product;

  final ProductFormType type;
  const ProductFormLoadedState({
    this.product,
    required this.type,
    this.categories,
    this.suppliers,
  });
  @override
  List<Object?> get props => [product, type, categories, suppliers];
}

class ProductFormValueChangedState extends ProductFormState {
  final ProductModel? product;

  const ProductFormValueChangedState(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductFormSuccessState extends ProductFormState {
  final String? successMessage;
  const ProductFormSuccessState({this.successMessage});
  @override
  List<Object?> get props => [successMessage];
}

class ProductFormErrorState extends ProductFormState {
  final String? message;
  const ProductFormErrorState({this.message});
  @override
  List<Object?> get props => [message];
}
