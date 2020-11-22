import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qpv_face_scanner/helper/configs.dart';
import 'package:qpv_face_scanner/local_storage.dart';

class NotificationBloc extends ChangeNotifier {
  Future sendNotification(title, description) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${Config().serverToken}',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': description,
            'title': title
          },
          'priority': 'normal',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': "${Config().serverToken}",
        },
      ),
    );
  }

  getUserTokenId() async {
    String userUID = LocalStorage.instance.getString('uid');
    String tokenId = '';
    await FirebaseFirestore.instance
        .collection('customerAccounts')
        .doc(userUID)
        .collection('tokens')
        .get()
        .then((value) {
      tokenId = value.docs.first.id;
    });

    return tokenId;
  }

  Future sendToAUser() async {
    FirebaseMessaging _fcm = FirebaseMessaging();
  }

  Future updateFaceIdentifyStatus(bool status) async {
    String uid = LocalStorage.instance.getString('uid');
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('customerAccounts').doc(uid);
    await ref.set({'confirmFace': status});
  }
}
