import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:passit/components/TextHeader.dart';
import 'package:passit/components/TextNormal.dart';
import 'package:passit/components/TextNormalTittle.dart';
import 'package:passit/models/userModel.dart';
import 'package:unicons/unicons.dart';

import '../../utils/constants.dart';
import 'package:passit/firebase/auth.dart';
import 'package:passit/login/login.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: Get.width,
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: Get.width,
                    height: 100,
                    color: constants.primary1,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.3),
                          radius: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(text: user.name ?? ''),
                            SizedBox(
                              height: 5,
                            ),
                            TextNormal(text: "250 - Viagens com Passit")
                          ],
                        )
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextNormal(
                          text: "Phone number",
                          textColor: Colors.grey,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(UniconsLine.phone),
                            SizedBox(width: 5),
                            TextNormalTittle(
                              text: user.phone ?? '',
                              textColor: Colors.black,
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        TextNormal(
                          text: "Email",
                          textColor: Colors.grey,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.mail_outline),
                            SizedBox(width: 5),
                            TextNormalTittle(
                              text: user.email ?? '',
                              textColor: Colors.black,
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        TextNormal(
                          text: "Identity card",
                          textColor: Colors.grey,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(UniconsLine.user_square),
                            SizedBox(width: 5),
                            TextNormalTittle(
                              text: user.numberId ?? '',
                              textColor: Colors.black,
                            )
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            width: Get.width,
            child: TextButton.icon(
              onPressed: () async {
                await Auth().signOut();
                if (Auth().currentuser == null) {
                  Get.to(LoginPage());
                } else {}
              },
              icon: Icon(
                UniconsLine.trash,
                color: Colors.white,
              ),
              label: Text(
                'delete account',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade400,
              ),
            ),
          ),
        )
      ],
    );
  }
}
