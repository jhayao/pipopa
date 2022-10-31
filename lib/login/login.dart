import 'package:animate_do/animate_do.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:passit/components/TextButtonDecoratedSecondary.dart';
import 'package:passit/components/TextNormal.dart';
import 'package:passit/components/TextSmall.dart';
import 'package:passit/models/userModel.dart';
import 'package:passit/utils/constants.dart';
import 'package:unicons/unicons.dart';

import '../components/InputDouble.dart';
import '../components/TextButtonDecorated.dart';
import '../components/TextHeader.dart';
import 'loginController.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(LoginController());
    final constants = Constants();
    final box = GetStorage();
    // //print("Logged User: ${box.read("logged_user")}");

    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          gradient: constants.backgroundGradient,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ExtendedImage.asset(
                      constants.logoImage,
                      width: 200,
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                TextHeader(text: constants.texts['login']),
                const SizedBox(height: 10),
                TextSmall(text: constants.texts['note_login']),
                InputDouble(
                  icons: const [
                    Icon(UniconsLine.user),
                    Icon(UniconsLine.lock),
                  ],
                  labels: [
                    "Email Address",
                    constants.texts['Password'],
                  ],
                  onChange01: (val) {
                    ctrl.nome = val;
                  },
                  onChange02: (val) {
                    ctrl.Password = val;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Stack(
                  children: [
                    Obx(() => TextButtonDecorated(
                          onclick: ctrl.login,
                          text: constants.texts['Enter'],
                          disabled: ctrl.logginIn.value,
                        )),
                    Positioned(
                      top: 7,
                      left: 20,
                      child: Obx(() => Visibility(
                            visible: ctrl.logginIn.value,
                            child: ZoomIn(
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 4,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextNormal(text: constants.texts['no_acc']),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButtonDecoratedSecondary(
                  onclick: ctrl.newAccount,
                  text: constants.texts['create_new'],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
