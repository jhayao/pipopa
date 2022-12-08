import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passit/map/mapPage.dart';
import 'package:unicons/unicons.dart';

import 'PrimaryButtonDecorated.dart';
import 'TextHeader.dart';
import 'TextSmall.dart';

class ReportButtonDecorated extends StatelessWidget {
  const ReportButtonDecorated({
    Key? key,
    this.onclick,
  }) : super(key: key);

  final Function? onclick;

  @override
  Widget build(BuildContext context) {
    return PrimaryButtonDecorated(
        onclick: () {
          if (onclick != null) onclick!();
        },
        children: Container(
          width: Get.width,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextSmall(text: "Booking"),
                  TextHeader(text: "Reports"),
                ],
              ),
              Icon(
                UniconsLine.arrow_circle_right,
                color: Colors.white,
              )
            ],
          ),
        ));
  }
}
