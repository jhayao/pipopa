import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:provider/provider.dart';
import '../../../models/travelHistoryModel.dart';
import '../../../models/userModel.dart';
import '../../../utils/LocationService.dart';
import '../../../utils/constants.dart';
import 'driverMapController.dart' as controller;
import '../../../map/mapController.dart' as MapsControllers;


class DriverMapPage2 extends StatelessWidget {
  const DriverMapPage2(
      {Key? key, required this.travelHistory, required this.user})
      : super(key: key);
  final TravelHistoryModel travelHistory;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    var userLocation = Provider.of<UserLocation>(context);
    print("UserLocation ${userLocation.latitude} ${userLocation.longitude}");
    Get.delete<controller.DriverMapController>();
    final ctrl = Get.put(controller.DriverMapController(travelHistory));
    return Scaffold(
        body: Stack(
          children: [
            Obx(
              () => FlutterMap(
                key: Key('map_id_${ctrl.lat.value}'),
                options: MapOptions(
                    center: LatLong.LatLng(
                        double.parse(ctrl.travelHistory.startPoint!.lat!),
                        double.parse(ctrl.travelHistory.startPoint!.lon!)),
                    zoom: 13.0,
                    plugins: [
                      TappablePolylineMapPlugin(),
                    ]),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/luk3dx/cl79r9r3j001814qkhsfk6wne/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibHVrM2R4IiwiYSI6ImNqbmdlNDh6NzAyMmYzcXRqMzZhYXZ3ZXMifQ._-xyvv2Q9jDLon_J5cYocw',
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1IjoibHVrM2R4IiwiYSI6ImNqbmdlNDh6NzAyMmYzcXRqMzZhYXZ3ZXMifQ._-xyvv2Q9jDLon_J5cYocw',
                        'id': 'mapbox.mapbox-streets-v8'
                      }),
                  MarkerLayerOptions(markers: [
                    Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLong.LatLng(
                            double.parse(ctrl.travelHistory.startPoint!.lat!),
                            double.parse(ctrl.travelHistory.startPoint!.lon!)),
                        builder: (ctx) => CircleAvatar(
                              backgroundColor:
                                  Constants().primary1.withOpacity(0.5),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: user.account_type == 'cdrrmo'
                                      ? NetworkImage(
                                          "https://firebasestorage.googleapis.com/v0/b/ustpthesis.appspot.com/o/images%2Fweb-161067659-removebg-preview.png?alt=media&token=80d7029b-b310-4af5-95c0-fc44ed5fc922")
                                      : NetworkImage(
                                          "${travelHistory.passenger != null ? travelHistory.passenger!.picture == null ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Man_Driving_Car_Cartoon_Vector.svg/2560px-Man_Driving_Car_Cartoon_Vector.svg.png' : travelHistory.passenger!.picture : 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Man_Driving_Car_Cartoon_Vector.svg/2560px-Man_Driving_Car_Cartoon_Vector.svg.png'}"),
                                  // radius: 50,
                                ),
                              ),
                            )),


                    Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLong.LatLng(
                            double.parse(ctrl.travelHistory.endPoint!.lat!),
                            double.parse(ctrl.travelHistory.endPoint!.lon!)),
                        builder: (ctx) => Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Constants().primary1.withOpacity(0.5),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CircleAvatar(
                                      backgroundColor: Constants().primary1,
                                      // radius: 50,
                                      backgroundImage: user.account_type ==
                                              'cdrrmo'
                                          ? NetworkImage(
                                              'https://e7.pngegg.com/pngimages/361/318/png-clipart-traffic-collision-bicycle-accident-bicycle-car-accident-car-accident-fitness.png')
                                          : NetworkImage(''),

                                      // radius: 50,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Destination",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                )
                              ],
                            )),
                  ]),
                  TappablePolylineLayerOptions(
                      // Will only render visible polylines, increasing performance
                      polylineCulling: true,
                      polylines: ctrl.polylines.value,
                      onTap: (polylines, tapPosition) => print('Tapped: ' +
                          polylines.map((polyline) => polyline.tag).join(',') +
                          ' at ' +
                          tapPosition.globalPosition.toString()),
                      onMiss: (tapPosition) {
                        print('No polyline was tapped at position ' +
                            tapPosition.globalPosition.toString());
                      })
                ],
              ),
            ),
          ],
        ),

    );
  }


}
