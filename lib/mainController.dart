import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:passit/map/mapPage.dart';

class MainController extends GetxController {
  Future<bool> checkNotifPermissions() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  void initializeNotifListener() {
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      Get.to(MapPage(), arguments: receivedNotification.id);
    });
  }

  void showNotifications() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        category: NotificationCategory.Promo,
        title: 'Hello Po',
        body:
            'This month, we have reduced prices for our races. Now it''s all free!!',
      ),
      schedule: NotificationCalendar.fromDate(
        date: DateTime.now().add(
          Duration(seconds: 6),
        ),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    checkNotifPermissions().then((e) {
      initializeNotifListener();
      showNotifications();
    });
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        debugPrint("onMessage:");
        log("onMessage: ${message.data}");

      },
    );
  }
}
