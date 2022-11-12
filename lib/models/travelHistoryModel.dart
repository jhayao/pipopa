import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passit/models/locationModels.dart';
import 'package:passit/models/routesModel.dart';
import 'package:passit/models/userModel.dart';

class TravelHistoryModel {
  TravelHistoryModel(
      {this.createdAt,
      this.driver,
      this.passenger,
      this.startPoint,
      this.endPoint,
      this.routes,
      this.status,
      this.uid,
      this.rate,
      this.comment,
      this.currentLocation});

  UserModel? driver;
  UserModel? passenger;
  LocationModel? startPoint;
  LocationModel? endPoint;
  RoutesModel? routes;
  String? createdAt;
  String? status;
  String? uid;
  String? rate;
  String? comment;
  LocationModel? currentLocation;

  factory TravelHistoryModel.fromRawJson(String str) =>
      TravelHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TravelHistoryModel.fromJson(Map<String, dynamic> json) =>
      TravelHistoryModel(
        currentLocation: json["endPoint"] == null
            ? null
            : LocationModel.fromJson(json["endPoint"]),
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
        status: json["status"] == null ? null : (json["status"]).toString(),
        rate: json["star"] == null ? null : (json["star"]).toString(),
        comment: json["comment"] == null ? null : (json["comment"]).toString(),
      );

  factory TravelHistoryModel.fromJson2(
          Map<String, dynamic> json, String uids) =>
      TravelHistoryModel(
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
        status: json["status"] == null ? null : (json["status"]).toString(),
      );

  Map<String, dynamic> toJson() => {
        "driver": driver?.toJson(),
        "passenger": passenger?.toJson(),
        "startPoint": startPoint?.toJson(),
        "endPoint": endPoint?.toJson(),
        "routes": routes?.toJson(),
        "createdAt": createdAt.toString(),
        "status": status.toString(),
        "currentLocation": currentLocation?.toJson(),
        "rate": rate.toString(),
        "comment": comment.toString()
      };
}
