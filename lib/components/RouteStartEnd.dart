import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passit/models/locationModels.dart';
import 'package:unicons/unicons.dart';

import '../utils/constants.dart';
import 'TextNormal.dart';
import 'TextNormalTittle.dart';

class RouteStartEnd extends StatelessWidget {
  const RouteStartEnd({
    Key? key,
    required this.constants,
    this.start,
    this.end, this.test,
  }) : super(key: key);

  final Constants constants;
  final LocationModel? start;
  final LocationModel? end;
  final bool? test;

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.black.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  backgroundColor: constants.primary2,
                ),
              ),
            ),
            Container(
              width: 2,
              height: 50,
              color: Colors.black.withOpacity(0.8),
            ),
            Icon(
              UniconsLine.location_pin_alt,
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextNormal(text: "Starting point", textColor: Colors.grey),
            Container(
              width: Get.width - 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: TextNormalTittle(
                    text: test==null ? (start?.displayName ?? "Current Location") : "Current Location" ,
                    textColor: Colors.black.withOpacity(0.8)),
              ),
            ),
            Container(
                width: Get.width - 100,
                margin: EdgeInsets.only(right: 5),
                child: Divider(
                  color: Colors.grey,
                )),
            TextNormal(text: "Destination Point", textColor: Colors.grey),
            Container(
              width: Get.width - 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: TextNormalTittle(
                    text: end?.displayName ?? "Cacuaco - Luanda - Angola",
                    textColor: Colors.black.withOpacity(0.8)),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(2),
          child: Icon(
            UniconsLine.refresh,
            color: Colors.grey,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        )
      ],
    );
  }
}
