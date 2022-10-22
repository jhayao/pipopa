import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:passit/components/PrimaryButtonDecorated.dart';
import 'package:passit/components/TextHeader.dart';
import 'package:passit/components/TextNormalBolded.dart';
import 'package:passit/models/locationModels.dart';
import 'package:passit/models/userModel.dart';
import 'package:unicons/unicons.dart';
import 'package:geolocator/geolocator.dart';
import '../components/TextNormal.dart';
import '../firebase/firestore.dart';
import '../models/routesModel.dart';
import '../models/travelHistoryModel.dart';
import '../server/requests.dart';
import '../utils/constants.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:geocoding/geocoding.dart';

class MapController extends GetxController {
  final box = GetStorage();
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
  late LocationModel temp;
  var myRoute = RoutesModel(code: '', routes: [], waypoints: []).obs;
  late LatLong.LatLng startPoint, endPoint;
  var startAddress = ''.obs, endAddress = ''.obs;
  late RxList<TravelHistoryModel> travelHistory;

  var showSugestions = false.obs;

  UserModel? user;

  Future<Position?> determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      Get.snackbar("Error determining position.",
          "Please make sure your GPS is active and your internet connection. $e",
          duration: Duration(seconds: 10), colorText: Colors.black);
      return null;
    }
  }

  void showDialog() async {
    await Future.delayed(Duration(milliseconds: 50));

    final constants = Constants();
    Get.bottomSheet(Material(
      child: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Container(
              width: Get.width,
              child: Text(
                "What's your starting point?",
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Container(
                  width: Get.width,
                  height: 40,
                  child: Material(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            onEditingComplete: () {
                              fetchWord(searchController.value.text);
                            },
                            decoration: InputDecoration(
                              hintText: "Search here...",
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(top: 5, left: 5, right: 5),
                              suffixIcon: Icon(UniconsLine.search),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: Get.width,
                  height: 200,
                  child: SingleChildScrollView(
                    child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: myLocations
                              .map((location) => Container(
                                    width: Get.width,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        long.value =
                                            double.parse(location.lon!);
                                        lat.value = double.parse(location.lat!);
                                        changeMarkerPosition(
                                            long.value,
                                            lat.value,
                                            location.displayName ?? '');
                                        startLocation = location;

                                        Get.back();
                                      },
                                      icon: Icon(Icons.location_pin),
                                      label: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          location.displayName ?? '',
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.black,
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )),
                  ),
                ),
                Container(
                  height: 40,
                  child: PrimaryButtonDecorated(
                    onclick: () async {
                      var cpos = await determinePosition();
                      if (cpos != null) {
                        long.value = cpos.longitude;
                        lat.value = cpos.latitude;
                        changeMarkerPosition(
                            cpos.longitude, cpos.latitude, 'Current position');

                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                cpos.latitude, cpos.longitude);


                        temp = await Requests().SearchLocations2(lat.value.toString(), long.value.toString());
                        // placemarks[0].

                        // print("Address : ${add.country} ${add.city}");
                        print(temp.address!.toJson());
                        startLocation = LocationModel(
                            address: temp.address,
                            displayName: temp.displayName!,
                            lat: cpos.latitude.toString(),
                            lon: cpos.longitude.toString(),
                            importance: '1');
                      } else {
                        Get.snackbar("Error determining position",
                            "Make sure your GPS is on and try again");
                      }

                      Get.back();
                    },
                    children: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "My Current Position",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    ));
  }

  void addDriversMarker() {
    try {} catch (e) {
      Get.snackbar("Error determining position.",
          "Please make sure your GPS is active and your internet connection. $e",
          duration: Duration(seconds: 10), colorText: Colors.black);
    }
  }

  void changeMarkerPosition(double _long, double _lat, String address) async {
    final constants = Constants();
    try {
      startPoint = LatLong.LatLng(_lat, _long);
      startAddress.value = address;
      var user = UserModel().obs;
      markers.value.clear();
      user.value = UserModel.fromJson(box.read("logged_user"));
      await Firestore().setRiderLocation(user.value, _long, _lat);

      markers.value.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLong.LatLng(_lat, _long),
          builder: (ctx) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CircleAvatar(
                backgroundColor: Constants().primary1.withOpacity(0.5),
                backgroundImage: NetworkImage(
                    "${(user.value.picture != null) ? user.value.picture : constants.texts['default']}"),
              ),
              Text(
                "My Location",
                style: TextStyle(fontSize: 13, color: Colors.white),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      Get.snackbar("Error determining position.",
          "Please make sure your GPS is active and your internet connection. $e",
          duration: Duration(seconds: 10), colorText: Colors.black);
    }
  }

  void setMyDestination(double _long, double _lat, String address) {
    try {
      // print("Address $address");
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
      choosen_location.value ='cxzczs';
    } catch (e) {
      Get.snackbar("Error determining position.",
          "Please make sure your GPS is active and your internet connection. $e",
          duration: Duration(seconds: 10), colorText: Colors.black);
    }
  }

  void fetchWord(String word) async {
    var res = Get.dialog(
      Container(
        width: Get.width,
        height: Get.height,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text(
                "Loading Locations...",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton.icon(
                onPressed: () {
                  if (Get.isDialogOpen ?? false) {
                    Get.back();
                  }
                },
                icon: Icon(Icons.cancel_outlined),
                label: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                    surfaceTintColor: Colors.red, foregroundColor: Colors.red),
              )
            ],
          ),
        ),
      ),
    );

    myLocations.value = await Requests().SearchLocations(word);

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void getCordinates() async {
    try {
      Get.dialog(
        Container(
          width: Get.width,
          height: Get.height,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Loading Locations",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  onPressed: () {
                    if (Get.isDialogOpen ?? false) {
                      Get.back();
                    }
                  },
                  icon: Icon(Icons.cancel_outlined),
                  label: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                      surfaceTintColor: Colors.red,
                      foregroundColor: Colors.red),
                )
              ],
            ),
          ),
        ),
      );

      var res = await Requests().GetRoutes(startPoint, endPoint);
      myRoute.value = res;

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (res.routes.isNotEmpty) {
        List<PointLatLng> result =
            PolylinePoints().decodePolyline(res.routes[0].geometry);

        final points =
            result.map((e) => LatLong.LatLng(e.latitude, e.longitude)).toList();

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
    } catch (e) {
      Get.snackbar("Error determining position.",
          "Please make sure your GPS is active and your internet connection. ",
          duration: Duration(seconds: 10), colorText: Colors.black);
    }
  }

  void showTransportationDetails() async {
    Get.dialog(Center(
        child: Container(
      height: 400,
      width: Get.width - 10,
      padding: EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHeader(
                  text: "Confirm Book Details",
                  textColor: Colors.black,
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Starting point:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        startAddress.value,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Destination:",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        endAddress.value,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      "Distance: ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      Constants().formatNumber(
                              myRoute.value.routes[0].distance)(',') +
                          " Kilometer",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Duration: ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      (myRoute.value.routes[0].duration / 30)
                              .round()
                              .toString() +
                          ' Minutes',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  width: Get.width,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextNormal(
                            text: "Cancel",
                            textColor: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: PrimaryButtonDecorated(
                            onclick: confirmTravel,
                            children: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextNormal(
                                  text: "Confirm book",
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
    )));
  }

  void confirmTravel() {
    travelHistory.value.insert(
        0,
        TravelHistoryModel(
            createdAt: DateTime.now().toIso8601String(),
            passenger: user,
            startPoint: startLocation,
            endPoint: endLocation,
            routes: myRoute.value,
            status: "Pending Ride"));
    // print("Travel History : ${travelHistory.value.first.status}");
    Get.back();
    Get.back();
  }

  @override
  void onInit() async {
    super.onInit();

    final box = GetStorage();
    user = UserModel.fromJson(box.read("logged_user"));

    travelHistory = Get.arguments[0] as RxList<TravelHistoryModel>;
    showDialog();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    dispose();
  }
}
