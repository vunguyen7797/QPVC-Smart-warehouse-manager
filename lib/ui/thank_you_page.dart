import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:qpv_face_scanner/components/animation/custom_bounce_on_tap.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';

import '../constant.dart';
import 'camera_page.dart';

class ThankYouPage extends StatefulWidget {
  @override
  _ThankYouPageState createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CameraApp()));
    });
    super.initState();
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
                    top: 20 * SizeConfig.heightMultiplier,
                    left: 5 * SizeConfig.widthMultiplier),
                child: Container(
                  child: Text(
                    'Thank you!',
                    style: TextStyle(
                        color: ColorPalette.PrimaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RubikBold',
                        fontSize: 7 * SizeConfig.textMultiplier),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 8 * SizeConfig.heightMultiplier,
                    bottom: 5 * SizeConfig.heightMultiplier,
                    left: 5 * SizeConfig.widthMultiplier,
                    right: 5 * SizeConfig.widthMultiplier),
                child: Container(
                  child: Text(
                    'Your recycle points will be updated in your account soon.',
                    style: TextStyle(
                        color: ColorPalette.PrimaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RubikBold',
                        fontSize: 6 * SizeConfig.textMultiplier),
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
