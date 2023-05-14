import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/inventories/categories/services.dart';
import '../../category_form/bloc/category_form_bloc.dart';
import '../../category_form/views/category_entry_form.dart';
import '../bloc/category_list_bloc.dart';
import 'category_list_form.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});
  static MaterialPageRoute<CategoryPage> route(BuildContext context) {
    return MaterialPageRoute<CategoryPage>(
      builder: (_) => RepositoryProvider.value(
        value: RepositoryProvider.of<CategoryRepository>(context),
        child: const CategoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryListBloc>(
          create: (_) => CategoryListBloc(
            categoryRepository:
                RepositoryProvider.of<CategoryRepository>(context),
          ),
        ),
        BlocProvider(
          create: (_) => CategoryFormBloc(
            categoryRepository:
                RepositoryProvider.of<CategoryRepository>(context),
          ),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Category Entry"),
          actions: [
            _AddCategoryButton(),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(10),
          child: CategoryListForm(),
        ),
      ),
    );
  }
}

class _AddCategoryButton extends StatelessWidget {
  void _addEvent(BuildContext context) {
    BlocProvider.of<CategoryFormBloc>(context).add(
      const LoadCategoryFormEvent(),
    );
    Navigator.of(context).push(
      CategoryEntryForm.route(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key("categoryListFrm_addCategory_elevatedButton"),
      onPressed: () => _addEvent(context),
      icon: const Icon(Icons.add),
    );
  }
}
