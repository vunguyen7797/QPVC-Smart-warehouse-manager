import 'package:cached_network_image/cached_network_image.dart';
import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:provider/provider.dart';
import 'package:qpv_face_scanner/blocs/users_bloc.dart';
import 'package:qpv_face_scanner/components/animation/custom_bounce_on_tap.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/model/customers.dart';
import 'package:qpv_face_scanner/ui/available_parcel_page.dart';
import 'package:qpv_face_scanner/ui/pickup_options_page.dart';
import 'package:shimmer/shimmer.dart';

import '../constant.dart';
import '../local_storage.dart';

class UserInfoPage extends StatefulWidget {
  final Customer customer;

  const UserInfoPage({Key key, this.customer}) : super(key: key);
  @override
  _UserInfoPageState createState() => _UserInfoPageState(this.customer);
}

class _UserInfoPageState extends State<UserInfoPage> {
  Customer customer;
  String _idCard = '';

  _UserInfoPageState(this.customer);

  @override
  void initState() {
    if (customer != null && customer.idCard != "") {
      for (int i = 0; i < customer.idCard.length - 3; i++) _idCard += 'x';
      _idCard += customer.idCard.substring(customer.idCard.length - 3);
    }
    LocalStorage.instance.setString('name', customer.displayName);
    LocalStorage.instance.setString('faceId', customer.userFaceId);
    LocalStorage.instance.setString('customerUID', customer.userUID);
    Future.delayed(Duration(seconds: 0)).then((_) async {
      final UserBloc userBloc = Provider.of<UserBloc>(context);
      await userBloc.getUserParcels(customer.userUID);
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
                    left: (Device.get().isTablet ? 12 : 5) *
                        SizeConfig.widthMultiplier),
                child: Container(
                  child: Text(
                    'Is this you?',
                    style: TextStyle(
                        color: ColorPalette.PrimaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RubikBold',
                        fontSize: 7 * SizeConfig.textMultiplier),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: Device.get().isTablet
                      ? EdgeInsets.symmetric(
                          horizontal: 10 * SizeConfig.widthMultiplier)
                      : EdgeInsets.symmetric(
                          horizontal: 5 * SizeConfig.widthMultiplier),
                  child: Container(
                    height: 30 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                        color: ColorPalette.PrimaryColor,
                        borderRadius: BorderRadius.circular(
                            3 * SizeConfig.heightMultiplier)),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 4.5 * SizeConfig.heightMultiplier,
                        left: Device.get().isTablet
                            ? 0
                            : 5 * SizeConfig.widthMultiplier,
                        right: Device.get().isTablet
                            ? 0
                            : 5 * SizeConfig.widthMultiplier,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer != null ? customer.displayName : '',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'RubikMedium',
                                    fontSize: 4 * SizeConfig.textMultiplier),
                              ),
                              SizedBox(
                                height: 3 * SizeConfig.heightMultiplier,
                              ),
                              Text(
                                'ID: ' + (customer != null ? _idCard : ''),
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Rubik',
                                    fontSize: 3 * SizeConfig.textMultiplier),
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Text(
                                customer != null ? customer.address : '',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Rubik',
                                    fontSize: 3 * SizeConfig.textMultiplier),
                              ),
                              SizedBox(
                                height: 1 * SizeConfig.heightMultiplier,
                              ),
                              Text(
                                customer != null ? customer.phoneNumber : '',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Rubik',
                                    fontSize: 3 * SizeConfig.textMultiplier),
                              ),
                            ],
                          ),
                          Device.get().isTablet
                              ? CachedNetworkImage(
                                  imageUrl: customer.photoUrl ?? defaultProfile,
                                  imageBuilder: (context, imageProvider) =>
                                      ClipRRect(
                                    child: Container(
                                      height: 8 * SizeConfig.heightMultiplier,
                                      width: 8 * SizeConfig.heightMultiplier,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            5 * SizeConfig.heightMultiplier),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    highlightColor: ColorPalette.SecondaryColor,
                                    baseColor: Colors.white30,
                                    child: Container(
                                      height: 8 * SizeConfig.heightMultiplier,
                                      width: 8 * SizeConfig.heightMultiplier,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            5 * SizeConfig.heightMultiplier),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: 5 * SizeConfig.heightMultiplier,
                                    width: 15 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          4 * SizeConfig.heightMultiplier),
                                      color: Colors.white30,
                                    ),
                                    child: Icon(Icons.error),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5 * SizeConfig.heightMultiplier,
              ),
              CustomBounceAnimation(
                onTap: () {
                  // Temporary link, for testing purpose
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PickUpOptionPage()));
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff4D4D4D),
                      borderRadius: BorderRadius.circular(
                          5 * SizeConfig.heightMultiplier),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5 * SizeConfig.widthMultiplier,
                        vertical: 2 * SizeConfig.heightMultiplier,
                      ),
                      child: Text(
                        'This isn\'t me',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'RubikMedium',
                            fontSize: 3 * SizeConfig.textMultiplier),
                      ),
                    ),
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
                          builder: (context) =>
                              AvailableParcelPage(uid: customer.userUID)));
                },
                child: Center(
                    child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'If this is you',
                      style: TextStyle(
                          color: ColorPalette.PrimaryTextColor,
                          fontSize: 3 * SizeConfig.textMultiplier,
                          fontFamily: 'RubikMedium'),
                      children: <TextSpan>[
                        TextSpan(
                          text: '\nplease confirm via QPV app in your phone.',
                          style: TextStyle(
                              color: ColorPalette.PrimaryTextColor,
                              fontSize: 3 * SizeConfig.textMultiplier,
                              fontFamily: 'RubikMedium'),
                        )
                      ]),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
