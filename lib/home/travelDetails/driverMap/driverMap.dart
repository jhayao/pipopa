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
import '../../../utils/constants.dart';
import 'driverMapController.dart' as controller;

class DriverMapPage extends StatelessWidget {
  const DriverMapPage({Key? key, required this.travelHistory})
      : super(key: key);
  final TravelHistoryModel travelHistory;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();

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
                                backgroundColor: Constants().primary1,
                              ),
                            ),
                          )),
                  Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLong.LatLng(
                          double.parse(ctrl.travelHistory.endPoint!.lat!),
                          double.parse(ctrl.travelHistory.endPoint!.lon!)),
                      builder: (ctx) => CircleAvatar(
                            backgroundColor:
                                Constants().primary1.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                backgroundColor: Constants().primary1,
                              ),
                            ),
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
