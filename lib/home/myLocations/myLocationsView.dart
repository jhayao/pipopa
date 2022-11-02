import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:passit/home/homeController.dart';
import 'package:passit/models/userModel.dart';

import '../../components/PrimaryMainButtonDecorated.dart';
import '../../components/RouteStartEnd.dart';
import '../../components/TextHeader.dart';
import '../../components/TextNormal.dart';
import '../../components/TextNormalBolded.dart';
import '../../components/TextNormalTittle.dart';
import '../../models/travelHistoryModel.dart';
import '../../utils/constants.dart';
import '../travelDetails/travelDetails.dart';

class MyLocationsView extends StatelessWidget {
  const MyLocationsView(
      {Key? key, required this.controller, required this.user})
      : super(key: key);

  final HomeController controller;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    //print(user.id);
    final constants = Constants();
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey.shade200,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PrimaryMainButtonDecorated(),
            SizedBox(
              height: 20,
            ),
            user.account_type == 'Driver'
                ? TextNormal(text: "Travel Logs:", textColor: Colors.grey)
                : TextNormal(
                    text: "Travel Logs:", textColor: Colors.grey),
            SizedBox(
              height: 20,
            ),
            ...controller.favTravelHistory.map((history) {
              return Container(
                width: Get.width,
                margin: EdgeInsets.only(bottom: 10),
                child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {},
                          child: RouteStartEnd(
                            constants: constants,
                            start: history.startPoint,
                            end: history.endPoint,
                          )),
                    )),
              );
            }).toList(),

            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('travel_history')
                    .where('driver.id', isEqualTo: user.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("test");
                  } else {
                    //print(snapshot.data!.docs.length);
                    return Column(
                      children: snapshot.data!.docs
                          .map((e) => Padding(
                        padding:
                        const EdgeInsets.only(bottom: 10),
                        child: OpenContainer(
                          closedBuilder: (context, action) {
                            TravelHistoryModel history =
                            TravelHistoryModel.fromRawJson(
                                jsonEncode(e.data()));
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 2),
                              width: Get.width,
                              child: Padding(
                                padding:
                                const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
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
                                          visible:
                                          history.driver !=
                                              null,
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                color: Colors.grey
                                                    .withOpacity(
                                                    0.3),
                                                margin: EdgeInsets
                                                    .only(
                                                    right: 5),
                                                // child: ExtendedImage.network(
                                                //     (history.driver ==
                                                //         null &&
                                                //         history.driver!.picture.isNull)
                                                //         ? "https://images.pexels.com/photos/428361/pexels-photo-428361.jpeg?auto=compress&cs=tinysrgb&w=600"
                                                //         : history
                                                //         .driver!
                                                //         .picture!,
                                                //     fit: BoxFit
                                                //         .cover),
                                                child: ExtendedImage.network(history.driver!.picture ?? 'https://images.pexels.com/photos/428361/pexels-photo-428361.jpeg?auto=compress&cs=tinysrgb&w=600'),
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
                                                        'ad',
                                                    textColor: Colors
                                                        .black
                                                        .withOpacity(
                                                        0.8),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextNormal(
                                                    text: history.driver!.plate != null ?
                                                    "Plate number: ${history.driver!.plate!}" : '',
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
                                                vertical: 5,
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
                                                "${history.status!.length>=12? history.status!.substring(0, 12) + '....' :history.status }"),
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
                                                Colors.grey)
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
                                    user.account_type == 'Diver'
                                        ? Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: SizedBox(
                                            child: Material(
                                              color: Theme.of(
                                                  context)
                                                  .primaryColor
                                                  .withOpacity(
                                                  0.5),
                                              elevation: 0,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  5),
                                              child:
                                              InkWell(
                                                onTap: () {

                                                },
                                                child:
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      10),
                                                  child:
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                        Colors.green,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                        10,
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
                            TravelHistoryModel.fromRawJson(
                                jsonEncode(e.data()));
                                travel.uid = e.id;
                            return TravelDetails(
                                user: user,
                                update: false,
                                travelHistory: travel
                            );
                          },
                        ),
                      ))
                          .toList(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
