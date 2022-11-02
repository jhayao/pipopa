import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:passit/components/TextHeader.dart';
import 'package:passit/components/TextNormal.dart';
import 'package:passit/components/TextNormalTittle.dart';
import 'package:passit/models/userModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicons/unicons.dart';
import '../../firebase/firestore.dart';
import '../../main.dart';

import '../../start.dart';
import '../../utils/constants.dart';
import 'package:passit/firebase/auth.dart';
import 'package:passit/login/login.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    var users = UserModel().obs;
    final box = GetStorage();
    final plate = box.read("plate");
    final bday = box.read("bday");
    final gender = box.read("gender");
    users.value = UserModel.fromJson(box.read("logged_user"));
    print("users.value.plate : ${users.value.toJson()}");
    //print(users.value.picture);
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
                        GestureDetector(
                          onTap: () async {
                            //print("CLICKED");
                            final _firebaseStorage = FirebaseStorage.instance;
                            final _imagePicker = ImagePicker();
                            XFile? image;
                            //Check Permissions
                            await Permission.photos.request();

                            var permissionStatus =
                                await Permission.photos.status;

                            if (permissionStatus.isGranted) {
                              //Select Image
                              image = await _imagePicker.pickImage(
                                  source: ImageSource.gallery);
                              var file = File(image!.path);
                              var filename = image.name;
                              if (image != null) {
                                //Upload to Firebase
                                Get.dialog(Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Obx(
                                      () => new LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        animation: true,
                                        lineHeight: 30.0,
                                        animationDuration: 1000,
                                        percent: users.value.progress == null
                                            ? 0
                                            : users.value.progress! / 100,
                                        center: Obx(() => Text(
                                            "${users.value.progress != null ? users.value.progress!.toStringAsFixed(0) : '0'}%")),
                                        barRadius: const Radius.circular(16),
                                        progressColor: Colors.purpleAccent,
                                      ),
                                    )));
                                var snapshot = await _firebaseStorage
                                    .ref()
                                    .child('images/$filename')
                                    .putFile(file)
                                    .snapshotEvents
                                    .listen((taskSnapshot) {
                                  switch (taskSnapshot.state) {
                                    case TaskState.running:
                                      final progress = 100.0 *
                                          (taskSnapshot.bytesTransferred /
                                              taskSnapshot.totalBytes);
                                      //print("Upload is $progress% complete.");
                                      users.value.progress = progress;
                                      users.update((val) {});
                                      break;
                                    case TaskState.paused:
                                      // ...
                                      break;
                                    case TaskState.success:
                                      if (Get.isDialogOpen ?? false) {
                                        Get.back();
                                      }
                                      taskSnapshot.ref
                                          .getDownloadURL()
                                          .then((downloadUrl) {
                                        users.value.picture = downloadUrl;

                                        box.write('logged_user',
                                            users.value.toJson());
                                        users.update((val) {});
                                        print("User ID: ${users.value.id}");
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user.id)
                                            .update(
                                                {'picture': '$downloadUrl'});
                                      });

                                      // users.value.picture = downloadUrl;
                                      break;
                                    case TaskState.canceled:
                                      // ...
                                      break;
                                    case TaskState.error:
                                      // ...
                                      break;
                                  }
                                });
                              } else {
                                //print('No Image Path Received');
                              }
                            } else {
                              print(
                                  'Permission not granted. Try Again with permission access');
                            }
                          },
                          child: Obx(() => CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.3),
                                backgroundImage: NetworkImage(
                                    "${(users.value.picture != null) ? users.value.picture : constants.texts['default']}"),
                                radius: 40,
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                                text: user.lname!=null? (toBeginningOfSentenceCase(user.lname!)! +
                                            ' ' +
                                            toBeginningOfSentenceCase(
                                                user.fname!)! +
                                            ' ' +
                                            toBeginningOfSentenceCase(
                                                user.mname!)!) +
                                        '.' : user.name != null ? user.name! :
                                    ''),
                            SizedBox(
                              height: 5,
                            ),
                            TextNormal(
                                text: "Account Type: ${user.account_type}")
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
                        Visibility(
                          visible: user.account_type == 'Driver',
                          child: TextNormal(
                            text: 'Plate number',
                            textColor: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(UniconsLine.car),
                            SizedBox(width: 5),
                            TextNormalTittle(
                              text: plate == null
                                  ? ''
                                  : plate!,
                              textColor: Colors.black,
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        TextNormal(
                          text: "Birthday",
                          textColor: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(width: 5),
                            TextNormalTittle(
                              text: bday ?? '',
                              textColor: Colors.black,
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        TextNormal(
                          text: "Gender",
                          textColor: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.people),
                            SizedBox(width: 5),
                            TextNormalTittle(
                              text: gender ?? '',
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
      ],
    );
  }
}
