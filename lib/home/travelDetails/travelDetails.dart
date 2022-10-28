import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:passit/firebase/firestore.dart';
import 'package:passit/home/travelDetails/driverMap/driverMap.dart';
import 'package:passit/models/locationModels.dart';
import 'package:passit/models/userModel.dart';
import 'package:passit/utils/constants.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import '../../components/RouteStartEnd.dart';
import '../../map/mapController.dart';
import '../../models/travelHistoryModel.dart';
import '../../server/requests.dart';

class TravelDetails extends StatelessWidget {
  const TravelDetails(
      {super.key, required this.travelHistory, required this.user});

  final TravelHistoryModel travelHistory;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    // print(travelHistory.startPoint!.displayName);
    return Stack(
      children: [
        Container(
          width: Get.width,
          height: Get.height,
          color: Colors.grey.shade100,
          child: DriverMapPage(travelHistory: travelHistory),
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
                          "Your booking",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Follow the progress of your ride here",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RouteStartEnd(
                          constants: constants,
                          start: travelHistory.startPoint,
                          end: travelHistory.endPoint,
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text("Ride Status:"),
                            SizedBox(
                              width: 10,
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green.withOpacity(0.5),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "${travelHistory.status}",
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Distance",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  child: Material(
                                    elevation: 3,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${Constants().formatNumber(travelHistory.routes?.routes[0].distance ?? 0)(',')}",
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                            ),
                                          ),
                                          Text(
                                            "m",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Amount to be paid",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  child: Material(
                                    elevation: 3,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "100 ",
                                            style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(0.8)),
                                          ),
                                          Text(
                                            "PHP",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
        Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: Get.width - 20,
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  child: InkWell(
                    onTap: () async {
                      await Requests().launchURL(
                          travelHistory.startPoint, travelHistory.endPoint);
                    },
                    child: Visibility(
                      visible: user.account_type == 'Passenger' &&
                              travelHistory.status != 'Pending Ride'
                          ? false
                          : true,
                      // visible: true,
                      child: Padding(
                        padding: EdgeInsets.all(17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${user.account_type == 'Driver' ? 'Navigate' : 'Cancel booking'}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
        Positioned(
            top: (Get.height / 2) - 100,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                var cur = await MapController().determinePosition();
                if (cur != null) {
                  print(cur.latitude.toString());
                  var temp = await Requests().SearchLocations2(
                      cur.latitude.toString(), cur.longitude.toString());
                  // print("Temp ${temp.displayName}");
                  var currentLocation = LocationModel(
                      address: temp.address,
                      displayName: temp.displayName!,
                      lat: cur.latitude.toString(),
                      lon: cur.longitude.toString(),
                      importance: '1');
                  travelHistory.currentLocation = currentLocation;
                  // print(travelHistory.currentLocation!.displayName);
                  await Firestore().setEmergency(travelHistory);
                }

                // travelHistory.currentLocation =
                //
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.sos),
            )),

      ],
    );
  }
}
