import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String? email;
  final String? phone;
  final String? name;
  final String? photo;

  const UserModel(
      {required this.uid, this.email, this.phone, this.name, this.photo});
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data[UserModelMapping.uidFeild],
      email: data[UserModelMapping.emailFeild]!,
      phone: data[UserModelMapping.phoneFeild]!,
      name: data[UserModelMapping.nameFeild]!,
      photo: data[UserModelMapping.photoFeild]!,
    );
  }
  toJson() {
    return {
      UserModelMapping.uidFeild: uid,
      UserModelMapping.emailFeild: email,
      UserModelMapping.phoneFeild: phone,
      UserModelMapping.nameFeild: name,
      UserModelMapping.photoFeild: photo,
    };
  }

  static const empty = UserModel(uid: '');
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [uid, email, phone, name, photo];
}

class UserModelMapping {
  static const collectioName = 'Users';
  static const uidFeild = 'uid';
  static const emailFeild = 'email';
  static const phoneFeild = 'phone';
  static const nameFeild = 'name';
  static const photoFeild = 'photoURL';
}
