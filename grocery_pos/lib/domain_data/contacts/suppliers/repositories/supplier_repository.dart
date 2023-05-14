import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_pos/domain_data/authentications/models/models.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/models/supplier_model.dart';
import 'package:grocery_pos/domain_data/inventories/products/models/product_model.dart';

abstract class ISupplierRepository {
  Future<void> createSupplier(SupplierModel model) async {}
  Future<void> updateSupplier(SupplierModel model) async {}
  Future<void> deleteSupplier(SupplierModel model) async {}
  // Fetch
  Future<String> getNewSupplierID();
  Future<SupplierModel?> getSupplierByID(String id);
  Future<List<SupplierModel>?> getAllSuppliers();
  Future<List<SupplierModel>?> getAllSupplierNames();
  Future<void> updateProductSupplier(
      SupplierModel model, SupplierModel newModel);
}

class SupplierRepository implements ISupplierRepository {
  final FirebaseFirestore _firestore;
  final UserModel _userModel;

  SupplierRepository(
      {FirebaseFirestore? firestore, required UserModel userModel})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _userModel = userModel;

  @override
  Future<void> createSupplier(SupplierModel model) async {
    try {
      // Use the new document ID to create a new document
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(SupplierModelMapping.collectionName)
          .doc(model.id)
          .set(model.toJson());
    } catch (e) {
      throw Exception("Couldn't create supplier: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteSupplier(SupplierModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(SupplierModelMapping.collectionName)
          .doc(model.id)
          .delete();
      await updateProductSupplier(model, SupplierModel.empty);
    } catch (e) {
      throw Exception("Update Supplier Error ${model.id}: ${e.toString()}");
    }
  }

  @override
  Future<List<SupplierModel>?> getAllSuppliers() async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(SupplierModelMapping.collectionName)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final models = snapshot.docs
            .map(
              (doc) => SupplierModel.fromJson(doc.data()),
            )
            .toList();
        return models;
      } else {
        throw Exception("The supplier list is emty");
      }
    } catch (e) {
      throw Exception("Fetch the supplier: ${e.toString()}");
    }
  }

  @override
  Future<SupplierModel?> getSupplierByID(String id) async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(SupplierModelMapping.collectionName)
          .doc(id)
          .get();
      if (snapshot.data() == null) return null;
      return SupplierModel.fromJson(snapshot.data()!);
    } catch (e) {
      throw Exception("Could't find the supplier's ID $id: ${e.toString()}");
    }
  }

  @override
  Future<void> updateSupplier(SupplierModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(SupplierModelMapping.collectionName)
          .doc(model.id)
          .update(model.toJson());
      await updateProductSupplier(model, model);
    } catch (e) {
      throw Exception("Update Supplier Error: ${e.toString()}");
    }
  }

  @override
  Future<String> getNewSupplierID() async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(SupplierModelMapping.collectionName)
          .orderBy(SupplierModelMapping.idKey, descending: true)
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
            .replaceFirst(SupplierModelMapping.idFormat, '');
        final maxDocId = int.tryParse(docIdStr) ?? 0;
        // Generate a new document ID
        return SupplierModelMapping.idFormat + (maxDocId + 1).toString();
      }

      return 'SL1';
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<SupplierModel>?> getAllSupplierNames() async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(SupplierModelMapping.collectionName)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final models = snapshot.docs
            .map(
              (doc) => SupplierModel.fromProductJson(doc.data()),
            )
            .toList();
        return models;
      }
      return null;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateProductSupplier(
      SupplierModel model, SupplierModel newModel) async {
    try {
      // Get all the documents in the Products subcollection where supplier.id is equal to model.id
      final QuerySnapshot productsSnapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(ProductModelMapping.collectionName)
          .where(
              "${ProductModelMapping.supplierKey}.${SupplierModelMapping.idKey}",
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
      throw Exception("Update Product Supplier Error: ${e.toString()}");
    }
  }
}
