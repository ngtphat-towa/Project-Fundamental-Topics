// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain_data/contacts/suppliers/models/models.dart';
import '../../../../common/dialog.dart';
import '../../supplier_form/bloc/supplier_form_bloc.dart';
import '../../supplier_form/views/supplier_entry_form.dart';
import '../bloc/supplier_list_bloc.dart';

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
          debugPrint("Error State: Supplier Form ");
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
        if (state is SupplierListLoadingState || state is SupplierListInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SupplierListLoadedState) {
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15.0),
            itemCount: state.suppliers!.length,
            itemBuilder: (context, index) {
              final supplier = state.suppliers![index];
              return _SupplierCard(model: supplier!);
            },
          );
        } else {
          if (state is SupplierListErrorState) {
            return Center(child: Text(state.errorMessage!));
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
    required this.model,
  });

  final SupplierModel model;

  Future _editEvent(BuildContext context) async {
    // Navigate to form screen to edit supplier
    // Call
    BlocProvider.of<SupplierFormBloc>(context).add(
      LoadSupplierFormEvent(
        model: model,
        type: SupplierFormType.edit,
      ),
    );
    Navigator.of(context).push(SupplierEntryForm.route(context));
  }

  Future _deleteEvent(BuildContext context) async {
    final blocList = BlocProvider.of<SupplierListBloc>(context);
    final confirmDelete = await showDialogDeleteConfirm(
      context: context,
      modelType: "supplier",
    );
    if (confirmDelete!) {
      blocList.add(DeleteSupplierListEvent(model: model));
      blocList.add(const LoadSupplierListEvent());
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
