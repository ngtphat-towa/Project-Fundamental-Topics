import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/dialog.dart';

/// Bloc Controllers
import '../../product_list/bloc/product_list_bloc.dart';
import '../bloc/product_form_bloc.dart';

/// Services
import '../../../../../domain_data/inventories/products/services.dart';

/// Models
import '../../../../../domain_data/contacts/suppliers/models/models.dart';
import '../../../../../domain_data/inventories/categories/models/models.dart';

class ProductEntryForm extends StatefulWidget {
  const ProductEntryForm({super.key});
  static MaterialPageRoute<ProductEntryForm> route(BuildContext context) {
    return MaterialPageRoute<ProductEntryForm>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<ProductListBloc>.value(
            value: BlocProvider.of<ProductListBloc>(context),
          ),
          BlocProvider<ProductFormBloc>.value(
            value: BlocProvider.of<ProductFormBloc>(context),
          ),
        ],
        child: const ProductEntryForm(),
      ),
    );
  }

  @override
  State<ProductEntryForm> createState() => _ProductEntryFormState();
}

class _ProductEntryFormState extends State<ProductEntryForm> {
  // @override
  // void initState() {

  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    final ProductFormBloc formBloc = BlocProvider.of<ProductFormBloc>(context);
    final ProductListBloc listBloc = BlocProvider.of<ProductListBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        if ((formBloc.state is ProductFormValueChangedState)) {
          final shouldPop = await showDiagLogExitForm(context);
          if (shouldPop!) {
            formBloc.add(BackProductFormEvent());
          }
          return shouldPop;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Product Entry"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: BlocConsumer<ProductFormBloc, ProductFormState>(
                    listener: (context, state) {
                  if (state is ProductFormSuccessState) {
                    listBloc.add(const LoadProductListEvent());
                    Navigator.pop(context);
                  }
                }, builder: (context, state) {
                  if (state is ProductFormValueChangedState ||
                      state is ProductFormLoadedState) {
                    return Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Product Info:"),

                          /// Name Feild
                          _NameInput(),

                          /// Barcode Feild
                          _BarcodeInput(),

                          /// Product Category Dropdown
                          _CategoryInput(),

                          /// Product Supplier Dropdown
                          _SupplierInput(),

                          ///Product Inventory

                          ///Measure Unit
                          _MeasureUnitInput(),

                          ///Unit Pirce
                          _UnitPriceInput(),

                          ///Sold Unit
                          _SoldUnitInput(),

                          ///SKU
                          _SKUInput(),

                          ///Inventory Enable
                          _IsEnableInput(),

                          /// Submit Button
                          const SizedBox(height: 24),
                          _SubmitProduct(),
                        ],
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      buildWhen: (previous, current) =>
          (current is ProductFormValueChangedState &&
              previous.model!.name != current.model!.name) ||
          (current is ProductFormLoadedState),
      // previous.model?.name != current.model?.name,
      builder: (_, state) {
        final model = BlocProvider.of<ProductFormBloc>(context).state.model!;
        return TextFormField(
          initialValue: model.name,
          key: const Key('productEntryFrm_nameInput_textField'),
          onChanged: (value) {
            BlocProvider.of<ProductFormBloc>(context).add(
              ValueChangedProductEvent(
                model: model.copyWith(name: value),
                type: state.type,
              ),
            );
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.title),
            labelText: 'Name',
            helperText: '',
            errorText: (state.model != ProductModel.empty &&
                    model.name.isNotEmpty &&
                    !(model.name.length > 3))
                ? "Name should contain more than 3 characters"
                : null,
          ),
        );
      },
    );
  }
}

