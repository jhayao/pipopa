import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passit/components/TextSmall.dart';
import 'package:passit/phone_confirmation/phoneConfirmationController.dart';
import 'package:passit/utils/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../components/TextButtonDecorated.dart';
import '../components/TextHeader.dart';

class PhoneConfirmationPage extends StatelessWidget {
  const PhoneConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    final ctrl = Get.put(PhoneConfirmationController());
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          gradient: constants.backgroundGradient,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ExtendedImage.asset(
                      constants.logoImage,
                      width: 200,
                    ),
                  ],
                ),
                SizedBox(height: 70),
                TextHeader(text: constants.texts['code']),
                SizedBox(height: 10),
                TextSmall(text: constants.texts['note_phone']),
                SizedBox(height: 50),
                PinCodeTextField(
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  obscureText: false,
                  obscuringCharacter: '*',
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                    errorBorderColor: Colors.cyanAccent,
                    activeColor: Colors.white,
                    disabledColor: Colors.white,
                    inactiveColor: Colors.white,
                    inactiveFillColor: Colors.white.withOpacity(0.8),
                    selectedColor: Colors.white.withOpacity(0.8),
                    selectedFillColor: Colors.white.withOpacity(0.8),
                  ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  textStyle: TextStyle(fontSize: 20, height: 1.6),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  appContext: context,
                  onChanged: (String value) {
                    ctrl.code.value = value;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                TextButtonDecorated(
                  onclick: ctrl.validate,
                  text: constants.texts['confirm'],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
