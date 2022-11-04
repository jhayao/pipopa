import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passit/components/PrimaryButtonDecorated.dart';
import 'package:passit/components/TextHeader.dart';
import 'package:passit/components/TextNormal.dart';
import 'package:passit/components/TextNormalBolded.dart';
import 'package:passit/components/TextNormalTittle.dart';
import 'package:passit/components/TextSmall.dart';
import 'package:passit/home/homeController.dart';
import 'package:passit/home/myLocations/myLocationsView.dart';
import 'package:passit/utils/constants.dart';
import 'package:unicons/unicons.dart';
import 'package:passit/firebase/auth.dart';
import 'package:passit/login/login.dart';
import '../components/PrimaryMainButtonDecorated.dart';
import '../components/RouteStartEnd.dart';
import '../start.dart';
import 'main/MainView.dart';
import 'profile/profileView.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    final ctrl = Get.put(HomeController());
    final box = GetStorage();
    // ////print("Logged User: ${box.read("logged_user")}");
    // ////print('History : ${ctrl.travelHistory.value.}');
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: constants.primary1,
        elevation: 0,
        // leading: Icon(Icons.menu),
        automaticallyImplyLeading: false,
        // title: new Text("Pipopa"),
        actions: <Widget>[

          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await Auth().signOut();
              if (Auth().currentuser == null) {
                final box = GetStorage();
                box.remove("logged_user");
                box.erase();
                Get.to(Start());
                Get.deleteAll();
                Get.reset();
              } else {}
              // do something
            },
          )
        ],
        title: Row(
          children: [
            ExtendedImage.asset(
              constants.logoImage,
              height: 60,
            ),
            Center(child: Text("Pipopa"))
          ],

        ),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: TabBarView(
          children: [
            Obx(() => MainView(
                  key: Key("locations_list_${ctrl.updater.value}"),
                  ctrl: ctrl,
                  constants: constants,
                  user: ctrl.user.value,
                  uid: 'test',
                  travelHistory: ctrl.travelHistory,
                )),
            MyLocationsView(
              controller: ctrl,
              user: ctrl.user.value,
            ),
            ProfileView(
              user: ctrl.user.value,
            ),
          ],
          controller: ctrl.tabController,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (val) {
            ctrl.currentTab.value = val;
            ctrl.goTo(val);
          },
          currentIndex: ctrl.currentTab.value,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                UniconsLine.home,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                UniconsLine.location_pin_alt,
              ),
              label: ctrl.user.value.account_type == 'Driver' ? "Travel Logs" : ctrl.user.value.account_type == 'Passenger' ? "Travel Logs" : "Recent Accidents",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                UniconsLine.user_circle,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
