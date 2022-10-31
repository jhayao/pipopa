import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passit/models/locationModels.dart';
import 'package:passit/models/routesModel.dart';
import 'package:passit/models/userModel.dart';

class PaymentModel {
  PaymentModel({
    this.createdAt,
    this.driver,
    this.passenger,
    this.startPoint,
    this.endPoint,
    this.routes,
    this.status,
    this.uid,
    this.amount
  });

  UserModel? driver;
  UserModel? passenger;
  LocationModel? startPoint;
  LocationModel? endPoint;
  RoutesModel? routes;
  String? createdAt;
  String? status;
  String? uid;
  double? amount;

  factory PaymentModel.fromRawJson(String str) =>
      PaymentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      PaymentModel(
        driver:
        json["driver"] == null ? null : UserModel.fromJson(json["driver"]),
        passenger: json["passenger"] == null
            ? null
            : UserModel.fromJson(json["passenger"]),
        startPoint: json["startPoint"] == null
            ? null
            : LocationModel.fromJson(json["startPoint"]),
        endPoint: json["endPoint"] == null
            ? null
            : LocationModel.fromJson(json["endPoint"]),
        routes: json["routes"] == null
            ? null
            : RoutesModel.fromJson(json["routes"]),
        createdAt:
        json["createdAt"] == null ? null : (json["createdAt"]).toString(),
        status:
        json["status"] == null ? null : (json["status"]).toString(),
      );

  factory PaymentModel.fromJson2(Map<String, dynamic> json,String uids) =>
      PaymentModel(
        uid: uids,
        driver:
        json["driver"] == null ? null : UserModel.fromJson(json["driver"]),
        passenger: json["passenger"] == null
            ? null
            : UserModel.fromJson(json["passenger"]),
        startPoint: json["startPoint"] == null
            ? null
            : LocationModel.fromJson(json["startPoint"]),
        endPoint: json["endPoint"] == null
            ? null
            : LocationModel.fromJson(json["endPoint"]),
        routes: json["routes"] == null
            ? null
            : RoutesModel.fromJson(json["routes"]),
        createdAt:
        json["createdAt"] == null ? null : (json["createdAt"]).toString(),
        status:
        json["status"] == null ? null : (json["status"]).toString(),
      );

  Map<String, dynamic> toJson() => {
    "driver": driver?.toJson(),
    "passenger": passenger?.toJson(),
    "startPoint": startPoint?.toJson(),
    "endPoint": endPoint?.toJson(),
    "routes": routes?.toJson(),
    "createdAt": createdAt.toString(),
    "status" : status.toString(),
    "amount" : amount?.toDouble()
  };
}
