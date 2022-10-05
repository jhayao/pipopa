import 'package:flutter/material.dart';

import '../utils/constants.dart';

class TextNormalTittle extends StatelessWidget {
  const TextNormalTittle({
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
        fontSize: constants.textNormal + 2,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