class _BarcodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      buildWhen: (previous, current) =>
          (current is ProductFormValueChangedState &&
              previous.model?.barcode != current.model?.barcode) ||
          (current is ProductFormLoadedState),
      // previous.model?.name != current.model?.name,
      builder: (_, state) {
        final model = BlocProvider.of<ProductFormBloc>(context).state.model!;
        return TextFormField(
          initialValue: model.barcode,
          key: const Key('productEntryFrm_barcodeInput_textField'),
          onChanged: (value) {
            BlocProvider.of<ProductFormBloc>(context).add(
              ValueChangedProductEvent(
                model: model.copyWith(barcode: value),
                type: state.type,
              ),
            );
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.document_scanner),
            suffixIcon: IconButton(
              /// TODO: add barcode scan event
              onPressed: () {},
              icon: const Icon(
                Icons.barcode_reader,
              ),
            ),
            labelText: 'Barcode',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _CategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      buildWhen: (previous, current) =>
          (current is ProductFormValueChangedState &&
              previous.model!.category != current.model!.category) ||
          (current is ProductFormLoadedState),
      // previous.model?.category != current.model?.category,
      builder: (_, state) {
        final model = BlocProvider.of<ProductFormBloc>(context).state.model!;
        final categoires = state.categories!;

        return DropdownButtonFormField<CategoryModel>(
          icon: const Icon(Icons.category),
          key: const Key(
              'productEntryFrm_categoryInput_dropdownButtonFormField'),
          value: model.category,
          items: categoires.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: <Widget>[
                  Text((category.isEmpty)
                      ? "None"
                      : "${category.id!}-${category.name}")
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            BlocProvider.of<ProductFormBloc>(context).add(
              ValueChangedProductEvent(
                model: model.copyWith(category: value),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            labelText: 'Category',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _SupplierInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      buildWhen: (previous, current) =>
          (current is ProductFormValueChangedState &&
              previous.model?.barcode != current.model?.barcode) ||
          (current is ProductFormLoadedState),
      // previous.model?.barcode != current.model?.barcode,
      builder: (_, state) {
        final model = BlocProvider.of<ProductFormBloc>(context).state.model!;
        final suppliers = state.suppliers!;

        return DropdownButtonFormField<SupplierModel>(
          icon: const Icon(Icons.local_shipping),
          key: const Key(
              'productEntryFrm_supplierInput_dropdownButtonFormField'),
          value: model.supplier,
          items: suppliers.map((supplier) {
            return DropdownMenuItem(
              value: supplier,
              child: Row(
                children: <Widget>[
                  Text((supplier.isEmptyName)
                      ? 'None'
                      : "${supplier.id!}-${supplier.name}")
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            BlocProvider.of<ProductFormBloc>(context).add(
              ValueChangedProductEvent(
                model: model.copyWith(supplier: value),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            labelText: 'Supplier',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _MeasureUnitInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      buildWhen: (previous, current) =>
          (current is ProductFormValueChangedState &&
              previous.model?.measureUnit != current.model?.measureUnit) ||
          (current is ProductFormLoadedState),
      // previous.model?.measureUnit != current.model?.measureUnit,
      builder: (_, state) {
        final model = BlocProvider.of<ProductFormBloc>(context).state.model!;

        return TextFormField(
          initialValue: model.measureUnit,
          key: const Key('productEntryFrm_measurePriceInput_textField'),
          onChanged: (value) {
            BlocProvider.of<ProductFormBloc>(context).add(
              ValueChangedProductEvent(
                model: model.copyWith(measureUnit: value),
                type: state.type,
              ),
            );
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.scale),
            labelText: 'Measure Unit',
            helperText: '',
            errorText: (state.model != ProductModel.empty &&
                    model.name.isNotEmpty &&
                    !(model.name.length > 3))
                ? "Measure unit must be filled"
                : null,
          ),
        );
      },
    );
  }
}

class _UnitPriceInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      buildWhen: (previous, current) =>
          (current is ProductFormValueChangedState &&
              previous.model?.unitPrice != current.model?.unitPrice) ||
          (current is ProductFormLoadedState),
      // previous.model?.unitPrice != current.model?.unitPrice,
      builder: (_, state) {
        final model = BlocProvider.of<ProductFormBloc>(context).state.model!;

        return TextFormField(
          keyboardType: const TextInputType.numberWithOptions(
              decimal: true, signed: false),
          initialValue: model.unitPrice.toString(),
          key: const Key('productEntryFrm_unitPriceInput_textField'),
          onChanged: (value) {
            if (value.isEmpty) return;
            double number = value != '' ? double.parse(value) : 0.0;

            BlocProvider.of<ProductFormBloc>(context).add(
              ValueChangedProductEvent(
                model: model.copyWith(unitPrice: number),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.attach_money),
            labelText: 'Unit Pirce',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _SoldUnitInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      buildWhen: (previous, current) =>
          (current is ProductFormValueChangedState &&
              previous.model?.quantity?.soldUnit !=
                  current.model?.quantity?.soldUnit) ||
          (current is ProductFormLoadedState),
      // previous.model?.quantity != current.model?.quantity,
      builder: (_, state) {
        final model = BlocProvider.of<ProductFormBloc>(context).state.model!;

        return TextFormField(
          keyboardType: TextInputType.number,
          initialValue: model.quantity!.soldUnit.toString(),
          key: const Key('productEntryFrm_soldUnitInput_textField'),
          onChanged: (value) {
            if (value.isEmpty) return;
            double number = value != '' ? double.parse(value) : 0.0;

            BlocProvider.of<ProductFormBloc>(context).add(
              ValueChangedProductEvent(
                model: model.copyWith(
                  quantity: model.quantity!.copyWith(soldUnit: number),
                ),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.shopping_cart),
            labelText: 'Sold Unit',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _SKUInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      buildWhen: (previous, current) =>
          (current is ProductFormValueChangedState &&
              previous.model?.quantity! != current.model?.quantity!) ||
          (current is ProductFormLoadedState),
      // previous.model?.quantity != current.model?.quantity,
      builder: (_, state) {
        final model = BlocProvider.of<ProductFormBloc>(context).state.model!;

        return TextFormField(
          keyboardType: TextInputType.number,
          initialValue: model.quantity!.sku.toString(),
          key: const Key('productEntryFrm_skuInput_textField'),
          onChanged: (value) {
            if (value.isEmpty) return;
            double number = value != '' ? double.parse(value) : 0.0;
            BlocProvider.of<ProductFormBloc>(context).add(
              ValueChangedProductEvent(
                model: model.copyWith(
                  quantity: model.quantity!.copyWith(sku: number),
                ),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.inventory),
            labelText: 'SKU',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _IsEnableInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      buildWhen: (previous, current) =>
          (current is ProductFormValueChangedState &&
              previous.model?.isInventoryEnable !=
                  current.model?.isInventoryEnable) ||
          (current is ProductFormLoadedState),
      // previous.model?.isInventoryEnable != current.model?.isInventoryEnable,
      builder: (_, state) {
        final model = BlocProvider.of<ProductFormBloc>(context).state.model!;

        return SwitchListTile(
          key: const Key('productEntryFrm_isEnableInput_textField'),
          value: model.isInventoryEnable!,
          onChanged: (value) {
            BlocProvider.of<ProductFormBloc>(context).add(
              ValueChangedProductEvent(
                  model: model.copyWith(
                    isInventoryEnable: value,
                  ),
                  type: state.type),
            );
          },
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text("Inventory enable"),
        );
      },
    );
  }
}

class _SubmitProduct extends StatelessWidget {
  Future _submitProduct(BuildContext context) async {
    final model = BlocProvider.of<ProductFormBloc>(context).state.model!;
    switch (BlocProvider.of<ProductFormBloc>(context).state.type) {
      case ProductFormType.edit:
        BlocProvider.of<ProductFormBloc>(context)
            .add(UpdateProductEvent(model: model));
        break;
      case ProductFormType.createNew:
        BlocProvider.of<ProductFormBloc>(context)
            .add(AddProductEvent(model: model));
        break;
      default:
        break;
    }
    BlocProvider.of<ProductFormBloc>(context).add(BackProductFormEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormBloc, ProductFormState>(
      buildWhen: (previous, current) =>
          (current is ProductFormValueChangedState &&
              previous.model != current.model) ||
          (current is ProductFormLoadedState),
      // previous.model?.quantity != current.model?.quantity,
      builder: (_, state) {
        // final  model = state.model!;

        return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              minimumSize: const Size.fromHeight(45),
            ),
            key: const Key('supplierEntryFrm_summitProduct_elevatedButton'),
            onPressed: () async =>
                (state is ProductFormValueChangedState && state.isValid!)
                    ? _submitProduct(context)
                    : null,
            child: const Text("Done"));
      },
    );
  }
}
