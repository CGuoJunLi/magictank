import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';
import 'package:magictank/cncpage/basekey.dart';

import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';

import '../alleventbus.dart';
import '../appdata.dart';

class CnCWorkingPage extends StatefulWidget {
  const CnCWorkingPage({Key? key}) : super(key: key);

  @override
  State<CnCWorkingPage> createState() => _CnCWorkingPageState();
}

class _CnCWorkingPageState extends State<CnCWorkingPage> {
  bool btdown = false;
  late StreamSubscription upgradepage;
  late StreamSubscription changesidepage;
  late StreamSubscription btstatet;
  @override
  void initState() {
    debugPrint("init");
    appData.errorreturn = true;
    upgradepage = eventBus.on<UpPageEvent>().listen((event) {
      if (event.state == 1) {
        baseKey.readstate = true;
        Navigator.pop(context, 1);
      } else {
        Navigator.pop(context, 2);
      }
    });
    changesidepage = eventBus.on<ChangeSideEvent>().listen((event) {
      // print(event.message);
      switch (event.message) {
        case 27: //非导电提示安装钥匙
          Navigator.pushNamed(context, '/openclamp', arguments: {"state": 1});
          break;
        case 21:
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (c) {
                return MyTextDialog(
                  S.of(context).keywideerror,
                  button1: S.of(context).stop,
                  button2: S.of(context).continuebt,
                );
              }).then((value) async {
            if (value) {
              sendCmd([0X9A, 0, 0]);
            } else {
              sendCmd([cncBtSmd.pause, 0, 0]);
              await Future.delayed(const Duration(seconds: 1));
              sendCmd([cncBtSmd.stop, 0, 0]);
            }
          });
          break;
        default:
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog("errorstate:${event.message}");
              });
          break;
      }
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
    changesidepage.cancel();
    btstatet.cancel();
    appData.errorreturn = false;
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
            )));
  }
}
