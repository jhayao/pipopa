import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:passit/components/PrimaryButtonDecorated.dart';
import 'package:passit/components/TextNormal.dart';
import 'package:passit/components/TextNormalTittle.dart';
import 'package:passit/map/mapController.dart' as controller;
import 'package:unicons/unicons.dart';
import 'package:passit/firebase/firestore.dart';
import '../components/TextHeader.dart';
import '../components/TextNormalBolded.dart';
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
                  ...ctrl.destinationMarkers.value
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
                                    onTap: () async{
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
                                              color: Colors.grey.withOpacity(0.3),
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
                                                  text: "Filipe Lukebana",
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
                                              text: "1.300,00Kz",
                                              textColor:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextNormal(
                                                text: "2.3Km",
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
                                  Row(
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
                                            color: Colors.grey.withOpacity(0.3),
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
                                                text: "Moisés António",
                                                textColor: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextNormalTittle(
                                                text: "Exclusive",
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
                                            text: "2.300,00Kz",
                                            textColor:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextNormal(
                                              text: "2.3Km",
                                              textColor: Colors.grey)
                                        ],
                                      )
                                    ],
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
