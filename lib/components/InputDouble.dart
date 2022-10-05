import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../utils/constants.dart';

class InputDouble extends StatelessWidget {
  const InputDouble({
    Key? key,
    required this.icons,
    required this.labels,
    this.onChange01,
    this.onChange02,
  }) : super(key: key);

  final List<Icon> icons;
  final List<String> labels;
  final Function? onChange01;
  final Function? onChange02;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: constants.radousNormal,
      ),
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              icon: icons[0],
              hintText: labels[0],
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.name,
            onChanged: (val) {
              if (onChange01 != null) {
                onChange01!(val);
              }
            },
          ),
          Divider(
            height: 1,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              icon: icons[1],
              hintText: labels[1],
              border: InputBorder.none,
            ),
            onChanged: (val) {
              if (onChange02 != null) {
                onChange02!(val);
              }
            },
          ),
        ],
      ),
    );
  }
}
