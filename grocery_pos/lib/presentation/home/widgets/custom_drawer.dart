import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/common/themes/colors.dart';
import 'package:grocery_pos/domain_data/authentications/repositories/repositories.dart';
import 'package:grocery_pos/domain_data/store/store_profile_repository.dart';

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
          DrawerExpansionTitle(
              title: "Point Of Sales", nagivigates: posNavigators(context)),
          DrawerExpansionTitle(
              title: "Inventory", nagivigates: inventoryNavigatators(context)),
          DrawerExpansionTitle(
              title: "Contacts", nagivigates: contactNavigators(context)),
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
        title: const Text('Add new suppliers'),
        onTap: () {},
      ),
      ListTile(
        title: const Text('View suppliers list'),
        onTap: () {},
      ),
      const Divider(thickness: 1.0),
      ListTile(
        title: const Text('Add new customer'),
        onTap: () {},
      ),
      ListTile(
        title: const Text('View customer list'),
        onTap: () {},
      ),
    ];
  }

  List<StatelessWidget> inventoryNavigatators(BuildContext context) {
    return [
      ListTile(
        title: const Text('Adjust inventory stock'),
        onTap: () {},
      ),
      ListTile(
        title: const Text('Add new product'),
        onTap: () {},
      ),
      ListTile(
        title: const Text('View product list'),
        onTap: () {},
      ),
      const Divider(thickness: 1.0),
      ListTile(
        title: const Text('Add new category'),
        onTap: () {},
      ),
      ListTile(
        title: const Text('View category list'),
        onTap: () {},
      ),
    ];
  }

  List<Widget> posNavigators(BuildContext context) => [
        ListTile(
          title: const Text('Add new invoice'),
          onTap: () {},
        ),
        ListTile(
          title: const Text('View invoices list'),
          onTap: () {},
        ),
        ListTile(
          title: const Text('View invoices report'),
          onTap: () {},
        )
      ];
}

class DrawerExpansionTitle extends StatelessWidget {
  final List<Widget>? nagivigates;

  final String title;

  const DrawerExpansionTitle(
      {super.key, this.nagivigates, required this.title});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: nagivigates ?? [],
    );
  }
}
