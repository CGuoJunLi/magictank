import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:magictank/appdata.dart';

import 'package:magictank/cncpage/bluecmd/cmd.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';

import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/cncpage/mycontainer.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

import '../../alleventbus.dart';

class TooolsShowPage extends StatelessWidget {
  final Map arguments;
  const TooolsShowPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        switch (arguments["page"]) {
          case "104":
          case "103":
            sendCmd([cncBtSmd.out, 0, 0]);
            break;
        }
        return true;
      },
      child: Scaffold(
        appBar: userTankBar(context),
        body: ToolsShow(arguments),
      ),
    );
  }
}

class ToolsShow extends StatefulWidget {
  final Map arguments;
  const ToolsShow(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  State<ToolsShow> createState() => _ToolsShowState();
}

class _ToolsShowState extends State<ToolsShow> {
  late StreamSubscription upPageEvent;
  double motorspeed = 0.0;
  bool motorstate = false;
  bool xdtouch = false;
  bool pztouch = false;
  Timer? time;
  Duration timeout = const Duration(seconds: 20);
  @override
  void initState() {
    //如果是完成界面 并且是校准
    if (appData.getdata && widget.arguments["page"] == "2") {
      if (time != null) {
        time!.cancel();
      }
      sendCmd([cncBtSmd.getData, 0, 0, 0]); //发送校准数据
    }
    upPageEvent = eventBus.on<UpPageEvent>().listen(
      (UpPageEvent event) {
        setState(() {
          if (event.state & 0xf0 == 0xf0) {
            pztouch = true;
          } else {
            pztouch = false;
          }
          if (event.state & 0xf == 0xf) {
            xdtouch = true;
          } else {
            xdtouch = false;
          }
        });
      },
    );
    super.initState();
  }

//通讯超时检测
//如果通讯超时 重新获取一下应答信号?
  void timeOutCheck() {
    time = Timer(timeout, () {});
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    upPageEvent.cancel();

    super.dispose();
  }

