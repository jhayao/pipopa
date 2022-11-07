import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passit/firebase/firestore.dart';
import 'package:passit/mainController.dart';
import 'package:passit/map/mapPage.dart';
import 'package:passit/models/travelHistoryModel.dart';
import 'package:passit/models/userModel.dart';

import '../map/mapController.dart';
import '../models/locationModels.dart';
import '../server/requests.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final box = GetStorage();

  Rx<int> currentTab = 0.obs;
  var user = UserModel().obs;
  late TabController tabController;

  var updater = 0.obs;
  late LocationModel myLocation;
  var travelHistory = <TravelHistoryModel>[].obs;
  var bookingList = <TravelHistoryModel>[].obs;
  var lastTravelLegnth = 0;
  var favTravelHistory = <TravelHistoryModel>[].obs;
  late StreamSubscription<Position> streamSubcrition;

  void openMap() async {
    lastTravelLegnth = travelHistory.length;
    // ////print(lastTravelLegnth);
    ////print("Last Travel Lenght : $lastTravelLegnth");

    await Get.to(() => MapPage(), arguments: [travelHistory]);
    updater.value = updater.value + 1;
    // ////print("travelHistory : ${travelHistory.length}");
    if (lastTravelLegnth < travelHistory.length) {
      // ////print("Travel History : ${travelHistory.value[0].status}");
      var result =
          await Firestore().storeTravel(travel: travelHistory.value.first);
      ////print("ERROR?: $result");

      // save();
    }
  }

  void goTo(int tab) {
    tabController.animateTo(tab);
  }

  void navigate() {
    currentTab.value = tabController.index;
  }

  void save() async {
    box.write("myFavs",
        jsonEncode(favTravelHistory.value.map((e) => e.toJson()).toList()));
    // ////print("MYFAVS : ${box.read("myFavs")}");
    await Firestore().storeFav(travel: favTravelHistory.last);
  }

  @override
  void onInit() async {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(navigate);
    print("CurrentTab: ${currentTab.toString()}");
    super.onInit();

    final mainCtrl = Get.put(MainController());

    mainCtrl.showNotifications();

    user.value = UserModel.fromJson(box.read("logged_user"));
    ////print("LOGGED USER HOME CONTROLLER: ${box.read("logged_user")}");
    ////print("User Value ${user.value.plate}");
    // travelHistory.value.clear();
    if (user.value.account_type != 'Driver') {
      travelHistory.value = await Firestore().getTravels(user.value, (error) {
        ////print("HISTORY ERROR $error");
      });
    } else {
      travelHistory.value = await Firestore().getBooking(user.value, (error) {
        ////print("Get Booking ERROR $error");
      });
    }

    updater.value = updater.value + 1;

    var stored = box.read("myFavs");

    if (stored != null) {
      favTravelHistory.value = List.from(jsonDecode(stored))
          .map((e) => TravelHistoryModel.fromJson(e))
          .toList();
    }
    favTravelHistory.value = await Firestore().getTravels(user.value, (error) {
      ////print("HISTORY ERROR $error");
    });
    getCurrentLocation();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    dispose();
  }

  void getCurrentLocation() async {
    final userLocation = FirebaseFirestore.instance.collection('locations').doc(user.value.id);
    await MapController().determinePosition();
    streamSubcrition =
        Geolocator.getPositionStream().listen((Position cur) async {
      await userLocation.set({
        'lat' : cur.latitude,
        'long' : cur.longitude,
        'userType' : user.value.account_type,
        'user' : user.value.toJson()
      }, SetOptions(merge: true));
    });
  }
}
