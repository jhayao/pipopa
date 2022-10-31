import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:unicons/unicons.dart';

import '../utils/constants.dart';

class InputPhone extends StatelessWidget {
  const InputPhone({
    Key? key,
    required this.icon,
    required this.label,
    this.onChange,
    required this.widthSize,
  }) : super(key: key);

  final Icon icon;
  final String label;
  final Function? onChange;
  final int widthSize;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    String initialCountry = 'PH';
    final TextEditingController controller = TextEditingController();
    PhoneNumber number = PhoneNumber(isoCode: 'PH');
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: constants.radousNormal,
      ),
      width: Get.width / widthSize,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              print(number.phoneNumber);
              if (onChange != null) onChange!(number.phoneNumber);
            },
            onInputValidated: (bool value) {
              print(value);
            },
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle: TextStyle(color: Colors.black),
            initialValue: number,
            textFieldController: controller,
            formatInput: false,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            inputBorder: OutlineInputBorder(),
            onSaved: (PhoneNumber number) {
              print('On Saved: $number');
            },
          ),
        ],
      ),
    );
  }
}
