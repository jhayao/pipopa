// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LocationModel locationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  LocationModel({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.displayName,
    this.locationModelClass,
    this.type,
    this.importance,
    this.icon,
    this.address,
  });

  int? placeId;
  String? licence;
  String? osmType;
  int? osmId;
  String? lat;
  String? lon;
  String? displayName;
  String? locationModelClass;
  String? type;
  double? importance;
  String? icon;
  Address? address;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        placeId: json["place_id"],
        licence: json["licence"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        lat: json["lat"],
        lon: json["lon"],
        displayName: json["display_name"],
        locationModelClass: json["class"],
        type: json["type"],
        importance: json["importance"].toDouble(),
        icon: json["icon"],
        address: Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmType,
        "osm_id": osmId,
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
        "class": locationModelClass,
        "type": type,
        "importance": importance,
        "icon": icon,
        "address": address?.toJson(),
      };
}

class Address {
  Address({
    this.tourism,
    this.road,
    this.neighbourhood,
    this.suburb,
    this.city,
    this.county,
    this.state,
    this.iso31662Lvl4,
    this.country,
    this.countryCode,
  });

  String? tourism;
  String? road;
  String? neighbourhood;
  String? suburb;
  String? city;
  String? county;
  String? state;
  String? iso31662Lvl4;
  String? country;
  String? countryCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        tourism: json["tourism"],
        road: json["road"],
        neighbourhood: json["neighbourhood"],
        suburb: json["suburb"],
        city: json["city"],
        county: json["county"],
        state: json["state"],
        iso31662Lvl4: json["ISO3166-2-lvl4"],
        country: json["country"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "tourism": tourism,
        "road": road,
        "neighbourhood": neighbourhood,
        "suburb": suburb,
        "city": city,
        "county": county,
        "state": state,
        "ISO3166-2-lvl4": iso31662Lvl4,
        "country": country,
        "country_code": countryCode,
      };
}
