import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:qpv_face_scanner/components/animation/custom_bounce_on_tap.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/model/parcel.dart';
import 'package:qpv_face_scanner/ui/pickup_options_page.dart';

import '../constant.dart';
import '../local_storage.dart';
import 'available_parcel_page.dart';

class PickupReceiptPage extends StatefulWidget {
  final Parcel parcel;

  const PickupReceiptPage({Key key, this.parcel}) : super(key: key);
  @override
  _PickupReceiptPageState createState() => _PickupReceiptPageState(this.parcel);
}

class _PickupReceiptPageState extends State<PickupReceiptPage> {
  Parcel parcel;

  _PickupReceiptPageState(this.parcel);

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PickUpOptionPage()));
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
                    top: 8 * SizeConfig.heightMultiplier,
                    bottom: 6 * SizeConfig.heightMultiplier,
                    left: (Device.get().isTablet ? 10 : 5) *
                        SizeConfig.widthMultiplier),
                child: Container(
                  child: Text(
                    'Paperless receipt',
                    style: TextStyle(
                        color: ColorPalette.PrimaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RubikBold',
                        fontSize: 6 * SizeConfig.textMultiplier),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: (Device.get().isTablet ? 0 : 5) *
                          SizeConfig.widthMultiplier),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          3 * SizeConfig.heightMultiplier),
                    ),
                    child: Center(
                      child: Padding(
                        padding:
                            EdgeInsets.all(3 * SizeConfig.heightMultiplier),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Tracking #: ${parcel.tracking}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorPalette.PrimaryTextColor,
                                  fontSize: 2.2 * SizeConfig.textMultiplier,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            Container(
                              child: RichText(
                                  text: TextSpan(
                                      text: 'Picked up: ',
                                      style: TextStyle(
                                        color: ColorPalette.PrimaryTextColor,
                                        fontSize:
                                            2.2 * SizeConfig.textMultiplier,
                                        fontFamily: 'Rubik',
                                      ),
                                      children: <TextSpan>[
                                    TextSpan(
                                      text: '${DateTime.now()}',
                                      style: TextStyle(
                                        color: ColorPalette.PrimaryTextColor,
                                        fontSize:
                                            2.2 * SizeConfig.textMultiplier,
                                        fontFamily: 'RubikBold',
                                      ),
                                    )
                                  ])),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            Container(
                              child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                      text: 'Receiver: ',
                                      style: TextStyle(
                                        color: ColorPalette.PrimaryTextColor,
                                        fontSize:
                                            2.2 * SizeConfig.textMultiplier,
                                        fontFamily: 'Rubik',
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              '${LocalStorage.instance.getString('name')}',
                                          style: TextStyle(
                                            color:
                                                ColorPalette.PrimaryTextColor,
                                            fontSize:
                                                2.2 * SizeConfig.textMultiplier,
                                            fontFamily: 'RubikBold',
                                          ),
                                        )
                                      ])),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            Container(
                              child: Text(
                                'Station No. 1234, 8 Hoang Hoa Tham, Hue, Vietnam',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ColorPalette.PrimaryTextColor,
                                  fontSize: 2.2 * SizeConfig.textMultiplier,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                            MySeparator(
                              color: ColorPalette.PrimaryTextColor,
                            ),
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                            Container(
                              child: Text(
                                'Thank you!',
                                style: TextStyle(
                                  color: ColorPalette.PrimaryTextColor,
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                  fontFamily: 'RubikBold',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            Container(
                              child: Text(
                                'This will be emailed to you soon.',
                                style: TextStyle(
                                  color: ColorPalette.PrimaryTextColor,
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                  fontFamily: 'RubikBold',
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
            ],
          ),
        ),
      ),
    );
  }
}
