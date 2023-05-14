import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery_pos/common/themes/themes.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/models/supplier_model.dart';

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
        if ((formBloc.state is SupplierFormValueChangedState)) {
          final shouldPop = await showDiagLogYesNo(context);
          if (shouldPop!) {
            formBloc.add(BackSupplierFormEvent());
          }
          return shouldPop;
        }
        return true;
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
                child: BlocListener<SupplierFormBloc, SupplierFormState>(
                  listener: (context, state) {
                    if (state is SupplierFormSuccessState) {
                      listBloc.add(const LoadSupplierListEvent());
                      Navigator.pop(context);
                    }
                  },
                  child: Form(
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
                        _SubmitSupplier(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitSupplier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierFormBloc, SupplierFormState>(
      buildWhen: (previous, current) =>
          (current is SupplierFormValueChangedState ||
              current is LoadSupplierFormEvent),
      builder: (context, state) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              minimumSize: const Size.fromHeight(45),
            ),
            key: const Key('supplierEntryFrm_summitSupplier_elevatedButton'),
            onPressed:
                (state is SupplierFormValueChangedState && state.isValid!)
                    ? () async {
                        final model = state.model!;
                        switch (state.type) {
                          case SupplierFormType.edit:
                            BlocProvider.of<SupplierFormBloc>(context)
                                .add(UpdateSupplierEvent(model: model));
                            break;
                          case SupplierFormType.createNew:
                            BlocProvider.of<SupplierFormBloc>(context)
                                .add(AddSupplierEvent(model: model));
                            break;
                          default:
                            break;
                        }
                        BlocProvider.of<SupplierFormBloc>(context)
                            .add(BackSupplierFormEvent());
                      }
                    : null,
            child: const Text("Done"));
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierFormBloc, SupplierFormState>(
      buildWhen: (previous, current) =>
          (current is SupplierFormValueChangedState &&
              previous.model?.name != current.model?.name) ||
          (current is LoadSupplierFormEvent),
      // previous.model?.name != current.model?.name,
      builder: (context, state) {
        final SupplierModel model = state.model!;
        return TextFormField(
          initialValue: model.name,
          key: const Key('supplierEntryFrm_nameInput_textField'),
          onChanged: (value) {
            BlocProvider.of<SupplierFormBloc>(context).add(
              ValueChangedSupplierEvent(
                model: model.copyWith(name: value),
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
    return BlocBuilder<SupplierFormBloc, SupplierFormState>(
      buildWhen: (previous, current) =>
          (current is SupplierFormValueChangedState &&
              previous.model?.email != current.model?.email) ||
          (current is LoadSupplierFormEvent),
      // previous.model?.email != current.model?.email,
      builder: (context, state) {
        final SupplierModel model = state.model!;
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          initialValue: model.email,
          key: const Key('supplierEntryFrm_emailInput_textField'),
          onChanged: (value) {
            BlocProvider.of<SupplierFormBloc>(context).add(
              ValueChangedSupplierEvent(
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
    return BlocBuilder<SupplierFormBloc, SupplierFormState>(
      buildWhen: (previous, current) =>
          (current is SupplierFormValueChangedState &&
              previous.model?.phone != current.model?.phone) ||
          (current is LoadSupplierFormEvent),
      // previous.model?.phone != current.model?.phone,
      builder: (context, state) {
        final SupplierModel model = state.model!;
        return TextFormField(
          keyboardType: TextInputType.phone,
          initialValue: model.phone,
          key: const Key('supplierEntryFrm_phoneInput_textField'),
          // key: _formKey,
          onChanged: (value) {
            BlocProvider.of<SupplierFormBloc>(context).add(
              ValueChangedSupplierEvent(
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
    return BlocBuilder<SupplierFormBloc, SupplierFormState>(
      buildWhen: (previous, current) =>
          (current is SupplierFormValueChangedState &&
              previous.model?.address?.street !=
                  current.model?.address?.street) ||
          (current is LoadSupplierFormEvent),
      // previous.model?.address?.street != current.model?.address?.street,
      builder: (context, state) {
        final SupplierModel model = state.model!;
        return TextFormField(
          initialValue: model.address!.street ?? '',
          key: const Key('supplierEntryFrm_streetInput_textField'),
          onChanged: (value) {
            BlocProvider.of<SupplierFormBloc>(context).add(
              ValueChangedSupplierEvent(
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
    return BlocBuilder<SupplierFormBloc, SupplierFormState>(
      buildWhen: (previous, current) =>
          (current is SupplierFormValueChangedState &&
              previous.model?.address?.city != current.model?.address?.city) ||
          (current is LoadSupplierFormEvent),
      // previous.model?.address?.city != current.model?.address?.city,
      builder: (context, state) {
        final SupplierModel model = state.model!;
        return TextFormField(
          initialValue: model.address!.city ?? '',
          key: const Key('supplierEntryFrm_cityInput_textField'),
          onChanged: (value) {
            BlocProvider.of<SupplierFormBloc>(context).add(
              ValueChangedSupplierEvent(
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
    return BlocBuilder<SupplierFormBloc, SupplierFormState>(
      buildWhen: (previous, current) =>
          (current is SupplierFormValueChangedState &&
              previous.model?.address?.country !=
                  current.model?.address?.country) ||
          (current is LoadSupplierFormEvent),
      // previous.model?.address?.country != current.model?.address?.country,
      builder: (context, state) {
        final SupplierModel model = state.model!;
        return TextFormField(
          initialValue: model.address!.city ?? '',
          key: const Key('supplierEntryFrm_countryInput_textField'),
          onChanged: (value) {
            BlocProvider.of<SupplierFormBloc>(context).add(
              ValueChangedSupplierEvent(
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
    return BlocBuilder<SupplierFormBloc, SupplierFormState>(
      buildWhen: (previous, current) =>
          (current is SupplierFormValueChangedState &&
              previous.model?.description != current.model?.description) ||
          (current is LoadSupplierFormEvent),
      builder: (context, state) {
        final SupplierModel model = state.model!;
        return TextFormField(
          // keyboardType: TextInputType.multiline,
          initialValue: model.description,
          key: const Key('supplierEntryFrm_descriptionInput_textField'),
          // key: _formKey,

          onChanged: (value) {
            BlocProvider.of<SupplierFormBloc>(context).add(
              ValueChangedSupplierEvent(
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
