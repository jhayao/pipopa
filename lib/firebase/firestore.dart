import 'package:cloud_firestore/cloud_firestore.dart';
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
    });
  }

  Future<UserModel?> getUser(
      {String? uid,
      String? phone,
      Function(DocumentSnapshot<Map<String, dynamic>>?)? callbak}) async {
    if (uid == null) {
      return null;
    }
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      if (callbak != null) {
        callbak(value);
      }
    });

    if (phone != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get()
          .then((value) {
        if (callbak != null) {
          var val = value.size > 0 ? value.docs.first : null;
          callbak(val);
        }
      });
    }

    var json = userDoc.data();

    if (json == null) {
      return null;
    }

    return UserModel.fromJson(userDoc.data()!);
  }

  Future<String?> storeTravel({required TravelHistoryModel travel}) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('travel_history');
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
    return travels;
  }
}
