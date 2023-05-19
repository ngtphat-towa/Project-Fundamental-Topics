import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
    return WillPopScope(
      onWillPop: () async {
        final CategoryFormBloc formBloc =
            BlocProvider.of<CategoryFormBloc>(context);
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
              if (state is CategoryFormLoadedState ||
                  state is CategoryFormValueChanged) {
                return Form(
                  child: Column(
                    children: [
                      const Text("Category Entry Form"),
                      _NameInput(),
                      _DescriptionInput(),
                      _ColorInput(),
                      _SubmitCategoryButton(),
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
      buildWhen: (previous, current) =>
          previous.model?.color != current.model?.color,
      builder: (context, state) {
        final model = BlocProvider.of<CategoryFormBloc>(context).state.model!;
        return BlockPicker(
          key: const Key('categoryEntryFrm_colorInput_textField'),
          pickerColor:
              (model.color != null) ? Color(model.color!) : Colors.grey,
          availableColors: categoryColors,
          onColorChanged: (Color color) {
            BlocProvider.of<CategoryFormBloc>(context).add(
              OnChangedCategoryFormEvent(
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
      buildWhen: (previous, current) =>
          previous.model?.name != current.model?.name,
      builder: (context, state) {
        final model = BlocProvider.of<CategoryFormBloc>(context).state.model!;

        return TextFormField(
          initialValue: model.name,
          key: const Key('categoryEntryFrm_nameInput_textField'),
          onChanged: (value) {
            if (value.isNotEmpty) {
              BlocProvider.of<CategoryFormBloc>(context).add(
                OnChangedCategoryFormEvent(
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
      buildWhen: (previous, current) =>
          previous.model?.description != current.model?.description,
      builder: (_, state) {
        final model = BlocProvider.of<CategoryFormBloc>(context).state.model!;

        return TextFormField(
          initialValue: model.description,
          key: const Key('categoryEntryFrm_descriptionInput_textField'),
          onChanged: (value) {
            BlocProvider.of<CategoryFormBloc>(context).add(
              OnChangedCategoryFormEvent(
                model: model.copyWith(description: value),
                type: state.type,
              ),
            );
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

class _SubmitCategoryButton extends StatelessWidget {
  Future _submitEvent(BuildContext context) async {
    //  Try to validate category
    final blocForm = BlocProvider.of<CategoryFormBloc>(context);

    final model = blocForm.state.model!;
    switch (blocForm.state.type) {
      case CategoryFormType.edit:
        blocForm.add(UpdateCategoryEvent(model: model));
        break;
      case CategoryFormType.createNew:
        blocForm.add(AddCategoryEvent(model: model));
        break;
      default:
        break;
    }
    blocForm.add(BackCategroyFormEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormBloc, CategoryFormState>(
      builder: (_, state) {
        return ElevatedButton(
            key: const Key('categoryEntryFrm_submitCategory_elevatedButton'),
            onPressed: () async =>
                (state is CategoryFormValueChanged && state.isValid!)
                    ? _submitEvent(context)
                    : null,
            child: const Text("Done"));
      },
    );
  }
}
