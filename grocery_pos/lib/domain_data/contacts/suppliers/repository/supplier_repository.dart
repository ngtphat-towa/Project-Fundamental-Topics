import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_pos/domain_data/authentications/models/models.dart';
import 'package:grocery_pos/domain_data/contacts/suppliers/model/supplier_model.dart';

abstract class ISupplierRepository {
  Future<void> createSupplier(SupplierModel model) async {}
  Future<void> updateSupplier(SupplierModel model) async {}
  Future<void> deleteSupplier(SupplierModel model) async {}
  // Fetch
  Future<String> getNewSupplierID();
  Future<SupplierModel?> getSupplierByID(String id);
  Future<List<SupplierModel>?> getAllSuppliers();
  Future<List<SupplierModel>?> getAllSupplierNames();
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
    } catch (_) {}
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
    } catch (_) {}
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
      }
      return null;
    } catch (_) {
      return null;
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
    } catch (_) {
      return null;
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
    } catch (_) {}
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
}
