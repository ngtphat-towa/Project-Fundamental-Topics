import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';

import '../../category_list/bloc/category_list_bloc.dart';
import '../bloc/category_form_bloc.dart';
import 'category_color_values.dart';

class CategoryEntryForm extends StatefulWidget {
  const CategoryEntryForm({super.key});
  static MaterialPageRoute<CategoryEntryForm> route(BuildContext context) {
    return MaterialPageRoute<CategoryEntryForm>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<CategoryListBloc>.value(
            value: BlocProvider.of<CategoryListBloc>(context),
          ),
          BlocProvider<CategoryFormBloc>.value(
            value: BlocProvider.of<CategoryFormBloc>(context),
          ),
        ],
        child: const CategoryEntryForm(),
      ),
    );
  }

  @override
  State<CategoryEntryForm> createState() => _CategoryEntryFormState();
}

class _CategoryEntryFormState extends State<CategoryEntryForm> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // final _formKey = GlobalKey<FormState>();
  Future<bool?> showDiagLogYesNo(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Do you want to exit form?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CategoryFormBloc formBloc =
        BlocProvider.of<CategoryFormBloc>(context);

    BlocProvider.of<CategoryListBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDiagLogYesNo(context);
        if (shouldPop!) {
          formBloc.add(BackCategroyFormEvent());
        }
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Category Entry"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(35),
          child: BlocConsumer<CategoryFormBloc, CategoryFormState>(
            listener: (context, state) {
              if (state is CategoryFormSuccessState) {
                BlocProvider.of<CategoryListBloc>(context)
                    .add(const LoadCategoryListEvent());
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (state is CategoryFormLoaded) {
                return Form(
                  child: Column(
                    children: [
                      const Text("Category Entry Form"),
                      _NameInput(),
                      _DescriptionInput(),
                      _ColorInput(),
                      _SummitCategoryButton(),
                    ],
                  ),
                );
              } else if (state is CategoryFormLoadingState) {
                return const CircularProgressIndicator();
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class _ColorInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormBloc, CategoryFormState>(
      builder: (context, state) {
        final model = state.model ?? CategoryModel.empty;
        return BlockPicker(
          key: const Key('categoryEntryFrm_colorInput_textField'),
          pickerColor:
              (model.color != null) ? Color(model.color!) : Colors.grey,
          availableColors: categoryColors,
          onColorChanged: (Color color) {
            BlocProvider.of<CategoryFormBloc>(context).add(
              LoadToEditCategoryEvent(
                model: model.copyWith(color: color.value),
                type: state.type,
              ),
            );
          },
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormBloc, CategoryFormState>(
      builder: (context, state) {
        final model = state.model ?? CategoryModel.empty;
        return TextFormField(
          initialValue: model.name,
          key: const Key('categoryEntryFrm_nameInput_textField'),
          onChanged: (value) {
            if (value.isNotEmpty) {
              BlocProvider.of<CategoryFormBloc>(context).add(
                LoadToEditCategoryEvent(
                  model: model.copyWith(name: value),
                  type: state.type,
                ),
              );
            }
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.title),
            labelText: 'Name',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormBloc, CategoryFormState>(
      builder: (context, state) {
        final model = state.model ?? CategoryModel.empty;
        return TextFormField(
          initialValue: model.description,
          key: const Key('categoryEntryFrm_descriptionInput_textField'),
          onChanged: (value) {
            if (value.isNotEmpty) {
              BlocProvider.of<CategoryFormBloc>(context).add(
                LoadToEditCategoryEvent(
                  model: model.copyWith(name: value),
                  type: state.type,
                ),
              );
            }
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.description),
            labelText: 'Description',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _SummitCategoryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormBloc, CategoryFormState>(
      builder: (context, state) {
        return ElevatedButton(
            key: const Key('categoryEntryFrm_summitCategory_elevatedButton'),
            onPressed: () async {
              //  Try to validate category
              final categoryModel = state.model!;
              switch (state.type) {
                case CategoryFormType.edit:
                  BlocProvider.of<CategoryFormBloc>(context)
                      .add(UpdateCategoryEvent(model: categoryModel));
                  break;
                case CategoryFormType.createNew:
                  BlocProvider.of<CategoryFormBloc>(context)
                      .add(AddCategoryEvent(model: categoryModel));
                  break;
                default:
                  break;
              }
              BlocProvider.of<CategoryFormBloc>(context)
                  .add(BackCategroyFormEvent());
            },
            child: const Text("Done"));
      },
    );
  }
}
