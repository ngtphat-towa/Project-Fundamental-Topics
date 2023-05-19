import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/contacts/customers/services.dart';
import '../../customer_form/bloc/customer_form_bloc.dart';
import '../../customer_form/views/customer_entry_form.dart';
import '../bloc/customer_list_bloc.dart';
import 'customer_list_form.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  static MaterialPageRoute<CustomerPage> route(BuildContext context) {
    return MaterialPageRoute<CustomerPage>(
      builder: (_) => RepositoryProvider.value(
        value: RepositoryProvider.of<CustomerRepository>(context),
        child: const CustomerPage(),
      ),
    );
  }

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  // ignore: unnecessary_new, prefer_final_fields
  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CustomerListBloc(
            customerRepository:
                RepositoryProvider.of<CustomerRepository>(context),
          ),
        ),
        BlocProvider(
          create: (_) => CustomerFormBloc(
            customerRepository:
                RepositoryProvider.of<CustomerRepository>(context),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Customer List"),
        ),
        floatingActionButton: _AddCustomerButton(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Column(
              children: [
                _SearchBar(searchController: _searchController),
                const CustomerListForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddCustomerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: const Key("customerListFrm_addCustomer_elevatedButton"),
      onPressed: () async {
        BlocProvider.of<CustomerFormBloc>(context).add(
          const LoadCustomerFormEvent(),
        );
        Navigator.of(context).push(
          CustomerEntryForm.route(context),
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
    BlocProvider.of<CustomerListBloc>(context)
        .add(LoadCustomerListEvent(searchValue: _searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        key: const Key("customerListFrm_searchCustomer_textField"),
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
            hintText: "eg.${CustomerModelMapping.idFormat}1",
            labelText: "Search"),
        onSubmitted: (value) async => _searchEvent(context),
      ),
    );
  }
}
