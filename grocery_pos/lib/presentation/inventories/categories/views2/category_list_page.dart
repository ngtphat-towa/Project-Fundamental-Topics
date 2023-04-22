// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_pos/domain_data/inventories/categories/repositories/category_repository.dart';
// import 'package:grocery_pos/presentation/inventories/categories/cubit/category_cubit.dart';

// class CategoriesScreen extends StatelessWidget {
//   const CategoriesScreen({super.key});

//   static Route<void> route() {
//     return MaterialPageRoute<void>(builder: (_) => const CategoriesScreen());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => CategoryCubit(context.read<CategoryRepository>()),
//       child: BlocBuilder<CategoryCubit, CategoryState>(
//         builder: (context, state) {
//           if (state is CategoriesLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is CategoriesLoaded) {
//             return ListView.builder(
//               itemCount: state.categories.length,
//               itemBuilder: (context, index) {
//                 final category = state.categories[index];
//                 return _CategoryCard(category: category);
//               },
//             );
//           } else {
//             return const Center(child: Text('Error loading categories'));
//           }
//         },
//       ),
//     );
//   }
// }

// class _CategoryCard extends StatelessWidget {
//   const _CategoryCard({
//     super.key,
//     required this.category,
//   });

//   final CategoryModel category;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(category.name),
//       subtitle: Text(category.description ?? ''),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               // Navigate to form screen to edit category
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () {
//               // context.read<CategoryCubit>().deleteCategory(category.id);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
