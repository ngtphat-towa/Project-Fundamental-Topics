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
    on<LoadToEditCategoryEvent>(_loadToEditCategoryEvent);
  }

  Future<void> _updateCategoryEvent(
      UpdateCategoryEvent event, Emitter<CategoryFormState> emit) async {
    emit(CategoryFormLoadingState());
    try {
      await categoryRepository.updateCategory(event.model);
      emit(const CategoryFormSuccessState(
          successMessage: "Update category succesfully!"));
    } catch (e) {
      emit(CategoryFormErrorState(message: e.toString()));
    }
  }

  Future<void> _addCategoryEvent(
      AddCategoryEvent event, Emitter<CategoryFormState> emit) async {
    emit(CategoryFormLoadingState());
    try {
      final String newId = await categoryRepository.getNewCategoryID();
      await categoryRepository.createCategory(event.model.copyWith(id: newId));
      emit(const CategoryFormSuccessState(
          successMessage: "Update category succesfully!"));
    } catch (e) {
      emit(CategoryFormErrorState(message: e.toString()));
    }
  }

  Future<void> _loadToEditCategoryEvent(
      LoadToEditCategoryEvent event, Emitter<CategoryFormState> emit) async {
    try {
      if (event.type == CategoryFormType.edit) {
        final latestModel =
            await categoryRepository.getCategoryByID(event.model.id!);
        emit(CategoryFormLoaded(latestModel, CategoryFormType.edit));
      } else {
        emit(const CategoryFormLoaded(
            CategoryModel.empty, CategoryFormType.createNew));
      }
    } catch (e) {
      emit(CategoryFormErrorState(message: e.toString()));
    }
  }
}
