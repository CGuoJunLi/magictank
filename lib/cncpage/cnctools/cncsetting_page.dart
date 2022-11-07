import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/cncpage/bluecmd/cmd.dart';

import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/cncpage/cncguide_page.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class CnCSettingPage extends StatefulWidget {
  const CnCSettingPage({Key? key}) : super(key: key);

  @override
  _CnCSettingPageState createState() => _CnCSettingPageState();
}

class _CnCSettingPageState extends State<CnCSettingPage> {
  List<Widget> settingWidget = [];
  late StreamSubscription btstatet;
  late ProgressDialog pd;

  Widget changeFixtrueDialog() {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 300.w,
          height: 400.w,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
                width: 2.w,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(13.0))),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.w,
                    ),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(13.0))),
                height: 50.h,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        S.of(context).selefixture,
                        style: TextStyle(
                            fontSize: 17.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: const Color(0xffeeeeee),
                  child: Column(
                    children: [
                      Text(S.of(context).newfixture),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, 1);
                          },
                          child: SizedBox(
                            width: 254.w,
                            height: 181.w,
                            child: Image.asset("image/tank/new_fixture.png"),
                          ),
                        ),
                      ),
                      const Divider(),
                      // VerticalDivider(),
                      Text(S.of(context).oldfixture),
                      Expanded(
                          child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, 2);
                        },
                        child: SizedBox(
                          width: 254.w,
                          height: 181.w,
                          child: Image.asset("image/tank/old_fixture.png"),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
                child: Container(
                  padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                  width: 150.w,
                  height: 40.h,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0))),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff384c70))),
                    onPressed: () {
                      Navigator.pop(context, 0);
                      // return false;
                    },
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget parameterPage() {
    //加工设置
    return ListView(
      children: [
        Container(
          width: 340.w,
          height: 176.h,
          margin: EdgeInsets.only(left: 10.w, top: 20.h, right: 10.w),
          decoration: BoxDecoration(
              color: const Color(0xff384c70),
              borderRadius: BorderRadius.circular(13.0)),
          child: Column(
            children: [
              SizedBox(
                height: 23.h,
                child: Center(
                  child: Text(
                    S.of(context).cutsetting,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      width: double.maxFinite,
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Expanded(child: SizedBox()),
                          TextButton(
                            style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero)),
                            onPressed: () {
                              Navigator.pushNamed(context, '/speedset');
                            },
                            child: Container(
                              color: const Color(0xffdde2ea),
                              height: 40.h,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 53.w,
                                    child: Image.asset(
                                        "image/tank/cnctools/Icon_s1.png"),
                                  ),
                                  SizedBox(
                                    width: 30.w,
                                  ),
                                  Text(
                                    S.of(context).cutsetting,
                                    style: const TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                if (getCncBtState()) {
                                  sendCmd([cncBtSmd.getData, 0, 0, 0]);
                                  Navigator.pushNamed(context, '/toolsshow',
                                      arguments: {"page": "101"});
                                } else {
                                  _autoConnectBT();
                                }
                              },
                              child: Container(
                                color: const Color(0xffdde2ea),
                                height: 40.h,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 53.w,
                                      child: Image.asset(
                                          "image/tank/cnctools/Icon_s2.png"),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    Text(
                                      S.of(context).getcalibrationdata,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              )),
                          const Expanded(child: SizedBox()),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                // Navigator.pushNamed(context, "/setkeysys");
                              },
                              child: Container(
                                color: const Color(0xffdde2ea),
                                height: 40.h,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 53.w,
                                      child: Image.asset(
                                          "image/tank/cnctools/Icon_s2.png"),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    const Text(
                                      "设置钥匙胚系统",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              )),
                          const Expanded(child: SizedBox()),
                        ],
                      )))
            ],
          ),
        ),
        Container(
          width: 340.w,
          height: 176.h,
          margin: EdgeInsets.only(left: 10.w, top: 20.h, right: 10.w),
          decoration: BoxDecoration(
              color: const Color(0xff384c70),
              borderRadius: BorderRadius.circular(13.0)),
          child: Column(
            children: [
              SizedBox(
                height: 23.h,
                child: Center(
                  child: Text(
                    S.of(context).cutcalibration,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      width: double.maxFinite,
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Expanded(child: SizedBox()),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                if (getCncBtState()) {
                                  sendCmd([cncBtSmd.replaceXd, 0, 0, 0]);
                                  //updatacmd([0x71, 0, 0], false);
                                  Navigator.pushNamed(context, '/toolswait',
                                      arguments: {});
                                } else {
                                  _autoConnectBT();
                                }
                              },
                              child: Container(
                                color: const Color(0xffdde2ea),
                                height: 40.h,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 53.w,
                                      child: Image.asset(
                                          "image/tank/cnctools/Icon_s3.png"),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    Text(
                                      S.of(context).changexdpz,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              )),
                          const Expanded(child: SizedBox()),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                if (getCncBtState()) {
                                  showDialog(
                                      context: context,
                                      builder: (c) {
                                        return changeFixtrueDialog();
                                      }).then((value) {
                                    switch (value) {
                                      case 1:
                                        //  sendCmd([cncBtSmd.replaceFix, 0, 1, 0]);
                                        // Navigator.pushNamed(
                                        //   context,
                                        //   '/toolswait',
                                        // );
                                        sendCmd([cncBtSmd.openClamp, 0, 0, 0]);
                                        Navigator.pushNamed(
                                            context, '/toolsshow',
                                            arguments: {"page": "105"});
                                        break;
                                      case 2:
                                        // sendCmd([cncBtSmd.replaceFix, 0, 0, 0]);
                                        // Navigator.pushNamed(
                                        //   context,
                                        //   '/toolswait',
                                        // );
                                        sendCmd([cncBtSmd.openClamp, 0, 0, 0]);
                                        Navigator.pushNamed(
                                            context, '/toolsshow',
                                            arguments: {"page": "106"});
                                        break;
                                    }
                                  });
                                } else {
                                  _autoConnectBT();
                                }
                              },
                              child: Container(
                                color: const Color(0xffdde2ea),
                                height: 40.h,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 53.w,
                                      child: Image.asset(
                                          "image/tank/cnctools/Icon_s4.png"),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    Text(
                                      S.of(context).fixturecalibration,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              )),
                          const Expanded(child: SizedBox()),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                //   if (getCncBtState()) {
                                sendCmd([cncBtSmd.openClamp, 0, 0, 0]);
                                appData.getdata = true;
                                Navigator.pushNamed(context, '/toolsshow',
                                    arguments: {"page": "100"});
                                // } else {
                                //   _autoConnectBT();
                                // }
                              },
                              child: Container(
                                color: const Color(0xffdde2ea),
                                height: 40.h,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 53.w,
                                      child: Image.asset(
                                          "image/tank/cnctools/Icon_s5.png"),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    Text(
                                      S.of(context).cutcalibration,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              )),
                          const Expanded(child: SizedBox()),
                        ],
                      )))
            ],
          ),
        ),
        Container(
          width: 340.w,
          height: 126.h,
          margin:
              EdgeInsets.only(left: 10.w, top: 20.h, right: 10.w, bottom: 20.h),
          decoration: BoxDecoration(
              color: const Color(0xff384c70),
              borderRadius: BorderRadius.circular(13.0)),
          child: Column(
            children: [
              SizedBox(
                height: 23.h,
                child: Center(
                  child: Text(
                    S.of(context).cnccheck,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      width: double.maxFinite,
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Expanded(child: SizedBox()),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                if (getCncBtState()) {
                                  sendCmd([cncBtSmd.motorTest, 0, 0X05, 1, 0]);
                                  Navigator.pushNamed(context, "/toolsshow",
                                      arguments: {"page": "103"});
                                } else {
                                  _autoConnectBT();
                                }
                              },
                              child: Container(
                                color: const Color(0xffdde2ea),
                                height: 40.h,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 53.w,
                                      child: Image.asset(
                                          "image/tank/cnctools/Icon_s6.png"),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    Text(
                                      S.of(context).motortest,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              )),
                          const Expanded(child: SizedBox()),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                if (getCncBtState()) {
                                  sendCmd([cncBtSmd.checkXd, 0, 0, 0]);
                                  Navigator.pushNamed(context, "/toolsshow",
                                      arguments: {"page": "104"});
                                } else {
                                  _autoConnectBT();
                                }
                              },
                              child: Container(
                                color: const Color(0xffdde2ea),
                                height: 40.h,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 53.w,
                                      child: Image.asset(
                                          "image/tank/cnctools/Icon_s7.png"),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    Text(
                                      S.of(context).electrictest,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              )),
                          const Expanded(child: SizedBox()),
                        ],
                      )))
            ],
          ),
        ),
        appData.limit == 10
            ? Card(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/achive');
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.horizontal_rule),
                      Text("设备激活"),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget deviceinfoPage() {
    return Column();
  }

  Widget authorizationPage() {
    return Column();
  }

  @override
  void initState() {
    appData.getdata = false;
    pd = ProgressDialog(context: context);
    // settingWidget.add(parameterPage());
    // settingWidget.add(deviceinfoPage());
    //settingWidget.add(authorizationPage());
    if (appData.cncguide) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(
            barrierDismissible: false,
            barrierColor: Colors.white10,
            context: context,
            builder: (c) {
              return const GuideSetPage();
            }).then((value) {
          appData.upgradeAppData({"cncguide": false});
        });
      });
      super.initState();
    }
  }

  _autoConnectBT() {
    if (cncbtmodel.blSwitch &&
        appData.autoconnect &&
        appData.cncbluetoothname != "") {
      btstatet = eventBus.on<CNCConnectEvent>().listen((event) {
        if (event.state) {
          ////print(pd.isOpen());
          btstatet.cancel();
          pd.close();
        } else {
          pd.close();
          btstatet.cancel();
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog(S.of(context).btconnetcerror);
              }).then((value) {
            if (value) {
              btstatet.cancel();
              Navigator.pushNamed(context, '/selecnc', arguments: 3);
            }
          });
        }
        setState(() {});
      });

      pd.show(max: 100, msg: S.of(context).btconnecting);

      cncbt4model.autoConnect();
    } else {
      if (cncbtmodel.blSwitch) {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(S.of(context).needconnectbt);
            }).then((value) {
          Navigator.pushNamed(context, '/selecnc', arguments: 3);
        });
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(S.of(context).needbtopen);
            }).then((value) {
          Navigator.pushNamed(context, '/selecnc', arguments: 3);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: parameterPage(),
      // body: DefaultTabController(
      //   //初始化选择页面
      //   initialIndex: 0,
      //   //多个页面
      //   length: settingWidget.length,
      //   child: Scaffold(
      //     appBar: PreferredSize(
      //       preferredSize: const Size.fromHeight(50.0),
      //       child: AppBar(
      //         automaticallyImplyLeading: false,
      //         bottom: const TabBar(tabs: <Widget>[
      //           Tab(text: '参数'),
      //           Tab(text: '数控机'),
      //           Tab(text: '授权'),
      //         ]),
      //       ),
      //     ),
      //     //切换tab的view
      //     body: TabBarView(
      //       children: settingWidget,
      //     ),
      //   ),
      // ),
    );
  }
}
