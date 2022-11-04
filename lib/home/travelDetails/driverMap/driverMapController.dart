import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:passit/components/PrimaryButtonDecorated.dart';
import 'package:passit/components/TextHeader.dart';
import 'package:passit/components/TextNormalBolded.dart';
import 'package:passit/models/locationModels.dart';
import 'package:passit/models/userModel.dart';
import 'package:unicons/unicons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as LatLong;

import '../../../components/TextNormal.dart';
import '../../../models/routesModel.dart';
import '../../../models/travelHistoryModel.dart';
import '../../../server/requests.dart';
import '../../../utils/constants.dart';

class DriverMapController extends GetxController {
  final TravelHistoryModel travelHistory;

  DriverMapController(this.travelHistory);

  var choosen_location = ''.obs;
  var searchWorld = ''.obs;
  var polylines = <TaggedPolyline>[
    TaggedPolyline(
      tag: 'My Polyline',
      // An optional tag to distinguish polylines in callback
      points: <LatLong.LatLng>[],
      color: Colors.red,
      strokeWidth: 9.0,
    )
  ].obs;
  var markers = <Marker>[
    Marker(
        width: 80.0,
        height: 80.0,
        point: LatLong.LatLng(-8.827, 13.248),
        builder: (ctx) => CircleAvatar(
              backgroundColor: Constants().primary1.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundColor: Constants().primary1,
                ),
              ),
            ))
  ].obs;
  var destinationMarkers = <Marker>[].obs;
  var long = 0.0.obs, lat = 0.0.obs;
  var searchingWord = '';
  var searchController = TextEditingController();
  var myLocations = <LocationModel>[].obs;
  late LocationModel startLocation;
  late LocationModel endLocation;
  var myRoute = RoutesModel(code: '', routes: [], waypoints: []).obs;
  late LatLong.LatLng startPoint, endPoint;
  var startAddress = ''.obs, endAddress = ''.obs;

  var showSugestions = false.obs;

  void changeMarkerPosition(double _long, double _lat, String address) {
    try {
      startPoint = LatLong.LatLng(_lat, _long);
      startAddress.value = address;
      markers.value.clear();
      markers.value.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLong.LatLng(_lat, _long),
          builder: (ctx) => Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Constants().primary1.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Constants().primary1,
                  ),
                ),
              ),
              Text(
                "Match",
                style: TextStyle(fontSize: 13, color: Colors.white),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      //print("ERROR E1: ${e.toString()}");
      Get.snackbar("Erro ao determinar a posição.",
          "Please make sure your GPS is active and your internet connection. $e",
          duration: Duration(seconds: 10), colorText: Colors.black);
    }
  }

  void setMyDestination(double _long, double _lat, String address) {
    try {
      endPoint = LatLong.LatLng(_lat, _long);
      endAddress.value = address;
      destinationMarkers.value.clear();
      destinationMarkers.value.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLong.LatLng(_lat, _long),
          builder: (ctx) => Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Constants().primary1.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Constants().primary1,
                  ),
                ),
              ),
              Text(
                "Destination",
                style: TextStyle(fontSize: 13, color: Colors.white),
              )
            ],
          ),
        ),
      );


      getCordinates();
    } catch (e) {
      Get.snackbar("Error!.",
          "Please make sure your GPS is active and your internet connection. $e",
          duration: Duration(seconds: 10), colorText: Colors.black);
    }
  }

  void getCordinates() async {


    try {

      

      var res = await Requests().GetRoutes(startPoint, endPoint).then((value) {

        myRoute.value = value;
        print("asddajdgd ${endPoint.toString()}");
        if (value.routes.isNotEmpty) {


          List<PointLatLng> result =
          PolylinePoints().decodePolyline(value.routes[0].geometry);
          print("Result ${result.first.toString()}");
          final points =
          result.map((e) => LatLong.LatLng(e.latitude, e.longitude)).toList();
          print("POINTS: ${points.toString()}");
          points.insert(0, startPoint);
          points.add(endPoint);

          polylines.value = [
            TaggedPolyline(
              tag: 'My Polyline',
              // An optional tag to distinguish polylines in callback
              points: points,
              color: Constants().primary1.withOpacity(0.5),
              strokeWidth: 6.0,
            )
          ];

        } else {
          //print("NE DIALOG");
          Get.dialog(Center(
            child: Container(
              child: Material(
                child: Column(
                  children: [
                    Text(
                        "Oops! There was an error loading the route information.\n Please check your internet status and try again."),
                    TextButton.icon(
                      onPressed: getCordinates,
                      icon: Icon(Icons.refresh),
                      label: Text(
                        "Try again",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
        }




      });
      // //print("res ${startPoint()}  ${endPoint.toJson()} ");


      //print("Testing");




    } catch (e) {
      //print("ERROR E: ${e.toString()}");
      Get.snackbar("Erro ao determinar a posição.",
          "Please make sure your GPS is active and your internet connection. ",
          duration: Duration(seconds: 10), colorText: Colors.black);
    }
    finally
        {
          //print("DIALOG IS OPEN? ${Get.isDialogOpen}");
          if(Get.isDialogOpen ?? false)
            {
              // Get.back();
            }
        }
  }

  @override
  void onInit() async {
    super.onInit();
    //print("RUNNED");
    await Future.delayed(const Duration(seconds: 3), () {
//do something
    });
    changeMarkerPosition(
        double.parse(travelHistory.startPoint!.lon!),
        double.parse(travelHistory.startPoint!.lat!),
        travelHistory.startPoint!.displayName!);
    //printError(info: "TESTE BSICO");

    setMyDestination(
        double.parse(travelHistory.endPoint!.lon!),
        double.parse(travelHistory.endPoint!.lat!),
        travelHistory.endPoint!.displayName!);
    ////print("LOADING....");
  }

  @override
  void onClose() async {
    print("Close");
    // Get.delete<DriverMapController>();
  }
  // @override
  // void dispose() {
  //   //print("Dispose");
  //   Get.delete<DriverMapController>();
  // }
}
