import 'package:flutter/material.dart';
import 'package:qpv_face_scanner/model/customers.dart';

// Replace with your endpoint
final endpoint = "https://vface-4.cognitiveservices.azure.com/face/v1.0";
// Replace with your key
final key = "81d5f2e93eec4ef89faec013ceef83a4";

class TestFace extends StatefulWidget {
  final Customer customer;
  final List<String> faceIds;

  const TestFace({Key key, this.customer, this.faceIds}) : super(key: key);
  @override
  _TestFaceState createState() => _TestFaceState(this.customer);
}

class _TestFaceState extends State<TestFace> {
  Customer customer;

  _TestFaceState(this.customer);

  @override
  void initState() {
//    Future.delayed(Duration(milliseconds: 0)).then((_) async {
//      IdentifyResult _identity = await client.identityInLargePersonGroup(
//          largePersonGroupId: "1cf81f49-aa51-46f2-b18c-965c48a6c401",
//          faceIds: widget.faceIds);

//      personId = _identity.candidates[0].personId;
//
//      print("PERSON ID: " + personId);
    //});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          customer.displayName,
          style: TextStyle(color: Colors.black, fontSize: 50),
        ),
      ),
    );
  }
}
