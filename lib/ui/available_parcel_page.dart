import 'package:background_stt/background_stt.dart';
import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:provider/provider.dart';
import 'package:qpv_face_scanner/blocs/users_bloc.dart';
import 'package:qpv_face_scanner/components/animation/custom_bounce_on_tap.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/model/parcel.dart';
import 'package:qpv_face_scanner/ui/pickup_receipt_page.dart';

import '../constant.dart';

class AvailableParcelPage extends StatefulWidget {
  final String uid;

  const AvailableParcelPage({Key key, this.uid}) : super(key: key);
  @override
  _AvailableParcelPageState createState() =>
      _AvailableParcelPageState(this.uid);
}

class _AvailableParcelPageState extends State<AvailableParcelPage> {
  String uid;
  BackgroundStt _speech = BackgroundStt();
  String _text = 'Please say the slot number that you want to pick up';
  String _choice;

  _AvailableParcelPageState(this.uid);

  void _listen() async {
    _speech.startSpeechListenService;

    _speech.getSpeechResults().onData((data) async {
//      _speech.confirmIntent(
//          confirmationText: "Say yes to confirm",
//          positiveCommand: "yes",
//          negativeCommand: "no");
      setState(() {
        _text = 'Your choice is ' + data.result;
        _choice = data.result;
        print('HELLO' + _text);
      });

      final UserBloc userBloc = Provider.of<UserBloc>(context);

      int result = userBloc.parcelList.indexWhere(
          (element) => element.slot.toString().contains(_choice) == true);

      for (var item in userBloc.parcelList) print(item.slot.toString());
      if (result != -1) {
        _speech.stopSpeechListenService;
        _speech.cancelConfirmation;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PickupReceiptPage(
                      parcel: userBloc.parcelList[result],
                    )));
      } else {
        print('Failed search');
      }
    });

//    _speech.getConfirmationResults().onData((data) {
//      print(
//          "getConfirmationResults: Confirmation Text: ${data.confirmationIntent} , "
//          "User Replied: ${data.confirmedResult} , "
//          "Is Confirmation Success?: ${data.isSuccess}");
//      if (data.confirmedResult == 'yes') {
//
//      }
//    });
  }

  @override
  void dispose() {
    print('Disposing');
    _speech.stopSpeechListenService;
    _speech.cancelConfirmation;
    super.dispose();
  }

  @override
  void initState() {
    _listen();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    return Scaffold(
      backgroundColor: Color(0xffF5F8FA),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                  bottom: 2 * SizeConfig.heightMultiplier,
                  left: 5 * SizeConfig.widthMultiplier,
                  right: 5 * SizeConfig.widthMultiplier),
              child: Container(
                child: Text(
                  'Your available parcels',
                  style: TextStyle(
                      color: ColorPalette.PrimaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RubikBold',
                      fontSize: 6 * SizeConfig.textMultiplier),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 2 * SizeConfig.heightMultiplier,
                  left: 5 * SizeConfig.widthMultiplier,
                  right: 5 * SizeConfig.widthMultiplier),
              child: Container(
                child: Text(
                  _text,
                  style: TextStyle(
                      color: ColorPalette.PrimaryTextColor,
                      fontFamily: 'Rubik',
                      fontSize: (Device.get().isTablet ? 3 : 2.5) *
                          SizeConfig.textMultiplier),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                    itemCount: userBloc.parcelList.length,
                    itemBuilder: (_, int index) => CustomBounceAnimation(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PickupReceiptPage(
                                        parcel: userBloc.parcelList[index],
                                      )));
                        },
                        child: ParcelCardWidget(
                            parcel: userBloc.parcelList[index]))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ParcelCardWidget extends StatelessWidget {
  final Parcel parcel;

  const ParcelCardWidget({
    Key key,
    this.parcel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 5 * SizeConfig.widthMultiplier,
          vertical: 2 * SizeConfig.heightMultiplier),
      child: Center(
        child: Container(
          height: 25 * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(3 * SizeConfig.heightMultiplier),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(3 * SizeConfig.heightMultiplier),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Expanded(
                          child: Container(
                            child: Text(
                              Device.get().isTablet
                                  ? 'Slot #: ${parcel.slot}'
                                  : ' S#${parcel.slot}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorPalette.PrimaryTextColor,
                                fontSize: 2.2 * SizeConfig.textMultiplier,
                                fontFamily: 'RubikBold',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.5 * SizeConfig.heightMultiplier,
                  ),
                  Expanded(
                      child: Container(
                    child: Text(
                      '${parcel.description}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPalette.PrimaryTextColor,
                        fontSize: 2.2 * SizeConfig.textMultiplier,
                        fontFamily: 'RubikBold',
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 1.5 * SizeConfig.heightMultiplier,
                  ),
                  MySeparator(
                    color: ColorPalette.PrimaryTextColor,
                  ),
                  SizedBox(
                    height: 1.5 * SizeConfig.heightMultiplier,
                  ),
                  Expanded(
                    child: Container(
                      child: RichText(
                          text: TextSpan(
                              text: 'Sender: ',
                              style: TextStyle(
                                color: ColorPalette.PrimaryTextColor,
                                fontSize: 2.2 * SizeConfig.textMultiplier,
                                fontFamily: 'Rubik',
                              ),
                              children: <TextSpan>[
                            TextSpan(
                              text: '${parcel.sender}',
                              style: TextStyle(
                                color: ColorPalette.PrimaryTextColor,
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                fontFamily: 'RubikBold',
                              ),
                            )
                          ])),
                    ),
                  ),
                  SizedBox(
                    height: 1.5 * SizeConfig.heightMultiplier,
                  ),
                  Expanded(
                      child: Container(
                    child: Text(
                      '${parcel.address} - ${parcel.phone}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPalette.PrimaryTextColor,
                        fontSize: 2.2 * SizeConfig.textMultiplier,
                        fontFamily: 'Rubik',
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
