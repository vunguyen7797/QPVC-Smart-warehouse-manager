import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:qpv_face_scanner/components/animation/custom_bounce_on_tap.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/ui/thank_you_page.dart';

import '../constant.dart';

class RecyclePointsPage extends StatefulWidget {
  @override
  _RecyclePointsPageState createState() => _RecyclePointsPageState();
}

class _RecyclePointsPageState extends State<RecyclePointsPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ThankYouPage()));
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
              CustomBounceAnimation(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ThankYouPage()));
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 8 * SizeConfig.heightMultiplier,
                      bottom: 5 * SizeConfig.heightMultiplier,
                      left: 10 * SizeConfig.widthMultiplier,
                      right: 10 * SizeConfig.widthMultiplier),
                  child: Container(
                    child: Text(
                      'Recycle points',
                      style: TextStyle(
                          color: ColorPalette.PrimaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RubikBold',
                          fontSize: 7 * SizeConfig.textMultiplier),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10 * SizeConfig.widthMultiplier),
                  child: Container(
                    height: 30 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                        color: ColorPalette.AccentColor,
                        borderRadius: BorderRadius.circular(
                            3 * SizeConfig.heightMultiplier)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Container(
                          child: Text(
                            '123',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13 * SizeConfig.textMultiplier,
                              fontFamily: 'RubikBold',
                            ),
                          ),
                        )),
                        Center(
                            child: Container(
                          child: Text(
                            '10 more to get our discount!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 2 * SizeConfig.textMultiplier,
                              fontFamily: 'RubikSemiBold',
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5 * SizeConfig.heightMultiplier,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10 * SizeConfig.widthMultiplier),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 20 * SizeConfig.heightMultiplier,
                        width: 20 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              3 * SizeConfig.heightMultiplier),
                          color: ColorPalette.PrimaryColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier),
                            child: Text(
                              'Used cardboard boxes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                fontFamily: 'RubikMedium',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
