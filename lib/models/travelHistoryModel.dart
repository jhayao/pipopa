import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passit/models/locationModels.dart';
import 'package:passit/models/routesModel.dart';
import 'package:passit/models/userModel.dart';

class TravelHistoryModel {
  TravelHistoryModel({
    this.createdAt,
    this.driver,
    this.passenger,
    this.startPoint,
    this.endPoint,
    this.routes,
  });

  UserModel? driver;
  UserModel? passenger;
  LocationModel? startPoint;
  LocationModel? endPoint;
  RoutesModel? routes;
  String? createdAt;

  factory TravelHistoryModel.fromRawJson(String str) =>
      TravelHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TravelHistoryModel.fromJson(Map<String, dynamic> json) =>
      TravelHistoryModel(
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
      );

  Map<String, dynamic> toJson() => {
        "driver": driver?.toJson(),
        "passenger": passenger?.toJson(),
        "startPoint": startPoint?.toJson(),
        "endPoint": endPoint?.toJson(),
        "routes": routes?.toJson(),
        "createdAt": createdAt.toString(),
      };
}
