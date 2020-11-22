import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qpv_face_scanner/blocs/authenticate_bloc.dart';
import 'package:qpv_face_scanner/components/animation/custom_bounce_on_tap.dart';
import 'package:qpv_face_scanner/components/custom_clipper.dart';
import 'package:qpv_face_scanner/constant.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/model/customers.dart';
import 'package:qpv_face_scanner/ui/camera_page.dart';
import 'package:qpv_face_scanner/ui/user_info_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _date = '';
  String _stationNo = '';
  String _address = '';
  bool _loading = true;

  void _getDate() {
    DateTime now = new DateTime.now();

    var formatter = new DateFormat('MMMM dd, yyyy');
    _date = formatter.format(now);
  }

  @override
  void initState() {
    super.initState();
    _getDate();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      final AuthenticateBloc authenticateBloc =
          Provider.of<AuthenticateBloc>(context);
      await authenticateBloc.getUserFirestore();
      _stationNo = authenticateBloc.name ?? "Unknown";
      _address = authenticateBloc.address ?? "Unknown";
      _loading = false;
    });
  }

  Widget build(BuildContext context) {
    final AuthenticateBloc authenticateBloc =
        Provider.of<AuthenticateBloc>(context);
    return Scaffold(
        backgroundColor: Color(0xffF5F8FA),
        body: _loading
            ? Center(
                child: SpinKitFadingFour(
                color: ColorPalette.PrimaryColor,
              ))
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    CustomizeClipper(
                      clipType:
                          Device.get().isTablet ? ClipType.waved : ClipType.arc,
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height *
                            (Device.get().isTablet ? 0.63 : 0.57),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color(0xff72A8F0),
                                Color(0xff4878CC),
                                Color(0xff4878CC)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                        ),
                      ),
                    ),
                    Positioned(
                        child: Align(
                      alignment: Alignment.center,
                      child: SafeArea(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8 * SizeConfig.heightMultiplier,
                                left: Device.get().isTablet
                                    ? 0
                                    : 5 * SizeConfig.widthMultiplier,
                                right: Device.get().isTablet
                                    ? 0
                                    : 5 * SizeConfig.widthMultiplier,
                              ),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomBounceAnimation(
                                          onTap: () async {
                                            authenticateBloc.clearAllData();
                                            authenticateBloc.signOut();
                                            Navigator.pushReplacementNamed(
                                                context, '/');
                                          },
                                          child: Text(
                                            'Welcome',
                                            style: TextStyle(
                                              fontSize:
                                                  6 * SizeConfig.textMultiplier,
                                              fontFamily: 'RubikBold',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              5 * SizeConfig.heightMultiplier,
                                        ),
                                        Text(
                                          'Today is ' + _date,
                                          style: TextStyle(
                                            fontSize:
                                                2.5 * SizeConfig.textMultiplier,
                                            fontFamily: 'Rubik',
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              1.5 * SizeConfig.heightMultiplier,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              text: 'Station ',
                                              style: TextStyle(
                                                fontSize: 2.5 *
                                                    SizeConfig.textMultiplier,
                                                fontFamily: 'Rubik',
                                                color: Colors.white,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'No. ' + _stationNo,
                                                  style: TextStyle(
                                                    fontSize: 2.5 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontFamily: 'RubikBold',
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ]),
                                        ),
                                        SizedBox(
                                          height:
                                              1.5 * SizeConfig.heightMultiplier,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              FlevaIcons.pin,
                                              color: Colors.white,
                                              size: 2.5 *
                                                  SizeConfig.textMultiplier,
                                            ),
                                            SizedBox(
                                              width: 0.8 *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            Text(
                                              _address,
                                              style: TextStyle(
                                                fontSize: 2.5 *
                                                    SizeConfig.textMultiplier,
                                                fontFamily: 'Rubik',
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Device.get().isTablet
                                        ? Container(
                                            child: Image.asset(
                                                'res/images/qpv_logo.png'),
                                          )
                                        : Expanded(
                                            child: Container(
                                                child: Image.asset(
                                                    'res/images/qpv_logo.png'))),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: (Device.get().isTablet ? 8 : 10) *
                                  SizeConfig.heightMultiplier,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomBounceAnimation(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CameraApp()));
                                    },
                                    child: Container(
                                      height: Device.get().isTablet
                                          ? 25 * SizeConfig.heightMultiplier
                                          : 18 * SizeConfig.heightMultiplier,
                                      width: 35 * SizeConfig.widthMultiplier,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              3 * SizeConfig.heightMultiplier),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xff89D1FF)
                                                  .withOpacity(0.2),
                                              offset: Offset(0, 1),
                                              blurRadius: 30,
                                              spreadRadius: 0,
                                            )
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            2 * SizeConfig.heightMultiplier),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Image.asset(
                                                  'res/images/face_icon.png',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 1 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            Text(
                                              'Face Scanner',
                                              style: TextStyle(
                                                  fontFamily: 'RubikBold',
                                                  color: ColorPalette
                                                      .PrimaryTextColor,
                                                  fontSize: 2 *
                                                      SizeConfig
                                                          .textMultiplier),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: (Device.get().isTablet ? 25 : 18) *
                                        SizeConfig.heightMultiplier,
                                    width: 35 * SizeConfig.widthMultiplier,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            3 * SizeConfig.heightMultiplier),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xff89D1FF)
                                                .withOpacity(0.2),
                                            offset: Offset(0, 1),
                                            blurRadius: 30,
                                            spreadRadius: 0,
                                          )
                                        ]),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          2 * SizeConfig.heightMultiplier),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Image.asset(
                                                'res/images/setting_icon.png',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                1 * SizeConfig.heightMultiplier,
                                          ),
                                          Text(
                                            'Settings',
                                            style: TextStyle(
                                                fontFamily: 'RubikBold',
                                                color: ColorPalette
                                                    .PrimaryTextColor,
                                                fontSize: 2 *
                                                    SizeConfig.textMultiplier),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5 * SizeConfig.heightMultiplier,
                            ),
                            CustomBounceAnimation(
                              onTap: () {
                                Customer customer = new Customer(
                                    displayName: 'Vu Nguyen',
                                    email: 'vu.nguyen7797@gmail.com',
                                    phoneNumber: '0981234567',
                                    address: '7B/56 Hai Trieu, Hue, TTHue',
                                    idCard: '215645987');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserInfoPage(
                                              customer: customer,
                                            )));
                              },
                              child: Container(
                                height: 20 * SizeConfig.heightMultiplier,
                                width: 80 * SizeConfig.widthMultiplier,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        3 * SizeConfig.heightMultiplier),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xff89D1FF).withOpacity(0.2),
                                        offset: Offset(0, 1),
                                        blurRadius: 30,
                                        spreadRadius: 0,
                                      )
                                    ]),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 2 * SizeConfig.heightMultiplier),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Image.asset(
                                            'res/images/station_manager_icon.png',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Station Manager',
                                        style: TextStyle(
                                            fontFamily: 'RubikBold',
                                            color:
                                                ColorPalette.PrimaryTextColor,
                                            fontSize:
                                                2 * SizeConfig.textMultiplier),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ));
  }
}
