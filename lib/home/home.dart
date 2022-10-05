import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

import '../components/PrimaryMainButtonDecorated.dart';
import '../components/RouteStartEnd.dart';
import 'main/MainView.dart';
import 'profile/profileView.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    final ctrl = Get.put(HomeController());
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: constants.primary1,
        elevation: 0,
        leading: Icon(Icons.menu),
        title: Column(
          children: [
            ExtendedImage.asset(
              constants.logoImage,
              height: 30,
            ),
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
                  travelHistory: ctrl.travelHistory,
                )),
            MyLocationsView(
              controller: ctrl,
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
              label: "My Locations",
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
