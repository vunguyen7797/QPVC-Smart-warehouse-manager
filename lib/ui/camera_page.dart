import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image/image.dart' as imglib;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qpv_face_scanner/cognitiveFaceServices/contract/face.dart'
    as mFace;
import 'package:qpv_face_scanner/cognitiveFaceServices/contract/identify_result.dart';
import 'package:qpv_face_scanner/cognitiveFaceServices/face_service_client.dart';
import 'package:qpv_face_scanner/cognitiveFaceServices/face_service_rest_client.dart';
import 'package:qpv_face_scanner/constant.dart';
import 'package:qpv_face_scanner/helper/size_config.dart';
import 'package:qpv_face_scanner/helper/utils.dart';
import 'package:qpv_face_scanner/model/customers.dart';
import 'package:qpv_face_scanner/ui/loading_page.dart';
import 'package:qpv_face_scanner/ui/user_info_page.dart';
import 'package:quiver/collection.dart';

// Replace with your endpoint
final endpoint = "https://vface-4.cognitiveservices.azure.com/face/v1.0";
// Replace with your key
final key = "81d5f2e93eec4ef89faec013ceef83a4";

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  String _description =
      'Please put your face in the frame. When your face is identified, the frame will turn red and the screen will display your information to confirm.';
  CameraController _cameraController;
  CameraLensDirection _direction = CameraLensDirection.front;
  bool _isDetecting = false;
  bool _faceFound = false;
  Directory tempDir;
  final client = FaceServiceClient(key, serviceHost: endpoint);
  List<mFace.Face> _detectedFaces = [];
  String _customerGroupId = "customergroup";
  bool _spinner = false;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    // Set the phone orientation portrait
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);
    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );

    tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/face.jpg';

    _cameraController = CameraController(
      description,
      ResolutionPreset.veryHigh,
    );
    await _cameraController.initialize();

    //  await Future.delayed(Duration(milliseconds: 500));

    _cameraController.startImageStream((CameraImage image) {
      if (_cameraController != null) {
        if (_isDetecting) return;
        _isDetecting = true;

        dynamic finalResult = Multimap<String, Face>();
        detect(image, _handleDetection(), rotation).then(
          (dynamic result) async {
            Face _face;
            print('FACES SIZE: ' + result.length.toString());
            imglib.Image convertedImage =
                _convertCameraImage(image, _direction);

            if (result.length == 0) _detectedFaces.clear();
            for (_face in result) {
              double x, y, w, h;
              x = (_face.boundingBox.left - 10);
              y = (_face.boundingBox.top - 10);
              w = (_face.boundingBox.width + 10);
              h = (_face.boundingBox.height + 10);
              imglib.Image croppedImage = imglib.copyCrop(
                  convertedImage, x.round(), y.round(), w.round(), h.round());
              croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);

              File _imageFace = File(_embPath)
                ..writeAsBytesSync(imglib.encodeJpg(croppedImage));

              _detectedFaces = await client.detect(
                image: _imageFace,
                returnFaceAttributes: FaceAttributeType.values,
                returnFaceLandmarks: true,
              );
              if (_detectedFaces.length > 0) {
                break;
              }
              finalResult.add('', _face);
            }

            if (_detectedFaces.length > 0) {
              print('DETECTED FACES: ${_detectedFaces.length}');

              setState(() {
                _faceFound = true;
                _spinner = true;
              });
              print('Face ID: ' + _detectedFaces[0].faceId);
              List<String> _faceIds = [];
              for (var item in _detectedFaces) _faceIds.add(item.faceId);

              IdentifyResult _identity =
                  await client.identityInLargePersonGroup(
                      largePersonGroupId: _customerGroupId, // customerGroupID
                      faceIds: _faceIds);

              print("IDENTITIES LIST: " + _identity.faceId);
              setState(() {
                _faceFound = false;
                _spinner = false;
              });
//              Future.delayed(Duration(milliseconds: 1000)).then((_) async {
//                final UserBloc userBloc = Provider.of<UserBloc>(context);
////                await userBloc
////                    .getUserWithFaceID(_identity.candidates[0].personId)
////                    .then(() {
////
////                });

//              await FirebaseFirestore.instance
//                  .collection('customerAccounts')
//                  .doc(_identity.candidates[0].personId)
//                  .get()
//                  .then((DocumentSnapshot snap) {
//                if (snap != null) {
//                  Navigator.pushReplacement(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => UserInfoPage(
//                              customer: Customer.fromMap(snap.data()))));
//                }
//              });

              if (_identity.candidates.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('customerAccounts')
                    .get()
                    .then((result) {
                  int tempResult;
                  try {
                    tempResult = result.docs.indexWhere((element) =>
                        element['userFaceID'] ==
                        _identity.candidates[0].personId);
                  } catch (e) {
                    tempResult = -1;
                  }
                  if (tempResult != -1) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserInfoPage(
                                customer: Customer.fromMap(
                                    result.docs[tempResult].data()))));
                  }
                });
              } else {
                setState(() {
                  _count++;
                });
                if (_count == 3) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoadingQRPage()));
                } else {
                  setState(() {
                    _description =
                        'Face is not recognized. Please try one more time. ($_count/3)';
                  });
                }

                if (mounted)
                  setState(() {
                    _isDetecting = true;
                  });
                Future.delayed(Duration(seconds: 5)).then((_) {
                  if (mounted)
                    setState(() {
                      _isDetecting = false;
                    });
                });
              }
              //  });
            } else {
              setState(() {
                _faceFound = false;
              });
            }

            _isDetecting = false;
          },
        ).catchError(
          (_) {
            _isDetecting = false;
          },
        );
      }
    });
  }

  HandleDetection _handleDetection() {
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(mode: FaceDetectorMode.accurate, minFaceSize: 0.8),
    );
    return faceDetector.processImage;
  }

  Widget _buildCameraPreview() {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      child: _cameraController == null
          ? const Center(child: null)
          : Stack(
              // fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_cameraController),
                //_buildResultFrame(),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _spinner,
        progressIndicator: SpinKitFadingFour(color: ColorPalette.PrimaryColor),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                3 * SizeConfig.heightMultiplier),
                          ),
                          child: _buildCameraPreview()),
                    ),
                    Positioned(
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: _faceFound
                                  ? Image.asset(
                                      'res/images/face_shape_found.png')
                                  : Image.asset('res/images/face_shape.png'),
                            )))
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
                  child: Container(
                      child: Center(
                    child: Text(
                      _description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPalette.PrimaryTextColor,
                        fontFamily: 'Rubik',
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),
                    ),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  imglib.Image _convertCameraImage(
      CameraImage image, CameraLensDirection _dir) {
    int width = image.width;
    int height = image.height;
    var img = imglib.Image(width, height); // Create Image buffer
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = hexFF | (b << 16) | (g << 8) | r;
      }
    }
    var img1 = (_dir == CameraLensDirection.front)
        ? imglib.copyRotate(img, -90)
        : imglib.copyRotate(img, 90);
    return img1;
  }
}
