import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/common/models/addresses/address_model.dart';
import 'package:grocery_pos/common/themes/themes.dart';
import 'package:grocery_pos/domain_data/contacts/customers/model/customer_model.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_form/bloc/customer_form_bloc.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_list/bloc/customer_list_bloc.dart';

class CustomerEntryForm extends StatefulWidget {
  const CustomerEntryForm({super.key});
  static MaterialPageRoute<CustomerEntryForm> route(BuildContext context) {
    return MaterialPageRoute<CustomerEntryForm>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<CustomerListBloc>.value(
            value: BlocProvider.of<CustomerListBloc>(context),
          ),
          BlocProvider<CustomerFormBloc>.value(
            value: BlocProvider.of<CustomerFormBloc>(context),
          ),
        ],
        child: const CustomerEntryForm(),
      ),
    );
  }

  @override
  State<CustomerEntryForm> createState() => _CustomerEntryFormState();
}

class _CustomerEntryFormState extends State<CustomerEntryForm> {
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
    final CustomerFormBloc formBloc =
        BlocProvider.of<CustomerFormBloc>(context);
    final CustomerListBloc listBloc =
        BlocProvider.of<CustomerListBloc>(context);
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
          title: const Text("Customer Entry"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocConsumer<CustomerFormBloc, CustomerFormState>(
                  listener: (context, state) {
                    if (state is CustomerFormSuccessState) {
                      listBloc.add(const LoadCustomerListEvent());
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is CustomerFormLoadingState) {
                      return const CircularProgressIndicator();
                    } else {
                      if (state is CustomerFormLoadedState) {
                        //Contact
                        String id = ((state.customer!.isEmpty)
                            ? ''
                            : state.customer!.id!);
                        String nameInput = ((state.customer!.isEmpty)
                            ? ''
                            : state.customer!.name);
                        String emailInput = ((state.customer!.isEmpty)
                            ? ''
                            : state.customer!.email!);
                        String phoneInput = ((state.customer!.isEmpty)
                            ? ''
                            : state.customer!.phone!);
                        String descriptionInput = ((state.customer!.isEmpty)
                            ? ''
                            : state.customer!.description!);
                        //Address

                        String streetInput = ((state.customer!.isEmpty ||
                                state.customer!.address == null)
                            ? ''
                            : state.customer!.address!.street!);
                        String countryInput = ((state.customer!.isEmpty ||
                                state.customer!.address == null)
                            ? ''
                            : state.customer!.address!.country!);
                        String cityInput = ((state.customer!.isEmpty ||
                                state.customer!.address == null)
                            ? ''
                            : state.customer!.address!.city!);

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
                                    'customerEntryFrm_nameInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  nameInput = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  helperText: '',
                                ),
                              ),

                              /// Email Feild
                              TextFormField(
                                // keyboardType: TextInputType.emailAddress,
                                initialValue: emailInput,
                                key: const Key(
                                    'customerEntryFrm_emailInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  emailInput = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  helperText: '',
                                ),
                              ),

                              /// Phone Feild
                              TextFormField(
                                // keyboardType: TextInputType.phone,
                                initialValue: phoneInput,
                                key: const Key(
                                    'customerEntryFrm_phoneInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  phoneInput = value;
                                },
                                decoration: const InputDecoration(
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
                                    'customerEntryFrm_streetInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  streetInput = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Street',
                                  helperText: '',
                                ),
                              ),

                              /// City Feild
                              TextFormField(
                                initialValue: cityInput,
                                key: const Key(
                                    'customerEntryFrm_cityInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  cityInput = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'City',
                                  helperText: '',
                                ),
                              ),

                              /// Country Feild
                              TextFormField(
                                initialValue: countryInput,
                                key: const Key(
                                    'customerEntryFrm_countryInput_textField'),
                                // key: _formKey,
                                onChanged: (value) {
                                  countryInput = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Country',
                                  helperText: '',
                                ),
                              ),

                              /// Description Feild
                              TextFormField(
                                // keyboardType: TextInputType.multiline,
                                initialValue: descriptionInput,
                                key: const Key(
                                    'customerEntryFrm_descriptionInput_textField'),
                                // key: _formKey,

                                onChanged: (value) {
                                  descriptionInput = value;
                                },
                                decoration: const InputDecoration(
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
                                      'customerEntryFrm_summitCustomer_elevatedButton'),
                                  onPressed: () async {
                                    final customerModel = CustomerModel(
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
                                    if (state.customer! != customerModel) {
                                      switch (state.type) {
                                        case CustomerFormType.edit:
                                          formBloc.add(UpdateCustomerEvent(
                                              customerModel));
                                          break;
                                        case CustomerFormType.createNew:
                                          formBloc.add(
                                              AddCustomerEvent(customerModel));
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
