import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_pos/domain_data/authentications/models/models.dart';
import 'package:grocery_pos/domain_data/inventories/categories/models/category_model.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';

abstract class ICategoryRepository {
  Future<void> createCategory(CategoryModel model);
  Future<void> updateCategory(CategoryModel model);
  Future<CategoryModel?> getCategoryByID(String id);
  Future<List<CategoryModel>?> getAllCategories();
  Future<String> getNewCategoryID();
  Future<List<CategoryModel>?> getAllCategoryNames();
  Future<void> deleteCategory(CategoryModel model);
  Future<void> updateProductCategory(
      CategoryModel model, CategoryModel newModel);
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
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<CategoryModel>?> getAllCategoryNames() async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CategoryModelMapping.collectionName)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final models = snapshot.docs
            .map((doc) => CategoryModel.fromProductJson(doc.data()))
            .toList();
        return models;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
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
      await updateProductCategory(model, model);
    } catch (e) {
      throw (e.toString());
    }
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

  @override
  Future<void> deleteCategory(CategoryModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CategoryModelMapping.collectionName)
          .doc(model.id)
          .delete();
      await updateProductCategory(model, CategoryModel.empty);
    } catch (e) {
      throw ("Delete category error: ${e.toString()}");
    }
  }

  @override
  Future<void> updateProductCategory(
      CategoryModel model, CategoryModel newModel) async {
    try {
      // Get all the documents in the Products subcollection where category.id is equal to model.id
      final QuerySnapshot productsSnapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(ProductModelMapping.collectionName)
          .where(
              "${ProductModelMapping.categoryKey}.${CategoryModelMapping.idKey}",
              isEqualTo: model.id)
          .get();

      // Loop through each document and update it
      for (final QueryDocumentSnapshot doc in productsSnapshot.docs) {
        final DocumentReference productRef = _firestore
            .collection(UserModelMapping.collectioName)
            .doc(_userModel.uid)
            .collection(ProductModelMapping.collectionName)
            .doc(doc.id);
        await productRef.update(newModel.toProductJson());
      }
    } catch (e) {
      throw Exception("Update Product Category Error: ${e.toString()}");
    }
  }
}
