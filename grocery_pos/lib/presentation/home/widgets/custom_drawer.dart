import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/common/themes/colors.dart';
import 'package:grocery_pos/domain_data/authentications/models/user_model.dart';
import 'package:grocery_pos/domain_data/authentications/repositories/repositories.dart';
import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_model.dart';
import 'package:grocery_pos/domain_data/store/store_profile_model.dart';
import 'package:grocery_pos/domain_data/store/store_profile_repository.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_list/views/customer_list_page.dart';
import 'package:grocery_pos/presentation/contacts/suppliers/supplier_list/views/supplier_list_page.dart';
import 'package:grocery_pos/presentation/inventories/categories/category_list/views/category_list_page.dart';
import 'package:grocery_pos/presentation/inventories/products/product_list/views/product_list_page.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/bloc/invoice_form_bloc.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/views/invoice_entry_form.dart';
import 'package:grocery_pos/presentation/invoices/invoice_list/views/invoice_list_page.dart';
import 'package:grocery_pos/presentation/store_profile/bloc/store_form_bloc.dart';
import 'package:grocery_pos/presentation/store_profile/views/store_profile_page.dart';
import 'package:grocery_pos/presentation/user_profile/bloc/user_form_bloc.dart';
import 'package:grocery_pos/presentation/user_profile/views/user_profile_page.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final storeInfRepository = context.read<StoreProfileRepository>();
    final storeModel = storeInfRepository.getStoreProfile();

    return Drawer(
      backgroundColor: AppColors.backgroundColor,
      // ignore: prefer_const_literals_to_create_immutables
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            child: FutureBuilder(
              future: storeModel,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(children: [
                    Text(
                      snapshot.data!.storeName!,
                      style: textTheme.headlineMedium!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      snapshot.data!.ownerName!,
                      style: textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.w300),
                    ),
                    Text(
                      snapshot.data!.email!,
                      style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic),
                    ),
                  ]);
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            onTap: () async {
              BlocProvider.of<UserFormBloc>(context).add(
                const LoadToEditUserEvent(
                  model: UserModel.empty,
                ),
              );
              Navigator.of(context).push(
                UserProfilePage.route(context),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.store_mall_directory),
            title: const Text('Store Profile'),
            onTap: () async {
              BlocProvider.of<StoreFormBloc>(context).add(
                LoadToEditStoreEvent(
                  model: StoreProfileModel.empty,
                ),
              );
              Navigator.of(context).push(
                StoreProfilePage.route(context),
              );
            },
          ),
          DrawerExpansionTitle(
              iconsName: Icons.point_of_sale,
              title: "Point Of Sales",
              nagivigates: posNavigators(context)),
          DrawerExpansionTitle(
              iconsName: Icons.inventory,
              title: "Inventory",
              nagivigates: inventoryNavigatators(context)),
          DrawerExpansionTitle(
              iconsName: Icons.contacts,
              title: "Contacts",
              nagivigates: contactNavigators(context)),
          const Divider(thickness: 1.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              onPressed: () async {
                await context.read<AuthenticationRepository>().logOut();
              },
              child: const Text(
                "Log out",
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> contactNavigators(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.local_shipping),
        title: const Text('Suppliers'),
        onTap: () async {
          Navigator.of(context).push(
            SupplierPage.route(context),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.people),
        title: const Text('Customers'),
        onTap: () async {
          Navigator.of(context).push(
            CustomerPage.route(context),
          );
        },
      ),
    ];
  }

  List<StatelessWidget> inventoryNavigatators(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.edit),
        title: const Text('Adjust inventory stock'),
        onTap: () async {},
      ),
      ListTile(
        leading: const Icon(Icons.production_quantity_limits),
        title: const Text('Products'),
        onTap: () async {
          Navigator.of(context).push(
            ProductPage.route(context),
          );
        },
      ),
      const Divider(thickness: 1),
      ListTile(
        leading: const Icon(Icons.category),
        title: const Text('Categories'),
        onTap: () async {
          Navigator.of(context).push(
            CategoryPage.route(context),
          );
        },
      ),
    ];
  }

  List<Widget> posNavigators(BuildContext context) => [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Add new invoice'),
          onTap: () async {
            BlocProvider.of<InvoiceFormBloc>(context).add(
              LoadToEditInvoiceEvent(
                model: InvoiceModel.empty,
                type: InvoiceFormType.createNew,
              ),
            );
            Navigator.of(context).push(
              InvoiceEntryForm.route(context),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.receipt),
          title: const Text('View invoices list'),
          onTap: () async {
            Navigator.of(context).push(
              InvoicePage.route(context),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.bar_chart),
          title: const Text('View invoices report'),
          onTap: () {},
        )
      ];
}

class DrawerExpansionTitle extends StatelessWidget {
  final List<Widget>? nagivigates;
  final IconData iconsName;
  final String title;

  const DrawerExpansionTitle(
      {super.key,
      this.nagivigates,
      required this.title,
      required this.iconsName});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(iconsName),
      title: Text(title),
      children: nagivigates ?? [],
    );
  }
}
