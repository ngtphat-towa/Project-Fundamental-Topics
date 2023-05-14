import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Models
import '../../../../../domain_data/inventories/categories/models/models.dart';

import '../../../../common/dialog.dart';

/// Blocs Controllers
import '../bloc/category_list_bloc.dart';
import '../../category_form/bloc/category_form_bloc.dart';

/// Form View Page
import '../../category_form/views/category_entry_form.dart';

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
          debugPrint("Loading State: Category List");
        } else if (state is CategoryListErrorState) {
          debugPrint("Error State: Category List");
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message ?? ''),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is CategoryListLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryListLoadedState) {
          return ListView.builder(
            itemCount: state.models!.length,
            itemBuilder: (context, index) {
              final category = state.models![index];
              return _CategoryCard(model: category);
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
    required this.model,
  });

  final CategoryModel model;

  void _editEvent(BuildContext context) async {
    // Navigate to form screen to edit category
    BlocProvider.of<CategoryFormBloc>(context).add(
      LoadCategoryFormEvent(
        model: model,
        type: CategoryFormType.edit,
      ),
    );
    Navigator.of(context).push(CategoryEntryForm.route(context));
  }

  void _deleteEvent(BuildContext context) async {
    final blocList = BlocProvider.of<CategoryListBloc>(context);
    final confirmDelete = await showDialogDeleteConfirm(
      context: context,
      modelType: "category",
    );
    if (confirmDelete!) {
      blocList.add(DeleteCategoryEvent(model));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        isThreeLine: true,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: Text(
          model.name,
          style: DefaultTextStyle.of(context).style.copyWith(
              color: Color(model.color!), fontWeight: FontWeight.bold),
        ),
        subtitle: Text(model.description ?? ''),
        onTap: () => _editEvent(context),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editEvent(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteEvent(context),
            ),
          ],
        ),
      ),
    );
  }
}
