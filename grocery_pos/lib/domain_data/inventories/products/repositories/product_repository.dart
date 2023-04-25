import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_pos/domain_data/authentications/models/models.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';
import 'package:grocery_pos/domain_data/inventories/stocks/models/quantity_model.dart';

abstract class IProductRepository {
  Future<void> createProduct(ProductModel model);
  Future<String> getNewProductID();
  Future<ProductModel?> getProductByID(String id);
  Future<Quantity?> getProductQuantityByID(String id);
  Future<List<ProductModel>?> getAllProducts();
  Future<void> updateProduct(ProductModel model);
  Future<void> updateProductQuantity(ProductModel model, double quantity);
  Future<void> deleteProduct(ProductModel model);
}

class ProductRepository implements IProductRepository {
  final FirebaseFirestore _firestore;
  final UserModel _userModel;

  ProductRepository(
      {FirebaseFirestore? firestore, required UserModel userModel})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _userModel = userModel;

  @override
  Future<void> createProduct(ProductModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(ProductModelMapping.collectionName)
          .doc(model.id)
          .set(model.toJson());
    } on Exception catch (e) {
      throw Exception("Error occoured: ${e.toString()}");
    }
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
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(ProductModelMapping.collectionName)
          .doc(id)
          .get();
      if (snapshot.exists) {
        return ProductModel.fromJson(snapshot.data()!).quantity;
      } else {
        throw Exception("Can't find the product which has ID: $id");
      }
    } on Exception catch (e) {
      throw Exception("Error occoured: ${e.toString()}");
    }
  }

  @override
  Future<List<ProductModel>?> getAllProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(ProductModelMapping.collectionName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => ProductModel.fromJson(doc.data()))
            .toList();
      }
      return null;
    } catch (e) {
      throw Exception("Error occoured: ${e.toString()}");
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
    } catch (e) {
      throw Exception("Error occoured: ${e.toString()}");
    }
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
    } catch (e) {
      throw Exception("Error occoured: ${e.toString()}");
    }
  }

  @override
  Future<void> updateProductQuantity(
      ProductModel model, double quantity) async {
    try {
      // Find the old one
      final currentQuantity = await getProductQuantityByID(model.id!);
      final newQuanitty = currentQuantity!.copyWith(
          soldUnit: currentQuantity.soldUnit! + quantity,
          sku: currentQuantity.soldUnit! - quantity);
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(ProductModelMapping.collectionName)
          .doc(model.id)
          .update({ProductModelMapping.quantityKey: newQuanitty.toJson()});
    } on Exception catch (e) {
      throw Exception("Error occoured: ${e.toString()}");
    }
  }

  @override
  Future<String> getNewProductID() async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(ProductModelMapping.collectionName)
          .orderBy(ProductModelMapping.idKey, descending: true)
          .limit(1)
          .get();

      // Find the maximum numeric value of the document IDs

      // int maxDocId = snapshot.docs.isNotEmpty
      //     ? snapshot.docs.fold<int>(0, (maxId, doc) {
      //         final docIdStr = doc.id.replaceFirst('SL', '');
      //         final docIdNum = int.tryParse(docIdStr) ?? 0;
      //         return max(maxId, docIdNum);
      //       })
      //     : 0;
      if (snapshot.docs.isNotEmpty) {
        final docIdStr = snapshot.docs.single.id
            .replaceFirst(ProductModelMapping.idFormat, '');
        final maxDocId = int.tryParse(docIdStr) ?? 0;
        // Generate a new document ID
        return ProductModelMapping.idFormat + (maxDocId + 1).toString();
      }

      return 'SL1';
    } on Exception catch (e) {
      throw Exception("Error occoured: ${e.toString()}");
    }
  }
}
