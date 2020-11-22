import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:provider/provider.dart';
import 'package:qpv_face_scanner/blocs/authenticate_bloc.dart';
import 'package:qpv_face_scanner/components/animation/custom_bounce_on_tap.dart';
import 'package:qpv_face_scanner/components/animation/custom_fade_in.dart';
import 'package:qpv_face_scanner/constant.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:shimmer/shimmer.dart';

import 'dashboard_page.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 10 * SizeConfig.heightMultiplier),
                  child: Center(
                    child: Container(
                      child: Image.asset('res/images/welcome.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: Device.get().isTablet
                          ? 100
                          : 10 * SizeConfig.widthMultiplier,
                      top: 50),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'QPVC Face ID',
                          style: TextStyle(
                              color: ColorPalette.PrimaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RubikBold',
                              fontSize: 4 * SizeConfig.textMultiplier),
                        ),
                        Text(
                          'Smart Parcel Pick-up',
                          style: TextStyle(
                              color: ColorPalette.PrimaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RubikBold',
                              fontSize: 4 * SizeConfig.textMultiplier),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomBounceAnimation(
                  onTap: () async {
                    final AuthenticateBloc signInBloc =
                        Provider.of<AuthenticateBloc>(context);

                    signInBloc.isLoggedIn();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => signInBloc.isSignedIn == false
                                ? LoginPage()
                                : CustomFadeIn(
                                    transform: false,
                                    transformDuration: 0,
                                    delay: 0,
                                    child: DashboardPage())));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 150.0),
                    child: Center(
                      child: Container(
                        height: 7 * SizeConfig.heightMultiplier,
                        width: 50 * SizeConfig.widthMultiplier,
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
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: Color(0xff253B80),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 50,
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
    );
  }
}
