// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.numberId,
    this.accountStatus,
    this.picture,
    this.password,
    this.account_type,
    this.label,
    this.plate,
    this.progress
  });

  String? id;
  String? name;
  String? phone;
  String? email;
  String? numberId;
  String? accountStatus;
  String? picture;
  String? password;
  String? account_type;
  String? label;
  String? plate;
  double? progress;

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        numberId: json["numberId"],
        accountStatus: json["accountStatus"],
        picture: json["picture"],
        password: json["password"],
        account_type: json['accountType'],
        plate: json['plateNumber']
      );
  
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "numberId": numberId,
        "accountStatus": accountStatus,
        "picture": picture,
        "password": password,
        "accountType": account_type,
        "plate" : plate
      };
}
