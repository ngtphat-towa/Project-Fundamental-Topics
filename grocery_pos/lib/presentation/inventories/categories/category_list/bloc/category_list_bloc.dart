import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/inventories/categories/services.dart';

part 'category_list_event.dart';
part 'category_list_state.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  final CategoryRepository categoryRepository;
  CategoryListBloc({required this.categoryRepository})
      : super(CategoryListInitial()) {
    on<LoadCategoryListEvent>(_loadCategoryListEvent);
    on<DeleteCategoryEvent>(_deleteCategoryEvent);
  }

  Future<void> _loadCategoryListEvent(
    LoadCategoryListEvent event,
    Emitter<CategoryListState> emit,
  ) async {
    emit(CategoryListLoadingState());
    try {
      final List<CategoryModel>? categoires =
          event.categories ?? await categoryRepository.getAllCategories();
      if (categoires != null) {
        emit(const CategoryListErrorState("The category list is empty!"));
      }
      emit(CategoryListLoadedState(categories: categoires));
    } catch (e) {
      emit(CategoryListErrorState(e.toString()));
    }
  }

  Future<void> _deleteCategoryEvent(
      DeleteCategoryEvent event, Emitter<CategoryListState> emit) async {
    try {
      await categoryRepository.deleteCategory(event.model);
      final categoires = await categoryRepository.getAllCategories();
      emit(CategoryListLoadedState(categories: categoires));
    } catch (e) {
      emit(CategoryListErrorState(e.toString()));
    }
  }
}
