import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:provider/provider.dart%20';
import 'package:unicons/unicons.dart';
import 'package:passit/firebase/auth.dart';
import 'package:passit/login/login.dart';
import '../components/PrimaryMainButtonDecorated.dart';
import '../components/RouteStartEnd.dart';
import '../firebase/firestore.dart';
import '../map/mapController.dart';
import '../models/locationModels.dart';
import '../models/travelHistoryModel.dart';
import '../server/requests.dart';
import '../start.dart';
import '../utils/LocationService.dart';
import 'main/MainView.dart';
import 'mySos/mySos.dart';
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
          Visibility(
            visible: ctrl.user.value.account_type != 'cdrrmo',
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                // shape: CircleBorder(),
              ),
              child: Icon(
                Icons.sos,
                color: Colors.white,
              ),
              onPressed: () async {
                var cur = await MapController().determinePosition();
                if (cur != null) {
                  ////print(cur.latitude.toString());
                  var temp = await Requests().SearchLocations2(
                      cur.latitude.toString(), cur.longitude.toString());
                  // ////print("Temp ${temp.displayName}");
                  var currentLocation = LocationModel(
                      address: temp.address,
                      displayName: temp.displayName!,
                      lat: cur.latitude.toString(),
                      lon: cur.longitude.toString(),
                      importance: '1');
                  LocationModel? currentLocations = currentLocation;
                  TravelHistoryModel travelHistory = new TravelHistoryModel(
                      createdAt: DateTime.now().toIso8601String(),
                      currentLocation: currentLocation);

                  // travelHistory.currentLocation = currentLocation;
                  // ////print(travelHistory.currentLocation!.displayName);
                  await Firestore()
                      .setEmergency(travelHistory)
                      .then((value) => AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.bottomSlide,
                      title: 'Success',
                      desc: 'SOS Request have sent',
                      // btnCancelOnPress: () {},
                      dismissOnTouchOutside: true,
                      btnOkOnPress: () async {},
                      onDismissCallback: (type) {
                        // Get.back();
                      })
                    ..show());
                }
              },
            ),
          ),
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
      body: StreamProvider<UserLocation>(
        initialData: UserLocation(
            latitude: 8.485774650813763, longitude: 123.80719541063236),
        create: (context) => LocationService().locationStream,
        child: Container(
          width: Get.width,
          height: Get.height,
          child: TabBarView(
            children: [
              Obx(() =>
                  MainView(
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
      ),
      bottomNavigationBar: Obx(
            () =>
            BottomNavigationBar(
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
                  label: ctrl.user.value.account_type == 'Driver'
                      ? "Travel Logs"
                      : ctrl.user.value.account_type == 'Passenger'
                      ? "Travel Logs"
                      : "Accident Log",
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
