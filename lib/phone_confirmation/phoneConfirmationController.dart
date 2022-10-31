import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passit/firebase/auth.dart';
import 'package:passit/firebase/firestore.dart';
import 'package:passit/home/home.dart';
import 'package:passit/models/userModel.dart';

class PhoneConfirmationController extends GetxController {
  var code = "".obs;
  var verificationId = "";
  late UserModel user;
  var user2 = UserModel().obs;
  final box = GetStorage();

  void goHome() {
    Get.to(HomePage());
  }

  void validate() async {
    var user = await Auth()
        .validate(verificationId: verificationId, smsCode: code.value);
    // var logingResult = await Auth().signInWithCredential(
    //   authCredential: user as AuthCredential,
    // );

    if (Auth().currentuser != null) {
      Get.to(HomePage());
      user2.value = UserModel.fromJson(box.read("logged_user"));
      await Firestore().updateUser(user: user2.value);
    } else {}
  }

  Future<void> sendValidationCode() async {
    try{
      await Auth().phoneConfirmation(
          phone: user.phone!,
          onCodeSent: (_verificationId, resendToken) {
            verificationId = _verificationId;
          });
    }catch  (e)
    {
        //print(e.toString());
    }

  }

  @override
  void onInit() async {
    super.onInit();
    final box = GetStorage();
    user = UserModel.fromJson(box.read("logged_user"));

    Future.delayed(Duration(seconds: 5));
    await sendValidationCode();
  }
}
