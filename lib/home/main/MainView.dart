import 'dart:convert';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passit/home/homeController.dart';
import 'package:passit/home/travelDetails/accidentDetails.dart';
import 'package:passit/home/travelDetails/travelDetails.dart';
import 'package:passit/map/mapPage.dart';
import 'package:passit/models/travelHistoryModel.dart';
import 'package:provider/provider.dart%20';

import '../../components/PrimaryMainButtonDecorated.dart';
import '../../components/RouteStartEnd.dart';
import '../../components/TextHeader.dart';
import '../../components/TextNormal.dart';
import '../../components/TextNormalBolded.dart';
import '../../components/TextNormalTittle.dart';
import '../../firebase/firestore.dart';
import '../../map/mapController.dart';
import '../../models/locationModels.dart';
import '../../models/userModel.dart';
import '../../server/requests.dart';
import '../../utils/LocationService.dart';
import '../../utils/constants.dart';
import '../myLocations/myLocationsView.dart';

class MainView extends StatelessWidget {
  const MainView(
      {Key? key,
      this.datas,
      required this.constants,
      required this.travelHistory,
      required this.ctrl,
      required this.user,
      required this.uid})
      : super(key: key);

  final Constants constants;
  final RxList<TravelHistoryModel> travelHistory;
  final HomeController ctrl;
  final UserModel user;
  final String uid;
  final String? datas;

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    // ////print(user.id);
    var userLocation = Provider.of<UserLocation>(context);
    print("UserLcoaton Provider : ${userLocation.longitude}");
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Obx((() => Container(
            key: Key("locations_list_${travelHistory.length}"),
            color: Colors.grey.shade200,
            padding: EdgeInsets.all(10),
            width: Get.width,
            child: Column(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: user.account_type == 'Passenger',
                      child: PrimaryMainButtonDecorated(
                        onclick: () async {
                          ctrl.openMap();
                        },
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextNormal(
                    text:
                        "${user.account_type == 'cdrrmo' ? "Active Accidents" : ' Booking:'}",
                    textColor: Colors.grey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              user.account_type == 'Driver'
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('travel_history')
                          .where('driver', isNull: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('No Data');
                        } else {
                          // print(snapshot.data!.docs.);

                          return Column(
                            children: snapshot.data!.docs.map((e) {
                              TravelHistoryModel history =
                              TravelHistoryModel.fromRawJson(
                                  jsonEncode(e.data()));
                              print("history ${history.startPoint!.lon} , ${history.startPoint!.lat}");
                              print("Current Location :${userLocation.latitude} , ${userLocation.longitude}");


                              // String distance = calculateDistance(userLocation.latitude!.toDouble(), userLocation.longitude!.toDouble(), history.startPoint!.lat!, history.startPoint!.lon).toString();
                              double distance = calculateDistance(userLocation.latitude!.toDouble(), userLocation.longitude!.toDouble(),double.parse(history.startPoint!.lat!) , double.parse(history.startPoint!.lon!));
                              print("Calculated Distance: ${calculateDistance(userLocation.latitude!.toDouble(), userLocation.longitude!.toDouble(),double.parse(history.startPoint!.lat!) , double.parse(history.startPoint!.lon!)).toString()}");
                              return Visibility(
                                visible: distance<=0.2,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: OpenContainer(
                                    closedBuilder: (context, action) {


                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 2),
                                        width: Get.width,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextNormalTittle(
                                                text:
                                                    "Book Information - ${history.createdAt?.split('T')[0]} ${history.createdAt?.split('T')[1].split('.')[0]}",
                                                textColor: constants.primary2,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Visibility(
                                                    visible:
                                                        history.driver != null,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          margin: EdgeInsets.only(
                                                              right: 5),
                                                          child: ExtendedImage
                                                              .network(
                                                                  "https://images.pexels.com/photos/428361/pexels-photo-428361.jpeg?auto=compress&cs=tinysrgb&w=600",
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            TextNormalBolded(
                                                              text: history.driver
                                                                      ?.name ??
                                                                  '',
                                                              textColor: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            TextNormal(
                                                              text:
                                                                  "Proffesional",
                                                              textColor: constants
                                                                  .primary2,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                      ),
                                                      child: Text(
                                                          "${history.status}"),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      TextHeader(
                                                        text:
                                                            "${Constants().formatNumber(history.routes?.routes[0].distance ?? 0)(',')}",
                                                        textColor: Colors.black
                                                            .withOpacity(0.8),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextNormal(
                                                          text:
                                                              "${Constants().formatNumber(history.routes?.routes[0].distance ?? 0)(',')} KM",
                                                          textColor: Colors.grey)
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              RouteStartEnd(
                                                constants: constants,
                                                start: history.startPoint,
                                                end: history.endPoint,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    openBuilder: (context, action) {
                                      TravelHistoryModel travel =
                                          TravelHistoryModel.fromRawJson(
                                              jsonEncode(e.data()));
                                      travel.uid = e.id;
                                      final box = GetStorage();
                                      String updateDetails =
                                          box.read('travelDetails') == null
                                              ? 'false'
                                              : box.read('travelDetails');

                                      Firestore()
                                          .updateTravel(
                                              userModel: user,
                                              uid: e.id,
                                              status: 'The driver is on the way')
                                          .then((value) => null);
                                      return TravelDetails(
                                        user: user,
                                        catchs: true,
                                        update: true,
                                        travelHistory: travel,
                                      );
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      })
                  : user.account_type == 'Passenger'
                      ? StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('travel_history')
                              .where('passenger.id', isEqualTo: user.id)
                              .where('status', isNotEqualTo: 'Completed')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text('No Data');
                            } else {
                              ////print(snapshot.data!.docs.length);
                              showNotifications();
                              return Column(
                                children: snapshot.data!.docs
                                    .map((e) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: OpenContainer(
                                            closedBuilder: (context, action) {
                                              TravelHistoryModel history =
                                                  TravelHistoryModel
                                                      .fromRawJson(
                                                          jsonEncode(e.data()));

                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 2),
                                                width: Get.width,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextNormalTittle(
                                                        text:
                                                            "Book Information - ${history.createdAt?.split('T')[0]} ${history.createdAt?.split('T')[1].split('.')[0]}",
                                                        textColor:
                                                            constants.primary2,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Visibility(
                                                            visible: history
                                                                    .driver !=
                                                                null,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              5),
                                                                  child: ExtendedImage.network(
                                                                      (history.driver == null ||
                                                                              history.driver!.picture ==
                                                                                  null)
                                                                          ? "https://images.pexels.com/photos/428361/pexels-photo-428361.jpeg?auto=compress&cs=tinysrgb&w=600"
                                                                          : history
                                                                              .driver!
                                                                              .picture!,
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    TextNormalBolded(
                                                                      text: history
                                                                              .driver
                                                                              ?.name ??
                                                                          '',
                                                                      textColor: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.8),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextNormal(
                                                                      text: history.driver != null &&
                                                                              history.driver!.plate != null
                                                                          ? "Plate number: ${history.driver!.plate!}"
                                                                          : 'aaa',
                                                                      textColor:
                                                                          constants
                                                                              .primary2,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextNormal(
                                                                      text: history.driver != null &&
                                                                              history.driver!.phone != null
                                                                          ? "Phone: ${history.driver!.phone!}"
                                                                          : 'aaa',
                                                                      textColor:
                                                                          constants
                                                                              .primary2,
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Visibility(
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5,
                                                                      horizontal:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Text(
                                                                  "${history.status!.length > 12 ? history.status!.substring(0, 12) + '....' : history.status!}"),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              TextHeader(
                                                                text:
                                                                    "${Constants().formatNumber(history.routes?.routes[0].distance ?? 0)(',')}",
                                                                textColor: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.8),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              TextNormal(
                                                                  text:
                                                                      "${Constants().formatNumber(history.routes?.routes[0].distance ?? 0)(',')} KM",
                                                                  textColor:
                                                                      Colors
                                                                          .grey)
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      RouteStartEnd(
                                                        constants: constants,
                                                        start:
                                                            history.startPoint,
                                                        end: history.endPoint,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      user.account_type ==
                                                              'Driver'
                                                          ? Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 8,
                                                                  child:
                                                                      SizedBox(
                                                                    child:
                                                                        Material(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                      elevation:
                                                                          0,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          ctrl.favTravelHistory
                                                                              .add(history);

                                                                          ctrl.currentTab.value =
                                                                              1;

                                                                          ctrl.save();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 10,
                                                                              vertical: 10),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.green,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text(
                                                                                "Pick up passenger",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                // Expanded( flex : 1,child: SizedBox( width: 10,)),
                                                              ],
                                                            )
                                                          : SizedBox.shrink()
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            openBuilder: (context, action) {
                                              TravelHistoryModel travel =
                                                  TravelHistoryModel
                                                      .fromRawJson(
                                                          jsonEncode(e.data()));
                                              travel.uid = e.id;
                                              //print("UID: ${e.id}");
                                              return TravelDetails(
                                                user: user,
                                                update: false,
                                                travelHistory: travel,
                                                catchs: true,
                                              );
                                            },
                                          ),
                                        ))
                                    .toList(),
                              );
                            }
                          })
                      : StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('accidents')
                              .where('status', isEqualTo: 'Active')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text('No Data');
                            } else {
                              ////print(snapshot.data!.docs.length);
                              return Column(
                                children: snapshot.data!.docs
                                    .map((e) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: OpenContainer(
                                            closedBuilder: (context, action) {
                                              TravelHistoryModel history =
                                                  TravelHistoryModel
                                                      .fromRawJson(
                                                          jsonEncode(e.data()));
                                              //print(history.currentLocation!.displayName);
                                              LocationModel cur =
                                                  LocationModel.fromJson(
                                                      e.get('currentLocation'));

                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 2),
                                                width: Get.width,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextNormalTittle(
                                                        text:
                                                            "Accident Information - ${history.createdAt?.split('T')[0]}",
                                                        textColor:
                                                            constants.primary2,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Visibility(
                                                            visible: history
                                                                    .driver !=
                                                                null,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              5),
                                                                  child: ExtendedImage.network(
                                                                      "https://e7.pngegg.com/pngimages/361/318/png-clipart-traffic-collision-bicycle-accident-bicycle-car-accident-car-accident-fitness.png",
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Visibility(
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5,
                                                                      horizontal:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Text(
                                                                  "${history.status!.length > 12 ? history.status!.substring(0, 12) + '....' : history.status}"),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              TextHeader(
                                                                text:
                                                                    "${Constants().formatNumber(history.routes?.routes[0].distance ?? 0)(',')}",
                                                                textColor: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.8),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              TextNormal(
                                                                  text:
                                                                      "${Constants().formatNumber(history.routes?.routes[0].distance ?? 0)(',')} KM",
                                                                  textColor:
                                                                      Colors
                                                                          .grey)
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      RouteStartEnd(
                                                        test: true,
                                                        constants: constants,
                                                        start:
                                                            history.startPoint,
                                                        end: cur,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            openBuilder: (context, action) {
                                              TravelHistoryModel travel =
                                                  TravelHistoryModel
                                                      .fromRawJson(
                                                          jsonEncode(e.data()));

                                              // //print("Travel Details start: ${travel.startPoint}");
                                              travel.uid = e.id;
                                              travel.endPoint =
                                                  LocationModel.fromJson(
                                                      e.get('currentLocation'));

                                              return AccidentDetails(
                                                  user: user,
                                                  update: false,
                                                  travelHistory: travel);
                                            },
                                          ),
                                        ))
                                    .toList(),
                              );
                            }
                          }),
            ]),
          ))),
    );
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    print("lat 1 : $lat1 , lat 2: $lat2");
    print("long 1 : $lon1 , long 2: $lon2");
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
  void showNotifications() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        category: NotificationCategory.Promo,
        title: 'Hello Po',
        body:
        'This month, we have reduced prices for our races. Now it''s all free!!',
      ),
      schedule: NotificationCalendar.fromDate(
        date: DateTime.now().add(
          Duration(seconds: 6),
        ),
      ),
    );
  }
}
