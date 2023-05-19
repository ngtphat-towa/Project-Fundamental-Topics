import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';
import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';

part 'category_form_event.dart';
part 'category_form_state.dart';

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {
  final CategoryRepository categoryRepository;
  CategoryFormBloc({required this.categoryRepository})
      : super(CategoryFormInitial()) {
    on<AddCategoryEvent>(_addCategoryEvent);
    on<UpdateCategoryEvent>(_updateCategoryEvent);
    on<LoadCategoryFormEvent>(_loadToEditCategoryEvent);
    on<OnChangedCategoryFormEvent>(_onChangedCategoryFormEvent);
    on<BackCategroyFormEvent>(_backCategroyFormEvent);
  }

  Future<void> _updateCategoryEvent(
      UpdateCategoryEvent event, Emitter<CategoryFormState> emit) async {
    /// Check if model change or not
    final currentModel =
        await categoryRepository.getCategoryByID(event.model!.id!);
    if (event.model! == currentModel) return;

    /// If it was changed
    emit(CategoryFormLoadingState());
    try {
      await categoryRepository.updateCategory(event.model!);
      emit(const CategoryFormSuccessState(
          successMessage: "Update category succesfully!"));
    } catch (e) {
      emit(CategoryFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _addCategoryEvent(
      AddCategoryEvent event, Emitter<CategoryFormState> emit) async {
    /// Check if current model default or not
    if (event.model! == CategoryModel.empty) return;
    emit(CategoryFormLoadingState());
    try {
      final String newId = await categoryRepository.getNewCategoryID();
      await categoryRepository.createCategory(event.model!.copyWith(id: newId));
      emit(const CategoryFormSuccessState(
          successMessage: "Add category succesfully!"));
    } catch (e) {
      emit(CategoryFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _loadToEditCategoryEvent(
      LoadCategoryFormEvent event, Emitter<CategoryFormState> emit) async {
    emit(CategoryFormLoadingState());
    try {
      if (event.type == CategoryFormType.edit) {
        /// Load current model from database else assign new value of model
        final latestModel = event.model ??
            await categoryRepository.getCategoryByID(event.model!.id!);
        emit(CategoryFormLoadedState(
            model: latestModel, type: CategoryFormType.edit));
      } else {
        emit(CategoryFormLoadedState(
          model: CategoryModel.empty,
          type: CategoryFormType.createNew,
        ));
      }
    } catch (e) {
      emit(CategoryFormErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _backCategroyFormEvent(
      BackCategroyFormEvent event, Emitter<CategoryFormState> emit) async {
    emit(CategoryFormInitial());
  }

  Future<void> _onChangedCategoryFormEvent(
      OnChangedCategoryFormEvent event, Emitter<CategoryFormState> emit) async {
    /// check current model changed

    try {
      final bool isValid = _validateModel(event.model!);
      emit(CategoryFormValueChanged(
        model: event.model,
        type: event.type,
        isValid: isValid,
      ));
    } catch (e) {
      /// Simple catch
      emit(CategoryFormErrorState(errorMessage: e.toString()));
    }
  }

  /// TODO: handle validation this form
  bool _validateModel(CategoryModel model) {
    //if (model.name.isEmpty) return false;
    return true;
  }
}
