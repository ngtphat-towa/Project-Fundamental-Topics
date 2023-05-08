import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery_pos/common/themes/themes.dart';
import 'package:grocery_pos/presentation/store_profile/bloc/store_form_bloc.dart';

class StoreProfilePage extends StatelessWidget {
  const StoreProfilePage({super.key});
  static MaterialPageRoute<StoreProfilePage> route(BuildContext context) {
    return MaterialPageRoute<StoreProfilePage>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<StoreFormBloc>.value(
            value: BlocProvider.of<StoreFormBloc>(context),
          ),
        ],
        child: const StoreProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Profile Entry"),
      ),
      body: BlocListener<StoreFormBloc, StoreFormState>(
        listener: (context, state) {
          if (state is StoreFormSuccessState) {
            Navigator.of(context).pop();
          } else if (state is StoreFormErrorState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.message ?? 'Submit Failure')),
              );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Contact Label
              Text(
                "Contact:",
                style: AppThemes.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              /// Name Feild
              _StoreNameInput(),

              /// Owner name Feild
              _OnwerInput(),
              const SizedBox(height: 16),

              /// Email Feild
              _EmailDisplay(),
              const SizedBox(height: 16),

              /// Phone Feild
              _PhoneInput(),
              const SizedBox(height: 16),

              /// Address Label
              Text(
                "Address:",
                style: AppThemes.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              /// Street Feild
              _StreetInput(),
              const SizedBox(height: 16),

              /// City Feild
              _CityInput(),
              const SizedBox(height: 16),

              /// Country Feild
              _CountryInput(),
              const SizedBox(height: 16),

              /// Submit Button
              _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreFormBloc, StoreFormState>(
      builder: (context, state) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              minimumSize: const Size.fromHeight(45),
            ),
            key: const Key('storeEntryFrm_summitStore_elevatedButton'),
            onPressed: (state is StoreFormLoaded && state.isValueChanged!)
                ? () async {
                    BlocProvider.of<StoreFormBloc>(context)
                        .add(UpdateStoreEvent(state.model!));
                  }
                : null,
            child: const Text("Done"));
      },
    );
  }
}

class _CountryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreFormBloc, StoreFormState>(
      builder: (context, state) {
        final country =
            (state is StoreFormLoaded && state.model!.address != null)
                ? state.model!.address!.country
                : '';
        return TextFormField(
          initialValue: country,
          key: const Key('storeEntryFrm_countryInput_textField'),
          // key: _formKey,
          onChanged: (value) async {
            if (state is StoreFormLoaded) {
              BlocProvider.of<StoreFormBloc>(context).add(LoadToEditStoreEvent(
                model: state.model!,
                isValueChanged: true,
              ));
            }
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

class _CityInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreFormBloc, StoreFormState>(
      builder: (context, state) {
        final ctiy = (state is StoreFormLoaded && state.model!.address != null)
            ? state.model!.address!.city
            : '';
        return TextFormField(
          key: const Key('storeEntryFrm_cityInput_textField'),
          initialValue: ctiy,
          onChanged: (value) async {
            if (state is StoreFormLoaded) {
              final address = state.model!.address!.copyWith(city: value);
              BlocProvider.of<StoreFormBloc>(context).add(LoadToEditStoreEvent(
                model: state.model!.copyWith(address: address),
                isValueChanged: true,
              ));
            }
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

class _StreetInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreFormBloc, StoreFormState>(
      builder: (context, state) {
        final street =
            (state is StoreFormLoaded && state.model!.address != null)
                ? state.model!.address!.street
                : '';
        return TextFormField(
          key: const Key('storeEntryFrm_streetInput_textField'),
          initialValue: street,
          onChanged: (value) async {
            if (state is StoreFormLoaded) {
              final address = state.model!.address!.copyWith(street: value);
              BlocProvider.of<StoreFormBloc>(context).add(
                LoadToEditStoreEvent(
                  model: state.model!.copyWith(address: address),
                  isValueChanged: true,
                ),
              );
            }
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

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreFormBloc, StoreFormState>(
      builder: (context, state) {
        final phone = (state is StoreFormLoaded && state.model!.phone != null)
            ? state.model!.phone
            : '';
        return TextFormField(
          keyboardType: TextInputType.phone,
          key: const Key('storeEntryFrm_phoneInput_textField'),
          initialValue: phone,
          onChanged: (value) async {
            if (state is StoreFormLoaded) {
              BlocProvider.of<StoreFormBloc>(context).add(LoadToEditStoreEvent(
                  model: state.model!.copyWith(phone: value),
                  isValueChanged: true));
            }
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

class _EmailDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreFormBloc, StoreFormState>(
      builder: (context, state) {
        final email = (state is StoreFormLoaded && state.model!.email != null)
            ? state.model!.email
            : '';
        return TextFormField(
          // keyboardType: TextInputType.emailAddress,

          key: const Key('storeEntryFrm_emailInput_textField'),
          initialValue: email,
          decoration: const InputDecoration(
            enabled: false,
            prefixIcon: Icon(Icons.email),
            labelText: 'Email',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _OnwerInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreFormBloc, StoreFormState>(
      builder: (context, state) {
        final ownerName =
            (state is StoreFormLoaded && state.model!.ownerName != null)
                ? state.model!.ownerName
                : '';
        return TextFormField(
          key: const Key('storeEntryFrm_owenr_nameInput_textField'),
          initialValue: ownerName,
          onChanged: (value) async {
            if (state is StoreFormLoaded) {
              BlocProvider.of<StoreFormBloc>(context).add(LoadToEditStoreEvent(
                  model: state.model!.copyWith(ownerName: value),
                  isValueChanged: true));
            }
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.title),
            labelText: 'Onwer Name',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _StoreNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreFormBloc, StoreFormState>(
      builder: (context, state) {
        final storeName =
            (state is StoreFormLoaded && state.model!.storeName != null)
                ? state.model!.storeName
                : '';
        return TextFormField(
          key: const Key('storeEntryFrm_nameInput_textField'),
          initialValue: storeName,
          onChanged: (value) async {
            if (state is StoreFormLoaded) {
              BlocProvider.of<StoreFormBloc>(context).add(LoadToEditStoreEvent(
                  model: state.model!.copyWith(storeName: value),
                  isValueChanged: true));
            }
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.title),
            labelText: 'Name',
            helperText: '',
          ),
        );
      },
    );
  }
}
