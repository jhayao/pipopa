import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:passit/components/TextButtonDecoratedSecondary.dart';
import 'package:passit/components/TextNormal.dart';
import 'package:passit/components/TextSmall.dart';
import 'package:passit/register/registerController.dart';
import 'package:passit/utils/constants.dart';
import 'package:unicons/unicons.dart';

import '../components/Input.dart';
import '../components/InputDouble.dart';
import '../components/Phone.dart';
import '../components/TextButtonDecorated.dart';
import '../components/TextHeader.dart';
import '../components/dropdown.dart';
import '../components/multipleInput.dart';
import '../models/userModel.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    final ctrl = Get.put(RegisterController());
    var type = UserModel().obs;
    var ident = "Identity card".obs;
    var _status = ["Driver", "Passenger","Cdrrmo"];

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
                SizedBox(height: 10),
                TextHeader(text: "Account Type"),
                Obx(() => RadioGroup<String>.builder(
                      groupValue: type.value.account_type == null
                          ? 'Driver'
                          : type.value.account_type!,
                      horizontalAlignment: MainAxisAlignment.spaceAround,
                      onChanged: (value) {
                        ctrl.user.account_type = value;
                        type.value.account_type = value;
                        print("ctrl.user");
                        if (value == 'Driver') {
                          type.value.label = "Plate number";
                        } else {
                          type.value.label = "Identity card";
                        }
                        // ////print(type.value.account_type );
                        type.update((val) {});
                      },
                      items: _status,
                      itemBuilder: (item) => RadioButtonBuilder(item),
                    )),
                MultipleInput(
                  label1: 'Firstname',
                  icon1: Icon(UniconsLine.user),
                  onChange1: (String val) {
                    ctrl.user.fname = val;
                  },
                  label2: 'Lastname',
                  icon2: Icon(UniconsLine.user),
                  onChange2: (String val) {
                    ctrl.user.lname = val;
                  },
                  label3: 'MI',
                  onChange3: (String val) {
                    ctrl.user.mname = val;
                  },
                ),
                InputDouble(
                  icons: [
                    Icon(Icons.mail_outline),
                    Icon(UniconsLine.lock),
                  ],
                  labels: [
                    'Email',
                    constants.texts['Password'],
                  ],
                  onChange01: (String val) {
                    ctrl.user.email = val;
                  },
                  onChange02: (String val) {
                    ctrl.user.password = val;
                  },
                ),
                Obx(() => Visibility(
                  visible: type.value.label == null || type.value.label == 'Plate number',
                  child: Input(
                        widthSize: 1,
                        label: type.value.label == null
                            ? "Plate number"
                            : type.value.label!,
                        icon: Icon((type.value.label == null ||
                                type.value.label == 'Plate number')
                            ? UniconsLine.car
                            : UniconsLine.card_atm),
                        onChange: (String val) {
                          if (type.value.label == null ||
                              type.value.label == 'Plate number') {
                            ctrl.user.account_type = 'Driver';
                            ctrl.user.plate = val;
                          } else {
                            ctrl.user.numberId = val;
                            ctrl.user.account_type = 'Passenger';
                          }
                        },
                      ),
                )),

                Dropdown(
                  widthSize: 1,
                  label: 'DropDon',
                  icon: Icon(Icons.mail_outline),
                  onChange: (String val) {
                    ctrl.user.gender = val;
                  },
                  label2: 'DropDon',
                  icon2: Icon(Icons.mail_outline),
                  onChange2: (String val) {
                    ctrl.user.bdate = val;
                  },
                ),
                InputPhone(
                  widthSize: 1,
                  label: 'Email',
                  icon: Icon(Icons.mail_outline),
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
                  // onclick: () {//print(ctrl.user.toJson());},
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
