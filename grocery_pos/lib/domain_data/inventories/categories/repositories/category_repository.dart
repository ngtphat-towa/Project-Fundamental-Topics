import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_pos/domain_data/authentications/models/models.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';

abstract class ICategoryRepository {
  Future<void> createCategory(CategoryModel model);
  Future<void> updateCategory(CategoryModel model);
  Future<CategoryModel?> getCategoryByID(String id);
  Future<List<CategoryModel>?> getAllCategories();
  Future<String> getNewCategoryID();
}

class CategoryRepository implements ICategoryRepository {
  final FirebaseFirestore _firestore;
  final UserModel _userModel;

  CategoryRepository(
      {FirebaseFirestore? firestore, required UserModel userModel})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _userModel = userModel;
  @override
  Future<List<CategoryModel>?> getAllCategories() async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CategoryModelMapping.collectionName)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final models = snapshot.docs
            .map((doc) => CategoryModel.fromJson(doc.data()))
            .toList();
        return models;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createCategory(CategoryModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CategoryModelMapping.collectionName)
          .doc(model.id)
          .set(model.toJson());
    } catch (_) {}
  }

  @override
  Future<CategoryModel?> getCategoryByID(String id) async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CategoryModelMapping.collectionName)
          .doc(id)
          .get();
      if (!snapshot.exists) return null;
      return CategoryModel.fromJson(snapshot.data()!);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateCategory(CategoryModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CategoryModelMapping.collectionName)
          .doc(model.id)
          .update(model.toJson());
    } catch (_) {}
  }

  /// Gets a new category ID for the current user.
  ///
  /// This method retrieves the highest existing category ID for the current user
  /// and returns a new ID that is one greater than the highest existing ID.
  /// If no categories exist for the current user, this method returns '1'.
  ///
  /// Returns a [Future] that completes with the new category ID as a [String].
  @override
  Future<String> getNewCategoryID() async {
    try {
      // Get the highest existing category ID for the current user
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CategoryModelMapping.collectionName)
          .orderBy(CategoryModelMapping.idKey, descending: true)
          .limit(1)
          .get();
      // If no categories exist for the current user, return '1'
      if (snapshot.docs.isEmpty) return '1';
      // Get the highest existing category ID and increment it by 1
      int currentID = int.parse(snapshot.docs.first.id);
      return '${currentID + 1}';
    } catch (_) {
      // If an error occurs, return '1'
      return '1';
    }
  }
}
