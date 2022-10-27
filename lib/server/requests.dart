import 'dart:convert';

import 'package:passit/models/locationModels.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:passit/models/routesModel.dart';
import 'package:map_launcher/map_launcher.dart';

class Requests {
  final baseUrl =
      'https://nominatim.openstreetmap.org/search?q=philippines+###&format=json&polygon_geojson=1&addressdetails=1';

  final baseUrl2 =
      'https://nominatim.openstreetmap.org/reverse.php?###&zoom=18&format=json';

  final maps =
      'https://www.google.com/maps/dir/?api=1&origin=###&destination=###&travelmode=driving';

  final routesUrls =
      "http://router.project-osrm.org/route/v1/driving/###?overview=full&geometries=polyline";

  Future<List<LocationModel>> SearchLocations(String word) async {
    String toSearch = word.split(' ').join('+');

    var locationLists = <LocationModel>[];

    try {
      var response = await Dio().get(baseUrl.split('###').join(toSearch));
      locationLists = List.from(response.data)
          .map((e) => LocationModel.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    }
    return locationLists;
  }

  launchURL(LocationModel? origin, LocationModel? destination) async {
    String paramenters = 'origin=&destination=###';
    DirectionsMode directionsMode = DirectionsMode.driving;

    final availableMaps = await MapLauncher.installedMaps;
    ;
    await availableMaps.first.showDirections(
      origin: Coords(double.parse(origin!.lat!), double.parse(origin!.lon!)),
      destination: Coords(double.parse(destination!.lat!), double.parse(destination!.lon!)),
      directionsMode: DirectionsMode.driving,
      // title: "Ocean Beach",
    );
  }

  Future<LocationModel> SearchLocations2(String lat, String long) async {
    // String toSearch = word.split(' ').join('+');
    String toSearch = "lat=$lat&lon=$long";
    // var locationLists = <LocationModel>[];
    LocationModel locationLists = LocationModel();
    // print("Final String ${baseUrl2.split('###').join(toSearch)}");
    try {
      var response = await Dio().get(baseUrl2.split('###').join(toSearch));
      print(response.data);
      // locationLists = List.from(response.data)
      //     .map((e) => LocationModel.fromJson(e))
      //     .toList();
      locationLists = LocationModel.fromJson(response.data);
    } catch (e) {
      print("Error Found: $e");
    }
    return locationLists;
  }

  Future<RoutesModel> GetRoutes(LatLng start, end) async {
    var routes = RoutesModel(code: 'error', routes: [], waypoints: []);
    var response = await Dio().get(routesUrls.split('###').join(
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'));
    routes = RoutesModel.fromJson(response.data);

    return routes;
  }
}
