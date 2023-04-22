// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/model/supplier_model.dart';
import 'package:grocery_pos/presentation/contacts/suppliers/supplier_form/bloc/supplier_form_bloc.dart';
import 'package:grocery_pos/presentation/contacts/suppliers/supplier_form/views/supplier_entry_form.dart';
import 'package:grocery_pos/presentation/contacts/suppliers/supplier_list/bloc/supplier_list_bloc.dart';

class SupplierListForm extends StatefulWidget {
  const SupplierListForm({super.key});

  @override
  State<SupplierListForm> createState() => _SupplierListFormState();
}

class _SupplierListFormState extends State<SupplierListForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SupplierListBloc>(context)
        .add(const LoadSupplierListEvent());
  }

  // _SearchBar(searchController: _searchController),
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupplierListBloc, SupplierListState>(
      listener: (context, state) {
        if (state is SupplierListErrorState) {
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
        if (state is SupplierListLoadingState || state is SupplierListInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SupplierListLoadedState) {
          return ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: state.suppliers!.length,
            itemBuilder: (context, index) {
              final supplier = state.suppliers![index];
              return _SupplierCard(supplier: supplier!);
            },
          );
        } else {
          if (state is SupplierListErrorState) {
            return Center(child: Text(state.message!));
          } else {
            return const Center(child: Text("Coudn't loading suppliers"));
          }
        }
      },
    );
  }
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard({
    required this.supplier,
  });

  final SupplierModel supplier;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(supplier.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${supplier.id}-${supplier.address!.full}"),
          Text(supplier.phone ?? '')
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to form screen to edit supplier
              // Call
              BlocProvider.of<SupplierFormBloc>(context).add(
                LoadToEditSupplierEvent(
                  supplier,
                  SupplierFormType.edit,
                ),
              );
              Navigator.of(context).push(SupplierEntryForm.route(context));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              BlocProvider.of<SupplierListBloc>(context)
                  .add(DeleteSupplierListEvent(supplier: supplier));

              BlocProvider.of<SupplierListBloc>(context)
                  .add(const LoadSupplierListEvent());
            },
          ),
        ],
      ),
    );
  }
}
