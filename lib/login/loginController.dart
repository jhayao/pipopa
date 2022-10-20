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
      var result =
          await Auth().signInWithEmailAndPassword(email: nome, password: Password);

      if (Auth().currentuser != null) {
        // var user = UserModel();
        var user = Auth().currentuser;

        // box.write("logged_user", user.);

        await Firestore().getUser(uid: user!.uid);
        var users = UserModel();

        // Get.to(const HomePage());
        Get.to(() => const HomePage());
      }
    } catch (e) {
      print("ERROR ${e.toString()}");
      Get.snackbar("ERROR!",
          "Username and password do not match. Check and try again",
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
