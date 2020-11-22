import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:provider/provider.dart';
import 'package:qpv_face_scanner/blocs/users_bloc.dart';
import 'package:qpv_face_scanner/components/animation/custom_bounce_on_tap.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/ui/recycle_points_page.dart';

import '../constant.dart';

class PickUpOptionPage extends StatefulWidget {
  final speech;

  const PickUpOptionPage({Key key, this.speech}) : super(key: key);
  @override
  _PickUpOptionPageState createState() => _PickUpOptionPageState();
}

class _PickUpOptionPageState extends State<PickUpOptionPage> {
  String _text = 'Do you want to donate used boxes?';
  String _choice;

//  void _listen(UserBloc userBloc) async {
//    _speech.startSpeechListenService;
//    _speech.getSpeechResults().onData((data) async {
////      _speech.confirmIntent(
////          confirmationText: "Say yes to confirm",
////          positiveCommand: "yes",
////          negativeCommand: "no");
//      setState(() {
//        _text = 'Your choice is ' + data.result;
//        _choice = data.result;
//        print('HELLO' + _text);
//      });
//
//      if (data.result == 'yes') {
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => RecyclePointsPage()));
//      } else if (data.result == 'no') {
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => ThankYouPage()));
//      }
//    });
//
////    _speech.getConfirmationResults().onData((data) {
////      print(
////          "getConfirmationResults: Confirmation Text: ${data.confirmationIntent} , "
////          "User Replied: ${data.confirmedResult} , "
////          "Is Confirmation Success?: ${data.isSuccess}");
////      if (data.confirmedResult == 'yes') {
////
////      }
////    });
//  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(minutes: 0)).then((_) async {
      final UserBloc userBloc = Provider.of<UserBloc>(context);
      await userBloc.getUserFirestore();

      //_listen(userBloc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F8FA),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                      color: ColorPalette.SecondaryColor.withOpacity(0.5),
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
                    bottom: 5 * SizeConfig.heightMultiplier,
                    left: (Device.get().isTablet ? 10 : 5) *
                        SizeConfig.widthMultiplier,
                    right: (Device.get().isTablet ? 10 : 5) *
                        SizeConfig.widthMultiplier),
                child: Container(
                  child: Text(
                    '$_text',
                    style: TextStyle(
                        color: ColorPalette.PrimaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RubikBold',
                        fontSize: (Device.get().isTablet ? 7 : 5) *
                            SizeConfig.textMultiplier),
                  ),
                ),
              ),
              SizedBox(
                height: 4 * SizeConfig.heightMultiplier,
              ),
              CustomBounceAnimation(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecyclePointsPage()));
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10 * SizeConfig.widthMultiplier),
                    child: Container(
                      height: 25 * SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                        color: ColorPalette.AccentColor,
                        borderRadius: BorderRadius.circular(
                            3 * SizeConfig.heightMultiplier),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: (Device.get().isTablet ? 0 : 5) *
                                  SizeConfig.widthMultiplier),
                          child: Text(
                            'Drop-off used boxes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 4 * SizeConfig.textMultiplier,
                              fontFamily: 'RubikMedium',
                            ),
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
    );
  }
}
