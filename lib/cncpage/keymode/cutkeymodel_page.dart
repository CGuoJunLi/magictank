//切削模型界面
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';

import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';

import '../../alleventbus.dart';

class CutKeyModelPage extends StatefulWidget {
  const CutKeyModelPage({Key? key}) : super(key: key);

  @override
  State<CutKeyModelPage> createState() => _CutKeyModelPageState();
}

class _CutKeyModelPageState extends State<CutKeyModelPage> {
  late StreamSubscription upgradepage;
  late StreamSubscription btstatet;
  bool btdown = false;
  @override
  void initState() {
    appData.errorreturn = true;
    upgradepage = eventBus.on<ChangeSideEvent>().listen((event) {
      upgradepage.cancel();

      Navigator.pushReplacementNamed(context, "/clampmodel", arguments: {
        "type": event.type,
        "no": event.no,
        "message": event.message,
        "first": false
      });
    });
    btstatet = eventBus.on<CNCConnectEvent>().listen((event) {
      if (!event.state) {
        Navigator.pop(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    upgradepage.cancel();
    btstatet.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          sendCmd([cncBtSmd.pause, 0, 0]);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (c) {
                return MyTextDialog(
                  S.of(context).suspending,
                  button1: S.of(context).stop,
                  button2: S.of(context).continuebt,
                );
              }).then((value) {
            if (value) {
              sendCmd([cncBtSmd.resume, 0, 0]);
            } else {
              sendCmd([cncBtSmd.stop, 0, 0]);
            }
          });
          return false;
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(double.maxFinite, 28.h),
            child: Builder(
              builder: (context) {
                return SizedBox(
                  width: double.maxFinite,

                  height: 28.h,
                  //color: Colors.red,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 92.w,
                          height: 18.h,
                          child: Image.asset(
                            "image/tank/Icon_tankbar.png",
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Align(
                    child: SizedBox(
                      width: 200.r,
                      height: 200.r,
                      child: CircularProgressIndicator(
                          strokeWidth: 15.w, color: const Color(0xff384c70)),
                    ),
                    alignment: Alignment.center,
                  ),
                  Align(
                    child: Container(
                      width: 110.r,
                      height: 110.r,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(55.w)),
                      child: TextButton(
                        onPressed: () {
                          sendCmd([cncBtSmd.pause, 0, 0]);
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (c) {
                                return MyTextDialog(
                                  S.of(context).suspending,
                                  button1: S.of(context).stop,
                                  button1color: Colors.red,
                                  button2: S.of(context).continuebt,
                                  button2color: Colors.green,
                                  model: 1,
                                );
                              }).then((value) {
                            if (value) //继续
                            {
                              sendCmd([cncBtSmd.resume, 0, 0]);
                            } else //停止
                            {
                              sendCmd([cncBtSmd.stop, 0, 0]);
                            }
                          });
                        },
                        child: Text(
                          S.of(context).suspend,
                          style:
                              TextStyle(color: Colors.white, fontSize: 30.sp),
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 50.h),
                      child: Text(
                        S.of(context).working,
                        style: TextStyle(fontSize: 17.sp),
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ));
  }
}
