import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/common/models/models.dart';
import 'package:grocery_pos/common/themes/themes.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/model/supplier_model.dart';

import 'package:grocery_pos/presentation/contacts/suppliers/supplier_form/bloc/supplier_form_bloc.dart';
import 'package:grocery_pos/presentation/contacts/suppliers/supplier_list/bloc/supplier_list_bloc.dart';

class SupplierEntryForm extends StatefulWidget {
  const SupplierEntryForm({super.key});
  static MaterialPageRoute<SupplierEntryForm> route(BuildContext context) {
    return MaterialPageRoute<SupplierEntryForm>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<SupplierListBloc>.value(
            value: BlocProvider.of<SupplierListBloc>(context),
          ),
          BlocProvider<SupplierFormBloc>.value(
            value: BlocProvider.of<SupplierFormBloc>(context),
          ),
        ],
        child: const SupplierEntryForm(),
      ),
    );
  }

  @override
  State<SupplierEntryForm> createState() => _SupplierEntryFormState();
}

class _SupplierEntryFormState extends State<SupplierEntryForm> {
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
  Widget build(BuildContext context) {
    final SupplierFormBloc formBloc =
        BlocProvider.of<SupplierFormBloc>(context);
    final SupplierListBloc listBloc =
        BlocProvider.of<SupplierListBloc>(context);
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
          title: const Text("Supplier Entry"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocConsumer<SupplierFormBloc, SupplierFormState>(
                  listener: (context, state) {
                    if (state is SupplierFormSuccessState) {
                      listBloc.add(const LoadSupplierListEvent());
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is SupplierFormLoadingState) {
                      return const CircularProgressIndicator();
                    } else {
                      if (state is SupplierFormLoadedState) {
                        //Contact
                        String id = ((state.supplier!.isEmpty)
                            ? ''
                            : state.supplier!.id!);
                        String nameInput = ((state.supplier!.isEmpty)
                            ? ''
                            : state.supplier!.name);
                        String emailInput = ((state.supplier!.isEmpty)
                            ? ''
                            : state.supplier!.email!);
                        String phoneInput = ((state.supplier!.isEmpty)
                            ? ''
                            : state.supplier!.phone!);
                        String descriptionInput = ((state.supplier!.isEmpty)
                            ? ''
                            : state.supplier!.description!);
                        //Address

                        String streetInput = ((state.supplier!.isEmpty ||
                                state.supplier!.address == null)
                            ? ''
                            : state.supplier!.address!.street!);
                        String countryInput = ((state.supplier!.isEmpty ||
                                state.supplier!.address == null)
                            ? ''
                            : state.supplier!.address!.country!);
                        String cityInput = ((state.supplier!.isEmpty ||
                                state.supplier!.address == null)
                            ? ''
                            : state.supplier!.address!.city!);

                        return Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Contact Label
                              Text(
                                "Contact:",
                                style:
                                    AppThemes.textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              /// Name Feild
                              TextFormField(
                                initialValue: nameInput,
                                key: const Key(
                                    'supplierEntryFrm_nameInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  nameInput = value;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.title),
                                  labelText: 'Name',
                                  helperText: '',
                                ),
                              ),

                              /// Email Feild
                              TextFormField(
                                // keyboardType: TextInputType.emailAddress,
                                initialValue: emailInput,
                                key: const Key(
                                    'supplierEntryFrm_emailInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  emailInput = value;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  labelText: 'Email',
                                  helperText: '',
                                ),
                              ),

                              /// Phone Feild
                              TextFormField(
                                // keyboardType: TextInputType.phone,
                                initialValue: phoneInput,
                                key: const Key(
                                    'supplierEntryFrm_phoneInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  phoneInput = value;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  labelText: 'Phone',
                                  helperText: '',
                                ),
                              ),

                              /// Address Label
                              Text(
                                "Address:",
                                style:
                                    AppThemes.textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              /// Street Feild
                              TextFormField(
                                initialValue: streetInput,
                                key: const Key(
                                    'supplierEntryFrm_streetInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  streetInput = value;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.streetview),
                                  labelText: 'Street',
                                  helperText: '',
                                ),
                              ),

                              /// City Feild
                              TextFormField(
                                initialValue: cityInput,
                                key: const Key(
                                    'supplierEntryFrm_cityInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  cityInput = value;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.location_city),
                                  labelText: 'City',
                                  helperText: '',
                                ),
                              ),

                              /// Country Feild
                              TextFormField(
                                initialValue: countryInput,
                                key: const Key(
                                    'supplierEntryFrm_countryInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  countryInput = value;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.public),
                                  labelText: 'Country',
                                  helperText: '',
                                ),
                              ),

                              /// Description Feild
                              TextFormField(
                                // keyboardType: TextInputType.multiline,
                                initialValue: descriptionInput,
                                key: const Key(
                                    'supplierEntryFrm_descriptionInput_textField'),
                                // key: _formKey,

                                onChanged: (value) {
                                  descriptionInput = value;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.description),
                                  labelText: 'Description',
                                  helperText: '',
                                ),
                              ),

                              /// Submit Button
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
                                      'supplierEntryFrm_summitSupplier_elevatedButton'),
                                  onPressed: () async {
                                    final supplierModel = SupplierModel(
                                      id: id,
                                      name: nameInput,
                                      email: emailInput,
                                      phone: phoneInput,
                                      address: Address(
                                        city: cityInput,
                                        country: countryInput,
                                        street: streetInput,
                                      ),
                                      description: descriptionInput,
                                    );
                                    if (state.supplier! != supplierModel) {
                                      switch (state.type) {
                                        case SupplierFormType.edit:
                                          formBloc.add(UpdateSupplierEvent(
                                              supplierModel));
                                          break;
                                        case SupplierFormType.createNew:
                                          formBloc.add(
                                              AddSupplierEvent(supplierModel));
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
                      }
                    }
                    return Container();
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
