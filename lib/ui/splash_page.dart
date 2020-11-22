import 'package:flutter/material.dart';
import 'package:qpv_face_scanner/components/animation/custom_fade_in.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/ui/welcome_page.dart';
import 'package:shimmer/shimmer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key key,
  }) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomePage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff4C87D5),
              Color(0xff1256B1),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: CustomFadeIn(
            transform: false,
            delay: 0.0,
            opacityDuration: 1000,
            transformDuration: 0,
            child: Center(
              child: Container(
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Color(0xff253B80),
                  child: Text(
                    'QPVC',
                    style: TextStyle(
                        fontFamily: 'RubikBold',
                        fontWeight: FontWeight.bold,
                        fontSize: 6 * SizeConfig.textMultiplier),
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
