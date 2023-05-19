import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/repositories/supplier_repository.dart';
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
        appBar: AppBar(title: const Text("Product List")),
        floatingActionButton: _AddProductButton(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Column(
            children: [
              _SearchBar(searchController: _searchController),
              const ProductListForm(),
            ],
          ),
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
      onPressed: () async {
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
  Future _searchEvent(BuildContext context) async {
    BlocProvider.of<ProductListBloc>(context)
        .add(LoadProductListEvent(searchValue: _searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: _searchController,
        autocorrect: false,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide:
                  const BorderSide(width: 0.5), // Set border thickness to 0.5
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            prefixText: "ID:",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async => _searchEvent(context),
            ),
            hintText: "eg.${ProductModelMapping.idFormat}1",
            labelText: "Search"),
        onSubmitted: (value) async => _searchEvent(context),
      ),
    );
  }
}
