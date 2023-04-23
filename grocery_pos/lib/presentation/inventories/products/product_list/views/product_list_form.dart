import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
import 'package:grocery_pos/presentation/inventories/products/product_form/bloc/product_form_bloc.dart';
import 'package:grocery_pos/presentation/inventories/products/product_form/views/product_entry_form.dart';
import 'package:grocery_pos/presentation/inventories/products/product_list/bloc/product_list_bloc.dart';

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
            padding: const EdgeInsets.all(15.0),
            itemCount: state.products!.length,
            itemBuilder: (context, index) {
              final product = state.products![index];
              return _ProductCard(product: product!);
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
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${product.unitPrice} per ${product.measureUnit}"),
          Text("${product.id!}-${product.barcode!}")
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to form screen to edit product
              // Call
              BlocProvider.of<ProductFormBloc>(context).add(
                LoadToEditProductEvent(
                  model: product,
                  type: ProductFormType.edit,
                ),
              );
              Navigator.of(context).push(ProductEntryForm.route(context));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              BlocProvider.of<ProductListBloc>(context)
                  .add(DeleteProductListEvent(product: product));

              BlocProvider.of<ProductListBloc>(context)
                  .add(const LoadProductListEvent());
            },
          ),
        ],
      ),
    );
  }
}
