import 'package:passit/models/locationModels.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:passit/models/routesModel.dart';

class Requests {
  final baseUrl =
      'https://nominatim.openstreetmap.org/search?q=philippines+###&format=json&polygon_geojson=1&addressdetails=1';

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

  Future<RoutesModel> GetRoutes(LatLng start, end) async {
    var routes = RoutesModel(code: 'error', routes: [], waypoints: []);
    var response = await Dio().get(routesUrls.split('###').join(
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'));
    routes = RoutesModel.fromJson(response.data);

    return routes;
  }
}
