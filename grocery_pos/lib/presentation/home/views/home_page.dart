import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/authentications/models/user_model.dart';
import 'package:grocery_pos/domain_data/authentications/repositories/repositories.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';
import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';
import 'package:grocery_pos/domain_data/store/store_profile_repository.dart';
import 'package:grocery_pos/presentation/home/widgets/custom_drawer.dart';

import 'package:grocery_pos/presentation/inventories/categories/category_list/views/category_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => StoreProfileRepository(
            userModel: context.read<AuthenticationRepository>().currentUser,
          ),
        ),
        RepositoryProvider(
          create: (_) => CategoryRepository(
            userModel: context.read<AuthenticationRepository>().currentUser,
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
              _ToggleCategoryScreen(),
              const SizedBox(height: 30),
            ]),
      ),
    );
  }
}

class _ToggleCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key("homePage_goCategoryScreen_elevatedButton"),
      onPressed: () {
        // debugPrint(RepositoryProvider.of<CategoryRepository>(context).toString());
        Navigator.of(context).push(
          CategoryPage.route(context),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) {
        //     return const CategoryPage();
        //   }),
        // );
      },
      child: const Text("Go to category"),
    );
  }
}
