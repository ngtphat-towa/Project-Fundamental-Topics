import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/model/supplier_model.dart';

import 'package:grocery_pos/domain_data/contacts/suppliers/repository/supplier_repository.dart';
import 'package:grocery_pos/presentation/contacts/suppliers/supplier_form/bloc/supplier_form_bloc.dart';
import 'package:grocery_pos/presentation/contacts/suppliers/supplier_form/views/supplier_entry_form.dart';
import 'package:grocery_pos/presentation/contacts/suppliers/supplier_list/bloc/supplier_list_bloc.dart';

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
          title: _SearchBar(searchController: _searchController),
        ),
        floatingActionButton: _AddSupplierButton(),
        body: const Padding(
          padding: EdgeInsets.all(10),
          child: SupplierListForm(),
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
      onPressed: () {
        BlocProvider.of<SupplierFormBloc>(context).add(
          LoadToEditSupplierEvent(
            SupplierModel.empty,
            SupplierFormType.createNew,
          ),
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
                BlocProvider.of<SupplierListBloc>(context).add(
                    LoadSupplierListEvent(searchValue: _searchController.text));
              },
            ),
            hintText: "eg.SL1",
            labelText: "Search"),
        onSubmitted: (value) {
          BlocProvider.of<SupplierListBloc>(context)
              .add(LoadSupplierListEvent(searchValue: _searchController.text));
        },
      ),
    );
  }
}
