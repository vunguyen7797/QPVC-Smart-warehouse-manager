import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qpv_face_scanner/constant.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/ui/camera_page.dart';

class AssistantPage extends StatefulWidget {
  @override
  _AssistantPageState createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10 * SizeConfig.widthMultiplier),
              child: Center(
                  child: Text(
                'Please call this number for assistant: 0912299999',
                style: TextStyle(
                    color: ColorPalette.PrimaryTextColor,
                    fontFamily: 'RubikBold',
                    fontSize: 6 * SizeConfig.textMultiplier),
              )),
            ),
          )),
    );
  }
}
