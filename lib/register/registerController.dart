import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passit/firebase/auth.dart';
import 'package:passit/firebase/firestore.dart';
import 'package:passit/login/login.dart';
import 'package:passit/phone_confirmation/phoneConfirmation.dart';
import 'package:passit/register/register.dart';

import '../models/userModel.dart';

class RegisterController extends GetxController {
  var user = UserModel();
  void login() {
    Get.to(const LoginPage());
  }

  void phoneConfirmation() async {
    if (user.name == null) {
      Get.snackbar("ERROR!", "Name is mandatory",
          colorText: Colors.black, duration: Duration(seconds: 10));
      return;
    }
    if (user.email == null) {
      Get.snackbar("ERROR!", "Email is mandatory",
          colorText: Colors.black, duration: Duration(seconds: 10));
      return;
    }
    if (user.numberId == null) {
      Get.snackbar("ERROR!", "Identity Card is mandatory",
          colorText: Colors.black, duration: Duration(seconds: 10));
      return;
    }
    if (user.phone == null) {
      Get.snackbar("ERROR!", "Identity phone number is required",
          colorText: Colors.black, duration: Duration(seconds: 10));
      return;
    }
    if (user.password == null) {
      Get.snackbar("ERROR!", "Password is mandatory",
          colorText: Colors.black, duration: Duration(seconds: 10));
      return;
    }

    if (user.password!.length < 6 || user.password!.length > 10) {
      Get.snackbar("ERROR!", "Password must contain 6 to 10 characters.",
          colorText: Colors.black, duration: Duration(seconds: 10));
      return;
    }

    try {
      var fire_user = await Auth().createUserInWithEmailAndPassword(
          email: user.email!, password: user.password!);

      if (Auth().currentuser != null) {
        try {
          user.id = Auth().currentuser!.uid;
          await Firestore().createUser(user: user);

          final box = GetStorage();
          box.write("logged_user", user.toJson());
          Get.to(const PhoneConfirmationPage());
        } catch (e) {
          print("Error while trying to register the user $e");
        }
      } else {
        print("Could not log in...");
      }
    } on FirebaseAuthException catch (e) {
      print("Nao deu para Logar no catch... ${e.code}");
      Get.snackbar("ERROR!", "${e.message}",
          colorText: Colors.black, duration: Duration(seconds: 10));
      return;
    }

    // final box = GetStorage();
    // box.write("logged_user", user.toJson());
    // Get.to(const PhoneConfirmationPage());
  }
}