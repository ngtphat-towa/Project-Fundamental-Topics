// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';

// import '../cubit/category_cubit.dart';

// class AddEditCategoryScreen extends StatefulWidget {
//   final CategoryModel? category;

//   const AddEditCategoryScreen({Key? key, this.category}) : super(key: key);

//   @override
//   AddEditCategoryScreenState createState() => AddEditCategoryScreenState();
// }

// class AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
//   // final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _colorController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.category?.name);
//     _descriptionController =
//         TextEditingController(text: widget.category?.description);
//     _colorController = TextEditingController(text: widget.category?.color);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _colorController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
//       ),
//       body: Form(
//         // key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a name';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: const InputDecoration(labelText: 'Description'),
//             ),
//             TextFormField(
//               controller: _colorController,
//               decoration: const InputDecoration(labelText: 'Color'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 if (_nameController.text.isNotEmpty) {
//                   final category = CategoryModel(
//                     id: widget.category?.id ?? '',
//                     name: _nameController.text,
//                     description: _descriptionController.text,
//                     color: _colorController.text,
//                   );
//                   if (widget.category == null) {
//                     context.read<CategoryCubit>().addCategory(category);
//                   } else {
//                     context.read<CategoryCubit>().updateCategory(category);
//                   }
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
