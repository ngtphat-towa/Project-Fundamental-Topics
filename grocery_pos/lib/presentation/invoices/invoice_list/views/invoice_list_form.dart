import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_model.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/bloc/invoice_form_bloc.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/views/invoice_entry_form.dart';
import 'package:grocery_pos/presentation/invoices/invoice_list/bloc/invoice_list_bloc.dart';

class InvoiceListForm extends StatefulWidget {
  const InvoiceListForm({super.key});

  @override
  State<InvoiceListForm> createState() => _InvoiceListFormState();
}

class _InvoiceListFormState extends State<InvoiceListForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<InvoiceListBloc>(context).add(const LoadInvoiceListEvent());
  }

  // _SearchBar(searchController: _searchController),
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoiceListBloc, InvoiceListState>(
      listener: (context, state) {
        if (state is InvoiceListErrorState) {
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
        if (state is InvoiceListLoadingState || state is InvoiceListInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is InvoiceListLoadedState) {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: state.invoices!.length,
            itemBuilder: (context, index) {
              final invoice = state.invoices![index];
              return _InvoiceCard(invoice: invoice);
            },
          );
        } else {
          if (state is InvoiceListErrorState) {
            return Center(child: Text(state.message!));
          } else {
            return const Center(child: Text("Coudn't loading invoices"));
          }
        }
      },
    );
  }
}

extension DateTimeFormat on DateTime {
  String get format {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = months[this.month - 1];
    final day = this.day.toString().padLeft(2, '0');
    final year = this.year;
    return '$month $day, $year';
  }
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({
    required this.invoice,
  });

  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(invoice.invoiceType.displayString),
      subtitle: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total: ${invoice.total}"),
              Text("ID: ${invoice.id}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discount: ${invoice.discount}"),
              Text("Date: ${invoice.createdDate!.format}"),
            ],
          )
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to form screen to edit invoice
              // Call
              BlocProvider.of<InvoiceFormBloc>(context).add(
                LoadToEditInvoiceEvent(
                  model: invoice,
                  type: InvoiceFormType.edit,
                ),
              );
              Navigator.of(context).push(InvoiceEntryForm.route(context));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              BlocProvider.of<InvoiceListBloc>(context)
                  .add(DeleteInvoiceListEvent(invoice: invoice));

              BlocProvider.of<InvoiceListBloc>(context)
                  .add(const LoadInvoiceListEvent());
            },
          ),
        ],
      ),
    );
  }
}
