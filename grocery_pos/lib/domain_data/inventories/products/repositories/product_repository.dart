import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_pos/domain_data/authentications/models/models.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
import 'package:grocery_pos/domain_data/inventories/stocks/models/quantity_model.dart';

abstract class IProductRepository {
  Future<void> createProduct(ProductModel model);
  Future<ProductModel?> getProductByID(String id);
  Future<Quantity?> getProductQuantityByID(String id);
  Future<List<ProductModel>?> getAllProducts();
  Future<void> updateProduct(ProductModel model);
  Future<void> updateQuantityByID(String id, Quantity quantity);
  Future<void> deleteProduct(ProductModel model);
}

class ProductRepository implements IProductRepository {
  final FirebaseFirestore _firestore;
  final UserModel _userModel;

  ProductRepository(this._firestore, this._userModel);

  @override
  Future<void> createProduct(ProductModel model) async {
    await _firestore
        .collection(UserModelMapping.collectioName)
        .doc(_userModel.uid)
        .collection(ProductModelMapping.collectionName)
        .add(model.toJson());
  }

  @override
  Future<ProductModel?> getProductByID(String id) async {
    final snapshot = await _firestore
        .collection(UserModelMapping.collectioName)
        .doc(_userModel.uid)
        .collection(ProductModelMapping.collectionName)
        .doc(id)
        .get();
    if (snapshot.exists) {
      return ProductModel.fromJson(snapshot.data()!);
    }
    return null;
  }

  @override
  Future<Quantity?> getProductQuantityByID(String id) async {
    final snapshot = await _firestore
        .collection(UserModelMapping.collectioName)
        .doc(_userModel.uid)
        .collection(ProductModelMapping.collectionName)
        .doc(id)
        .get();
    if (snapshot.exists) {
      return ProductModel.fromJson(snapshot.data()!).quantity;
    }
    return null;
  }

  @override
  Future<List<ProductModel>?> getAllProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(ProductModelMapping.collectionName)
          .get();
      if (querySnapshot.docs.isEmpty) return null;
      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateProduct(ProductModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(ProductModelMapping.collectionName)
          .doc(model.id)
          .update(model.toJson());
    } catch (_) {}
  }

  @override
  Future<void> deleteProduct(ProductModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(ProductModelMapping.collectionName)
          .doc(model.id)
          .delete();
    } catch (_) {}
  }

  @override
  Future<void> updateQuantityByID(String id, Quantity quantity) async {
    await _firestore
        .collection(UserModelMapping.collectioName)
        .doc(_userModel.uid)
        .collection(ProductModelMapping.collectionName)
        .doc(id)
        .update({ProductModelMapping.quantityKey: quantity.toJson()});
  }
}
