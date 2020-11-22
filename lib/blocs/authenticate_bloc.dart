import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateBloc extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  set isSignedIn(newVal) => _isSignedIn = newVal;

  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(newError) => _hasError = newError;

  bool _userExists = false;
  bool get userExists => _userExists;
  set setUserExist(bool value) => _userExists = value;

  String _name;
  String get name => _name;
  set setName(newName) => _name = newName;

  String _uid;
  String get uid => _uid;
  set setUid(newUid) => _uid = newUid;

  String _email;
  String get email => _email;
  set setEmail(newEmail) => _email = newEmail;

  String _address;
  String get address => _address;
  set setAddress(newAddress) => _address = newAddress;

  // Check if user is already login or not
  AuthenticateBloc() {
    isLoggedIn();
  }

  void isLoggedIn() async {
    final SharedPreferences ldb = await SharedPreferences.getInstance();

    // if login is null, user need to login
    _isSignedIn = ldb.getBool('login') ?? false;
    notifyListeners();
  }

  Future setSignInStatus() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('login', true);
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, context) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user;
      this._name = user.displayName ?? "";
      this._email = user.email ?? "";
      this._address = user.photoURL ?? "";
      this._uid = user.uid;
      if (user.uid != null || user.uid != "") {
        this._uid = user.uid;
        _hasError = false;
      } else
        _hasError = true;
      notifyListeners();
    } catch (e) {
      _hasError = true;

      notifyListeners();
    }
  }

  /* Future<void> signInWithTwitter(context) async {
    try {
      bool isLoggedIn = await _twitterLogin.isSessionActive;
      if (!isLoggedIn) {
        final TwitterLoginResult result = await _twitterLogin.authorize();
        if (result.status == TwitterLoginStatus.loggedIn) {
          final token = result.session.token;
          final tokenSecret = result.session.secret;
          final credential = TwitterAuthProvider.getCredential(
              authTokenSecret: tokenSecret, authToken: token);
          FirebaseUser firebaseUser =
              (await _firebaseAuth.signInWithCredential(credential)).user;

          this._name = firebaseUser.displayName ?? "";
          this._email = firebaseUser.email ?? "";
          this._imageUrl = firebaseUser.photoUrl ?? "";
          this._uid = firebaseUser.uid;

          if (firebaseUser.uid != null || firebaseUser.uid != "") {
            this._uid = firebaseUser.uid;
            _hasError = false;
          } else
            _hasError = true;
          notifyListeners();
        }
      }
    } catch (e) {
      hasError = false;
      return false;
    }
  }*/

  Future userExistCheck() async {
    await FirebaseFirestore.instance
        .collection('staffs')
        .get()
        .then((QuerySnapshot snap) {
      List values = snap.docs;
      List userIds = [];
      values.forEach((element) {
        userIds.add(element['uid']);
      });
      if (userIds.contains(_uid)) {
        _userExists = true;
      } else {
        _userExists = false;
      }
      notifyListeners();
    });
  }

  Future getUserFirestore() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String _userUid = sp.getString('uid');
    await FirebaseFirestore.instance
        .collection('staffs')
        .doc("Bc8EKAZJbfMff1ogNQFTNrW1NwU2")
        .get()
        .then((DocumentSnapshot snap) {
      _uid = snap.data()['uid'];
      _name = snap.data()['displayName'];
      _address = snap.data()['address'];
      _email = snap.data()['email'];
    });
    notifyListeners();
  }

  Future addUserToFirestoreDatabase() async {
    print('Adding user to database: $uid');
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('staffs').doc(uid);
    await ref.set({
      'uid': uid,
      'email': email,
      'displayName': name,
      'address': address,
    });
  }

  Future setUidToLocalStorage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('uid', _uid);
    await sharedPreferences.setString('address', _address);
    await sharedPreferences.setString('name', _name);
  }

//
//  Future<bool> updatePassword(String password) async {
//    try {
//      bool result;
//      FirebaseUser user = await FirebaseAuth.instance.currentUser();
//      await user.updatePassword(password).then((value) {
//        print('result is true');
//        result = true;
//        return result;
//      }).catchError((onError) {
//        print('result is false');
//        result = false;
//        return result;
//      });
//      return result;
//    } catch (e) {
//      print(e);
//      return false;
//    }
//  }

  Future<void> signOut() async {
    print('Signed out');
    clearAllData();
    _isSignedIn = false;
    await _firebaseAuth.signOut();
    // await _twitterLogin.logOut();
  }

  void clearAllData() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    localStorage.clear();
  }
}
