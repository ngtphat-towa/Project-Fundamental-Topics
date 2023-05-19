import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../../common/themes/themes.dart';
import '../../../../common/dialog.dart';
import '../../customer_list/bloc/customer_list_bloc.dart';
import '../bloc/customer_form_bloc.dart';

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
  @override
  Widget build(BuildContext context) {
    final CustomerFormBloc formBloc =
        BlocProvider.of<CustomerFormBloc>(context);
    final CustomerListBloc listBloc =
        BlocProvider.of<CustomerListBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        if ((formBloc.state is CustomerFormValueChangedState)) {
          final shouldPop = await showDiagLogExitForm(context);
          if (shouldPop!) {
            formBloc.add(BackCustomerFormEvent());
          }
          return shouldPop;
        }
        return true;
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
                  if (state is CustomerFormErrorState) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                              state.errorMessage ?? 'Submit customer error!'),
                        ),
                      );
                  }
                }, builder: (context, state) {
                  if (state is CustomerFormLoadedState ||
                      state is CustomerFormValueChangedState) {
                    return Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Contact Label
                          Text(
                            "Contact:",
                            style: AppThemes.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          /// Name Feild
                          _NameInput(),

                          /// Email Feild
                          _EmailInput(),

                          /// Phone Feild
                          _PhoneInput(),

                          /// Address Label
                          Text(
                            "Address:",
                            style: AppThemes.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          /// Street Feild
                          _StreetInput(),

                          /// City Feild
                          _CityInput(),

                          /// Country Feild
                          _CountryInput(),

                          /// Description Feild
                          _DescriptionInput(),

                          /// Submit Button
                          _SubmitCustomer(),
                        ],
                      ),
                    );
                  } else if (state is CustomerFormLoadingState) {
                    return const CircularProgressIndicator();
                  }

                  return Container();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitCustomer extends StatelessWidget {
  Future _submitCustomer(BuildContext context) async {
    final model = BlocProvider.of<CustomerFormBloc>(context).state.model!;
    switch (BlocProvider.of<CustomerFormBloc>(context).state.type) {
      case CustomerFormType.edit:
        BlocProvider.of<CustomerFormBloc>(context)
            .add(UpdateCustomerEvent(model: model));
        break;
      case CustomerFormType.createNew:
        BlocProvider.of<CustomerFormBloc>(context)
            .add(AddCustomerEvent(model: model));
        break;
      default:
        break;
    }
    BlocProvider.of<CustomerFormBloc>(context).add(BackCustomerFormEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerFormBloc, CustomerFormState>(
      buildWhen: (previous, current) =>
          (current is CustomerFormValueChangedState ||
              current is LoadCustomerFormEvent),
      builder: (_, state) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              minimumSize: const Size.fromHeight(45),
            ),
            key: const Key('customerEntryFrm_summitCustomer_elevatedButton'),
            onPressed: () async =>
                (state is CustomerFormValueChangedState && state.isValid!)
                    ? _submitCustomer(context)
                    : null,
            child: const Text("Done"));
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerFormBloc, CustomerFormState>(
      buildWhen: (previous, current) =>
          (current is CustomerFormValueChangedState &&
              previous.model?.name != current.model?.name) ||
          (current is CustomerFormLoadedState),
      // previous.model?.name != current.model?.name,
      builder: (_, state) {
        final model = BlocProvider.of<CustomerFormBloc>(context).state.model!;
        return TextFormField(
          initialValue: model.name,
          key: const Key('customerEntryFrm_nameInput_textField'),
          onChanged: (value) {
            BlocProvider.of<CustomerFormBloc>(context).add(
              ValueChangedCustomerEvent(
                model : model.copyWith(name: value),
                type: state.type,
              ),
            );
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.title),
            labelText: 'Name',
            helperText: '',
            errorText: (model.name.isNotEmpty && !(model.name.length > 3))
                ? "Name should contain more than 3 characters"
                : null,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerFormBloc, CustomerFormState>(
      buildWhen: (previous, current) =>
          (current is CustomerFormValueChangedState &&
              previous.model?.email != current.model?.email) ||
          (current is CustomerFormLoadedState),
      // previous.model?.email != current.model?.email,
      builder: (_, state) {
        final model = BlocProvider.of<CustomerFormBloc>(context).state.model!;
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          initialValue: model.email,
          key: const Key('customerEntryFrm_emailInput_textField'),
          onChanged: (value) {
            BlocProvider.of<CustomerFormBloc>(context).add(
              ValueChangedCustomerEvent(
                model: model.copyWith(email: value),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email),
            labelText: 'Email',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerFormBloc, CustomerFormState>(
      buildWhen: (previous, current) =>
          (current is CustomerFormValueChangedState &&
              previous.model?.phone != current.model?.phone) ||
          (current is CustomerFormLoadedState),
      // previous.model?.phone != current.model?.phone,
      builder: (_, state) {
        final model = BlocProvider.of<CustomerFormBloc>(context).state.model!;
        return TextFormField(
          keyboardType: TextInputType.phone,
          initialValue: model.phone,
          key: const Key('customerEntryFrm_phoneInput_textField'),
          // key: _formKey,
          onChanged: (value) {
            BlocProvider.of<CustomerFormBloc>(context).add(
              ValueChangedCustomerEvent(
                model: model.copyWith(phone: value),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.phone),
            labelText: 'Phone',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _StreetInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerFormBloc, CustomerFormState>(
      buildWhen: (previous, current) =>
          (current is CustomerFormValueChangedState &&
              previous.model?.address?.street !=
                  current.model?.address?.street) ||
          (current is CustomerFormLoadedState),
      // previous.model?.address?.street != current.model?.address?.street,
      builder: (_, state) {
        final model = BlocProvider.of<CustomerFormBloc>(context).state.model!;
        return TextFormField(
          initialValue: model.address!.street ?? '',
          key: const Key('customerEntryFrm_streetInput_textField'),
          onChanged: (value) {
            BlocProvider.of<CustomerFormBloc>(context).add(
              ValueChangedCustomerEvent(
                model: model.copyWith(
                  address: model.address!.copyWith(street: value),
                ),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.streetview),
            labelText: 'Street',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _CityInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerFormBloc, CustomerFormState>(
      buildWhen: (previous, current) =>
          (current is CustomerFormValueChangedState &&
              previous.model?.address?.city != current.model?.address?.city) ||
          (current is CustomerFormLoadedState),
      // previous.model?.address?.city != current.model?.address?.city,
      builder: (_, state) {
        final model = BlocProvider.of<CustomerFormBloc>(context).state.model!;
        return TextFormField(
          initialValue: model.address!.city ?? '',
          key: const Key('customerEntryFrm_cityInput_textField'),
          onChanged: (value) {
            BlocProvider.of<CustomerFormBloc>(context).add(
              ValueChangedCustomerEvent(
                model: model.copyWith(
                  address: model.address!.copyWith(city: value),
                ),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.location_city),
            labelText: 'City',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _CountryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerFormBloc, CustomerFormState>(
      buildWhen: (previous, current) =>
          (current is CustomerFormValueChangedState &&
              previous.model?.address?.country !=
                  current.model?.address?.country) ||
          (current is CustomerFormLoadedState),
      // previous.model?.address?.country != current.model?.address?.country,
      builder: (_, state) {
        final model = BlocProvider.of<CustomerFormBloc>(context).state.model!;
        return TextFormField(
          initialValue: model.address!.country ?? '',
          key: const Key('customerEntryFrm_countryInput_textField'),
          onChanged: (value) {
            BlocProvider.of<CustomerFormBloc>(context).add(
              ValueChangedCustomerEvent(
                model: model.copyWith(
                  address: model.address!.copyWith(country: value),
                ),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.public),
            labelText: 'Country',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerFormBloc, CustomerFormState>(
      buildWhen: (previous, current) =>
          (current is CustomerFormValueChangedState &&
              previous.model?.description != current.model?.description) ||
          (current is CustomerFormLoadedState),
      builder: (_, state) {
        final model = BlocProvider.of<CustomerFormBloc>(context).state.model!;
        return TextFormField(
          // keyboardType: TextInputType.multiline,
          initialValue: model.description,
          key: const Key('customerEntryFrm_descriptionInput_textField'),
          // key: _formKey,

          onChanged: (value) {
            BlocProvider.of<CustomerFormBloc>(context).add(
              ValueChangedCustomerEvent(
                model: model.copyWith(description: value),
                type: state.type,
              ),
            );
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.description),
            labelText: 'Description',
            helperText: '',
          ),
        );
      },
    );
  }
}
