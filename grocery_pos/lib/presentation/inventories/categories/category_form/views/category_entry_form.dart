import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';
import 'package:grocery_pos/presentation/inventories/categories/category_form/bloc/category_form_bloc.dart';
import 'package:grocery_pos/presentation/inventories/categories/category_list/bloc/category_list_bloc.dart';

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
  @override
  Widget build(BuildContext context) {
    final CategoryFormBloc formBloc =
        BlocProvider.of<CategoryFormBloc>(context);
    final CategoryListBloc listBloc =
        BlocProvider.of<CategoryListBloc>(context);
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Category Entry"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: BlocConsumer<CategoryFormBloc, CategoryFormState>(
          listener: (context, state) {
            if (state is CategoryFormSuccessState) {
              listBloc.add(const LoadCategoryListEvent());
              Navigator.pop(context);
            } else {}
          },
          builder: (context, state) {
            if (state is CategoryFormLoadingState) {
              return const CircularProgressIndicator();
            } else {
              if (state is CategoryFormLoaded) {
                CategoryModel categoryModel = state.category!;
                return Form(
                  child: Column(
                    children: [
                      const Text("Category Entry Form"),
                      TextFormField(
                        initialValue: state.category!.name,
                        key: const Key('categoryEntryFrm_nameInput_textField'),
                        // key: _formKey,
                        onChanged: (value) {
                          categoryModel.copyWith(name: value);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          helperText: '',
                        ),
                      ),
                      TextFormField(
                        initialValue: state.category!.description,
                        key: const Key(
                            'categoryEntryFrm_descriptionInput_textField'),
                        // key: _formKey,

                        onChanged: (value) {
                          categoryModel.copyWith(description: value);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          helperText: '',
                        ),
                      ),
                      ElevatedButton(
                          key: const Key(
                              'categoryEntryFrm_summitCategory_elevatedButton'),
                          onPressed: () async {
                            if (state.category! != categoryModel) {
                              switch (state.type) {
                                case CategoryFormType.edit:
                                  formBloc
                                      .add(UpdateCategoryEvent(categoryModel));
                                  break;
                                case CategoryFormType.createNew:
                                  formBloc.add(AddCategoryEvent(categoryModel));
                                  break;
                                default:
                                  break;
                              }
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Done")),
                    ],
                  ),
                );
              }
            }
            return Container();
          },
        ),
      ),
    );
  }
}

// class _NameInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       key: const Key('categoryEntryFrm_nameInput_textField'),
//       onChanged: (value) {},
//       decoration: const InputDecoration(
//         labelText: 'Name',
//         helperText: '',
//       ),
//     );
//   }
// }

// class _DescriptionInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       key: const Key('categoryEntryFrm_descriptionInput_textField'),
//       onChanged: (value) {},
//       decoration: const InputDecoration(
//         labelText: 'Description',
//         helperText: '',
//       ),
//     );
//   }
// }

// class _SummitCategoryButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         key: const Key('categoryEntryFrm_summitCategory_elevatedButton'),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         child: const Text("Done"));
//   }
// }
