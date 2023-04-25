import 'package:flutter/material.dart';
import 'package:grocery_pos/common/themes/themes.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile Entry"),
      ),
      body: SingleChildScrollView(
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
                      style: AppThemes.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    /// Name Feild
                    TextFormField(
                      key: const Key('userEntryFrm_nameInput_textField'),
                      // key: _formKey,
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        labelText: 'Name',
                        helperText: '',
                      ),
                    ),

                    /// Email Feild
                    TextFormField(
                      // keyboardType: TextInputType.emailAddress,

                      key: const Key('userEntryFrm_emailInput_textField'),
                      // key: _formKey,
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        helperText: '',
                      ),
                    ),

                    /// Phone Feild
                    TextFormField(
                      // keyboardType: TextInputType.phone,

                      key: const Key('userEntryFrm_phoneInput_textField'),
                      // key: _formKey,
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'Phone',
                        helperText: '',
                      ),
                    ),

                    /// Submit Button
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          minimumSize: const Size.fromHeight(45),
                        ),
                        key: const Key(
                            'userEntryFrm_summitSupplier_elevatedButton'),
                        onPressed: () async {},
                        child: const Text("Done")),
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
