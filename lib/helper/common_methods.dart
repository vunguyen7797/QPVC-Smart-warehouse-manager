import 'package:fleva_icons/fleva_icons.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';

import '../constant.dart';

class CommonMethods extends ChangeNotifier {
  static void showFlushBar(message, context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          margin: EdgeInsets.all(2.5 * SizeConfig.heightMultiplier),
          flushbarPosition: FlushbarPosition.BOTTOM,
          borderRadius: 3 * SizeConfig.heightMultiplier,
          backgroundColor: Colors.white,
          boxShadows: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.2),
              offset: Offset(0, 5),
              blurRadius: 20,
              spreadRadius: 0.1,
            )
          ],
          duration: Duration(seconds: 1),
          dismissDirection: FlushbarDismissDirection.HORIZONTAL,
          isDismissible: true,
          flushbarStyle: FlushbarStyle.FLOATING,
          forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
          messageText: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 2.5 * SizeConfig.widthMultiplier),
            child: Container(
              height: 5 * SizeConfig.heightMultiplier,
              child: Row(
                children: <Widget>[
                  Icon(
                    FlevaIcons.info_outline,
                    size: 3 * SizeConfig.heightMultiplier,
                    color: ColorPalette.PrimaryColor,
                  ),
                  SizedBox(
                    width: 2 * SizeConfig.widthMultiplier,
                  ),
                  Expanded(
                    child: Text(
                      message,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 1.85 * SizeConfig.textMultiplier,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )..show(context));
  }
}
