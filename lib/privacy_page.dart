import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/userappbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyTip extends StatelessWidget {
  const PrivacyTip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Container(
            // color: Colors.white,
            width: 300.w,
            height: 300.h,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(13.0))),
            child: Column(
              children: [
                SizedBox(
                  height: 40.r,
                  child: Center(
                    child: Text(
                      "隐私政策说明",
                      style: TextStyle(fontSize: 17.sp),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xffeeeeee),
                    child: Center(
                      child: RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text:
                                "感谢您下载Magictank APP!使用app连接设备工作时候,仅授权专业人士在法律许可范围内使用.使用本软件时,我们可能需要使用您部分必要的个人信息以及允许部分系统功能授权以提供相关服务,请您认真阅读,魔力星",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                              text: "<<服务协议/隐私政策>>",
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, "/showprivacy");
                                }),
                          const TextSpan(
                            text: ",如您同意所述政策,请点击\"同意并继续\"开始使用相关功能及服务.",
                            style: TextStyle(color: Colors.black),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 25.r,
                  child: OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff384c70)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0))),
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      "同意并继续",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.r,
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 25.r,
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text(
                      "不同意并关闭APP",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);
  // _showTimer(context) {
  //   // var timer;
  //   Timer.periodic(const Duration(milliseconds: 3000), (t) {
  //     Navigator.pop(context);
  //     t.cancel();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userAppBar(context),
      body: WebView(initialUrl: "https://www.xingruiauto.com/tank/privacy/"),
    );
  }
}
