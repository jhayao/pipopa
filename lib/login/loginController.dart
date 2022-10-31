import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passit/firebase/auth.dart';
import 'package:passit/home/home.dart';
import 'package:passit/models/userModel.dart';
import 'package:passit/phone_confirmation/phoneConfirmation.dart';
import 'package:passit/register/register.dart';

import '../firebase/firestore.dart';

class LoginController extends GetxController {
  var nome = '';
  var Password = '';
  final box = GetStorage();

  final logginIn = false.obs;

  void newAccount() {
    Get.to(const RegisterPage());
  }

  void login() async {
    logginIn.value = true;
    try {
      var result = await Auth()
          .signInWithEmailAndPassword(email: nome, password: Password);

      if (Auth().currentuser != null) {
        UserModel? user2 = UserModel();
        var user = Auth().currentuser;
        //print("User Phone Number: ${user!.phoneNumber}");

        await Firestore().getUser(uid: user!.uid);
        // var users = UserModel();
        user2 = UserModel.fromJson(box.read("logged_user"));

        if (user2?.accountStatus != null ) Get.to(() => const HomePage());
        else {
          Get.snackbar(
              "ERROR!", "Phone number not yet verified",
              colorText: Colors.black);
          Get.to(const PhoneConfirmationPage());
        }
      }
    } catch (e) {
      //print("ERRORs ${e.toString()}");
      Get.snackbar(
          "ERROR!", "Username and password do not match. Check and try again",
          colorText: Colors.black);
    }
    logginIn.value = false;
  }

  @override
  void onInit() {
    super.onInit();

    final User? user = Auth().currentuser;
    if (user != null) {
      Auth().signOut();
    }
    // if (user != null) {
    //   Get.to(HomePage());
    // }
  }
}
