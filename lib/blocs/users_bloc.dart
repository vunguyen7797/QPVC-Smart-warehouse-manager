import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:qpv_face_scanner/model/parcel.dart';

import '../local_storage.dart';

class UserBloc extends ChangeNotifier {
  String _name;
  String get name => _name;
  set setName(newName) => _name = newName;

  String _uid;
  String get uid => _uid;
  set setUid(newUid) => _uid = newUid;

  String _email;
  String get email => _email;
  set setEmail(newEmail) => _email = newEmail;

  String _imageUrl;
  String get imageUrl => _imageUrl;
  set setImageUrl(newImageUrl) => _imageUrl = newImageUrl;

  String _address;
  String get address => _address;
  set setAddress(newAddress) => _address = newAddress;

  String _idCard;
  String get idCard => _idCard;
  set setIdCard(newIdCard) => _idCard = newIdCard;

  String _phone;
  String get phone => _phone;
  set setPhone(newPhone) => _phone = newPhone;

  String _userFaceID;
  String get userFaceID => _userFaceID;
  set setUserFaceID(newUserFaceID) => _userFaceID = newUserFaceID;

  String _customerGroupId;
  String get customerGroupId => _customerGroupId;
  set setCustomerGroupId(newCustomerGroupId) =>
      _customerGroupId = newCustomerGroupId;

  int _numOfFaces;
  int get numOfFaces => _numOfFaces;
  set setNumOfFaces(newNumOfFaces) => _numOfFaces = newNumOfFaces;

  int _recyclePoints;
  int get recyclePoints => _recyclePoints;
  set setRecyclePoints(newRecyclePoints) => _recyclePoints = newRecyclePoints;

  int _totalParcels;
  int get totalParcels => _totalParcels;
  set setTotalParcels(newTotalParcels) => _totalParcels = newTotalParcels;

  int _totalPickedUp;
  int get totalPickedUp => _totalPickedUp;
  set setTotalPickedUp(newTotalPickedUp) => _totalPickedUp = newTotalPickedUp;

  bool _confirmFace;
  bool get confirmFace => _confirmFace;
  set setConfirmFace(newConfirmFace) => _confirmFace = newConfirmFace;

  String _tokenId;
  String get tokenId => _tokenId;
  set setTokenId(newTokenId) => _tokenId = newTokenId;

  List _parcelList = [];
  List get parcelList => _parcelList;
  set setParcelList(newParcelList) => _parcelList = newParcelList;

  getUserWithFaceID(String userFaceId) async {
    await FirebaseFirestore.instance
        .collection('customerAccounts')
        .doc(userFaceID)
        .get()
        .then((DocumentSnapshot snap) {
      if (snap != null) {
        _uid = snap.data()['userUID'] ?? "";
        _name = snap.data()['name'] ?? "";
        _email = snap.data()['email'] ?? "";
        _imageUrl = snap.data()['photoUrl'] ?? "";
        _phone = snap.data()['phone'] ?? "";
        _numOfFaces = snap.data()['num_faces'] ?? 0;
        _userFaceID = snap.data()['userFaceID'] ?? "";
        _idCard = snap.data()['id_card'] ?? "";
        _address = snap.data()['addr'] ?? "";
        _customerGroupId = snap.data()['customerGroupId'] ?? "";
        _confirmFace = snap.data()['confirmFace'];
      } else {
        _uid = "";
        _name = "";
        _email = "";
        _imageUrl = "";
        _phone = "";
        _numOfFaces = 0;
        _userFaceID = "";
        _idCard = "";
        _address = "";
        _customerGroupId = "";
        _confirmFace = false;
      }
    });
    notifyListeners();
  }

  getUserFirestore() async {
    String _userUid = LocalStorage.instance.get('customerUID');
    await FirebaseFirestore.instance
        .collection('customerAccounts')
        .doc(_userUid)
        .get()
        .then((DocumentSnapshot snap) {
      _uid = snap.data()['userUID'] ?? "";
      _name = snap.data()['name'] ?? "";
      _email = snap.data()['email'] ?? "";
      _imageUrl = snap.data()['photoUrl'] ?? "";
      _phone = snap.data()['phone'] ?? "";
      _numOfFaces = snap.data()['num_faces'] ?? 0;
      _userFaceID = snap.data()['userFaceID'] ?? "";
      _idCard = snap.data()['id_card'] ?? "0000000000";
      _address = snap.data()['addr'] ?? "";
      _customerGroupId = snap.data()['customerGroupId'] ?? "";
      _recyclePoints = snap.data()['recyclePoints'] ?? 0;
      _totalParcels = snap.data()['totalParcels'] ?? 0;
      _totalPickedUp = snap.data()['totalPickedUp'] ?? 0;
    });
    notifyListeners();
  }

  getUserParcels(userUid) async {
    await FirebaseFirestore.instance
        .collection('customerAccounts')
        .doc(userUid)
        .collection('parcels')
        .get()
        .then((value) {
      for (QueryDocumentSnapshot item in value.docs) {
        _parcelList.add(Parcel.fromMap(item.data()));
      }
    });
    _parcelList.sort((b, a) => a.timestamp.compareTo(b.timestamp));
    print(_parcelList.length);
    notifyListeners();
  }

//  updateUserFirestore(
//      {photoUrl, displayName, gender, location, phoneNumber, birthday}) async {
//    final SharedPreferences localStorage =
//        await SharedPreferences.getInstance();
//    String _userUid = localStorage.getString('uid');
//    print(_userUid);
//    await Firestore.instance.collection('users').document(_userUid).updateData({
//      'photoUrl': photoUrl,
//      'displayName': displayName,
//      'gender': gender,
//      'location': location,
//      'phoneNumber': phoneNumber,
//      'birthday': birthday,
//    });
//
//    _name = displayName;
//
//    _imageUrl = photoUrl;
//
//    _idCard = birthday;
//
//    _phone = gender;
//
//    _userFaceID = phoneNumber;
//
//    _address = location;
//
//    notifyListeners();
//  }
}
