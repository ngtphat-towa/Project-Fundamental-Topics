import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';
import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';

part 'category_list_event.dart';
part 'category_list_state.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  final CategoryRepository categoryRepository;
  CategoryListBloc({required this.categoryRepository})
      : super(CategoryListInitial()) {
    on<LoadCategoryListEvent>(_loadCategoryListEvent);
    // on<AddCategoryEvent>(_addCategoryEvent);
    // on<UpdateCategoryEvent>(_updateCategoryEvent);
    on<DeleteCategoryEvent>(_deleteCategoryEvent);
  }

  Future<void> _loadCategoryListEvent(
    LoadCategoryListEvent event,
    Emitter<CategoryListState> emit,
  ) async {
    emit(CategoryListLoading());
    try {
      final List<CategoryModel>? categoires =
          await categoryRepository.getAllCategories();
      if (categoires != null) {
        emit(const CategoryListError("The category list is empty!"));
      }
      emit(CategoryListLoaded(categories: categoires));
    } catch (e) {
      emit(CategoryListError(e.toString()));
    }
  }

  Future<void> _deleteCategoryEvent(
      DeleteCategoryEvent event, Emitter<CategoryListState> emit) async {
    try {
      //TODO: implemnt this
      final List<CategoryModel>? categoires =
          await categoryRepository.getAllCategories();
      if (categoires != null) {
        emit(const CategoryListError("The category list is empty!"));
      }
      emit(CategoryListLoaded(categories: categoires));
    } catch (e) {
      emit(CategoryListError(e.toString()));
    }
  }
}
