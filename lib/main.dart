import 'dart:async';

import 'package:camera_deep_ar/camera_deep_ar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  check() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage
    ].request();
    print(statuses[Permission.camera]);
  }

  @override
  Future<void> initState() {
    super.initState();

    check();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CameraWidget(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  String _platformVersion = 'Unknown';
  CameraDeepArController cameraDeepArController;
  int currentPage = 0;
  final vp = PageController(viewportFraction: .24);
  Effects currentEffect = Effects.none;
  Filters currentFilter = Filters.none;
  Masks currentMask = Masks.none;
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraDeepAr(
              supportedMasks: [
                Masks.aviators,
                Masks.bcgSeg,
                Masks.bigmouth,
                Masks.dalmatian,
                Masks.fatify,
                Masks.flowers,
                Masks.grumpycat,
                Masks.lion,
                Masks.look2,
                Masks.koala,
                Masks.teddycigar,
                Masks.sleepingmask
              ],
              onCameraReady: (isReady) {
                _platformVersion = "Camera status $isReady";
                setState(() {});
              },
              onImageCaptured: (path) {
                _platformVersion = "Image Taken @ $path";
                setState(() {});
              },
              onVideoRecorded: (path) {
                _platformVersion = "Video Recorded @ $path";
                isRecording = false;
                setState(() {});
              },
              androidLicenceKey:
                  "0225f93a6a04068c6a5d019e0999cfa6ec1558c61778da637ccef1526160fc68c96c8c451234ceab",
              iosLicenceKey:
                  "0225f93a6a04068c6a5d019e0999cfa6ec1558c61778da637ccef1526160fc68c96c8c451234ceab",
              cameraDeepArCallback: (c) async {
                cameraDeepArController = c;
                setState(() {});
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20),
              //height: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Text(
                  //   'Response >>> : $_platformVersion\n',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 14, color: Colors.white),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            if (null == cameraDeepArController) return;
                            if (isRecording) return;
                            cameraDeepArController.snapPhoto();
                          },
                          child: Icon(Icons.camera_enhance_outlined),
                          color: Colors.white,
                          padding: EdgeInsets.all(15),
                        ),
                      ),
                      // if (isRecording)
                      //   Expanded(
                      //     child: FlatButton(
                      //       onPressed: () {
                      //         if (null == cameraDeepArController) return;
                      //         cameraDeepArController.stopVideoRecording();
                      //         isRecording = false;
                      //         setState(() {});
                      //       },
                      //       child: Icon(Icons.videocam_off),
                      //       color: Colors.red,
                      //       padding: EdgeInsets.all(15),
                      //     ),
                      //   )
                      // else
                      //   Expanded(
                      //     child: FlatButton(
                      //       onPressed: () {
                      //         if (null == cameraDeepArController) return;
                      //         cameraDeepArController.startVideoRecording();
                      //         isRecording = true;
                      //         setState(() {});
                      //       },
                      //       child: Icon(Icons.videocam),
                      //       color: Colors.green,
                      //       padding: EdgeInsets.all(15),
                      //     ),
                      //   ),
                    ],
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.all(15),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(Masks.values.length, (p) {
                        bool active = currentPage == p;
                        return GestureDetector(
                          onTap: () {
                            currentPage = p;
                            cameraDeepArController.changeMask(p);
                            setState(() {});
                          },
                          child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(12),
                              width: active ? 100 : 80,
                              height: active ? 100 : 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: active ? Colors.orange : Colors.white,
                                  shape: BoxShape.circle),
                              child: Text(
                                "$p",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: active ? 16 : 14,
                                    color: Colors.black),
                              )),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
