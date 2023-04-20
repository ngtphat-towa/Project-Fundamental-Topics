import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_pos/domain_data/authentications/models/models.dart';
import 'package:grocery_pos/domain_data/pos/invoices/models/invoice_model.dart';

abstract class IInvoiceReposiotry {
  // create new invoice in firestore
  Future<void> createInvoice(InvoiceModel model);
  // update invoice in firestore
  Future<void> updateInvoice(InvoiceModel model);
  // From the invoiceDetails will modify the quantity of product by using product.updateProductQuantity(string id, double quanity)
  Future<void> deleteInvoice(InvoiceModel model);
  // Sort id field by desc and limt(1)
  // Get Single field and check if isEmpty : rerturn the format +1 ortherwise return the format+ current id +1
  Future<String?> getNewInvoiceID();
  // Find the invoice by ID feilds or Document ID
  Future<InvoiceModel?> getInvoiceByID(String id);
  Future<List<InvoiceModel>?> getALlInvoices();
}

class InvoiceRepository implements IInvoiceReposiotry {
  final UserModel _userModel;
  final FirebaseFirestore _firestore;

  InvoiceRepository(
      {required UserModel userModel, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _userModel = userModel;

  @override
  Future<void> createInvoice(InvoiceModel model) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_userModel.uid)
          .collection(InvoiceModelMapping.collectionName)
          .doc(model.id)
          .set(model.toJson());
    } catch (e) {
      throw Exception("Create new invoice failed: ${e.toString()}");
    }
  }

  @override
  Future<void> updateInvoice(InvoiceModel model) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_userModel.uid)
          .collection(InvoiceModelMapping.collectionName)
          .doc(model.id)
          .update(model.toJson());
    } catch (e) {
      throw Exception('Update invoice failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteInvoice(InvoiceModel model) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_userModel.uid)
          .collection(InvoiceModelMapping.collectionName)
          .doc(model.id)
          .delete();
    } catch (e) {
      throw Exception('Delete invoice failed: ${e.toString()}');
    }
  }

  @override
  Future<String?> getNewInvoiceID() async {
    try {
      final snapshot = await _firestore
          .collection('Users')
          .doc(_userModel.uid)
          .collection(InvoiceModelMapping.collectionName)
          .orderBy(InvoiceModelMapping.idKey, descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) {
        return '${InvoiceModelMapping.idFormat}1';
      } else {
        final currentID = snapshot.docs.first[InvoiceModelMapping.idKey];
        final newID = int.parse(
                currentID.substring(InvoiceModelMapping.idFormat.length)) +
            1;
        return '${InvoiceModelMapping.idFormat}$newID';
      }
    } catch (e) {
      throw Exception('Generate new Invoice ID failed: ${e.toString()}');
    }
  }

  @override
  Future<InvoiceModel?> getInvoiceByID(String id) async {
    try {
      final snapshot = await _firestore
          .collection('Users')
          .doc(_userModel.uid)
          .collection(InvoiceModelMapping.collectionName)
          .where(InvoiceModelMapping.idKey, isEqualTo: id)
          .get();
      if (snapshot.docs.isEmpty) return null;
      return InvoiceModel.fromJson(snapshot.docs.first.data());
    } catch (e) {
      throw Exception("Couldn't retrieve the invoice $id : ${e.toString()}");
    }
  }

  @override
  Future<List<InvoiceModel>?> getALlInvoices() async {
    try {
      final snapshot = await _firestore
          .collection('Users')
          .doc(_userModel.uid)
          .collection(InvoiceModelMapping.collectionName)
          .get();
      return snapshot.docs
          .map((doc) => InvoiceModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error occurred! ${e.toString()}");
    }
  }
}
