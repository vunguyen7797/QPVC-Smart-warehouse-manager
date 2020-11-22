import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qpv_face_scanner/constant.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/ui/qr_scan_page.dart';

class LoadingQRPage extends StatefulWidget {
  @override
  _LoadingQRPageState createState() => _LoadingQRPageState();
}

class _LoadingQRPageState extends State<LoadingQRPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => QrScannerPage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 5 * SizeConfig.widthMultiplier),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Please try again with your QR Code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorPalette.PrimaryTextColor,
                      fontFamily: 'RubikBold',
                      fontSize: 5 * SizeConfig.textMultiplier),
                ),
              ),
              SizedBox(
                height: 2 * SizeConfig.heightMultiplier,
              ),
              Container(
                child: SpinKitFadingFour(
                  color: ColorPalette.PrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
