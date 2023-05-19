// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/contacts/customers/models/models.dart';
import '../../../../common/dialog.dart';
import '../../customer_form/bloc/customer_form_bloc.dart';
import '../../customer_form/views/customer_entry_form.dart';
import '../bloc/customer_list_bloc.dart';

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
          debugPrint("Error State: Customer Form ");
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? ''),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is CustomerListLoadingState || state is CustomerListInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CustomerListLoadedState) {
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15.0),
            itemCount: state.customers!.length,
            itemBuilder: (context, index) {
              final customer = state.customers![index];
              return _CustomerCard(model: customer!);
            },
          );
        } else {
          if (state is CustomerListErrorState) {
            return Center(child: Text(state.errorMessage!));
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
    required this.model,
  });

  final CustomerModel model;

  Future _editEvent(BuildContext context) async {
    // Navigate to form screen to edit customer
    // Call
    BlocProvider.of<CustomerFormBloc>(context).add(
      LoadCustomerFormEvent(
        model: model,
        type: CustomerFormType.edit,
      ),
    );
    Navigator.of(context).push(CustomerEntryForm.route(context));
  }

  Future _deleteEvent(BuildContext context) async {
    final blocList = BlocProvider.of<CustomerListBloc>(context);
    final confirmDelete = await showDialogDeleteConfirm(
      context: context,
      modelType: "customer",
    );
    if (confirmDelete!) {
      blocList.add(DeleteCustomerListEvent(model: model));
      blocList.add(const LoadCustomerListEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        isThreeLine: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(width: 0.2),
        ),
        title: Text(
          model.name,
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${model.id}-${model.address!.full}"),
            Text(model.phone ?? '')
          ],
        ),
        onTap: () => _editEvent(context),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async => _editEvent(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async => _deleteEvent(context),
            ),
          ],
        ),
      ),
    );
  }
}
