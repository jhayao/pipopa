import 'package:flutter/material.dart';

import '../utils/constants.dart';

class TextSmall extends StatelessWidget {
  const TextSmall({
    Key? key,
    required this.text,
    this.textColor,
  }) : super(key: key);

  final String text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    return Text(
      text,
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: constants.textSm,
      ),
    );
  }
}
