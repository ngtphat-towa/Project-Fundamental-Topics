import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery_pos/domain_data/authentications/repositories/repositories.dart';
import 'package:grocery_pos/domain_data/contacts/customers/repository/customer_repository.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/repository/supplier_repository.dart';
import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';
import 'package:grocery_pos/domain_data/inventories/products/repositories/product_repository.dart';
import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_model.dart';
import 'package:grocery_pos/domain_data/pos/invoices/repositories/invoice_repository.dart';
import 'package:grocery_pos/domain_data/store/store_profile_repository.dart';
import 'package:grocery_pos/presentation/home/widgets/custom_drawer.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/bloc/invoice_form_bloc.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/views/invoice_entry_form.dart';
import 'package:grocery_pos/presentation/invoices/invoice_list/bloc/invoice_list_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationRepository>().currentUser;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => StoreProfileRepository(
            userModel: currentUser,
          ),
        ),
        RepositoryProvider(
          create: (_) => CategoryRepository(
            userModel: currentUser,
          ),
        ),
        RepositoryProvider(
          create: (_) => SupplierRepository(
            userModel: currentUser,
          ),
        ),
        RepositoryProvider(
          create: (_) => CustomerRepository(
            userModel: currentUser,
          ),
        ),
        RepositoryProvider(
          create: (_) => SupplierRepository(
            userModel: currentUser,
          ),
        ),
        RepositoryProvider(
          create: (_) => ProductRepository(
            userModel: currentUser,
          ),
        ),
        RepositoryProvider(
          create: (_) => InvoiceRepository(
            userModel: currentUser,
          ),
        ),
      ],
      child: const HomePageScreen(),
    );
  }
}

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final invoiceRepository = RepositoryProvider.of<InvoiceRepository>(context);
    final productRepository = RepositoryProvider.of<ProductRepository>(context);
    final customerRepository =
        RepositoryProvider.of<CustomerRepository>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => InvoiceListBloc(
            invoiceRepository: invoiceRepository,
          ),
        ),
        BlocProvider(
          create: (_) => InvoiceFormBloc(
            invoiceRepository: invoiceRepository,
            productRepository: productRepository,
            customerRepository: customerRepository,
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("GroceryPOS"),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: _AddInvoiceButton(),
        drawer: const CustomNavigationDrawer(),
        // bottomNavigationBar: _BottomNavigationBar(),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTile(
                title: const Text("Menu"),
                children: [
                  Wrap(
                    children: const [
                      _ScreenMenuButton(
                        iconData: Icons.point_of_sale,
                        title: "POS",
                      ),
                      _ScreenMenuButton(
                        iconData: Icons.production_quantity_limits,
                        title: "Product",
                      ),
                      _ScreenMenuButton(
                        iconData: Icons.person,
                        title: "Customer",
                      ),
                      _ScreenMenuButton(
                        iconData: Icons.store,
                        title: "Store",
                      ),
                      _ScreenMenuButton(
                        iconData: Icons.inventory,
                        title: "Stock",
                      ),
                      _ScreenMenuButton(
                        iconData: Icons.bar_chart,
                        title: "Report",
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const ExpansionTile(
                leading: Icon(Icons.receipt_long),
                title: Text("Recent Invoices"),
                children: [],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreenMenuButton extends StatelessWidget {
  final IconData iconData;
  final String title;

  const _ScreenMenuButton({required this.iconData, required this.title});
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(68, 68), // button width and height
      child: ClipOval(
        child: Material(
          borderOnForeground: true, // button color
          child: InkWell(
            // splash color
            onTap: () {}, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData), // icon
                Text(title), // text
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _BottomNavigationBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       onTap: (index) {},
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.point_of_sale)),
//         BottomNavigationBarItem(icon: Icon(Icons.inventory)),
//         BottomNavigationBarItem(icon: Icon(Icons.contacts)),
//       ],
//     );
//   }
// }

class _AddInvoiceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: const Key("homePage_addNewInvoice_IconButton"),
      child: const Icon(Icons.add),
      onPressed: () async {
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
    );
  }
}

// class _ToggleScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       key: const Key("homePage_goToScreen_elevatedButton"),
//       onPressed: () {
//         Navigator.of(context).push(
//           InvoicePage.route(context),
//         );
//       },
//       child: const Text("Go to invoice"),
//     );
//   }
// }
