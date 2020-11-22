import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:qpv_face_scanner/constant.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/model/customers.dart';
import 'package:qpv_face_scanner/ui/assistant_page.dart';
import 'package:qpv_face_scanner/ui/user_info_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerPage extends StatefulWidget {
  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  String _qrResult = '';
  bool _spinner = false;

  QRViewController _controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _spinner,
      progressIndicator: SpinKitFadingFour(
        color: ColorPalette.PrimaryColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5 * SizeConfig.widthMultiplier),
                      child: Text(
                        'Please put the QR code in front of the Scanner.',
                        style: TextStyle(
                            color: ColorPalette.PrimaryTextColor,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            fontFamily: 'RubikBold'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.flipCamera();

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        _qrResult = scanData;
      });
      if (_qrResult != null || _qrResult != "") {
        setState(() {
          _spinner = true;
        });
        await FirebaseFirestore.instance
            .collection('customerAccounts')
            .doc(_qrResult)
            .get()
            .then((value) {
          if (value.data() != null) {
            print('Not null: ${value.data()}');
            try {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserInfoPage(
                          customer: Customer.fromMap(value.data()))));
            } catch (e) {
              print(e);
            }
          } else {
            print(' null');
            try {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AssistantPage()));
            } catch (e) {
              print(e);
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
