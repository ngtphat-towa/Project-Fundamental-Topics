import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/authentications/repositories/repositories.dart';
import 'package:grocery_pos/domain_data/contacts/customers/repository/customer_repository.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/repository/supplier_repository.dart';
import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';
import 'package:grocery_pos/domain_data/inventories/products/repositories/product_repository.dart';
import 'package:grocery_pos/domain_data/pos/invoices/repositories/invoice_repository.dart';
import 'package:grocery_pos/domain_data/store/store_profile_repository.dart';
import 'package:grocery_pos/presentation/home/widgets/custom_drawer.dart';
import 'package:grocery_pos/presentation/invoices/invoice_form/bloc/invoice_form_bloc.dart';
import 'package:grocery_pos/presentation/invoices/invoice_list/bloc/invoice_list_bloc.dart';
import 'package:grocery_pos/presentation/invoices/invoice_list/views/invoice_list_page.dart';

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
        appBar: AppBar(title: const Text("Home Page")),
        drawer: const CustomNavigationDrawer(),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Sign successfully"),
              _ToggleScreen(),
              const SizedBox(height: 30),
            ]),
      ),
    );
  }
}

class _ToggleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key("homePage_goToScreen_elevatedButton"),
      onPressed: () {
        Navigator.of(context).push(
          InvoicePage.route(context),
        );
      },
      child: const Text("Go to invoice"),
    );
  }
}
