import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/customers/model/customer_model.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_form/bloc/customer_form_bloc.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_form/views/customer_entry_form.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_list/bloc/customer_list_bloc.dart';

class CustomerListForm extends StatefulWidget {
  const CustomerListForm({super.key});

  @override
  State<CustomerListForm> createState() => _CustomerListFormState();
}

class _CustomerListFormState extends State<CustomerListForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CustomerListBloc>(context)
        .add(const LoadCustomerListEvent());
  }

  // _SearchBar(searchController: _searchController),
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerListBloc, CustomerListState>(
      listener: (context, state) {
        if (state is CustomerListErrorState) {
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
        if (state is CustomerListLoadingState || state is CustomerListInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CustomerListLoadedState) {
          return ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: state.customers!.length,
            itemBuilder: (context, index) {
              final customer = state.customers![index];
              return _CustomerCard(customer: customer!);
            },
          );
        } else {
          if (state is CustomerListErrorState) {
            return Center(child: Text(state.message!));
          } else {
            return const Center(child: Text("Coudn't loading customers"));
          }
        }
      },
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({
    required this.customer,
  });

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(customer.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${customer.id}-${customer.address!.full}"),
          Text(customer.phone ?? '')
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to form screen to edit customer
              // Call
              BlocProvider.of<CustomerFormBloc>(context).add(
                LoadToEditCustomerEvent(
                  customer,
                  CustomerFormType.edit,
                ),
              );
              Navigator.of(context).push(CustomerEntryForm.route(context));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              BlocProvider.of<CustomerListBloc>(context)
                  .add(DeleteCustomerListEvent(customer: customer));

              BlocProvider.of<CustomerListBloc>(context)
                  .add(const LoadCustomerListEvent());
            },
          ),
        ],
      ),
    );
  }
}
