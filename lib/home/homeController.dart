import 'dart:async';
import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passit/firebase/firestore.dart';
import 'package:passit/mainController.dart';
import 'package:passit/map/mapPage.dart';
import 'package:passit/models/travelHistoryModel.dart';
import 'package:passit/models/userModel.dart';
import 'package:passit/pdf/data.dart';
import 'package:unicons/unicons.dart';

import '../components/PrimaryButtonDecorated.dart';
import '../map/mapController.dart';
import '../models/locationModels.dart';
import '../pdf/app.dart';
import '../server/requests.dart';
import '../utils/constants.dart';
import 'Report/reportPage.dart';

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
  RxList<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime(1999, 5, 6),
    DateTime(1999, 5, 21),
  ].obs;

  List<DateTime?> _rangeDatePickerValueWithDefaultValue2 = [
    DateTime(2022, 11, 20),
    DateTime(1999, 11, 30),
  ];
  late StreamSubscription<Position> streamSubcrition;

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

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

  void showDialog(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 50));
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
        dayTextStyle: dayTextStyle,
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: Colors.purple[800],
        closeDialogOnCancelTapped: true,
        firstDayOfWeek: 1,
        weekdayLabelTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        controlsTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
        dayTextStylePredicate: ({required date}) {
          TextStyle? textStyle;
          if (date.weekday == DateTime.saturday ||
              date.weekday == DateTime.sunday) {
            textStyle = weekendTextStyle;
          }
          if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
            textStyle = anniversaryTextStyle;
          }
          return textStyle;
        },
        dayBuilder: ({
          required date,
          textStyle,
          decoration,
          isSelected,
          isDisabled,
          isToday,
        }) {
          Widget? dayWidget;
          if (date.day % 3 == 0 && date.day % 9 != 0) {
            dayWidget = Container(
              decoration: decoration,
              child: Center(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Text(
                      MaterialLocalizations.of(context).formatDecimal(date.day),
                      style: textStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 27.5),
                      child: Container(
                        height: 4,
                        width: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isSelected == true
                              ? Colors.white
                              : Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return dayWidget;
        });
    final constants = Constants();

    Get.bottomSheet(Material(
      child: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Container(
              width: Get.width,
              child: Text(
                "Select Date",
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CalendarDatePicker2(
                        config: config,
                        initialValue: _rangeDatePickerValueWithDefaultValue2,
                        onValueChanged: (values) {
                          print("RUNTTYPE");
                          print(values.runtimeType);
                          print(values.first.toString());
                          print(values.last.toString());
                          _rangeDatePickerValueWithDefaultValue2 = values;
                          // _rangeDatePickerValueWithDefaultValue.value = values;
                        }),
                    const SizedBox(height: 15),
                  ],
                ),
                Container(
                  height: 40,
                  child: PrimaryButtonDecorated(
                    onclick: () async {
                      print("SUBMIT");
                      List<TravelHistoryModel> travels = [];
                      print(
                          "Last ${_rangeDatePickerValueWithDefaultValue2.last!.toIso8601String()}");
                      print(
                          "First ${_rangeDatePickerValueWithDefaultValue2.first!.toIso8601String()}");
                      try {
                        var doc = await FirebaseFirestore.instance
                            .collection('travel_history');
                        await doc
                            .where('driver.id', isEqualTo: user.value.id)
                            .where('createdAt',
                                isLessThanOrEqualTo:
                                    _rangeDatePickerValueWithDefaultValue2.last!
                                        .toIso8601String())
                            .where('createdAt',
                                isGreaterThanOrEqualTo:
                                    _rangeDatePickerValueWithDefaultValue2
                                        .first!
                                        .toIso8601String())
                            .orderBy('createdAt', descending: true)
                            .get()
                            .then((value) {
                          travels = value.docs.map((travel) {
                            var data = travel.data();

                            return TravelHistoryModel.fromJson(data);
                          }).toList();
                          print("DONE");
                          print(travels[1].passenger?.toJson());

                        });
                      } catch (e) {
                        print(e.toString());
                      }

                      Get.to(MyApp(
                        reportType: 'Report',
                        data: travels,
                      ));
                    },
                    children: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    ));
  }

  void openReport() async {
    lastTravelLegnth = travelHistory.length;
    // ////print(lastTravelLegnth);
    ////print("Last Travel Lenght : $lastTravelLegnth");

    await Get.to(
      () => ReportView(),
    );
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
    final userLocation =
        FirebaseFirestore.instance.collection('locations').doc(user.value.id);
    await MapController().determinePosition();
    streamSubcrition =
        Geolocator.getPositionStream().listen((Position cur) async {
      await userLocation.set({
        'lat': cur.latitude,
        'long': cur.longitude,
        'userType': user.value.account_type,
        'user': user.value.toJson()
      }, SetOptions(merge: true));
    });
  }
}
