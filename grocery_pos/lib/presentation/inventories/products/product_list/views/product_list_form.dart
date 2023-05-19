import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
import 'package:grocery_pos/presentation/inventories/products/product_form/bloc/product_form_bloc.dart';
import 'package:grocery_pos/presentation/inventories/products/product_form/views/product_entry_form.dart';
import 'package:grocery_pos/presentation/inventories/products/product_list/bloc/product_list_bloc.dart';

import '../../../../common/dialog.dart';

class ProductListForm extends StatefulWidget {
  const ProductListForm({super.key});

  @override
  State<ProductListForm> createState() => _ProductListFormState();
}

class _ProductListFormState extends State<ProductListForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductListBloc>(context).add(const LoadProductListEvent());
  }

  // _SearchBar(searchController: _searchController),
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductListBloc, ProductListState>(
      listener: (context, state) {
        if (state is ProductListErrorState) {
          debugPrint("Loading");
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
        if (state is ProductListLoadingState || state is ProductListInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductListLoadedState) {
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15.0),
            itemCount: state.products!.length,
            itemBuilder: (context, index) {
              final product = state.products![index];
              return _ProductCard(model: product!);
            },
          );
        } else {
          if (state is ProductListErrorState) {
            return Center(child: Text(state.message!));
          } else {
            return const Center(child: Text("Coudn't loading products"));
          }
        }
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.model,
  });

  final ProductModel model;

  Future _editEvent(BuildContext context) async {
    BlocProvider.of<ProductFormBloc>(context).add(
      LoadToEditProductEvent(
        model: model,
        type: ProductFormType.edit,
      ),
    );
    Navigator.of(context).push(ProductEntryForm.route(context));
  }

  Future _deleteEvent(BuildContext context) async {
    final blocList = BlocProvider.of<ProductListBloc>(context);
    final confirmDelete = await showDialogDeleteConfirm(
      context: context,
      modelType: "supplier",
    );
    if (confirmDelete!) {
      blocList.add(DeleteProductListEvent(model: model));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        isThreeLine: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(width: 0.2),
        ),
        title: Text(
          model.name,
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${model.unitPrice} per ${model.measureUnit}"),
            Text("${model.id!}-${model.barcode!}")
          ],
        ),
        onTap: () => _editEvent(context),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async => _editEvent(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async => _deleteEvent(context),
            ),
          ],
        ),
      ),
    );
  }
}
