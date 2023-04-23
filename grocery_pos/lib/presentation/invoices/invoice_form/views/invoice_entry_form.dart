import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/common/themes/themes.dart';
import 'package:grocery_pos/domain_data/contacts/customers/model/customer_model.dart';
import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_detail_model.dart';
import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_model.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/bloc/invoice_form_bloc.dart';
import 'package:grocery_pos/presentation/invoices/invoice_list/bloc/invoice_list_bloc.dart';

class InvoiceEntryForm extends StatelessWidget {
  const InvoiceEntryForm({super.key});
  static MaterialPageRoute<InvoiceEntryForm> route(BuildContext context) {
    return MaterialPageRoute<InvoiceEntryForm>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<InvoiceListBloc>.value(
            value: BlocProvider.of<InvoiceListBloc>(context),
          ),
          BlocProvider<InvoiceFormBloc>.value(
            value: BlocProvider.of<InvoiceFormBloc>(context),
          ),
        ],
        child: const InvoiceEntryForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Entry Form"),
      ),
      body: const InvoiceEntryBody(),
    );
  }
}

class InvoiceEntryBody extends StatelessWidget {
  const InvoiceEntryBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text("Product Entry Form"),

            //Invoice ID
            _InvoiceDisplay(),
            const SizedBox(height: 16),

            //Created Date
            _CreatedDateInput(),
            const SizedBox(height: 16),

            // Invoice Type
            _InvoiceTypeInput(),
            const SizedBox(height: 16),

            // Customer
            _CustomerInput(),
            const SizedBox(height: 16),

            //Total Disable
            _TotalDisplay(),
            const SizedBox(height: 16),

            //Discount
            _DiscountInput(),
            const SizedBox(height: 16),

            //Note
            _NoteInput(),
            const SizedBox(height: 16),

            //Add Product Button
            ElevatedButton(
              onPressed: () {
                // _InvoiceItemsInput();
              },
              child: const Text("Add product"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
                builder: (context, state) {
                  if ((state is InvoiceFormLoadedState ||
                          state is InvoiceFormValueChangedState) &&
                      (state.invoice!.invoiceDetails != null)) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.invoice!.invoiceDetails!.length,
                      key: const Key(
                          'invoiceEntryFrm_invoiceDetailInput_listView'),
                      itemBuilder: (BuildContext context, int index) {
                        return _InvoiceDetailCard(
                            invoice: state.invoice!,
                            index: index,
                            formType: state.formType);
                      },
                    );
                  } else {
                    return const Text("List is empty! Please add product");
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            _SummitButton()
          ],
        ),
      ),
    );
  }
}

class _InvoiceDetailCard extends StatelessWidget {
  _InvoiceDetailCard({
    required this.invoice,
    required this.index,
    this.formType,
  });

  final InvoiceModel invoice;
  final int index;
  InvoiceFormType? formType;

  @override
  Widget build(BuildContext context) {
    InvoiceDetail invoiceDetail = invoice.invoiceDetails![index];
    List<InvoiceDetail> invoiceDetails = invoice.invoiceDetails!;
    final TextEditingController quantityController =
        TextEditingController(text: invoiceDetail.quantity.toString());
    return ListTile(
      title: Text(invoiceDetail.product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${invoiceDetail.quantity} X ${invoiceDetail.product.measureUnit}",
            style: AppThemes.textTheme.labelMedium!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
              "${invoiceDetail.product.id} - ${invoiceDetail.product.barcode}"),
        ],
      ),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // IconButton(
          //   icon: const Icon(Icons.edit),
          //   onPressed: () async {
          //     // Get the value from the text field
          // double quantity =
          //     double.tryParse(_quantityController.text) ?? 0.0;

          // // remove current value form the list
          // invoiceDetails.removeAt(index);
          // invoiceDetails.insert(
          //     index,
          //     invoiceDetail.copyWith(
          //         product: invoiceDetail.product, quantity: quantity));
          // BlocProvider.of<InvoiceFormBloc>(context).add(
          //     LoadToEditInvoiceEvent(
          //         type: formType!,
          //         model: invoice.copyWith(invoiceDetails: invoiceDetails)));
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              //Remove the item in the list
              ///TODO -
            },
          ),
        ],
      ),
      trailing: SizedBox(
        width: 132.0,
        child: TextFormField(
          key: Key(
              "invoiceEntryFrm_invoiceDetail${invoice.id}_${invoiceDetail.product.id}Input_listView"),
          controller: quantityController,
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.numbers,
              size: 18,
            ),
            labelText: 'Quanity',
            hintText: "Quanity",
          ),
          onEditingComplete: () {
            double quantity = double.tryParse(quantityController.text) ?? 0.0;

            // remove current value form the list
            invoiceDetails.removeAt(index);
            invoiceDetails.insert(
                index,
                invoiceDetail.copyWith(
                    product: invoiceDetail.product, quantity: quantity));
            BlocProvider.of<InvoiceFormBloc>(context).add(
                LoadToEditInvoiceEvent(
                    isValueChanged: true,
                    type: formType!,
                    model: invoice.copyWith(invoiceDetails: invoiceDetails)));
          },
        ),
      ),
    );
  }
}

class _SummitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
      builder: (context, state) {
        if (state is InvoiceFormLoadedState) {
          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                minimumSize: const Size.fromHeight(45),
              ),
              key: const Key('invoiceEntryFrm_summitProduct_elevatedButton'),
              onPressed: () async {
                switch (state.formType) {
                  case InvoiceFormType.edit:
                    BlocProvider.of<InvoiceFormBloc>(context)
                        .add(UpdateInvoiceEvent(state.invoice!));
                    break;
                  case InvoiceFormType.createNew:
                    BlocProvider.of<InvoiceFormBloc>(context)
                        .add(AddInvoiceEvent(state.invoice!));
                    break;
                  default:
                    break;
                }
                Navigator.pop(context);
              },
              child: const Text("Done"));
        } else {
          if (state is InvoiceFormLoadingState) {
            return const CircularProgressIndicator();
          }
          return const Text("Could not load the Submit button");
        }
      },
    );
  }
}

