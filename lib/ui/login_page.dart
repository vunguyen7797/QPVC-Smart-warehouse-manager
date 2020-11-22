import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:qpv_face_scanner/blocs/authenticate_bloc.dart';
import 'package:qpv_face_scanner/components/animation/custom_bounce_on_tap.dart';
import 'package:qpv_face_scanner/components/animation/custom_fade_in.dart';
import 'package:qpv_face_scanner/components/custom_text_field.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/ui/dashboard_page.dart';

import '../constant.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  Icon _suffixIconController = Icon(FlevaIcons.eye_off, color: Colors.grey);

  /// Show password controller
  bool _showPassword = true;

  /// Check if the login is success or not
  bool _isNotSuccess = false;

  /// Check if the fields are empty
  bool _isEmpty = false;

  /// Show loading spinner in async task
  bool _showSpinner = false;

  /// Event when users tap on Show password icon
  void _onTapShowPassword() {
    if (_showPassword == true)
      setState(() {
        _showPassword = false;
        _suffixIconController = Icon(
          FlevaIcons.eye,
          color: Colors.grey,
          size: 3 * SizeConfig.textMultiplier,
        );
      });
    else {
      setState(() {
        _showPassword = true;
        _suffixIconController = Icon(FlevaIcons.eye_off,
            color: Colors.grey, size: 3 * SizeConfig.textMultiplier);
      });
    }
  }

  /// Sign-in using registered email and password
  void _signInWithEmailPassword(BuildContext context) async {
    setState(() {
      _showSpinner = true;
    });

    // Fields are not empty
    if (_emailController.text != "" && _passwordController.text != "") {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      final AuthenticateBloc signInBloc =
          Provider.of<AuthenticateBloc>(context);
      await signInBloc
          .signInWithEmailAndPassword(
              _emailController.text, _passwordController.text, context)
          .then((_) {
        _updateUserDataLogin(signInBloc);
      });

      if (signInBloc.hasError) {
        setState(() {
          _isNotSuccess = true;
        });
      }
      setState(() {
        _showSpinner = false;
      });
    } else // Fields are not empty
    {
      setState(() {
        _showSpinner = false;
        _isNotSuccess = false;
        _isEmpty = true;
      });
    }
  }

  void _updateUserDataLogin(signInBloc) {
    if (signInBloc.hasError == true ||
        signInBloc.uid == null ||
        signInBloc.uid == "") {
      setState(() {
        _isNotSuccess = true;
      });
    } else {
      print('Update user data: ${signInBloc.uid}');
      signInBloc.userExistCheck().then((value) {
        if (signInBloc.userExists) {
          setState(() {
            _showSpinner = false;
          });

          signInBloc.setUidToLocalStorage().then((value) => signInBloc
              .setSignInStatus()
              .then((value) => Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => DashboardPage()))));
        } else {
          setState(() {
            _showSpinner = false;
          });
          signInBloc.setUidToLocalStorage().then((value) => signInBloc
              .addUserToFirestoreDatabase()
              .then((value) => signInBloc.setSignInStatus().then((value) =>
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => DashboardPage())))));
        }
      });
    }
    ;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          progressIndicator: SpinKitFadingFour(
            color: ColorPalette.PrimaryColor,
          ),
          inAsyncCall: _showSpinner,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBounceAnimation(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 5 * SizeConfig.heightMultiplier,
                              left: 5 * SizeConfig.widthMultiplier),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color:
                                  ColorPalette.SecondaryColor.withOpacity(0.5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Icon(
                                FlevaIcons.arrow_back,
                                color: Colors.black,
                                size: 3 * SizeConfig.textMultiplier,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8 * SizeConfig.heightMultiplier,
                            bottom: 4 * SizeConfig.heightMultiplier,
                            left: 12 * SizeConfig.widthMultiplier),
                        child: Container(
                          child: Text(
                            'Hello there!',
                            style: TextStyle(
                                color: ColorPalette.PrimaryTextColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RubikBold',
                                fontSize: 7 * SizeConfig.textMultiplier),
                          ),
                        ),
                      ),
                      (_isNotSuccess == true)
                          ? Center(
                              child: Text(
                                'Incorrect email address or password.',
                                style: TextStyle(
                                  color: ColorPalette.AccentColor,
                                  fontSize: 1.75 *
                                      SizeConfig.textMultiplier, // = size 14
                                  fontFamily: 'RubikBold',
                                ),
                              ),
                            )
                          : (_isEmpty == true
                              ? Center(
                                  child: Text(
                                    'Please enter all required fields.',
                                    style: TextStyle(
                                      color: ColorPalette.AccentColor,
                                      fontSize: 1.75 *
                                          SizeConfig
                                              .textMultiplier, // = size 14
                                      fontFamily: 'RubikBold',
                                    ),
                                  ),
                                )
                              : Container()),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10 * SizeConfig.widthMultiplier),
                        child: CustomFadeIn(
                            transform: false,
                            delay: 3.0,
                            opacityDuration: 300,
                            transformDuration: 0,
                            child: CustomTextField(
                                hintText: 'Staff Account ID',
                                controller: _emailController,
                                obscureTextMode: false)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10 * SizeConfig.widthMultiplier),
                        child: CustomFadeIn(
                            transform: false,
                            delay: 3.0,
                            opacityDuration: 300,
                            transformDuration: 0,
                            child: CustomTextField(
                                showPassword: _showPassword,
                                onTapShowPassword: _onTapShowPassword,
                                suffixIconController: _suffixIconController,
                                hintText: 'Password',
                                controller: _passwordController,
                                obscureTextMode: true)),
                      ),
                      CustomBounceAnimation(
                        onTap: () async {
                          _signInWithEmailPassword(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10 * SizeConfig.heightMultiplier,
                            bottom: 5 * SizeConfig.heightMultiplier,
                          ),
                          child: Center(
                            child: Container(
                              height: 7 * SizeConfig.heightMultiplier,
                              width: 40 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xff4C87D5),
                                      Color(0xff1256B1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
