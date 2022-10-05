import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class Constants {
  final logoImage = "assets/images/logo.png";
  final textXl = 20.0;
  final textNormal = 12.0;
  final textSm = 10.0;

  final primary1 = HexColor("68BF01");
  final primary2 = HexColor("457F00");

  final btnPrimary =Color.fromARGB(255, 176, 8, 189);
  final btnSecondary = Color.fromARGB(255, 55, 120, 33);

/**
 * ## PASSIT GRADIENT
 * The main app Background Gradient
 */
  final backgroundGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      HexColor("b601bf"),
      HexColor("e17df5"),
    ],
  );

  /**
   * ## RADIUS 
   */
  final radousNormal = BorderRadius.all(Radius.circular(10));

  final texts = Map.from({
    "login": "LOGIN",
    "confirm": "Confirm",
    "code": "CONFIRMATION CODE",
    "new_acc": "New Account",
    "full_name": "Full Name",
    "Password": "Password",
    "Enter": "Login",
    "create_acc": "Create an account",
    "create_new": "Create new Account",
    "note_login": "Enter the Access information to log into the system",
    "note_phone":
        "We have sent a 6-digit code to your phone number\n please confirm to continue.",
    "note_reg":
        "Create a new account to access the application's features",
    "no_acc": "Don't have an account?",
    "already": "Already have an account?",
  });

  Function formatNumber(double number) {
    String res =
        NumberFormat('#,##0.' + "#" * 5).format((number).roundToDouble());

    return (String replaceWith) {
      return res.replaceAll(',', '.');
    };
  }

  double calculateFare(double number)
  {

    return number * 40;
  }
}
