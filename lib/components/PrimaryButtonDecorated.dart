import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

class PrimaryButtonDecorated extends StatelessWidget {
  const PrimaryButtonDecorated({
    Key? key,
    required this.onclick,
    required this.children,
  }) : super(key: key);

  final Function onclick;
  final Widget children;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();

    return SizedBox(
      height: 53,
      child: TextButton(
        onPressed: () {
          onclick();
        },
        child: children,
        style: TextButton.styleFrom(
          backgroundColor: constants.primary1,
          side: BorderSide(
            color: constants.primary1,
          ),
        ),
      ),
    );
  }
}
