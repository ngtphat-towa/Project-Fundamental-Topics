import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/common/themes/themes.dart';

import '../bloc/user_form_bloc.dart';


class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});
  static MaterialPageRoute<UserProfilePage> route(BuildContext context) {
    return MaterialPageRoute<UserProfilePage>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<UserFormBloc>.value(
            value: BlocProvider.of<UserFormBloc>(context),
          ),
        ],
        child: const UserProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile Entry"),
      ),
      body: const UserProfileForm(),
    );
  }
}

class UserProfileForm extends StatelessWidget {
  const UserProfileForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserFormBloc, UserFormState>(
      listener: (context, state) {
        if (state is UserFormSuccessState) {
          Navigator.of(context).pop();
        } else if (state is UserFormErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message ?? 'Submit Failure')),
            );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.add_a_photo,
                        size: 65,
                      ),
                    ),

                    /// Contact Label
                    Text(
                      "User Information:",
                      style: AppThemes.textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    /// Name Feild
                    _NameInput(),
                    const SizedBox(height: 16.0),

                    /// Email Feild
                    _EmailDisplay(),
                    const SizedBox(height: 16.0),

                    /// Phone Feild
                    _PhoneInput(),
                    const SizedBox(height: 16.0),

                    /// Submit Button
                    _SubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              minimumSize: const Size.fromHeight(45),
            ),
            key: const Key('userEntryFrm_summitUser_elevatedButton'),
            onPressed: (state is UserFormLoaded && state.isValueChanged!)
                ? () async {
                    BlocProvider.of<UserFormBloc>(context)
                        .add(UpdateUserEvent(state.model!));
                  }
                : null,
            child: const Text("Done"));
      },
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        final phone = (state is UserFormLoaded && state.model!.phone != null)
            ? state.model!.phone
            : '';
        return TextFormField(
          keyboardType: TextInputType.phone,
          initialValue: phone,
          key: const Key('userEntryFrm_phoneInput_textField'),
          // key: _formKey,
          onChanged: (value) async {
            if (state is UserFormLoaded) {
              BlocProvider.of<UserFormBloc>(context).add(LoadToEditUserEvent(
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
    return TextFormField(
      // keyboardType: TextInputType.emailAddress,

      key: const Key('userEntryFrm_EmailDisplay_textField'),
      // key: _formKey,
      enabled: false,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email),
        labelText: 'Email',
        helperText: '',
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        final name = (state is UserFormLoaded && state.model!.name != null)
            ? state.model!.name
            : '';
        return TextFormField(
          key: const Key('userEntryFrm_nameInput_textField'),
          initialValue: name,
          onChanged: (value) async {
            if (state is UserFormLoaded) {
              BlocProvider.of<UserFormBloc>(context).add(LoadToEditUserEvent(
                  model: state.model!.copyWith(name: value),
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
