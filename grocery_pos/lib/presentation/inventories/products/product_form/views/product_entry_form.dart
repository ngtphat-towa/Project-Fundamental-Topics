import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/model/supplier_model.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
// import 'package:grocery_pos/common/themes/themes.dart';
import 'package:grocery_pos/presentation/inventories/products/product_form/bloc/product_form_bloc.dart';
import 'package:grocery_pos/presentation/inventories/products/product_list/bloc/product_list_bloc.dart';

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
  Future<bool?> showDiagLogYesNo(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Do you want to exit form?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<ProductFormBloc>(context).add(LoadToDropDownListsEvent());
  }

  // bool _toggle = true;
  @override
  Widget build(BuildContext context) {
    final ProductFormBloc formBloc = BlocProvider.of<ProductFormBloc>(context);
    final ProductListBloc listBloc = BlocProvider.of<ProductListBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDiagLogYesNo(context);
        if (shouldPop!) {
          formBloc.add(BackCategroyFormEvent());
        }
        return shouldPop;
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
                  },
                  builder: (context, state) {
                    if (state is ProductFormLoadingState) {
                      return const CircularProgressIndicator();
                    } else {
                      if (state is ProductFormLoadedState) {
                        final categoires = state.categories!;
                        final suppliers = state.suppliers;
                        final product = state.product;

                        ProductModel productModel =
                            (state.type == ProductFormType.edit)
                                ? state.product!
                                : ProductModel.empty;

                        // _toggle = productModel.isInventoryEnable as bool;
                        return Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Product Info:"),

                              // Name Feild
                              TextFormField(
                                initialValue: productModel.name,
                                key: const Key(
                                    'productEntryFrm_nameInput_textField'),
                                onChanged: (value) {
                                  productModel =
                                      productModel.copyWith(name: value);
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  helperText: '',
                                ),
                              ),

                              // Barcode Feild
                              TextFormField(
                                initialValue: productModel.barcode,
                                key: const Key(
                                    'productEntryFrm_barcodeInput_textField'),
                                onChanged: (value) {
                                  productModel =
                                      productModel.copyWith(barcode: value);
                                },
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.barcode_reader,
                                    ),
                                  ),
                                  labelText: 'Barcode',
                                  helperText: '',
                                ),
                              ),

                              //Product Dropdown
                              DropdownButtonFormField<CategoryModel>(
                                key: const Key(
                                    'productEntryFrm_categoryInput_dropdownButtonFormField'),
                                value: productModel.category,
                                items: categoires.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Row(
                                      children: <Widget>[
                                        Text((category!.isEmpty)
                                            ? "None"
                                            : "${category.id!}-${category.name}")
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  productModel =
                                      productModel.copyWith(category: value);
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Category',
                                  helperText: '',
                                ),
                              ),

                              //Supplier Dropdown
                              DropdownButtonFormField<SupplierModel>(
                                key: const Key(
                                    'productEntryFrm_supplierInput_dropdownButtonFormField'),
                                value: productModel.supplier,
                                items: suppliers!.map((supplier) {
                                  return DropdownMenuItem(
                                    value: supplier,
                                    child: Row(
                                      children: <Widget>[
                                        Text((supplier!.isEmpty)
                                            ? 'None'
                                            : "${supplier.id!}-${supplier.name}")
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  productModel =
                                      productModel.copyWith(supplier: value);
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Supplier',
                                  helperText: '',
                                ),
                              ),

                              //Product Inventory

                              //Measure Unit
                              TextFormField(
                                initialValue: productModel.measureUnit,
                                key: const Key(
                                    'productEntryFrm_measurePriceInput_textField'),
                                onChanged: (value) {
                                  productModel =
                                      productModel.copyWith(measureUnit: value);
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Measure Unit',
                                  helperText: '',
                                ),
                              ),

                              //Unit Pirce
                              TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: productModel.unitPrice.toString(),
                                key: const Key(
                                    'productEntryFrm_unitPriceInput_textField'),
                                onChanged: (value) {
                                  productModel = productModel.copyWith(
                                      unitPrice: value != ''
                                          ? double.parse(value)
                                          : 0.0);
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Unit Pirce',
                                  helperText: '',
                                ),
                              ),

                              //Sold Unit
                              TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue:
                                    productModel.quantity.soldUnit.toString(),
                                key: const Key(
                                    'productEntryFrm_soldUnitInput_textField'),
                                onChanged: (value) {
                                  double number =
                                      value != '' ? double.parse(value) : 0.0;
                                  productModel = productModel.copyWith(
                                      quantity: productModel.quantity
                                          .copyWith(soldUnit: number));
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Sold Unit',
                                  helperText: '',
                                ),
                              ),

                              //SKU
                              TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue:
                                    productModel.quantity.sku.toString(),
                                key: const Key(
                                    'productEntryFrm_skuInput_textField'),
                                onChanged: (value) {
                                  double number =
                                      value != '' ? double.parse(value) : 0.0;
                                  productModel = productModel.copyWith(
                                      quantity: productModel.quantity
                                          .copyWith(sku: number));
                                },
                                decoration: const InputDecoration(
                                  labelText: 'SKU',
                                  helperText: '',
                                ),
                              ),

                              // Inventory Enable
                              // Checkbox(
                              //   key: const Key(
                              //       'productEntryFrm_isEnableInput_textField'),
                              //   value: productModel.isInventoryEnable!,
                              //   onChanged: (value) {
                              //     // setState(() {
                              //     //   _toggle = value;
                              //     // });
                              //     formBloc.add(ProductValueChangedEvent(
                              //         productModel.copyWith(
                              //             isInventoryEnable: value)));
                              //     productModel = productModel.copyWith(
                              //         isInventoryEnable: value);
                              //   },
                              // ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    minimumSize: const Size.fromHeight(45),
                                  ),
                                  key: const Key(
                                      'supplierEntryFrm_summitProduct_elevatedButton'),
                                  onPressed: () async {
                                    if (product! != productModel) {
                                      switch (state.type) {
                                        case ProductFormType.edit:
                                          formBloc.add(
                                              UpdateProductEvent(productModel));
                                          break;
                                        case ProductFormType.createNew:
                                          formBloc.add(
                                              AddProductEvent(productModel));
                                          break;
                                        default:
                                          break;
                                      }
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Done")),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
