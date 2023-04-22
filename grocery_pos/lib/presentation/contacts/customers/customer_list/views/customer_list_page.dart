import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/customers/model/customer_model.dart';
import 'package:grocery_pos/domain_data/contacts/customers/repository/customer_repository.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_form/bloc/customer_form_bloc.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_form/views/customer_entry_form.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_list/bloc/customer_list_bloc.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_list/views/customer_list_form.dart';

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
          title: _SearchBar(searchController: _searchController),
        ),
        floatingActionButton: _AddCustomerButton(),
        body: const Padding(
          padding: EdgeInsets.all(10),
          child: CustomerListForm(),
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
      onPressed: () {
        BlocProvider.of<CustomerFormBloc>(context).add(
          LoadToEditCustomerEvent(
            CustomerModel.empty,
            CustomerFormType.createNew,
          ),
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
                BlocProvider.of<CustomerListBloc>(context).add(
                    LoadCustomerListEvent(searchValue: _searchController.text));
              },
            ),
            hintText: "eg.${CustomerModelMapping.idForamt}1",
            labelText: "Search"),
        onSubmitted: (value) {
          BlocProvider.of<CustomerListBloc>(context)
              .add(LoadCustomerListEvent(searchValue: _searchController.text));
        },
      ),
    );
  }
}
