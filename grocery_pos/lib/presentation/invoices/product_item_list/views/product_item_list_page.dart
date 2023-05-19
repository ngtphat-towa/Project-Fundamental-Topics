import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/repositories/supplier_repository.dart';
import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
import 'package:grocery_pos/domain_data/inventories/products/repositories/product_repository.dart';
import 'package:grocery_pos/presentation/inventories/products/product_form/bloc/product_form_bloc.dart';
import 'package:grocery_pos/presentation/inventories/products/product_list/bloc/product_list_bloc.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/bloc/invoice_form_bloc.dart';
import 'package:grocery_pos/presentation/invoices/product_item_list/views/product_item_list_form.dart';

class ProductItemPage extends StatefulWidget {
  const ProductItemPage({super.key});

  static MaterialPageRoute<ProductItemPage> route(BuildContext context) {
    return MaterialPageRoute<ProductItemPage>(
      builder: (_) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: RepositoryProvider.of<ProductRepository>(context),
          ),
          RepositoryProvider.value(
            value: RepositoryProvider.of<CategoryRepository>(context),
          ),
          RepositoryProvider.value(
            value: RepositoryProvider.of<SupplierRepository>(context),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<InvoiceFormBloc>(context),
            ),
          ],
          child: const ProductItemPage(),
        ),
      ),
    );
  }

  @override
  State<ProductItemPage> createState() => _ProductItemPageState();
}

class _ProductItemPageState extends State<ProductItemPage> {
  // ignore: unnecessary_new, prefer_final_fields
  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productRepository = RepositoryProvider.of<ProductRepository>(context);
    final categoryRepository =
        RepositoryProvider.of<CategoryRepository>(context);
    final supplierRepository =
        RepositoryProvider.of<SupplierRepository>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductListBloc(
            productRepository: productRepository,
          ),
        ),
        BlocProvider(
          create: (_) => ProductFormBloc(
            productRepository: productRepository,
            categoryRepository: categoryRepository,
            supplierRepository: supplierRepository,
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: _SearchBar(searchController: _searchController),
        ),
        // floatingActionButton: _AddProductButton(),
        body: const Padding(
          padding: EdgeInsets.all(10),
          child: ProductItemListForm(),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: _searchController,
        autocorrect: false,
        decoration: InputDecoration(
            prefixText: "ID:",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                BlocProvider.of<ProductListBloc>(context).add(
                    LoadProductListEvent(searchValue: _searchController.text));
              },
            ),
            hintText: "eg.${ProductModelMapping.idFormat}1",
            labelText: "Search"),
        onSubmitted: (value) {
          BlocProvider.of<ProductListBloc>(context)
              .add(LoadProductListEvent(searchValue: _searchController.text));
        },
      ),
    );
  }
}
