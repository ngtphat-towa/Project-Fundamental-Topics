import 'package:flutter/material.dart';
import 'package:grocery_pos/common/themes/themes.dart';

class StoreProfilePage extends StatelessWidget {
  const StoreProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Profile Entry"),
      ),
      body: SingleChildScrollView(
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
            TextFormField(
              key: const Key('storeEntryFrm_nameInput_textField'),
              // key: _formKey,
              onChanged: (value) {},
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title),
                labelText: 'Name',
                helperText: '',
              ),
            ),

            /// onwer name Feild
            TextFormField(
              key: const Key('storeEntryFrm_owenr_nameInput_textField'),
              // key: _formKey,
              onChanged: (value) {},
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title),
                labelText: 'Onwer Name',
                helperText: '',
              ),
            ),

            /// Email Feild
            TextFormField(
              // keyboardType: TextInputType.emailAddress,

              key: const Key('storeEntryFrm_emailInput_textField'),
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

              key: const Key('storeEntryFrm_phoneInput_textField'),
              // key: _formKey,
              onChanged: (value) {},
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                labelText: 'Phone',
                helperText: '',
              ),
            ),

            /// Address Label
            Text(
              "Address:",
              style: AppThemes.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            /// Street Feild
            TextFormField(
              key: const Key('storeEntryFrm_streetInput_textField'),
              // key: _formKey,
              onChanged: (value) {},
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.streetview),
                labelText: 'Street',
                helperText: '',
              ),
            ),

            /// City Feild
            TextFormField(
              key: const Key('storeEntryFrm_cityInput_textField'),
              // key: _formKey,
              onChanged: (value) {},
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_city),
                labelText: 'City',
                helperText: '',
              ),
            ),

            /// Country Feild
            TextFormField(
              key: const Key('storeEntryFrm_countryInput_textField'),
              // key: _formKey,
              onChanged: (value) {},
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.public),
                labelText: 'Country',
                helperText: '',
              ),
            ),

            /// Description Feild
            TextFormField(
              // keyboardType: TextInputType.multiline,

              key: const Key('storeEntryFrm_descriptionInput_textField'),
              // key: _formKey,

              onChanged: (value) {},
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description),
                labelText: 'Description',
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
                key: const Key('storeEntryFrm_summitStore_elevatedButton'),
                onPressed: () async {},
                child: const Text("Done")),
          ],
        ),
      ),
    );
  }
}
