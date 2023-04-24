import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_detail_model.dart';
import 'package:grocery_pos/presentation/inventories/products/product_list/bloc/product_list_bloc.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/bloc/invoice_form_bloc.dart';

class ProductItemListForm extends StatefulWidget {
  const ProductItemListForm({super.key});

  @override
  State<ProductItemListForm> createState() => _ProductItemListFormState();
}

class _ProductItemListFormState extends State<ProductItemListForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductListBloc>(context).add(const LoadProductListEvent());
  }

  // Future addProduct(BuildContext context, ProductModel model) async {
  //   final invoiceFormBloc = BlocProvider.of<InvoiceFormBloc>(context);
  //   if (invoiceFormBloc.state is InvoiceFormLoadedState) {
  //     final state = invoiceFormBloc.state;
  //     final invoice = state.invoice;
  //     final newInvoiceDetails =
  //         List<InvoiceDetail>.of(invoice!.invoiceDetails ?? []);
  //     newInvoiceDetails.add(InvoiceDetail(product: model, quantity: 1));
  //     BlocProvider.of<InvoiceFormBloc>(context).add(
  //       LoadToEditInvoiceEvent(
  //           customers: state.customers,
  //           isValueChanged: true,
  //           model: invoice.copyWith(invoiceDetails: newInvoiceDetails),
  //           type: state.formType!),
  //     );
  //   }
  // }

  // _SearchBar(searchController: _searchController),
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductListBloc, ProductListState>(
      listener: (_, state) {
        if (state is ProductListErrorState) {
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
      builder: (_, state) {
        if (state is ProductListLoadingState || state is ProductListInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductListLoadedState) {
          return ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: state.products!.length,
            itemBuilder: (_, index) {
              final productModel = state.products![index];
              return InkWell(
                onTap: () async {
                  final invoiceFormBloc =
                      BlocProvider.of<InvoiceFormBloc>(context);
                  if (invoiceFormBloc.state is InvoiceFormLoadedState) {
                    final state = invoiceFormBloc.state;

                    final newInvoiceDetails = List<InvoiceDetail>.of(
                        state.invoice!.invoiceDetails ?? []);
                    newInvoiceDetails
                        .add(InvoiceDetail(product: productModel, quantity: 1));
                    BlocProvider.of<InvoiceFormBloc>(context).add(
                      LoadToEditInvoiceEvent(
                          customers: state.customers,
                          isValueChanged: true,
                          model: state.invoice!
                              .copyWith(invoiceDetails: newInvoiceDetails),
                          type: state.formType!),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: ListTile(
                  title: Text(productModel!.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${productModel.unitPrice} per ${productModel.measureUnit}"),
                      Text("${productModel.id!}-${productModel.barcode!}")
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        iconSize: 35.5,
                        onPressed: () async {
                          final invoiceFormBloc =
                              BlocProvider.of<InvoiceFormBloc>(context);
                          if (invoiceFormBloc.state is InvoiceFormLoadedState) {
                            final state = invoiceFormBloc.state;

                            final newInvoiceDetails = List<InvoiceDetail>.of(
                                state.invoice!.invoiceDetails ?? []);
                            newInvoiceDetails.add(InvoiceDetail(
                                product: productModel, quantity: 1));
                            BlocProvider.of<InvoiceFormBloc>(context).add(
                              LoadToEditInvoiceEvent(
                                  customers: state.customers,
                                  isValueChanged: true,
                                  model: state.invoice!.copyWith(
                                      invoiceDetails: newInvoiceDetails),
                                  type: state.formType!),
                            );
                            // Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          if (state is ProductListErrorState) {
            return Center(child: Text(state.message!));
          } else {
            return const Center(child: Text("Coudn't loading products"));
          }
        }
      },
    );
  }
}

// class _ProductCard extends StatelessWidget {
//   const _ProductCard({
//     required this.product,
//   });

//   final ProductModel product;

//   @override
//   Widget build(BuildContext context) {
//     return;
//   }
// }
