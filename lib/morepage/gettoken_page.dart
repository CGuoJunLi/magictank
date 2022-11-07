import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/http/api.dart';

import 'package:magictank/userappbar.dart';

class GetTokenPage extends StatefulWidget {
  const GetTokenPage({Key? key}) : super(key: key);

  @override
  State<GetTokenPage> createState() => _GetTokenPageState();
}

class _GetTokenPageState extends State<GetTokenPage> {
  String codestr = "";
  int token = 0;
  // Barcode? result;
  // QRViewController? controller;
  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // // In order to get hot reload to work we need to pause the camera if the platform
  // // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: userTankBar(context),
      body: Center(
        child: Container(
          width: 340.w,
          height: 189.h,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14.r)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text("当前积分:${appData.integral}"),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/qrcode").then((value) {
                      if (value != null) {
                        codestr = value.toString();
                        setState(() {});
                      }
                    });
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 195.w,
                        height: 29.h,
                        child: TextField(
                          controller: TextEditingController(text: codestr),
                          onChanged: (value) {
                            codestr = value;
                          },
                        ),
                      ),
                      appData.limit == 10
                          ? SizedBox(
                              width: 195.w,
                              height: 29.h,
                              child: TextField(
                                // controller:
                                //     TextEditingController(text: codestr),
                                onChanged: (value) {
                                  //codestr = value;
                                  if (value != "") {
                                    token = int.parse(value);
                                  }
                                },
                              ),
                            )
                          : Container(),
                    ],
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () async {
                      // var result = await Api.getToken("asd123456");
                      // print(result);
                      var result =
                          await Api.upToken({"token": codestr, "num": token});
                      Fluttertoast.showToast(msg: result["state"]);
                    },
                    child: Container(
                      width: 100.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          color: const Color(0xff50c5c4),
                          borderRadius: BorderRadius.circular(14.r)),
                      child: const Center(
                        child: Text(
                          "积分兑换",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
