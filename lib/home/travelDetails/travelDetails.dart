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
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:unicons/unicons.dart';
import '../../components/RouteStartEnd.dart';
import '../../map/mapController.dart';
import '../../models/travelHistoryModel.dart';
import '../../server/requests.dart';

class TravelDetails extends StatelessWidget {
  const TravelDetails(
      {super.key,
      required this.travelHistory,
      required this.user,
      required this.update,
      required this.catchs});

  final TravelHistoryModel travelHistory;
  final UserModel user;
  final bool update;
  final bool catchs;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    // ////print(travelHistory.startPoint!.displayName);
    final box = GetStorage();
    Future.delayed(const Duration(milliseconds: 500), () {});
    return StreamProvider<UserLocation>(
      initialData: UserLocation(
          latitude: 8.485774650813763, longitude: 123.80719541063236),
      create: (context) => LocationService().locationStream,
      child: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            color: Colors.grey.shade100,
            child: DriverMapPage2(
              travelHistory: travelHistory,
              user: user,
            ),
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
                                                color: Colors.black
                                                    .withOpacity(0.8),
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
            visible: user.account_type == 'Driver' &&
                travelHistory.status != 'Completed',
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
                            await Requests().launchURL(travelHistory.startPoint,
                                travelHistory.endPoint);
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
                                      createdAt:
                                          DateTime.now().toIso8601String(),
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
                                        desc:
                                            'Payment successfully received!!!',
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
            visible: travelHistory.status == 'Completed',
            child: Positioned(
                bottom: 0,
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: Get.width - 20,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                        child: InkWell(
                          onTap: () async {
                            print("Rating Details : ${travelHistory.rate}");
                            Get.dialog(RatingDialog(
                              initialRating: double.parse(travelHistory.rate!),
                              // your app's name?
                              title: Text(
                                'Customer Rating',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // encourage your user to leave a high rating?
                              message: Text(
                                '${travelHistory.comment=="" ? 'No comment' : travelHistory.comment}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15),
                              ),
                              enableComment: false,
                              // your app's logo?
                              image: ExtendedImage.asset(
                                constants.logoImage,
                                width: 50,
                                height: 125,
                              ),
                              submitButtonText: 'Okay',
                              commentHint: 'Set your custom comment hint',
                              onCancelled: () => print('cancelled'),
                              onSubmitted: (response) async {

                              },
                            ));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Rating Details",
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
                ])),
          ),
          Visibility(
            visible: user.account_type == 'Passenger' || travelHistory.status != 'Completed',
            child: Positioned(
                bottom: 0,
                child: Row(children: <Widget>[
                  Visibility(
                    visible: user.account_type == 'Passenger' && travelHistory.driver == null,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: Get.width - 20,
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
                                      if (catchs != 'True') {
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
                                                  // Firestore().updateTravel2(
                                                  //     uid: travelHistory.uid!,
                                                  //     status: 'Pending');
                                                  Get.back();
                                                })
                                              ..show());
                                      } else {
                                        AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.info,
                                            animType: AnimType.bottomSlide,
                                            title: 'Information',
                                            desc:
                                                "Can't cancelled booking here try again on Travel Logs",
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
                              visible: user.account_type == 'Passenger' && travelHistory.driver == null,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: Get.width - 20,
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
                              onSubmitted: (response) async {
                                print(
                                    'rating: ${response.rating}, comment: ${response.comment}');
                                await Firestore().storeRate(
                                    travelHistory.uid!,
                                    response.rating.toString(),
                                    response.comment);
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
                            visible: user.account_type == 'Passenger' && travelHistory.driver != null && travelHistory.status !='Completed' && travelHistory.status !='Accident happen',
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
            visible: travelHistory.status != 'Completed',
            child: Positioned(
                top: (Get.height / 2) - 200,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () async {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.info,
                      body: Center(
                        child: Text(
                          """ RULES and REGULATION
1) Introduction
  Do not Drive without these Documents
  Valid driving license
  Vehicle registration certificate ( Form 23)
  Valid vehicle's insurance certificate
  Permit and vehicle's certificate of fitness (applicable only to transport vehicles)
  Valid Pollution Under Control Certificate On demand by a police officer in uniform or an officer of the Transport Department, produce these documents for inspection
2) Rules of the Road
  General Rules Keep Left on a two-way road to allow traffic from the opposite direction to pass on your right and on a one-way road to allow vehicles behind you to overtake from your right.
  
  When Turning Left keep to the left side of the road you are leaving as well as the one you are entering. When turning right, move to the centre of the road you are leaving and arrive near the left side of road you are entering.
  
  Slow Down at road junctions, intersections, pedestrian crossings and road corners and wait until you are sure of a clear passage ahead. if you are entering a main road where traffic is not being regulated, give way to vehicles passing on your right.
  
  Hand Signal RightHand Signals are necessary at certain times. When slowing down, extend your right arm palm down and swing it up and down; when stopping, raise your forearm vertically outside the vehicle; when turning right or changing lane to the right hand side, extend your right arm straight out, palm to the front; when turning left or changing lane to the left hand side, extend your right arm and rotate it in an anti-clockwise direction.
  
  
   
  To allow the vehicle behind you to overtake, swing your right arm backward and forward in a semi circular motion. Hand Signal LeftDirection Indicators Better use directions indicators instead of hands singlals and both in case of any emergancy. Wearing a Helmet for Two Wheeler Drivers is a statutory requirement. The helmet must conform to the ISI standards and should bear the ISI mark. Helmet works as a shield for your head in case of a mishap. It is designed for your individual safety and not as a cover to avoid legal prosecution. For complete safety tie the strap properly otherwise the helmet may slip from your head in case of an accident head injury. (Turban wearing Sikhs are exempted from using a helmet).
  
  Do Not Park at or near a road crossing or on top of a hill or on a footpath; too near a traffic light or pedestrian crossing; on a main road or a road with heavy traffic; in front of or opposite another parked vehicle to cause obstruction; on roads that have a white line; near a bus- stop, school or hospital entrance; right next to a traffic sign thereby blocking it for others; at the entrance of a building; near a fire hydrant thereby blocking access to it; where parking is specifically prohibited.
  
  The Registration Mark of the vehicle should be clear, legible and visible at all times. Do not load the motor vehicle so as to obstruct the tail lights or any other lights or marks required on the vehicle for its safety.
  
  Do Not Drive on a one way road except in the direction permitted. Reversing into a one way street in the wrong direction, is also prohibited.
  
  Do Not Cross The Yellow Line dividing the road even while overtaking. On roads with defined lanes use appropriate indicator signal before changing lanes.
  
  Do Not Cross The Stop Line painted on the road when you stop at a road junction or intersection or a pedestrian crossing. In no case should your stationary vehicle project,beyond this line.
  
  Towing is Permitted only for mechanically disabled or incompletely assembled motor vehicles, registered trailers and side cars. Vehicles other than these may be towed for delivery to the nearest garage or petrol pump in case of untimely breakdown.
  
  Use The Horn only when essential and do not use it in a silence zone. Do not fit loud, multi-toned or harsh and shrill sounding horns or alarms in your vehicle. Vehicles with altered silencers are also prohibited on the road.
  
  Directions Given to Drivers either through police officers regulating traffic or through road signs or traffic signals should be followed at all times. Violation of these is an offense.
  
  Maintain an Adequate Distance from the vehicle ahead of you to avoid collision if that vehicle suddenly slows down or stops. A chart to guide you on minimum braking time required at different speeds is given on page 33 for your information.
  
  Do Not Brake Suddenly except for safety reasons.
  
  On Mountains and Steep Roads the vehicle driving uphill must be given the right of way by vehicles coming downhill. If the road is not sufficiently wide, pull your vehicle to a stop on the side of the road and allow the driver going uphill to proceed first.
  
  When Road Repair Work is going on, slow down and drive at a speed not exceeding twenty five kilometers per hour.
  
  Drivers of Tractors and Goods Vehicles are prohibited from carrying passengers for hire or reward. In a tractor, the driver should not carry any other person and in a goods vehicle, he should not exceed the number of persons permitted in the driver's cabin.
  
  Do Not Carry Goods on a motor vehicle in a manner that may cause danger to any person, or load it thus that the goods extend laterally beyond the side, front or to the rear of the vehicle. Carrying of explosives, inflammable or dangerous substances by any public service vehicle is also prohibited.
  
  Carry Only One Pillion Rider on your two wheeler. You must carry the rider only on the back seat. Do not allow any rider to sit or stand in front of you (not even children). It is not only illegal but often becomes dangerous because sudden braking may throw out the child or person hitting the vehicle in front. It is a violation of law to carry goods on your two wheeler as the rider may lose balance easily leading to accidents.
  
  Do Not Drive Backwards longer than necessary, and do ensure that you do not cause danger or inconvenience to any other person or vehicle while doing so.
  
  Do Not Drive on the road if you are unwell or after taking medication that is likely to impair your driving abilities including tonics that may have an alcohol content in them.
  
  Sharing The Road Drivers often forget that roads are not just for them alone. This can make things difficult on the road for pedestrians, cyclists, scooterists and motor cyclists who do not have solid protections around them. They are entitled to your care and consideration. Always keep a close watch on other road users. Children, for example, may do unexpected things. Elderly pedestrians may move more slowly than you expect or may not see or hear you until you are too close.
  
  Give Way to PedestriansAlways Give Way To Pedestrians if there is danger to their safety. Take extra care if they are children or elderly people. There are some obvious places and times where you should take extra care like shopping centres, busy intersections, schools, parks and residential areas where children and others have a greater need of crossing the road. Also, in wet weather, people may hurry and take risks. At night remember that pedestrians may not always be aware how hard it can be for you to see them.
  
   
  Give Way to PedestriansBe careful when approaching parked cars or buses. It is difficult to see or anticipate people crossing from behind them. Slow down at pedestrian crossings or intersections, especially if you are turning. You must give way to pedestrians on a pedestrian crossing. This means you must approach the crossing at a speed which will let you stop in time. Not all pedestrians look before they step onto a crossing. So watch out for anyone approaching and be ready to stop.You must stop if a pedestrian is on a school crossing. This applies even if there is no crossing supervisor present. Stop at the stop line until all pedestrians are off the crossing.
  
  Never Indulge in Zig-Zag DrivingNever Indulge in Zig-Zag Driving, especially on two wheelers. It is not only dangerous for you but is a danger for others also. Motorcycles have a high accelerating power. Don't misuse it. Don't overtake when it is not necessary. Remember, at higher speed the slightest collision can prove to be fatal.
  
  Do Not Overtake another vehicle that has stopped at a pedestrian school crossing. That driver may have stopped, or may be stopping, for a pedestrian you cannot see.
  
  Give Way to PedestriansYou Must Give Way to pedestrians when you are entering or leaving private property such as a driveway. If you cannot see whether anyone is coming, sound your horn and then drive out very slowly.
  
  Cyclists and MotorCyclists have the same rights and responsibilities as drivers of larger vehicles. When overtaking cyclists, leave at least one metre clearance. Don't try to share the lane with them. Cycle riders are entitled to ride two abreast. Also, when you are about to alight from your car, check for bicycle riders or scooterists to avoid opening your door in their path. Children on cycles can also be unpredictable. Take extra care of them.
  
  Safe Gap for Oncoming MotorcycleBicycles scooters and motorcycles are smaller than cars and therefore harder to see. A common cause of accidents is the failure of a right-turning driver to notice an oncoming motorcycle as motorcycle accelerate much faster than cars. What appears to be a safe gap in traffic may not be if there is an oncoming motorcycle or a scooter.
  
  Bicycles can travel surprisingly fast. 30 km/h is not unusual. Drivers can easily underestimate their speed. Be careful not to cut them off when turning in front of them.
  
  Most motorcycle crashes happen at intersections. Before turning, or entering an intersection, have one more look to make sure there's no motorcycle or bicycle there. Motorcyclists and cyclists can be hidden by trucks and buses which are overtaking them. Only move left or turn left from behind a large vehicle when you are sure the road is clear.
  
  Look Out for large, heavy, turning vehiclesLook Out for large, heavy, turning vehicles. When such a vehicle is turning, you must not pass on the left or right of the vehicle. If your vehicle comes between a large turning vehicle and the kerb, there is a likelihood of your vehicle getting crushed. Remember, long vehicles may use more than one lane when negociating turns.
  
  Overtaking When Overtaking do so from right of the vehicles you are passing. If the driver of the vehicle in front of you indicates that he is turning right, you may pass from his left. Remember not to cut in onto heavy vehicles. They need more room to slow down and stop.
  
  Do Not Overtake when you think it might endanger other traffic on the road; if the road ahead is not clearly visible, for example, near a bend or a hill. If you know that the vehicle behind you has begun to overtake you; if the driver ahead of you has not yet signalled his agreement that you pass him.
  
  If you cannot see for more than 150 metres ahead, because of a hill or curve or if the road is narrowing, avoid overtaking.
  
  If a vehicle has stopped at a pedestrian crossing, intersection or railway crossing, do not overtake it.
  
  In a multi-lane road, you must remember to give way to traffic already in the lane you are moving into.
  
  When Being Overtaken do not increase the speed of your own vehicle. This creates confusion for the driver trying to overtake you.
  
  Driving At Night There are fewer cars on the road at night. This does not increase your safety in any manner. This is because speeds are higher, people and bicycles are difficult to see and other motorists or pedestrians may have been drinking. Drive slowly and you will be able to react better. At higher speeds, the stopping distance exceeds the seeing distance thereby causing accidents.
  
  Driving at Night
  The driver will not see the cattle in time to stop the high beam is useful for extra seeing distance. However, you must dip your headlights to low beam when an approaching vehicle is within 200m, or die other vehicle's headlights dip, whichever is sooner. Also dip your headlights when driving 200m or less behind another vehicle.
  
  
  Dip your lights for oncoming traffic
  
  Dip your lights
  Dip your lights when following other vehicles Remember not to use high beam in foggy conditions as your light reflects back, reducing visibility. Also remember to use your dipper at night.If oncoming traffic does not dip its high beam, look to the left side of the road and drive towards the left of your lane.If you are dazzled, slow down or pull over until your eyes recover.
  
  How To Stop Quickly
  
  How To Stop Quickly
  The best way to stop quickly is to drive slowly. Sometimes, unexpected things happen quickly. A driver can pull out of a side street without warning. A pedestrian can suddenly step out from behind a parked car. A truck can drop some of its load. A scooterist or motorcyclist could hit a pot-hole and fall off. If you are travelling too fast, it may be difficult to avoid an accident. In the diagram below one of the cars is driving at a speed higher by only 10 km/h. A truck suddenly pulls up in front. If both drivers brake hard at the same time, one car will avoid a collision while the other will strike the truck at 30 km/h. (These calculations are based on ideal road conditions, good drivers and well-maintained cars. This may not be the case always.)
  
  Right of Way At some crossroads there are no traffic lights or signs. When you come to one of these intersections you must give way to vehicles travelling in the intersection on your right as marked below:
  
  Right of Way
  Red car has to give way to other oncoming vehicles. You must also give way to the right at intersections where the lights have failed. If yours and an oncoming vehicle are turning right at an intersection both cars should pass in front of each other.
  
  Right of WayIf the other drivers do not give way to you, do not commit the same mistake they are doing. Give way to fire engines and ambulances by driving your vehicles to the side of the road. Give way to pedestrians at crossings that are not regulated. Give way to traffic already in the lane you are moving into. INTERSECTION At T-intersections the vehicle travelling on the road that ends must give way to any vehicle traveling on the road that continues (unless otherwise sign-posted). The give way to the right rule does not apply to T-intersections.
  
  Right of WayRed Car has to give way to Blue Car
  
  
  
  
  Roundabouts and How to Approach Them
  
  Round AboutsAn intersection with a central traffic island is called a roundabout. Give way to vehicles already on the road. If you are turning, as you approach or exit the roundabout, you must use your indicator to show where you are going. Always slow down and prepare to give way at a roundabout. Please follow lane markings on the road leading to the roundabout.
  
  If there are no lane demarcations, do not overtake from the left. Enter the roundabout when there is a safe gap in the traffic.When turning left, stay on the left. When going straight, from whichever lane you enter, drive in the same position through the roundabout. When turning right, drive close to the centre of the roundabout. Take care while changing position on the roundabout, particularly when exiting.
  
  Turning
  
  Turning
  Remember to give way to pedestrians when turning to the left. When turning right, make proper hand or indicator signal, move as close to the centre line as possible and Turn only when there is no oncoming vehicle.
  
  U-Turn When Taking a U-Turn signal by hand the way you would for a right turn, observing the traffic behind you in your rear view mirror at the same time. Do not take a U-turn where it is specifically prohibited.
  
  U-turns can be dangerous. Be extra careful while taking one. Make sure it is safe and let other motorists know by signalling at least 30 metres before you turn.
  
  Remember U-turns cannot be made at traffic lights, on high-ways or if your U-turn disrupts traffic. Also U-turns are prohibited on a road marked with any single unbroken line or double centre lines whether or not one line is broken.

3) Traffic Police Hand Signals
  Traffic Police Hand SignalsTraffic Police Hand SignalsTraffic Police Hand SignalsTraffic Police Hand SignalsTraffic Police Hand Signals
  
  
  Traffic Police Hand SignalsTraffic Police Hand SignalsTraffic Police Hand SignalsTraffic Police Hand SignalsTraffic Police Hand Signals


4) Traffic Signals
  Stop Light Signal
  Stop:
  
  Stop well before the stop line, and don't crowd the intersection. This not only obstructs a clear view of the intersection for other road users, but also make the zebra crossing unsafe for the pedestrians. You are allowed to turn left at the red signal unless there is a sign specifically forbidding you to do so. When turning, yield the right of way to pedestrians and vehicles from other directions.
  
  
  
  
  
  
  
  
  Be Alert:
  
  Alert Light Signal
  The Amber light gives time to vehicles to clear the road when the signal is changing from green to red. If caught in the Amber signal in the middle of a large road crossing do not press your accelerator in panic but do continue with care.
  
  
  
  
  
  
  
  Go Light SignalGo: If first in line, do not go tearing off at the green signal but pause to see whether vehicles from other directions have cleared the road.
  
  Sometimes you are allowed to turn left or right too, unless separate signs exist for each direction. if turning, yield the right of way to pedestrians and vehicles from other directions.
  
  
  
  
  
  
  
  
  
  Steady Green Arrow SignalSteady Green Arrow Signal:
  
  Proceed with caution in the direction indicated by the arrows. Remember that you must yield to all pedestrians and vehicles already in the intersection.
  
  
  
  
  
  
  
  
  
  Flashing Red SignalFlashing Red Signal:
  
  You must come to a complete stop, yield to all other traffic and to pedestrians. Proceed only when the way is clear.
  
  
  
  Flashing Amber SignalFlashing Amber Signal:
  
  You should slow down and proceed with caution. """,
                          style: TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                      title: 'RULES and REGULATION',
                      desc: 'TRULES and REGULATION',
                      btnOkOnPress: () {},
                    )..show();
                  },
                  backgroundColor: Colors.blue,
                  child: Icon(UniconsLine.info_circle),
                )),
          ),
          Visibility(
            visible: (!catchs && travelHistory.status != 'Completed') ||
                user.account_type == 'Driver',
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
                              .cancelDriver(travelHistory.uid,travelHistory.passenger!.email!)
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
          Visibility(
            visible: true,
            child: Positioned(
                top: (Get.height / 2) - 275,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () async {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.info,
                      body: Align(
                        child: Text(
                          """
CDRRMO:
    Hotline Number: 09093478433 / 09700489700
    TEL. No. : 586-0246 / 564-0611
                          
PNP
    Hotline Number: 09985986919 / 09073021414
                          
BFP
    Hotline Number: 09187138509 / 09778097114
    Tel No. : 545-2155
                        """,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      title: 'RULES and REGULATION',
                      desc: 'TRULES and REGULATION',
                      btnOkOnPress: () {},
                    )..show();
                  },
                  backgroundColor: Colors.blue,
                  tooltip: "Rescue Details",
                  child: Icon(UniconsLine.phone),
                )),
          ),
        ],
      ),
    );
  }
}
