import 'package:flutter/material.dart';

import '../utils/constants.dart';

class TextHeaderBolded extends StatelessWidget {
  const TextHeaderBolded({
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
        fontSize: constants.textXl,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
