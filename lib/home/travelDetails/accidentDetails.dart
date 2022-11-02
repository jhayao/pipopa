import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:passit/firebase/firestore.dart';
import 'package:passit/home/travelDetails/driverMap/driverMap.dart';
import 'package:passit/models/locationModels.dart';
import 'package:passit/models/paymentModel.dart';
import 'package:passit/models/userModel.dart';
import 'package:passit/utils/constants.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:rating_dialog/rating_dialog.dart';
import '../../components/RouteStartEnd.dart';
import '../../map/mapController.dart';
import '../../models/travelHistoryModel.dart';
import '../../server/requests.dart';
import '../home.dart';

class AccidentDetails extends StatefulWidget {
  const AccidentDetails(
      {super.key,
      required this.travelHistory,
      required this.user,
      required this.update});

  final TravelHistoryModel travelHistory;
  final UserModel user;
  final bool update;

  @override
  State<AccidentDetails> createState() => _AccidentDetailsState();
}

class _AccidentDetailsState extends State<AccidentDetails> {
  LocationModel? start = LocationModel();

  @override
  void initState() {
    super.initState();
  }

  Future<LocationModel> setStartLocation() async {
    var cur = await MapController().determinePosition();
    if (cur != null) {
      var temp = await Requests()
          .SearchLocations2(cur.latitude.toString(), cur.longitude.toString());
      var currentLocation = LocationModel(
          address: temp.address,
          displayName: temp.displayName!,
          lat: cur.latitude.toString(),
          lon: cur.longitude.toString(),
          importance: '1');
      print("Current Location ${currentLocation.displayName}");
      return currentLocation;
    }
    return LocationModel();
  }

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    // //print(travelHistory.startPoint!.displayName);
    TravelHistoryModel hist = widget.travelHistory;

    final box = GetStorage();
    return FutureBuilder<LocationModel>(
        future: setStartLocation(),
        builder: (BuildContext context, AsyncSnapshot<LocationModel> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              start = snapshot.data;
              hist.startPoint = start;
              hist.endPoint = widget.travelHistory.currentLocation;
              print(
                  "Travel History StartPoint : ${widget.travelHistory.startPoint!.toJson()}");
              print(
                  "Travel History Endpoint : ${widget.travelHistory.endPoint!.toJson()}");
              return Stack(
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height,
                    color: Colors.grey.shade100,
                    child: DriverMapPage(travelHistory: hist),
                  ),
                  Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: Get.width,
                        height: 420,
                        child: Material(
                          color: Colors.white,
                          elevation: 20,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Accident Details",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Follow the progress of accident here",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RouteStartEnd(
                                    constants: constants,
                                    start: start,
                                    end: widget.travelHistory.currentLocation,
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      Text("Accident Status:"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Material(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green.withOpacity(0.5),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "${widget.travelHistory.status ?? ''}",
                                            style: TextStyle(
                                                color: Colors.green.shade800,
                                                fontSize: 15),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Distance",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            child: Material(
                                              elevation: 3,
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "${Constants().formatNumber(widget.travelHistory.routes?.routes[0].distance ?? 0)(',')}",
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),
                                                    Text(
                                                      "m",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                  Visibility(
                    visible: widget.user.account_type == 'cdrrmo',
                    child: Positioned(
                        bottom: 0,
                        child: Row(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: Get.width / 1.5 - 20,
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black,
                                child: InkWell(
                                  onTap: () async {
                                    await Requests().launchURL(start,
                                        widget.travelHistory.currentLocation);
                                  },
                                  child: Visibility(
                                    visible: true,
                                    // visible: true,
                                    child: Padding(
                                      padding: EdgeInsets.all(17),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Navigate",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: Get.width / 3 - 20,
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                                child: InkWell(
                                  onTap: () async {
                                    //print("travelHistory.uid ${travelHistory.status}");
                                    if (widget.travelHistory.status !=
                                        "Rescued")
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.info,
                                        animType: AnimType.bottomSlide,
                                        title: 'Confirm',
                                        desc:
                                            'Confirmed accident succesfully rescued?',
                                        btnCancelOnPress: () {},
                                        dismissOnTouchOutside: true,
                                        btnOkOnPress: () async {
                                          print(
                                              "Accident UID: ${widget.travelHistory.uid}");
                                          await Firestore()
                                              .updateEmergency(
                                                  widget.travelHistory)
                                              .then((value) => AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.success,
                                                  animType:
                                                      AnimType.bottomSlide,
                                                  title: 'Success',
                                                  desc: 'Rescued Successfully',
                                                  btnCancelOnPress: () {},
                                                  dismissOnTouchOutside: true,
                                                  btnOkOnPress: () async {},
                                                  onDismissCallback: (type) {
                                                    Get.back();
                                                  })
                                                ..show());
                                          //   await Firestore()
                                          //       .storePayments(payment: pay)
                                          //       .then((value) {
                                          //     Firestore().updateTravel2(
                                          //         uid: widget.travelHistory.uid!,
                                          //         status: 'Completed');

                                          //   });
                                        },
                                      )..show();
                                    else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.bottomSlide,
                                        title: 'Warning',
                                        desc:
                                            'This Booking was already completed',
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () {},
                                      )..show();
                                    }
                                  },
                                  child: Visibility(
                                    visible: true,
                                    // visible: true,
                                    child: Padding(
                                      padding: EdgeInsets.all(17),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Rescued",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ])),
                  ),
                ],
              );
          }
        });
  }
}
