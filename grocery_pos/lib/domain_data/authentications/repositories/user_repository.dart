import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/widgets.dart';
import 'package:grocery_pos/domain_data/authentications/models/user_model.dart';

abstract class IUserRepository {
  Future<UserModel?> getUser();
  Future<void> createUser() async {}
  Future<void> updateUser(UserModel model) async {}
}

class UserRepository implements IUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserModel firebaseUserModel;
  UserRepository({required this.firebaseUserModel});
  // @override
  // Future<UserModel?> getUserByUID(String uid) async {
  //   try {
  //     final snapshot = await _firestore
  //         .collection(UserModelMapping.collectioName)
  //         .where(UserModelMapping.uidFeild, isEqualTo: uid)
  //         .get();
  //     if (snapshot.docs.isNotEmpty) {
  //       final userData = snapshot.docs.first.data();
  //       return UserModel.fromMap(userData);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

  @override
  Future<UserModel?> getUser() async {
    try {
      final snapshot = await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(firebaseUserModel.uid)
          .get();
      if (snapshot.exists) {
        final userData = snapshot.data();
        return UserModel.fromMap(userData!);
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> createUser() async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(firebaseUserModel.uid)
          .set(firebaseUserModel.toJson());
      debugPrint("Create new account successfully!");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateUser(UserModel model) async {
    try {
      await _firestore
          .collection(UserModelMapping.collectioName)
          .doc(model.uid)
          .update(model.toJson());
    } catch (_) {}
  }
}
