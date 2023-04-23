part of 'product_form_bloc.dart';

enum ProductFormType { createNew, edit }

abstract class ProductFormEvent extends Equatable {
  const ProductFormEvent();

  @override
  List<Object?> get props => [];
}

class AddProductEvent extends ProductFormEvent {
  final ProductModel model;

  const AddProductEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ProductValueChangedEvent extends ProductFormEvent {
  final ProductModel model;

  const ProductValueChangedEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class LoadToEditProductEvent extends ProductFormEvent {
  final ProductModel? model;
  final ProductFormType type;
  final List<CategoryModel>? categories;
  final List<SupplierModel>? suppliers;
  const LoadToEditProductEvent(
      {this.model, required this.type, this.categories, this.suppliers});
  @override
  List<Object?> get props => [model, type, categories, suppliers];
}

class LoadToDropDownListsEvent extends ProductFormEvent {}

class UpdateProductEvent extends ProductFormEvent {
  final ProductModel model;

  const UpdateProductEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class BackCategroyFormEvent extends ProductFormEvent {}
