import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qpv_face_scanner/blocs/notification_bloc.dart';
import 'package:qpv_face_scanner/blocs/users_bloc.dart';
import 'package:qpv_face_scanner/local_storage.dart';
import 'package:qpv_face_scanner/ui/splash_page.dart';

import 'blocs/authenticate_bloc.dart';
import 'constant.dart';
import 'helper/common_methods.dart';
import 'helper/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorage.init();
  await Firebase.initializeApp();
  runApp(QpvFaceScanner());
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class QpvFaceScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticateBloc>(
          create: (context) => AuthenticateBloc(),
        ),
        ChangeNotifierProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        ChangeNotifierProvider<CommonMethods>(
          create: (context) => CommonMethods(),
        ),
        ChangeNotifierProvider<NotificationBloc>(
          create: (context) => NotificationBloc(),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                builder: (context, child) {
                  return ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: child,
                  );
                },
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark().copyWith(
                  primaryColor: ColorPalette.PrimaryColor,
                  accentColor: ColorPalette.AccentColor,
                  textSelectionColor: ColorPalette.PrimaryTextColor,
                  dialogTheme: DialogTheme.of(context).copyWith(
                      backgroundColor: Colors.grey,
                      contentTextStyle:
                          TextStyle(color: ColorPalette.PrimaryTextColor)),
                ),
                initialRoute: '/',
                routes: {
                  '/': (context) => SplashPage(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
