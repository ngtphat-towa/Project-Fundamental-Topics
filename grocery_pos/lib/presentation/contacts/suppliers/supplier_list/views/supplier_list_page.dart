import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/contacts/suppliers/services.dart';
import '../../supplier_form/bloc/supplier_form_bloc.dart';
import '../../supplier_form/views/supplier_entry_form.dart';
import '../bloc/supplier_list_bloc.dart';
import 'supplier_list_form.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  static MaterialPageRoute<SupplierPage> route(BuildContext context) {
    return MaterialPageRoute<SupplierPage>(
      builder: (_) => RepositoryProvider.value(
        value: RepositoryProvider.of<SupplierRepository>(context),
        child: const SupplierPage(),
      ),
    );
  }

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  // ignore: unnecessary_new, prefer_final_fields
  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SupplierListBloc(
            supplierRepository:
                RepositoryProvider.of<SupplierRepository>(context),
          ),
        ),
        BlocProvider(
          create: (_) => SupplierFormBloc(
            supplierRepository:
                RepositoryProvider.of<SupplierRepository>(context),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Supplier List"),
        ),
        floatingActionButton: _AddSupplierButton(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Column(
              children: [
                _SearchBar(searchController: _searchController),
                const SupplierListForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddSupplierButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: const Key("supplierListFrm_addSupplier_elevatedButton"),
      onPressed: () async {
        BlocProvider.of<SupplierFormBloc>(context).add(
          const LoadSupplierFormEvent(),
        );
        Navigator.of(context).push(
          SupplierEntryForm.route(context),
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
    BlocProvider.of<SupplierListBloc>(context)
        .add(LoadSupplierListEvent(searchValue: _searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        key: const Key("supplierListFrm_searchSupplier_textField"),
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
            hintText: "eg.${SupplierModelMapping.idFormat}1",
            labelText: "Search"),
        onSubmitted: (value) async => _searchEvent(context),
      ),
    );
  }
}
