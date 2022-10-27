import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:passit/models/userModel.dart';

import '../models/travelHistoryModel.dart';

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
      // print("VALUE GETUSER ${value.data()?['email']}");
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
      print(user.toJson().toString());
      box.write("logged_user", user.toJson());
      print("plate: ${user.plate}");
    });
  }

  Future<String?> storeTravel({required TravelHistoryModel travel}) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('travel_history');
      print(travel.status);
      var json = travel.toJson();
      // print(json)
      doc.add(json).then((value) {});
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateTravel(
      {required UserModel userModel, required String uid}) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('travel_history');
      var json = userModel.toJson();
      doc
          .doc(uid)
          .update({'driver': json, 'status': 'The driver is on the way'})
          .then((value) => print("Success"))
          .onError((error, stackTrace) => print(error));
      // doc.add(json).then((value) {});
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
      print("Get Travel ${user.email} ${user.phone}");
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
    // print("Travel Data : ${travels.first.toString()}");
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
        print(value.docs.length);
        travels = value.docs.map((travel) {
          var data = travel.data();
          // print(data.toString());

          data['uid'] = travel.id;
          // print("Data String: ${data.toString()}");
          print('Data UID: ${data.runtimeType}');
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
    print("Travel Data : ${travels.first.uid.toString()}");
    return travels;
  }

  Future<List<TravelHistoryModel>> getFav(
    UserModel user,
    Function(String)? onError,
  ) async {
    List<TravelHistoryModel> travels = [];
    try {
      var doc = await FirebaseFirestore.instance.collection('favTravel');
      print("Get Travel ${user.email} ${user.phone}");
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
    print("Travel Data : ${travels.first.toString()}");
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
      print("ADDED");
    } catch (e) {
      print("${e.toString()}");
    }
  }

  Future<void> setEmergency(TravelHistoryModel travel) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('accidents');
      var json = travel.toJson();
      travel.status = "Active";
      print(travel.currentLocation!.displayName);
      doc.add(json).then((value) {});
    } catch (e) {
      // return e.toString();
      print(e.toString());
    }
  }
}