  Widget showpic() {
    //Widget temp = [];
    switch (widget.arguments["page"]) {
      case "0":
        break;
      case "2": //校准完成
        return Stack(
          children: [
            const Align(
              child: Icon(
                Icons.check_outlined,
                size: 100,
                color: Colors.green,
              ),
              alignment: Alignment.center,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 200.r,
                height: 200.r,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 10.0),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(150),
                  ),
                ),
              ),
            ),
            Align(
              child: Text(S.of(context).complete),
              alignment: Alignment.bottomCenter,
            ),
            appData.getdata
                ? Align(
                    child: Column(
                      children: [
                        Text(S.of(context).currentdata),
                        Text("X:${appData.xDX}"),
                        Text("Y:${appData.xDY}"),
                      ],
                    ),
                  )
                : Container()
          ],
        );

      case "7": //放下铣刀导针
        return ListView(
          children: [
            myContainer(
                double.maxFinite,
                178.h,
                35.h,
                S.of(context).releasepz,
                "image/tank/cnctools/1_replace_3.png",
                EdgeInsets.only(left: 20.w, right: 20.w),
                assetimage: true),
            SizedBox(
              height: 20.h,
            ),
            myContainer(
                double.maxFinite,
                178.h,
                35.h,
                S.of(context).lockpz,
                "image/tank/cnctools/1_replace_4.png",
                EdgeInsets.only(left: 20.w, right: 20.w),
                assetimage: true),
          ],
        );
      case "9": //更换铣刀导针界面
        return ListView(
          children: [
            myContainer(
                double.maxFinite,
                178.h,
                35.h,
                S.of(context).inxdpz,
                "image/tank/cnctools/1_replace_1.png",
                EdgeInsets.only(left: 20.w, right: 20.w),
                assetimage: true),
            SizedBox(
              height: 20.h,
            ),
            myContainer(
                double.maxFinite,
                178.h,
                35.h,
                S.of(context).lockxdpz,
                "image/tank/cnctools/1_replace_2.png",
                EdgeInsets.only(left: 20.w, right: 20.w),
                assetimage: true),
          ],
        );
      case "12": //清理夹具
        return SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Center(
            child: Container(
              width: 340.w,
              height: 78.h,
              decoration: BoxDecoration(
                  color: const Color(0xff384c70),
                  borderRadius: BorderRadius.circular(13.0)),
              child: Column(
                children: [
                  SizedBox(
                    height: 78.h,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(S.of(context).dontremovekey,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontSize: 18.sp)),
                        Text(
                          S.of(context).clearnfixture,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white, fontSize: 13.sp),
                        ),
                      ],
                    )),
                  ),
                  Expanded(
                      child: Container(
                          width: double.maxFinite,
                          color: Colors.white,
                          child: Image.asset(
                            "image/tank/cnctools/1_calibration_2.png",
                            fit: BoxFit.cover,
                          )))
                ],
              ),
            ),
          ),
        );

      case "100": //切削校准
        return ListView(
          children: cncVersion.fixtureType == 21
              ? [
                  myContainer(
                      340.r,
                      227.r,
                      35.r,
                      S.of(context).fixture0_1_1_1,
                      "image/tank/cnctools/1_0_1_1.png",
                      EdgeInsets.only(left: 20.r, right: 20.r),
                      assetimage: true),
                  SizedBox(
                    height: 20.r,
                  ),
                  myContainer(
                      340.r,
                      227.r,
                      35.r,
                      S.of(context).fixture0_1_1_2,
                      "image/tank/cnctools/1_0_1_2.png",
                      EdgeInsets.only(left: 20.r, right: 20.r),
                      assetimage: true),
                ]
              : [
                  myContainer(
                      340.r,
                      227.r,
                      35.r,
                      S.of(context).fixture0_1_0_1,
                      "image/tank/cnctools/1_0_0_1.png",
                      EdgeInsets.only(left: 20.w, right: 20.w),
                      assetimage: true),
                  SizedBox(
                    height: 20.h,
                  ),
                  myContainer(
                      340.r,
                      227.r,
                      35.r,
                      S.of(context).fixture0_1_0_2,
                      "image/tank/cnctools/1_0_0_2.png",
                      EdgeInsets.only(left: 20.w, right: 20.w),
                      assetimage: true),
                  SizedBox(
                    height: 20.h,
                  ),
                  // myContainer(
                  //     340.r,
                  //     227.r,
                  //     35.r,
                  //     S.of(context).fixture0_1_0_3,
                  //     "image/tank/cnctools/0_0_1_3.png",
                  //     EdgeInsets.only(left: 20.w, right: 20.w),
                  //     assetimage: true),
                ],
        );
      case "101":
        return Center(
          child: Column(
            children: [
              Text(S.of(context).currentdata),
              Text("X:${appData.xDX}"),
              Text("Y:${appData.xDY}"),
            ],
          ),
        );
      case "103": //电机测试
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 250.w,
                  height: 248.h,
                  decoration: BoxDecoration(
                      color: const Color(0xff384c70),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                        child: Center(
                          child: Text(
                            S.of(context).xycontrol,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 13.sp),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        width: double.maxFinite,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 93.w,
                              top: 12.h,
                              child: GestureDetector(
                                child: Container(
                                  width: 70.w,
                                  height: 58.h,
                                  decoration: const BoxDecoration(
                                      color: Color(0xff384c70),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                      child: Icon(
                                    Icons.arrow_circle_up,
                                    color: Colors.white,
                                    size: 30.r,
                                  )),
                                ),
                                onLongPressStart: (details) {
                                  // sendmotor(0);
                                  sendCmd(
                                    [cncBtSmd.motorTest, 0, 0x01, 0, 0],
                                  );
                                },
                                onLongPressEnd: (details) {
                                  //   timer!.cancel();
                                  sendCmd([cncBtSmd.motorTest, 0, 0x0A, 0, 0]);
                                },
                              ),
                            ),
                            Positioned(
                              left: 93.w,
                              top: 135.h,
                              child: GestureDetector(
                                child: Container(
                                  width: 70.w,
                                  height: 58.h,
                                  decoration: const BoxDecoration(
                                      color: Color(0XFF384C70),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                      child: Icon(
                                    Icons.arrow_circle_down,
                                    color: Colors.white,
                                    size: 30.r,
                                  )),
                                ),
                                onLongPressStart: (details) {
                                  // sendmotor(0);
                                  sendCmd(
                                    [cncBtSmd.motorTest, 0, 0x02, 0, 0],
                                  );
                                },
                                onLongPressEnd: (details) {
                                  //timer!.cancel();
                                  sendCmd([cncBtSmd.motorTest, 0, 0x0A, 0, 0]);
                                },
                              ),
                            ),
                            Positioned(
                              left: 7.w,
                              top: 72.h,
                              child: GestureDetector(
                                child: Container(
                                  width: 70.w,
                                  height: 58.h,
                                  decoration: const BoxDecoration(
                                      color: Color(0XFF384C70),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                      child: Icon(
                                    Icons.arrow_circle_left_outlined,
                                    color: Colors.white,
                                    size: 30.r,
                                  )),
                                ),
                                onLongPressStart: (details) {
                                  // sendmotor(0);
                                  sendCmd(
                                    [cncBtSmd.motorTest, 0, 0x03, 0, 0],
                                  );
                                },
                                onLongPressEnd: (details) {
                                  //   timer!.cancel();
                                  sendCmd([cncBtSmd.motorTest, 0, 0x0A, 0, 0]);
                                },
                              ),
                            ),
                            Positioned(
                              left: 174.w,
                              top: 72.h,
                              child: GestureDetector(
                                child: Container(
                                  width: 70.w,
                                  height: 58.h,
                                  decoration: const BoxDecoration(
                                      color: Color(0XFF384C70),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                      child: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Colors.white,
                                    size: 30.r,
                                  )),
                                ),
                                onLongPressStart: (details) {
                                  // sendmotor(0);
                                  sendCmd(
                                    [cncBtSmd.motorTest, 0, 0x04, 0, 0],
                                  );
                                },
                                onLongPressEnd: (details) {
                                  //   timer!.cancel();
                                  sendCmd([cncBtSmd.motorTest, 0, 0x0A, 0, 0]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  width: 80.w,
                  height: 248.h,
                  decoration: BoxDecoration(
                      color: const Color(0xff384c70),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                        child: Center(
                          child: Text(
                            S.of(context).zcontrol,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 13.sp),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        width: double.maxFinite,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 5.w,
                              top: 12.h,
                              child: GestureDetector(
                                child: Container(
                                  width: 70.w,
                                  height: 58.h,
                                  decoration: const BoxDecoration(
                                      color: Color(0xff384c70),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                      child: Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.white,
                                    size: 30.r,
                                  )),
                                ),
                                onLongPressStart: (details) {
                                  //  sendmotor(0);
                                  sendCmd([cncBtSmd.motorTest, 0, 0x06, 0, 0]);
                                },
                                onLongPressEnd: (details) {
                                  //  timer!.cancel();
                                  sendCmd([cncBtSmd.motorTest, 0, 0x0A, 0, 0]);
                                },
                              ),
                            ),
                            Positioned(
                              left: 5.w,
                              top: 135.h,
                              child: GestureDetector(
                                child: Container(
                                  width: 70.w,
                                  height: 58.h,
                                  decoration: const BoxDecoration(
                                      color: Color(0xff384c70),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                      child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: 30.r,
                                  )),
                                ),
                                onLongPressStart: (details) {
                                  // sendmotor(0);
                                  sendCmd(
                                    [cncBtSmd.motorTest, 0, 0x07, 0, 0],
                                  );
                                },
                                onLongPressEnd: (details) {
                                  //   timer!.cancel();
                                  sendCmd([cncBtSmd.motorTest, 0, 0x0A, 0, 0]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              width: 340.w,
              height: 200.h,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(S.of(context).movespeed),
                      Expanded(
                        child: CupertinoSlider(
                          min: 0,
                          max: 3.0,
                          divisions: 3,
                          thumbColor: const Color(0xff384c70),
                          onChanged: (double value) {
                            ////print(value);
                            setState(() {
                              motorspeed = value;
                              sendCmd([
                                cncBtSmd.motorTest,
                                0,
                                0X05,
                                motorspeed.toInt(),
                                0
                              ]);
                            });
                          },
                          value: motorspeed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Text(S.of(context).bldctest),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        onPressed: () {
                          setState(() {
                            motorstate = !motorstate;
                            if (motorstate) {
                              sendCmd([cncBtSmd.motorTest, 0, 0x0C, 0, 0]);
                            } else {
                              sendCmd([cncBtSmd.motorTest, 0, 0x0C, 1, 0]);
                            }
                          });
                        },
                        child: Text(motorstate
                            ? S.of(context).bldcclose
                            : S.of(context).bldcopen),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    S.of(context).motortesttip,
                    style: TextStyle(color: Colors.red, fontSize: 20.sp),
                  ),
                ],
              ),
            ),
          ],
        );
      case "104": //导电性测试
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                myContainer(
                    165.w,
                    290.h,
                    40.h,
                    S.of(context).xd,
                    xdtouch
                        ? "image/tank/cnctools/c1.png"
                        : "image/tank/cnctools/c.png",
                    EdgeInsets.zero,
                    assetimage: true),
                myContainer(
                    165.w,
                    290.h,
                    40.h,
                    S.of(context).pz,
                    pztouch
                        ? "image/tank/cnctools/p1.png"
                        : "image/tank/cnctools/p.png",
                    EdgeInsets.zero,
                    assetimage: true),
              ],
            ),
            Container(
              width: 340.w,
              height: 170.h,
              margin: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 21.w, top: 21.h),
                        child: Text(S.of(context).tipmessage,
                            style: const TextStyle(
                              color: Colors.red,
                            ))),
                    Padding(
                        padding: EdgeInsets.only(left: 21.w, top: 21.h),
                        child: Text(S.of(context).xdpzchecktip))
                  ]),
            )
          ],
        );
      case "105": //更换新夹具
        return Column(
          children: [
            myContainer(
                300.r,
                160.r,
                30.r,
                S.of(context).changefixture_0_1,
                "image/tank/cnctools/1_replace_fixture_0.png",
                const EdgeInsets.all(10),
                assetimage: true),
            myContainer(
                300.r,
                160.r,
                30.r,
                S.of(context).changefixture_0_2,
                "image/tank/cnctools/1_replace_fixture_1.png",
                const EdgeInsets.all(10),
                assetimage: true),
          ],
        );
      case "106": //更换旧夹具

        return ListView(
          children: [
            myContainer(
                300.r,
                160.r,
                30.r,
                S.of(context).changefixture_1_1,
                "image/tank/cnctools/1_replace_fixture_0.png",
                const EdgeInsets.all(10),
                assetimage: true),
            SizedBox(
                child: myContainer(
                    300.r,
                    160.r,
                    30.r,
                    S.of(context).changefixture_1_2,
                    "image/tank/cnctools/1_replace_fixture_1.png",
                    const EdgeInsets.all(10),
                    assetimage: true)),
          ],
        );

      default:
        return Container();
    }
    return Container();
    // return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: showpic(), //加载跟换铣刀导针的示意图
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff384c70))),
                  onPressed: () {
                    switch (widget.arguments["page"]) {
                      case "2":
                        sendCmd([cncBtSmd.answer, widget.arguments["no"], 0]);
                        eventBus.fire(CNCChangeXDStateEvent(true));
                        Navigator.pop(context);
                        break;
                      case "100":
                        sendCmd([cncBtSmd.correct, 0, 0, 0]);
                        Navigator.pushReplacementNamed(context, '/toolswait',
                            arguments: {});

                        break;
                      case "101":
                      case "103":
                        sendCmd([cncBtSmd.out, 0, 0]);
                        Navigator.pop(context);
                        break;
                      case "104":
                        sendCmd([cncBtSmd.out, 0, 0]);
                        Navigator.pop(context);
                        break;
                      case "105": //更换新家具
                        sendCmd([cncBtSmd.replaceFix, 0, 1, 0]);
                        Navigator.pushReplacementNamed(context, '/toolswait',
                            arguments: {});
                        cncVersion.fixtureType = 21;
                        break;
                      case "106": //更换旧夹具
                        sendCmd([cncBtSmd.replaceFix, 0, 0, 0]);
                        Navigator.pushReplacementNamed(context, '/toolswait',
                            arguments: {});
                        cncVersion.fixtureType = 11;
                        break;
                      default:
                        sendCmd([cncBtSmd.answer, widget.arguments["no"], 0]);
                        Navigator.pushReplacementNamed(context, '/toolswait',
                            arguments: {});
                        break;
                    }
                  },
                  child: Text(S.of(context).okbt)),
            ),
            // SizedBox(
            //   width: 10,
            // ),
          ],
        ),
      ],
    );
  }
}
