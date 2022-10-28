import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:location/location.dart';
import 'package:passit/components/PrimaryButtonDecorated.dart';
import 'package:passit/components/TextNormal.dart';
import 'package:passit/components/TextNormalTittle.dart';
import 'package:passit/map/mapController.dart' as controller;
import 'package:passit/models/locationModels.dart';
import 'package:unicons/unicons.dart';
import 'package:passit/firebase/firestore.dart';
import 'package:geocoding/geocoding.dart';
import '../components/TextHeader.dart';
import '../components/TextNormalBolded.dart';
import '../server/requests.dart';
import '../utils/constants.dart';
import 'package:latlong2/latlong.dart' as LatLong;

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    final ctrl = Get.put(controller.MapController());
    return Scaffold(

      body: Stack(
        children: [
          Obx(
            () => FlutterMap(
              key: Key('map_id_${ctrl.lat.value}'),
              options: MapOptions(
                  onPositionChanged: (mapPosition, boolValue) {
                    // _lastposition = mapPosition.center;
                    mapPosition.center;
                  },
                  onLongPress: (position, latlng) async {
                    print("Long press");
                    LatLong.LatLng temp = latlng;
                    ctrl.endLocation = await Requests().SearchLocations2(
                        temp.latitude.toString(), temp.longitude.toString());
                    ctrl.setMyDestination(temp.longitude, temp.latitude,
                        ctrl.endLocation.displayName!);
                    print("My Locations ${ctrl.endLocation.displayName}");
                  },
                  center: LatLong.LatLng(ctrl.lat.value, ctrl.long.value),
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
                  ...ctrl.markers.value,
                  ...ctrl.destinationMarkers.value,
                  ...ctrl.driverMarkers.value,
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
          Positioned(
              top: 80,
              child: Container(
                width: Get.width,
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          UniconsLine.location_pin_alt,
                          color: constants.primary1,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        margin: EdgeInsets.only(right: 4),
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            ctrl.searchWorld.value = value;
                          },
                          onEditingComplete: () {
                            ctrl.fetchWord(ctrl.searchWorld.value);
                            ctrl.showSugestions.value = true;
                          },
                          decoration: InputDecoration(
                              hintText: 'Where do you intend to go?',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 5),
                              suffixIcon: Icon(UniconsLine.search)),
                          autofocus: false,
                        ),
                      ),
                    ],
                  ),
                ),
              )),

          Obx(() => Positioned(
                top: 125,
                child: Visibility(
                  visible: ctrl.showSugestions.value,
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Obx((() => Column(
                              children: ctrl.myLocations
                                  .map((location) => GestureDetector(
                                        onTap: () {
                                          ctrl.searchWorld.value = '';
                                          ctrl.choosen_location.value =
                                              'Angola';
                                          ctrl.searchWorld.value = '';
                                          ctrl.setMyDestination(
                                              double.parse(location.lon!),
                                              double.parse(location.lat!),
                                              location.displayName ?? '');
                                          ctrl.long.value =
                                              double.parse(location.lon!);
                                          ctrl.lat.value =
                                              double.parse(location.lat!);
                                          ctrl.endLocation = location;
                                          ctrl.showSugestions.value = false;
                                        },
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Icon(
                                                        UniconsLine
                                                            .location_pin_alt,
                                                        color:
                                                            constants.primary1,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      width: 1,
                                                      margin: EdgeInsets.only(
                                                          right: 4),
                                                      color: Colors.grey,
                                                    ),
                                                    Text(location.displayName ??
                                                        ''),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                                height: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ))),
                      ),
                    ),
                  ),
                ),
              )),

          //----------------------------------------------------------------
          Obx(() => Positioned(
                bottom: 10,
                child: Visibility(
                  visible: ctrl.choosen_location.isNotEmpty,
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Get.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextNormalTittle(
                                    text: "Book Information",
                                    textColor: constants.primary2,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      // var result =
                                      //     await Firestore().storeTravel(travel: travelHistory.value[0]);
                                      // print("ERROR?: $result");
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              margin: EdgeInsets.only(right: 5),
                                              child: ExtendedImage.network(
                                                  "https://images.pexels.com/photos/428361/pexels-photo-428361.jpeg?auto=compress&cs=tinysrgb&w=600",
                                                  fit: BoxFit.cover),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                TextNormalBolded(
                                                  text: "Regular Ride",
                                                  textColor: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextNormalTittle(
                                                  text: "Economy",
                                                  textColor: constants.primary2,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            TextHeader(
                                              text: ctrl.myRoute.value.routes
                                                          .length >
                                                      0
                                                  ? "PHP " +
                                                      Constants()
                                                          .calculateFare(ctrl
                                                                  .myRoute
                                                                  .value
                                                                  .routes[0]
                                                                  .distance
                                                                  .toDouble() /
                                                              1000)
                                                          .toStringAsFixed(2)
                                                  : '',
                                              textColor:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextNormal(
                                                text: ctrl.myRoute.value.routes
                                                            .length >
                                                        0
                                                    ? Constants().formatNumber(
                                                        ctrl
                                                            .myRoute
                                                            .value
                                                            .routes[0]
                                                            .distance)(',')
                                                    : '0' + " Kilometer",
                                                textColor: Colors.grey)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: Get.width,
                              child: Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      ctrl.choosen_location.value = '';
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextNormal(
                                        text: "Cancel",
                                        textColor: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: PrimaryButtonDecorated(
                                        onclick: () {
                                          ctrl.showTransportationDetails();
                                        },
                                        children: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextNormal(
                                              text: "Advance",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: constants.primary1,
        onPressed: ctrl.showDialog,
        child: Icon(UniconsLine.location_pin_alt),
      ),
    );
  }
}
