import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:passit/home/homeController.dart';

import '../../components/PrimaryMainButtonDecorated.dart';
import '../../components/RouteStartEnd.dart';
import '../../components/TextNormal.dart';
import '../../utils/constants.dart';

class MyLocationsView extends StatelessWidget {
  const MyLocationsView({Key? key, required this.controller}) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
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
            TextNormal(text: "My favorite locations:", textColor: Colors.grey),
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
          ],
        ),
      ),
    );
  }
}