class _NoteInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
      builder: (context, state) {
        if (state is InvoiceFormLoadedState) {
          return TextFormField(
            initialValue: state.invoice!.note,
            key: const Key('invoiceEntryFrm_noteInput_textField'),
            onChanged: (value) {
              BlocProvider.of<InvoiceFormBloc>(context).add(
                LoadToEditInvoiceEvent(
                    isValueChanged: true,
                    model:
                        state.invoice!.copyWith(discount: double.parse(value)),
                    type: state.formType!),
              );
            },
            decoration: const InputDecoration(
                labelText: 'Note',
                helperText: '',
                prefixIcon: Icon(Icons.description)),
          );
        }
        return const Text("Couldnt Load Note Input ");
      },
    );
  }
}

class _DiscountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
      builder: (context, state) {
        if (state is InvoiceFormLoadedState) {
          return TextFormField(
            initialValue: state.invoice!.discount.toString(),
            key: const Key('invoiceEntryFrm_discountInput_textField'),
            onChanged: (value) {
              BlocProvider.of<InvoiceFormBloc>(context).add(
                LoadToEditInvoiceEvent(
                    isValueChanged: true,
                    model:
                        state.invoice!.copyWith(discount: double.parse(value)),
                    type: state.formType!),
              );
            },
            decoration: const InputDecoration(
                labelText: 'Discount',
                helperText: '',
                prefixIcon: Icon(Icons.percent)),
          );
        }
        return const Text("Couldnt Load Discount ");
      },
    );
  }
}

class _TotalDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
      builder: (context, state) {
        if (state is InvoiceFormLoadedState) {
          return TextFormField(
            initialValue: state.invoice!.total.toString(),
            key: const Key('invoiceEntryFrm_totalDisplay_textField'),
            onChanged: (value) {
              ///TODO: change every times change product ID
              // invoiceModel =
              //     invoiceModel.copyWith(name: value);
            },
            enabled: false,
            decoration: const InputDecoration(
                labelText: 'Total',
                helperText: '',
                prefixIcon: Icon(Icons.tag)),
          );
        }
        return const Text("Couldnt Load Total ");
      },
    );
  }
}

class _CustomerInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
      builder: (context, state) {
        if (state is InvoiceFormLoadedState) {
          return DropdownButtonFormField<CustomerModel?>(
            key: const Key(
                'invoiceEntryFrm_customerInput_dropdownButtonFormField'),
            value: state.invoice!.customer ?? CustomerModel.empty,
            items: state.customers!.map((customer) {
              return DropdownMenuItem(
                value: customer,
                child: Row(
                  children: <Widget>[
                    Text((customer.isEmpty)
                        ? 'None'
                        : "${customer.id!}-${customer.name}")
                  ],
                ),
              );
            }).toList(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              labelText: 'Customer',
              helperText: '',
            ),
            onChanged: (value) {
              BlocProvider.of<InvoiceFormBloc>(context).add(
                LoadToEditInvoiceEvent(
                  isValueChanged: true,
                  model: state.invoice!,
                  type: state.formType!,
                ),
              );
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class _InvoiceTypeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
      builder: (context, state) {
        if (state is InvoiceFormLoadedState) {
          return DropdownButtonFormField<InvoiceType>(
            key: const Key(
                'invoiceEntryFrm_invoiceType_dropdownButtonFormField'),
            value: state.invoice!.invoiceType,
            items: InvoiceType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Row(
                  children: <Widget>[
                    Text(type.displayString),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              // invoiceModel = invoiceModel.copyWith(category: value);
            },
            decoration: const InputDecoration(
                labelText: 'Invoice Type',
                helperText: '',
                prefixIcon: Icon(Icons.receipt_long)),
          );
        } else if (state is InvoiceFormLoadingState) {
          return const CircularProgressIndicator();
        }
        return const Text("Couldnt Invoice Type");
      },
    );
  }
}

class _CreatedDateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
      builder: (context, state) {
        if (state is InvoiceFormLoadingState) {
          return const CircularProgressIndicator();
        }
        if (state is InvoiceFormLoadedState) {
          return TextFormField(
            initialValue: state.invoice!.createdDate == null
                ? DateTime.now().toString()
                : state.invoice!.createdDate!.toString(),
            key: const Key('invoiceEntryFrm_createdDate_textField'),
            onChanged: (value) {
              BlocProvider.of<InvoiceFormBloc>(context).add(
                  LoadToEditInvoiceEvent(
                      isValueChanged: true,
                      type: state.formType!,
                      model: state.invoice!));
            },
            decoration: const InputDecoration(
              labelText: 'Enter date:',
              helperText: '',

              icon: Icon(Icons.calendar_today), //icon of text field
              //label text of field
            ),
          );
        }
        return const Text("Couldnt Load Date ID");
      },
    );
  }
}

class _InvoiceDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
      builder: (context, state) {
        if (state is InvoiceFormLoadedState) {
          return TextFormField(
            initialValue: state.invoice!.id!,
            key: const Key('invoiceEntryFrm_idDisplay_textField'),
            onChanged: (value) {
              // invoiceModel =
              //     invoiceModel.copyWith(name: value);
            },
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'ID',
              helperText: '',
            ),
          );
        }
        return const Text("Couldnt Load Invoice ID");
      },
    );
  }
}
