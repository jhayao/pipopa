import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

class TextButtonDecorated extends StatelessWidget {
  const TextButtonDecorated(
      {Key? key, required this.onclick, required this.text, this.disabled})
      : super(key: key);

  final Function onclick;
  final String text;
  final bool? disabled;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();

    return SizedBox(
      width: Get.width,
      height: 50,
      child: TextButton(
        onPressed: () {
          if (disabled == null || disabled == false) onclick();
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
          backgroundColor: constants.btnPrimary
              .withOpacity((disabled == true || disabled == null) ? 1 : 0.5),
          side: BorderSide(
            color: constants.btnPrimary,
          ),
        ),
      ),
    );
  }
}
