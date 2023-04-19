import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_pos/domain_data/store/store_profile_model.dart';

import '../authentications/models/user_model.dart';

abstract class IStoreProfileRepository {
  Future<void> createStoreProfile(StoreProfileModel model);
  Future<void> updateStoreProfile(StoreProfileModel model);
  Future<StoreProfileModel?> getStoreProfile();
}

class StoreProfileRepository implements IStoreProfileRepository {
  final FirebaseFirestore _firestore;
  final UserModel _userModel;

  StoreProfileRepository(
      {FirebaseFirestore? firestore, required UserModel userModel})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _userModel = userModel;
  @override
  Future<void> createStoreProfile(StoreProfileModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(StoreProfileModelMapping.collectionName)
          .doc(StoreProfileModelMapping.documentID)
          .set(model.toJson());
    } catch (_) {}
  }

  @override
  Future<StoreProfileModel?> getStoreProfile() async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(StoreProfileModelMapping.collectionName)
          .doc(StoreProfileModelMapping.documentID)
          .get();
      if (!snapshot.exists) return null;
      return StoreProfileModel.fromJson(snapshot.data()!);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateStoreProfile(StoreProfileModel model) async {
    try {
      await FirebaseFirestore.instance
          .collection(UserModelMapping.collectioName)
          .doc(_userModel.uid)
          .collection(StoreProfileModelMapping.collectionName)
          .doc(StoreProfileModelMapping.documentID)
          .update(model.toJson());
    } catch (_) {}
  }
}
