import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passit/models/userModel.dart';

import '../models/paymentModel.dart';
import '../models/travelHistoryModel.dart';
import '../utils/constants.dart';

class Firestore {
  Future<void> createUser({required UserModel user}) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.id);
    return await userDoc.set({
      "name": user.name,
      'phone': user.phone,
      'email': user.email,
      'numberId': user.numberId,
      'accountStatus': user.accountStatus,
      'picture': user.picture,
      'password': user.password,
      'accountType': user.account_type,
      'plateNumber': user.plate
    });
  }

  Future<void> updateUser({required UserModel user}) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.id);
    return await userDoc.update({'accountStatus': 'Active'});
  }

  Future<UserModel?> getUser(
      {String? uid,
      Function(DocumentSnapshot<Map<String, dynamic>>?)? callbak}) async {
    if (uid == null) {
      return null;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      //print("VALUE GETUSER ${value.data()?["accountStatus"]}");
      var user = UserModel();
      user.id = value.id;
      user.email = value.data()?["email"];
      user.picture = value.data()?["picture"];
      user.accountStatus = value.data()?["accountStatus"];
      user.name = value.data()?['name'];
      user.numberId = value.data()?["numberId"];
      user.phone = value.data()?["phone"];
      user.account_type = value.data()?['accountType'];
      user.plate = value.data()?['plateNumber'];
      final box = GetStorage();
      //print(user.toJson().toString());
      box.write("logged_user", user.toJson());
      //print("plate: ${user.plate}");
    });
  }

  Future<String?> storeTravel({required TravelHistoryModel travel}) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('travel_history');
      //print(travel.status);
      var json = travel.toJson();
      // //print(json)
      doc.add(json).then((value) {});
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateTravel(
      {required UserModel userModel,
      required String uid,
      required String status}) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('travel_history');
      var json = userModel.toJson();
      doc
          .doc(uid)
          .update({'driver': json, 'status': status})
          .then((value) => print("Success Update Travel"))
          .onError((error, stackTrace) => print(error));
      // doc.add(json).then((value) {});
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateTravel2(
      {required String uid, required String status}) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('travel_history');
      doc
          .doc(uid)
          .update({'status': status})
          .then((value) => print("Success"))
          .onError((error, stackTrace) => print(error));
      // doc.add(json).then((value) {});
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> storePayments({required PaymentModel payment}) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('payments');
      var json = payment.toJson();
      // doc.add(json).then((value) {});
      doc
          .doc(payment.uid)
          .set(json, SetOptions(merge: true))
          .then((value) => mail(payment));
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> cancelBooking(String? uid) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('travel_history');
      // doc.add(json).then((value) {});
      doc.doc(uid).delete();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> cancelDriver(String? uid) async {

    try {
      var doc = await FirebaseFirestore.instance.collection('travel_history');
      // doc.add(json).then((value) {});
       doc.doc(uid).update({'driver': null});
    } catch (e) {
      return e.toString();
    }
    return uid;
  }

  Future<String?> mail(PaymentModel payment) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('mail');

      doc.add({
        'to': "${payment.passenger!.email}",
        'message': {
          'subject': "Invoice for ${payment.uid}",
          'text': "This is the plaintext section of the email body.",
          'html': Constants().emailTemplate(payment),
        },
      }).then((val) => print("Queued email for delivery!"));
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> storeFav({required TravelHistoryModel travel}) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('favTravel');
      var json = travel.toJson();
      doc.add(json).then((value) {});
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<TravelHistoryModel>> getTravels(
    UserModel user,
    Function(String)? onError,
  ) async {
    List<TravelHistoryModel> travels = [];
    try {
      var doc = await FirebaseFirestore.instance.collection('travel_history');
      //print("Get Travel ${user.email} ${user.phone}");
      await doc
          .orderBy('createdAt', descending: true)
          .where('passenger.email', isEqualTo: user.email)
          .where('passenger.phone', isEqualTo: user.phone)
          .get()
          .then((value) {
        travels = value.docs.map((travel) {
          var data = travel.data();

          return TravelHistoryModel.fromJson(data);
        }).toList();
      });
    } catch (e) {
      if (onError != null) {
        onError(e.toString());
      }
    }
    // //print("Travel Data : ${travels.first.toString()}");
    return travels;
  }

  Future<List<TravelHistoryModel>> getBooking(
    UserModel user,
    Function(String)? onError,
  ) async {
    List<TravelHistoryModel> travels = [];
    try {
      var doc = await FirebaseFirestore.instance.collection('travel_history');
      await doc
          // .orderBy('createdAt', descending: true)
          .where('driver', isNull: true)
          .get()
          .then((value) {
        //print(value.docs.length);
        travels = value.docs.map((travel) {
          var data = travel.data();
          // //print(data.toString());

          data['uid'] = travel.id;
          // //print("Data String: ${data.toString()}");
          //print('Data UID: ${data.runtimeType}');
          //   //
          return TravelHistoryModel.fromJson2(data, travel.id);
          //   // return null;
        }).toList();
      });
    } catch (e) {
      if (onError != null) {
        onError(e.toString());
      }
    }
    // //print("Travel Data : ${travels.first.uid.toString()}");
    return travels;
  }

  Future<List<TravelHistoryModel>> getFav(
    UserModel user,
    Function(String)? onError,
  ) async {
    List<TravelHistoryModel> travels = [];
    try {
      var doc = await FirebaseFirestore.instance.collection('favTravel');
      //print("Get Travel ${user.email} ${user.phone}");
      await doc
          .orderBy('createdAt', descending: true)
          .where('passenger.email', isEqualTo: user.email)
          .where('passenger.phone', isEqualTo: user.phone)
          .get()
          .then((value) {
        travels = value.docs.map((travel) {
          var data = travel.data();

          return TravelHistoryModel.fromJson(data);
        }).toList();
      });
    } catch (e) {
      if (onError != null) {
        onError(e.toString());
      }
    }
    //print("Travel Data : ${travels.first.toString()}");
    return travels;
  }

  Future<void> setRiderLocation(
      UserModel user, double _long, double _lat) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('locations');
      doc.add({
        'long': _long,
        'lat': _lat,
        'userid': user.id,
        'userEmail': user.email
      }).then((value) => print(value));
      //print("ADDED");
    } catch (e) {
      //print("${e.toString()}");
    }
  }

  Future<void> setEmergency(TravelHistoryModel travel) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('accidents');
      var json = travel.toJson();
      travel.status = "Active";
      //print(travel.currentLocation!.displayName);
      doc.add(json).then((value) {});
    } catch (e) {
      // return e.toString();
      //print(e.toString());
    }
  }
}
