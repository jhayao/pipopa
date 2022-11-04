import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:passit/firebase/firestore.dart';
import 'package:passit/home/travelDetails/driverMap/driverMap.dart';
import 'package:passit/home/travelDetails/driverMap/driverMap2.dart';
import 'package:passit/models/locationModels.dart';
import 'package:passit/models/paymentModel.dart';
import 'package:passit/models/userModel.dart';
import 'package:passit/utils/LocationService.dart';
import 'package:passit/utils/constants.dart';
import 'package:latlong2/latlong.dart'as LatLong;
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../../components/RouteStartEnd.dart';
import '../../map/mapController.dart';
import '../../models/travelHistoryModel.dart';
import '../../server/requests.dart';


class TravelDetails extends StatelessWidget {
  const TravelDetails(
      {super.key,
      required this.travelHistory,
      required this.user,
      required this.update, required this.catchs});

  final TravelHistoryModel travelHistory;
  final UserModel user;
  final bool update;
  final bool catchs;





  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    // ////print(travelHistory.startPoint!.displayName);
    final box = GetStorage();
    Future.delayed(const Duration(milliseconds: 500), () {
    });
    return StreamProvider<UserLocation>(
      initialData: UserLocation(latitude: 8.485774650813763,longitude: 123.80719541063236),
      create: (context) => LocationService().locationStream,
      child: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            color: Colors.grey.shade100,
            child: DriverMapPage2(travelHistory: travelHistory,user: user,),
          ),
          Positioned(
              bottom: 0,
              child: SizedBox(
                width: Get.width,
                height: 420,
                child: Material(
                  color: Colors.white,
                  elevation: 20,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your booking",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Follow the progress of your ride here",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RouteStartEnd(
                            constants: constants,
                            start: travelHistory.startPoint,
                            end: travelHistory.endPoint,
                          ),
                          Divider(),
                          Row(
                            children: [
                              Text("Ride Status:"),
                              SizedBox(
                                width: 10,
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green.withOpacity(0.5),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "${travelHistory.status}",
                                    style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 15),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Distance",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    child: Material(
                                      elevation: 3,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${Constants().formatNumber(travelHistory.routes?.routes[0].distance ?? 0)(',')}",
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors.black.withOpacity(0.8),
                                              ),
                                            ),
                                            Text(
                                              "m",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Amount to be paid",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    child: Material(
                                      elevation: 3,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${Constants().calculateFare((travelHistory.routes?.routes[0].distance.toDouble())! / 1000).toStringAsFixed(2)} ",
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(0.8)),
                                            ),
                                            Text(
                                              "PHP",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
          Visibility(
            visible: user.account_type == 'Driver' && travelHistory.status != 'Completed',
            child: Positioned(
                bottom: 0,
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: Get.width / 1.5 - 20,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        child: InkWell(
                          onTap: () async {
                            await Requests().launchURL(
                                travelHistory.startPoint, travelHistory.endPoint);
                          },
                          child: Visibility(
                            visible: user.account_type == 'Passenger' &&
                                    travelHistory.status != 'Pending Ride'
                                ? false
                                : true,
                            // visible: true,
                            child: Padding(
                              padding: EdgeInsets.all(17),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${user.account_type == 'Driver' ? 'Navigate' : 'Cancel booking'}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: Get.width / 3 - 20,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                        child: InkWell(
                          onTap: () async {
                            ////print("travelHistory.uid ${travelHistory.status}");
                            if (travelHistory.status != "Completed")
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.bottomSlide,
                                title: 'Confirm',
                                desc: 'Confirmed to received the payment?',
                                btnCancelOnPress: () {},
                                dismissOnTouchOutside: true,
                                btnOkOnPress: () async {
                                  var pay = PaymentModel(
                                      createdAt: DateTime.now().toIso8601String(),
                                      driver: travelHistory.driver,
                                      passenger: travelHistory.passenger,
                                      startPoint: travelHistory.startPoint,
                                      endPoint: travelHistory.endPoint,
                                      routes: travelHistory.routes,
                                      uid: travelHistory.uid,
                                      amount: Constants()
                                          .calculateFare((travelHistory
                                                  .routes?.routes[0].distance
                                                  .toDouble())! /
                                              1000)
                                          .toDouble());

                                  await Firestore()
                                      .storePayments(payment: pay)
                                      .then((value) {
                                    Firestore().updateTravel2(
                                        uid: travelHistory.uid!,
                                        status: 'Completed');
                                    AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.bottomSlide,
                                        title: 'Success',
                                        desc: 'Payment successfully received!!!',
                                        btnCancelOnPress: () {},
                                        dismissOnTouchOutside: true,
                                        btnOkOnPress: () async {},
                                        onDismissCallback: (type) {
                                          Get.back();
                                        })
                                      ..show();
                                  });
                                },
                              )..show();
                            else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.bottomSlide,
                                title: 'Warning',
                                desc: 'This Booking was already completed',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              )..show();
                            }
                          },
                          child: Visibility(
                            visible: user.account_type == 'Driver',
                            // visible: true,
                            child: Padding(
                              padding: EdgeInsets.all(17),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${user.account_type == 'Driver' ? 'Done' : 'Cancel booking'}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])),
          ),
          Visibility(
            visible: user.account_type == 'Passenger',
            child: Positioned(
                bottom: 0,
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: Get.width / 1.5 - 20,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        child: InkWell(
                          onTap: () async {
                            if (travelHistory.driver == null) {
                              // ////print(travelHistory.uid);
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.bottomSlide,
                                  title: 'Warning',
                                  desc:
                                      'This will permanently delete this booking',
                                  btnCancelOnPress: () {},
                                  dismissOnTouchOutside: true,
                                  btnOkOnPress: () async {
                                    if (catchs != 'True')
                                      {
                                        await Firestore()
                                            .cancelBooking(travelHistory.uid)
                                            .then((value) => AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.success,
                                            animType: AnimType.bottomSlide,
                                            title: 'Success',
                                            desc:
                                            'Booking successfully cancelled',
                                            btnCancelOnPress: () {},
                                            dismissOnTouchOutside: true,
                                            btnOkOnPress: () async {},
                                            onDismissCallback: (type) {
                                              Firestore().updateTravel2(uid: travelHistory.uid!, status: 'Pending');
                                              Get.back();
                                            })
                                          ..show());
                                      }
                                    else
                                      {
                                        AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.info,
                                            animType: AnimType.bottomSlide,
                                            title: 'Information',
                                            desc: "Can't cancelled booking here try again on Travel Logs",
                                            btnCancelOnPress: () {},
                                            dismissOnTouchOutside: true,
                                            btnOkOnPress: () async {},
                                            onDismissCallback: (type) {})
                                          ..show();
                                      }
                                  },
                                  onDismissCallback: (type) {})
                                ..show();
                            } else {
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.bottomSlide,
                                  title: 'Information',
                                  desc: 'Booking already confirmed',
                                  btnCancelOnPress: () {},
                                  dismissOnTouchOutside: true,
                                  btnOkOnPress: () async {},
                                  onDismissCallback: (type) {})
                                ..show();
                            }
                          },
                          child: Visibility(
                            visible: user.account_type == 'Passenger',
                            // visible: true,
                            child: Padding(
                              padding: EdgeInsets.all(17),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${'Cancel booking'}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: Get.width / 3 - 20,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                        child: InkWell(
                          onTap: () async {
                            ////print("Rate");
                            Get.dialog(RatingDialog(
                              initialRating: 1.0,
                              // your app's name?
                              title: Text(
                                'Rate your ride',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // encourage your user to leave a high rating?
                              message: Text(
                                'Tap a star to set your rating. Add more description here if you want.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15),
                              ),
                              // your app's logo?
                              image: ExtendedImage.asset(
                                constants.logoImage,
                                width: 50,
                                height: 150,
                              ),
                              submitButtonText: 'Submit',
                              commentHint: 'Set your custom comment hint',
                              onCancelled: () => print('cancelled'),
                              onSubmitted: (response) async{
                                print(
                                    'rating: ${response.rating}, comment: ${response.comment}');
                                await Firestore().storeRate(travelHistory.uid!, response.rating.toString(), response.comment);
                                // TODO: add your own logic
                                if (response.rating < 3.0) {
                                  // send their comments to your email or anywhere you wish
                                  // ask the user to contact you instead of leaving a bad review
                                } else {
                                  // _rateAndReviewApp();
                                }
                              },
                            ));
                          },
                          child: Visibility(
                            visible: true,
                            // visible: true,
                            child: Padding(
                              padding: EdgeInsets.all(17),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Rate",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])),
          ),
          Visibility(
            visible: travelHistory.status != 'Completed',
            child: Positioned(
                top: (Get.height / 2) - 100,
                right: 20,
                child: FloatingActionButton(
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
                      travelHistory.currentLocation = currentLocation;
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
                                Get.back();
                              })
                            ..show());
                    }
                  },
                  backgroundColor: Colors.red,
                  child: Icon(Icons.sos),
                )),
          ),
          Visibility(
            visible: (!catchs && travelHistory.status != 'Completed') || user.account_type == 'Driver',
            child: Positioned(
                top: Get.height / 14,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () async {
                    //print("Cancel ${catchs}  ${user.account_type}");
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.bottomSlide,
                        title: 'Warning',
                        btnOkText: 'Confirm',
                        desc:
                            'This will cancel the booking and will affect your rating',
                        btnCancelOnPress: () {},
                        dismissOnTouchOutside: true,
                        btnOkOnPress: () async {
                          var result = await Firestore()
                              .cancelDriver(travelHistory.uid)
                              .whenComplete(() => AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.bottomSlide,
                                  title: 'Success',
                                  desc:
                                      'We have notified the passenger for the cancellation',
                                  // btnCancelOnPress: () {},
                                  dismissOnTouchOutside: true,
                                  btnOkOnPress: () async {},
                                  onDismissCallback: (type) {
                                    box.write('travelDetails', 'true');
                                    Get.back();
                                    // Get.to(() => const HomePage());
                                    // Get.to(Start());
                                  })
                                ..show());
                          ////print('result $result');
                        },
                        onDismissCallback: (type) {
                          // Get.back();
                        })
                      ..show();
                    // travelHistory.currentLocation =
                    //
                  },
                  backgroundColor: Colors.red,
                  tooltip: "Cancel Booking",
                  child: Icon(Icons.cancel),
                )),
          ),
        ],
      ),
    );
  }
}
