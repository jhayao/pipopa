import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../utils/constants.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
    required this.icon,
    required this.label,
    this.onChange, required this.widthSize,
  }) : super(key: key);

  final Icon icon;
  final String label;
  final Function? onChange;
  final int widthSize;
  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: constants.radousNormal,
      ),
      width: Get.width/widthSize,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              icon: icon,
              hintText: label,
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.name,
            onChanged: (val) {
              if (onChange != null) onChange!(val);
            },
          ),

        ],
      ),
    );
  }
}
