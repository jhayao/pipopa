import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:passit/components/PrimaryButtonDecorated.dart';
import 'package:passit/components/TextNormal.dart';
import 'package:passit/components/TextNormalTittle.dart';
import 'package:unicons/unicons.dart';

import 'package:latlong2/latlong.dart' as LatLong;

import '../../../components/TextHeader.dart';
import '../../../components/TextNormalBolded.dart';
import '../../../models/travelHistoryModel.dart';
import '../../../models/userModel.dart';
import '../../../utils/constants.dart';
import 'driverMapController.dart' as controller;

class DriverMapPage extends StatelessWidget {
  const DriverMapPage(
      {Key? key, required this.travelHistory, required this.user})
      : super(key: key);
  final TravelHistoryModel travelHistory;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
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
                    'https://api.mapbox.com/styles/v1/yusaku04/cl9s75qms00bo14o2xcywmhr5/tiles/256/{z}/{x}/{y}@2x',
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoibHVrM2R4IiwiYSI6ImNqbmdlNDh6NzAyMmYzcXRqMzZhYXZ3ZXMifQ._-xyvv2Q9jDLon_J5cYocw',
                      'id': 'mapbox.satellite'
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
