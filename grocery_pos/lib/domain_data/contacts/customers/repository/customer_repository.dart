import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_pos/domain_data/authentications/models/models.dart';
import 'package:grocery_pos/domain_data/contacts/customers/model/customer_model.dart';

abstract class ICustomerRepository {
  Future<void> createCustomer(CustomerModel model) async {}
  Future<void> updateCustomer(CustomerModel model) async {}
  Future<void> deleteCustomer(CustomerModel model) async {}
  // Fetch
  Future<String> getNewCustomerID();
  Future<CustomerModel?> getCustomerByID(String id);
  Future<List<CustomerModel>?> getAllCustomers();
}

class CustomerRepository implements ICustomerRepository {
  final FirebaseFirestore _firestore;
  final UserModel _userModel;

  CustomerRepository(
      {FirebaseFirestore? firestore, required UserModel userModel})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _userModel = userModel;

  @override
  Future<void> createCustomer(CustomerModel model) async {
    try {
      // Use the new document ID to create a new document
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CustomerModelMapping.collectionName)
          .doc(model.id)
          .set(model.toJson());
    } catch (_) {}
  }

  @override
  Future<void> deleteCustomer(CustomerModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CustomerModelMapping.collectionName)
          .doc(model.id)
          .delete();
    } catch (_) {}
  }

  @override
  Future<List<CustomerModel>?> getAllCustomers() async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CustomerModelMapping.collectionName)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final models = snapshot.docs
            .map(
              (doc) => CustomerModel.fromJson(doc.data()),
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
  Future<CustomerModel?> getCustomerByID(String id) async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CustomerModelMapping.collectionName)
          .doc(id)
          .get();
      if (snapshot.data() == null) return null;
      return CustomerModel.fromJson(snapshot.data()!);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateCustomer(CustomerModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CustomerModelMapping.collectionName)
          .doc(model.id)
          .update(model.toJson());
    } catch (_) {}
  }

  @override
  Future<String> getNewCustomerID() async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(CustomerModelMapping.collectionName)
          .orderBy(CustomerModelMapping.idKey, descending: true)
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
            .replaceFirst(CustomerModelMapping.idForamt, '');
        final maxDocId = int.tryParse(docIdStr) ?? 0;
        // Generate a new document ID
        return CustomerModelMapping.idForamt + (maxDocId + 1).toString();
      }

      return 'SL1';
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
