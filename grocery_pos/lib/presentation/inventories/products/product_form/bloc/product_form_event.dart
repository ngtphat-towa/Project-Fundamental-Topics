part of 'product_form_bloc.dart';

enum ProductFormType { createNew, edit }

abstract class ProductFormEvent extends Equatable {
  const ProductFormEvent(
      {this.model, this.type, this.categories, this.suppliers});
  final ProductModel? model;
  final ProductFormType? type;
  final List<CategoryModel>? categories;
  final List<SupplierModel>? suppliers;
  @override
  List<Object?> get props => [];
}

class AddProductEvent extends ProductFormEvent {
  const AddProductEvent({ProductModel? model}) : super(model: model);
  @override
  List<Object?> get props => [model];
}

class ValueChangedProductEvent extends ProductFormEvent {
  const ValueChangedProductEvent({
    ProductModel? model,
    ProductFormType? type,
  }) : super(
          model: model,
          type: type,
        );
  @override
  List<Object?> get props => [model, type];
}

class LoadToEditProductEvent extends ProductFormEvent {
  const LoadToEditProductEvent({
    ProductModel? model,
    ProductFormType? type = ProductFormType.createNew,
    List<CategoryModel>? categories,
    List<SupplierModel>? suppliers,
  }) : super(
            model: model,
            type: type,
            suppliers: suppliers,
            categories: categories);
  @override
  List<Object?> get props => [model, type, suppliers, categories];
}

// class LoadToDropDownListsEvent extends ProductFormEvent {
//   const LoadToDropDownListsEvent({
//     List<CategoryModel>? categories,
//     List<SupplierModel>? suppliers,
//   });
//   @override
//   List<Object?> get props => [categories, suppliers];
// }

class UpdateProductEvent extends ProductFormEvent {
  const UpdateProductEvent({ProductModel? model}) : super(model: model);
  @override
  List<Object?> get props => [model];
}

class BackProductFormEvent extends ProductFormEvent {}
