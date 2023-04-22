import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/authentications/repositories/repositories.dart';
import 'package:grocery_pos/domain_data/contacts/customers/repository/customer_repository.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/repository/supplier_repository.dart';
import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';
import 'package:grocery_pos/domain_data/store/store_profile_repository.dart';
import 'package:grocery_pos/presentation/contacts/customers/customer_list/views/customer_list_page.dart';
import 'package:grocery_pos/presentation/home/widgets/custom_drawer.dart';

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
          create: (_) => CustomerRepository(
            userModel: currentUser,
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
        // debugPrint(RepositoryProvider.of<CategoryRepository>(context).toString());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) {
        //     return const CategoryPage();
        //   }),
        // );
        ///// Category
        // Navigator.of(context).push(
        //   CategoryPage.route(context),
        // );
        /////supplier

        Navigator.of(context).push(
          CustomerPage.route(context),
        );
      },
      child: const Text("Go to customer"),
    );
  }
}
