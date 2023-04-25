import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';
import 'package:grocery_pos/presentation/inventories/categories/category_form/bloc/category_form_bloc.dart';
import 'package:grocery_pos/presentation/inventories/categories/category_form/views/category_entry_form.dart';
import 'package:grocery_pos/presentation/inventories/categories/category_list/bloc/category_list_bloc.dart';

class CategoryListForm extends StatefulWidget {
  const CategoryListForm({super.key});

  @override
  State<CategoryListForm> createState() => _CategoryListFormState();
}

class _CategoryListFormState extends State<CategoryListForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryListBloc>(context)
        .add(const LoadCategoryListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryListBloc, CategoryListState>(
      listener: (context, state) {
        if (state is CategoryListLoadingState) {
          debugPrint("Loading");
        }
      },
      builder: (context, state) {
        if (state is CategoryListLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryListLoadedState) {
          return ListView.builder(
            itemCount: state.categories!.length,
            itemBuilder: (context, index) {
              final category = state.categories![index];
              return _CategoryCard(category: category);
            },
          );
        } else {
          return const Center(child: Text('Error loading categories'));
        }
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.name),
      subtitle: Text(category.description ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to form screen to edit category
              // Call
              BlocProvider.of<CategoryFormBloc>(context).add(
                LoadToEditCategoryEvent(
                  category,
                  CategoryFormType.edit,
                ),
              );
              Navigator.of(context).push(CategoryEntryForm.route(context));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              BlocProvider.of<CategoryListBloc>(context)
                  .add(DeleteCategoryEvent(category));
            },
          ),
        ],
      ),
    );
  }
}
