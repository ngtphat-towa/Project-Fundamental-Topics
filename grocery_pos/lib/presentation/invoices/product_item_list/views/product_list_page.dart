import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/repository/supplier_repository.dart';
import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
import 'package:grocery_pos/domain_data/inventories/products/repositories/product_repository.dart';
import 'package:grocery_pos/presentation/inventories/products/product_form/bloc/product_form_bloc.dart';
import 'package:grocery_pos/presentation/inventories/products/product_form/views/product_entry_form.dart';
import 'package:grocery_pos/presentation/inventories/products/product_list/bloc/product_list_bloc.dart';
import 'package:grocery_pos/presentation/inventories/products/product_list/views/product_list_form.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  static MaterialPageRoute<ProductPage> route(BuildContext context) {
    return MaterialPageRoute<ProductPage>(
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
        child: const ProductPage(),
      ),
    );
  }

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
        floatingActionButton: _AddProductButton(),
        body: const Padding(
          padding: EdgeInsets.all(10),
          child: ProductListForm(),
        ),
      ),
    );
  }
}

class _AddProductButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: const Key("productListFrm_addProduct_elevatedButton"),
      onPressed: () {
        BlocProvider.of<ProductFormBloc>(context).add(
          LoadToEditProductEvent(
            model: ProductModel.empty,
            type: ProductFormType.createNew,
          ),
        );
        Navigator.of(context).push(
          ProductEntryForm.route(context),
        );
      },
      child: const Icon(Icons.add),
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
