// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      uid: data[UserModelMapping.uidKey],
      email: data[UserModelMapping.emailKey] ?? '',
      phone: data[UserModelMapping.phoneKey] ?? '',
      name: data[UserModelMapping.nameKey] ?? '',
      photo: data[UserModelMapping.photoKey] ?? '',
    );
  }
  toJson() {
    return {
      UserModelMapping.uidKey: uid,
      UserModelMapping.emailKey: email,
      UserModelMapping.phoneKey: phone,
      UserModelMapping.nameKey: name,
      UserModelMapping.photoKey: photo,
    };
  }

  static const empty = UserModel(uid: '');
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [uid, email, phone, name, photo];

  UserModel copyWith({
    String? uid,
    String? email,
    String? phone,
    String? name,
    String? photo,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      photo: photo ?? this.photo,
    );
  }
}

class UserModelMapping {
  static const collectioName = 'Users';
  static const uidKey = 'uid';
  static const emailKey = 'email';
  static const phoneKey = 'phone';
  static const nameKey = 'name';
  static const photoKey = 'photoURL';
}
