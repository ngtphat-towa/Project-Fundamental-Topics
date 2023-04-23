import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
import 'package:grocery_pos/presentation/inventories/products/product_form/bloc/product_form_bloc.dart';
import 'package:grocery_pos/presentation/inventories/products/product_form/views/product_entry_form.dart';
import 'package:grocery_pos/presentation/inventories/products/product_list/bloc/product_list_bloc.dart';

class ProductItemListForm extends StatefulWidget {
  const ProductItemListForm({super.key});

  @override
  State<ProductItemListForm> createState() => _ProductItemListFormState();
}

class _ProductItemListFormState extends State<ProductItemListForm> {
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
    return InkWell(
      onDoubleTap: () {
        // Navigate to Invoice Detail screen to edit product
        // Call
      },
      child: ListTile(
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
              icon: const Icon(Icons.check),
              iconSize: 35.5,
              onPressed: () {
                // Navigate to Invoice Detail screen to edit product
                // Call
              },
            ),
          ],
        ),
      ),
    );
  }
}
