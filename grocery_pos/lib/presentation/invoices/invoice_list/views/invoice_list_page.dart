import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/customers/repositories/customer_repository.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/repositories/supplier_repository.dart';
import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';
import 'package:grocery_pos/domain_data/inventories/products/repositories/product_repository.dart';
import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_model.dart';
import 'package:grocery_pos/domain_data/pos/invoices/repositories/invoice_repository.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/bloc/invoice_form_bloc.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/views/invoice_entry_form.dart';
import 'package:grocery_pos/presentation/invoices/invoice_list/bloc/invoice_list_bloc.dart';
import 'package:grocery_pos/presentation/invoices/invoice_list/views/invoice_list_form.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});
  static MaterialPageRoute<InvoicePage> route(BuildContext context) {
    return MaterialPageRoute<InvoicePage>(
      builder: (_) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: RepositoryProvider.of<ProductRepository>(context),
          ),
          RepositoryProvider.value(
            value: RepositoryProvider.of<CustomerRepository>(context),
          ),
          RepositoryProvider.value(
            value: RepositoryProvider.of<InvoiceRepository>(context),
          ),
          RepositoryProvider.value(
            value: RepositoryProvider.of<SupplierRepository>(context),
          ),
          RepositoryProvider.value(
            value: RepositoryProvider.of<CategoryRepository>(context),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(
                value: BlocProvider.of<InvoiceListBloc>(context)),
            BlocProvider.value(
                value: BlocProvider.of<InvoiceFormBloc>(context)),
          ],
          child: const InvoicePage(),
        ),
      ),
    );
  }

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  // ignore: unnecessary_new, prefer_final_fields
  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final invoiceRepository = RepositoryProvider.of<InvoiceRepository>(context);
    // final productRepository = RepositoryProvider.of<ProductRepository>(context);
    // final customerRepository =
    //     RepositoryProvider.of<CustomerRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: _SearchBar(searchController: _searchController),
      ),
      floatingActionButton: _AddInvoiceButton(),
      body: const Padding(
        padding: EdgeInsets.all(1),
        child: InvoiceListForm(),
      ),
    );
  }
}

class _AddInvoiceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: const Key("invoiceListFrm_addInvoice_elevatedButton"),
      onPressed: () async {
        BlocProvider.of<InvoiceFormBloc>(context).add(
          LoadToEditInvoiceEvent(
            model: InvoiceModel.empty,
            type: InvoiceFormType.createNew,
          ),
        );
        Navigator.of(context).push(
          InvoiceEntryForm.route(context),
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
      padding: const EdgeInsets.all(1.0),
      child: TextField(
        controller: _searchController,
        autocorrect: false,
        decoration: InputDecoration(
            prefixText: "ID:",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                BlocProvider.of<InvoiceListBloc>(context).add(
                    LoadInvoiceListEvent(searchValue: _searchController.text));
              },
            ),
            hintText: "eg.${InvoiceModelMapping.idFormat}1",
            labelText: "Search"),
        onSubmitted: (value) {
          BlocProvider.of<InvoiceListBloc>(context)
              .add(LoadInvoiceListEvent(searchValue: _searchController.text));
        },
      ),
    );
  }
}
