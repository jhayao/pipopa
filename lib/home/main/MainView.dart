import 'package:animations/animations.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passit/home/homeController.dart';
import 'package:passit/home/travelDetails/travelDetails.dart';
import 'package:passit/map/mapPage.dart';
import 'package:passit/models/travelHistoryModel.dart';

import '../../components/PrimaryMainButtonDecorated.dart';
import '../../components/RouteStartEnd.dart';
import '../../components/TextHeader.dart';
import '../../components/TextNormal.dart';
import '../../components/TextNormalBolded.dart';
import '../../components/TextNormalTittle.dart';
import '../../utils/constants.dart';

class MainView extends StatelessWidget {
  const MainView({
    Key? key,
    required this.constants,
    required this.travelHistory,
    required this.ctrl,
  }) : super(key: key);

  final Constants constants;
  final RxList<TravelHistoryModel> travelHistory;
  final HomeController ctrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Obx((() => Container(
            key: Key("locations_list_${travelHistory.length}"),
            color: Colors.grey.shade200,
            padding: EdgeInsets.all(10),
            width: Get.width,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryMainButtonDecorated(
                      onclick: () async {
                        ctrl.openMap();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextNormal(
                        text: "Booking History:", textColor: Colors.grey),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Visibility(
                    visible: travelHistory.value.isEmpty,
                    child: Text(
                      "No Booking active 😅",
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: constants.primary1),
                    )),
                Obx(() => Column(
                      children: travelHistory
                          .map((history) => Padding(
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
                                                  "Book Information - ${history.createdAt?.split('T')[0]}",
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
                                                        "Pending Ride"),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    TextHeader(
                                                      text: "${Constants().formatNumber(history.routes?.routes[0].distance ?? 0)(',')}",
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
                                            SizedBox(
                                              child: Material(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.5),
                                                elevation: 0,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: InkWell(
                                                  onTap: () {
                                                    ctrl.favTravelHistory
                                                        .add(history);

                                                    ctrl.currentTab.value = 1;

                                                    ctrl.save();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 10),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.green,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "Add to my locations",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  openBuilder: (context, action) {
                                    return TravelDetails(
                                      travelHistory: history,
                                    );
                                  },
                                ),
                              ))
                          .toList(),
                    ))
              ],
            ),
          ))),
    );
  }
}
