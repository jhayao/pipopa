import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

class TextButtonDecoratedSecondary extends StatelessWidget {
  const TextButtonDecoratedSecondary({
    Key? key,
    required this.onclick,
    required this.text,
  }) : super(key: key);

  final Function onclick;
  final String text;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();

    return SizedBox(
      width: Get.width,
      height: 50,
      child: TextButton(
        onPressed: () {
          onclick();
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 176, 8, 189),
          side: BorderSide(
            color: Color.fromARGB(255, 113, 32, 120),
          ),
        ),
      ),
    );
  }
}
