import 'package:extended_image/extended_image.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:passit/components/TextButtonDecoratedSecondary.dart';
import 'package:passit/components/TextNormal.dart';
import 'package:passit/components/TextSmall.dart';
import 'package:passit/register/registerController.dart';
import 'package:passit/utils/constants.dart';
import 'package:unicons/unicons.dart';

import '../components/Input.dart';
import '../components/InputDouble.dart';
import '../components/TextButtonDecorated.dart';
import '../components/TextHeader.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    final ctrl = Get.put(RegisterController());
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
                SizedBox(height: 40),
                TextHeader(text: constants.texts['new_acc']),
                SizedBox(height: 10),
                TextSmall(text: constants.texts['note_reg']),
                InputDouble(
                  icons: [
                    Icon(UniconsLine.user),
                    Icon(UniconsLine.lock),
                  ],
                  labels: [
                    constants.texts['full_name'],
                    constants.texts['Password'],
                  ],
                  onChange01: (String val) {
                    ctrl.user.name = val;
                  },
                  onChange02: (String val) {
                    ctrl.user.password = val;
                  },
                ),
                Input(
                  label: 'Identity card',
                  icon: Icon(UniconsLine.card_atm),
                  onChange: (String val) {
                    ctrl.user.numberId = val;
                  },
                ),
                Input(
                  label: 'Email',
                  icon: Icon(Icons.mail_outline),
                  onChange: (String val) {
                    ctrl.user.email = val;
                  },
                ),
                Input(
                  label: 'Phone number',
                  icon: Icon(UniconsLine.phone),
                  onChange: (String val) {
                    ctrl.user.phone = val;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                ),
                TextButtonDecorated(
                  onclick: ctrl.phoneConfirmation,
                  text: constants.texts['create_acc'],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextNormal(text: constants.texts['already']),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextButtonDecoratedSecondary(
                  onclick: ctrl.login,
                  text: constants.texts['Enter'],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
