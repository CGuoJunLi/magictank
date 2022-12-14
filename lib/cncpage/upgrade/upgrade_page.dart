import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/cncpage/basekey.dart';

import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';

import 'package:magictank/convers/convers.dart';
import 'package:magictank/dialogshow/dialogpage.dart';

import 'package:magictank/http/api.dart';
import 'package:magictank/http/downfile.dart';
import 'package:magictank/main.dart';
import 'package:magictank/userappbar.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../appdata.dart';
//import '../../fileimageex.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({Key? key}) : super(key: key);

  @override
  _UpgradePageState createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  List<Widget> upgradeWidget = [];
  List<Widget> upgradeWidgettab = [];
  String cncServerVersion = "0";
  String appServerVersion = "0";
  String keyServerVersion = "0";
  String language = "0";
  int keydatadown = 0;
  int appdatadown = 0;
  late StreamSubscription eventBusDf;
  late StreamSubscription updatLcdKeyEvent;
  late ProgressDialog pd;
  List keylist = [];
  bool cangetdata = false;
  int allnum = 0;
  int sendnum = 0;
  int carmodelnum = 0;
  int civilmodelnum = 0;
  int carkeynum = 0;
  int civilkeynum = 0;
  String url = host +
      "/Binver?JQ=" +
      cncVersion.verJG.toString() +
      "&PCB=" +
      cncVersion.verPCB.toString() +
      "&sn=" +
      intToFormatStringHex(cncVersion.sn) +
      "&language=" +
      (locales!.languageCode == "zh" ? "0" : "1");
  @override
  void initState() {
    // upgradeWidget.add(cncupgrade());
    // upgradeWidget.add(lcdupgrade());
    pd = ProgressDialog(context: context);
    language = locales!.languageCode == "zh" ? "0" : "1";
    // getTankServer();
    // getkeyServer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cangetdata = true;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> getkeyServer() async {}

  Widget cncupgrade() {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: const Color(0xffeeeeee),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: double.maxFinite,
            height: 124.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        child: Text(
                          "Magic Tank",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                        top: 20.h,
                        left: 10.w,
                      ),
                      Positioned(
                        child: Text(
                          "???????????????",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black,
                          ),
                        ),
                        top: 40.h,
                        left: 10.w,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    "image/tank/2pro.png",
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            width: double.maxFinite,
            height: 200.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    const Expanded(
                      child: Text("??????"),
                    ),
                    const Expanded(
                      child: Text("????????????"),
                    ),
                    const Expanded(
                      child: Text("???????????????"),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
                Divider(
                  height: 1.h,
                ),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    if (appData.netapp["version"] != "") {
                      if (appData.appversion == appData.netapp["version"]) {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("APP????????????!");
                            });
                      } else {
                        if (!appData.hideProgressDialog[0]) {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return const MyTextDialog("????????????APP?");
                              }).then((value) async {
                            if (value) {
                              await Api.downfile(
                                  appData.netapp["url"], appData.apkPath, 0);
                              showDialog(
                                  context: context,
                                  builder: (c) {
                                    return const MyProgressDialog(
                                      "?????????????????????...",
                                      progresssmodel: 0,
                                    );
                                  }).then((value) async {
                                switch (value) {
                                  case 1:
                                    appData.hideProgressDialog[0] =
                                        true; //???????????????????????????
                                    break;
                                  case 3:
                                    appData.hideProgressDialog[0] = false;
                                    break;
                                  default:
                                    cancelDown(appData.netapp["url"]);
                                    appData.hideProgressDialog[0] = false;
                                    break;
                                }
                                setState(() {});
                              });
                            }
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return const MyProgressDialog(
                                  "?????????????????????...",
                                  progresssmodel: 0,
                                );
                              }).then((value) async {
                            switch (value) {
                              case 1:
                                appData.hideProgressDialog[0] =
                                    true; //???????????????????????????
                                break;
                              case 3:
                                appData.hideProgressDialog[0] = false;
                                break;
                              default:
                                cancelDown(appData.netapp["url"]);
                                appData.hideProgressDialog[0] = false;
                                break;
                            }
                            setState(() {});
                          });
                        }
                      }
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          "App??????",
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          appData.appversion,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appData.netapp["version"].toString(),
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.black),
                          ),
                          appData.hideProgressDialog[0] &&
                                  (cangetdata &&
                                      context.watch<AppProvid>().appdownload <
                                          100)
                              ? Text(
                                  "?????????:${context.watch<AppProvid>().appdownload}%",
                                  style: TextStyle(
                                      fontSize: 13.sp, color: Colors.black),
                                )
                              : Container(),
                        ],
                      )),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    if (!appData.hideProgressDialog[1]) {
                      if (int.parse(appData.keydataver) <
                          appData.netkeydata["version"]) {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("???????????????????????????");
                            }).then((value) async {
                          if (value) {
                            await Api.downfile(appData.netkeydata["url"],
                                appData.keyDataZipPath, 1);
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return const MyProgressDialog(
                                    "?????????????????????...",
                                    progresssmodel: 1,
                                  );
                                }).then((value) async {
                              switch (value) {
                                case 1:
                                  appData.hideProgressDialog[1] =
                                      true; //???????????????????????????
                                  break;
                                case 3:
                                  break;
                                default:
                                  cancelDown(appData.netkeydata["url"]);
                                  break;
                              }
                              setState(() {});
                            });
                          }
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("???????????????????????????");
                            }).then((value) async {
                          if (value) {
                            await Api.downfile(appData.netkeydata["url"],
                                appData.keyDataZipPath, 1);
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return const MyProgressDialog(
                                    "?????????????????????...",
                                    progresssmodel: 1,
                                  );
                                }).then((value) async {
                              switch (value) {
                                case 1:
                                  appData.hideProgressDialog[1] =
                                      true; //???????????????????????????
                                  break;
                                case 3:
                                  break;
                                default:
                                  cancelDown(appData.netkeydata["url"]);
                                  break;
                              }
                              setState(() {});
                            });
                          }
                        });
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return const MyProgressDialog(
                              "?????????????????????...",
                              progresssmodel: 1,
                            );
                          }).then((value) async {
                        switch (value) {
                          case 1:
                            appData.hideProgressDialog[1] = true; //???????????????????????????
                            break;
                          case 3:
                            appData.hideProgressDialog[1] = false;
                            break;
                          default:
                            cancelDown(appData.netkeydata["url"]);
                            appData.hideProgressDialog[1] = false;
                            break;
                        }
                        setState(() {});
                      });
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          "???????????????",
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          appData.keydataver,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appData.netkeydata["version"].toString(),
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.black),
                          ),
                          appData.hideProgressDialog[1] &&
                                  (cangetdata &&
                                      context
                                              .watch<AppProvid>()
                                              .keydatadownload <
                                          100)
                              ? Text(
                                  "?????????:${context.watch<AppProvid>().keydatadownload}%",
                                  style: TextStyle(
                                      fontSize: 13.sp, color: Colors.black),
                                )
                              : Container(),
                        ],
                      )),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    setState(() {
                      debugPrint("??????????????????");
                      if (cncVersion.verJG == 0) {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("?????????????????????");
                            });
                      } else {
                        Navigator.pushNamed(context, '/upgradelist');
                      }
                    });
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          "????????????",
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          cncVersion.version.toString(),
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          cncVersion.verJG == 0
                              ? "??????????????????"
                              : appData.nettank["ver"].toString(),
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(left: 10.w, bottom: 5.w),
                  child: Text("PCB:${cncVersion.verPCB}"),
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(left: 10.w, bottom: 5.w),
                  child: Text("JG:${cncVersion.verJG}"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Text("?????????(??????)??????????????????",
              style: TextStyle(fontSize: 13.sp, color: Colors.black)),
          const SizedBox(
            height: 2,
          ),
          Text(
            "??Magic Star (Shenzhen) Technology Co., LTD. All rights reserved",
            style: TextStyle(fontSize: 10.sp, color: Colors.black),
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Map getkeydata(int keyid, int type) {
    switch (type) {
      case 1:
        var temp = appData.carkeyList.where((r) {
          return r["id"] == keyid ? true : false;
        });

        return temp.toList()[0];

      case 2:
        var temp = appData.motorkeyList.where((r) {
          return r["id"] == keyid ? true : false;
        });

        return temp.toList()[0];

      case 3:
        var temp = appData.civilList.where((r) {
          return r["id"] == keyid ? true : false;
        });
        return temp.toList()[0];
      default:
        var temp = appData.carkeyList.where((r) {
          return r["id"] == keyid ? true : false;
        });
        return temp.toList()[0];
    }
  }

  ///??????????????????
  sendkeydata(int model) {
    List<int> senddata = [];
    List<int> temp = [];

    temp.add(keylist[sendnum]["enname"].length);

    temp.addAll(asciiStringToint(keylist[sendnum]["enname"]));

    temp.add(keylist[sendnum]["toothDepth"].length);
    for (var str in keylist[sendnum]["toothDepthName"]) {
      temp.addAll(asciiStringToint(str));
    }
    for (var str in keylist[sendnum]["toothDepth"]) {
      temp.addAll(intToFormatHex(str, 8));
    }

    baseKey.initdata(keylist[sendnum]);
    temp.addAll(baseKey.creatkeydata(1));
    // if (senddata.length < 128) {
    senddata.add(0x7c);
    senddata.add(model);
    senddata.addAll(intToFormatHex(temp.length, 8));
    sendCmd(senddata);
    // } else {
    //   debugPrint("????????????");
    // }
  }

  ///??????????????????
  sendcardata(int model) {
    List<int> senddata = [];
    senddata.add(0x7c);
    senddata.add(model);
    senddata.add(keylist[sendnum]["enbrand"].length);

    senddata.addAll(asciiStringToint(keylist[sendnum]["enbrand"].toString()));
    senddata.add(keylist[sendnum]["enbrand"].length);
    senddata.addAll(asciiStringToint(keylist[sendnum]["enbrand"].toString()));
    senddata.add(keylist[sendnum]["model"][0]["time"][0]["id"].length);
    for (var id in keylist[sendnum]["model"][0]["time"][0]["id"]) {
      senddata.addAll(intToFormatHex(id, 8));
    }
    sendCmd(senddata);
  }

  upgradelcdkeydata(int model) async {
    List readdata = [];

    updatLcdKeyEvent = eventBus
        .on<LcdUpKeyStateEvent>()
        .listen((LcdUpKeyStateEvent event) async {
      if (event.state == 0) {
        pd.update(value: ((sendnum / (allnum + 2)) * 100).toInt());
        switch (model) {
          case 0: //????????????????????????
            if (sendnum < allnum) {
              sendcardata(4);
            }
            if (sendnum == allnum) {
              sendCmd([0x7c, 1, 1]);
            }
            if (sendnum == allnum + 1) {
              updatLcdKeyEvent.cancel();
              if (pd.isOpen()) {
                pd.close();
              }
            }
            sendnum++;
            break;
          case 1:
            if (sendnum < allnum) {
              sendcardata(3);
            }
            if (sendnum == allnum) {
              sendCmd([0x7c, 1, 1]);
            }
            if (sendnum == allnum + 1) {
              Fluttertoast.showToast(msg: "????????????");
              updatLcdKeyEvent.cancel();

              if (pd.isOpen()) {
                pd.close();
              }
            }
            sendnum++;
            break;
          case 2:
            if (sendnum < allnum) {
              sendkeydata(2);
            }
            if (sendnum == allnum) {
              sendCmd([0x7c, 1, 1]);
            }
            if (sendnum == allnum + 1) {
              Fluttertoast.showToast(msg: "????????????");
              updatLcdKeyEvent.cancel();

              if (pd.isOpen()) {
                pd.close();
              }
            }
            sendnum++;
            break;

          case 3: //??????????????????
            if (sendnum < allnum) {
              sendkeydata(1);
            }
            if (sendnum == allnum) {
              sendCmd([0x7c, 1, 1]);
            }
            if (sendnum == allnum + 1) {
              updatLcdKeyEvent.cancel();

              if (pd.isOpen()) {
                pd.close();
              }
            }
            sendnum++;
            break;
          default:
        }
      } else {
        debugPrint("????????????");
      }
    });
    switch (model) {
      case 0: //??????????????????
        allnum = appData.carList.length;
        keylist = List.from(appData.carList);
        pd.show(max: 100, msg: "???????????????????????????..");
        // carmodelnum = appData.carList.length;
        // civilmodelnum = appData.civilList.length;
        // carkeynum = appData.carkeyList.length;
        // civilkeynum = appData.civilkeyList.length;
        // allnum = carmodelnum + civilmodelnum + carkeynum + civilkeynum;

        break;
      case 1: //??????????????????
        keylist = List.from(appData.civilList);
        allnum = keylist.length;

        pd.show(max: 100, msg: "???????????????????????????..");
        break;
      case 2: //????????????????????????
        keylist = [];
        keylist.addAll(appData.carkeyList);
        keylist.addAll(appData.civilkeyList);
        allnum = keylist.length;
        pd.show(max: 100, msg: "?????????????????????..");
        break;
      case 3: //????????????????????????
        readdata = await appData.getUserStar();
        ////print(keydatalist);
        for (var element in readdata) {
          if (element["state"] != 3) {
            keylist.add(getkeydata(element["keyid"], element["type"]));
          }
        }
        if (keylist.isEmpty) {
          Fluttertoast.showToast(msg: "????????????????????????");
        } else {
          if (keylist.length > 30) {
            Fluttertoast.showToast(msg: "???????????????????????????,?????????30?????????");
            allnum = 30;
          } else {
            allnum = keylist.length;
          }
          pd.show(max: 100, msg: "?????????????????????..");
        }

        break;
    }
    sendnum = 0;
    sendCmd([0x7c, 0, 0]);

    setState(() {});
    //sendkeydata(1);
  }

  Widget lcdupgrade() {
    return (cncVersion.verPCB != 0 && cncVersion.verJG != 0)
        ? Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: const Color(0xffeeeeee),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  width: double.maxFinite,
                  height: 124.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned(
                              child: Text(
                                "LCD Control",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                ),
                              ),
                              top: 20.h,
                              left: 10.w,
                            ),
                            Positioned(
                              child: Text(
                                "???????????????",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black,
                                ),
                              ),
                              top: 40.h,
                              left: 10.w,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          "image/tank/2pro.png",
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  width: double.maxFinite,
                  height: 345.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          const Expanded(
                            child: Text("??????"),
                          ),
                          const Expanded(
                            child: Text("????????????"),
                          ),
                          const Expanded(
                            child: Text("???????????????"),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                        ],
                      ),
                      const Divider(
                        height: 1,
                      ),
                      TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          setState(() {
                            debugPrint("??????????????????");
                            if (cncVersion.lcdJG == 0 ||
                                cncVersion.lcdPCB == 0) {
                              showDialog(
                                  context: context,
                                  builder: (c) {
                                    return const MyTextDialog("?????????????????????");
                                  });
                            } else {
                              Navigator.pushNamed(context, '/upgradelcdlist')
                                  .then((value) {
                                setState(() {});
                              });
                            }
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Text(
                                "????????????",
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                cncVersion.lcdVersion.toString(),
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                (cncVersion.lcdPCB == 0 ||
                                        cncVersion.lcdJG == 0)
                                    ? "??????????????????"
                                    : appData.netlcd["ver"].toString(),
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 10.w, bottom: 5.w),
                        child: Text("PCB:${cncVersion.lcdPCB}"),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 10.w, bottom: 5.w),
                        child: Text("JG:${cncVersion.lcdJG}"),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          if (cncVersion.lcdVersion <= 100) {
                            Fluttertoast.showToast(msg: "??????????????????");
                          } else {
                            upgradelcdkeydata(0);
                          }
                        },
                        child: const Text("??????LCD??????????????????"),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          if (cncVersion.lcdVersion <= 100) {
                            Fluttertoast.showToast(msg: "??????????????????");
                          } else {
                            upgradelcdkeydata(1);
                          }
                        },
                        child: const Text("??????LCD??????????????????"),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          if (cncVersion.lcdVersion <= 100) {
                            Fluttertoast.showToast(msg: "??????????????????");
                          } else {
                            upgradelcdkeydata(2);
                          }
                        },
                        child: const Text("??????LCD??????????????????"),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          if (cncVersion.lcdVersion <= 100) {
                            Fluttertoast.showToast(msg: "??????????????????");
                          } else {
                            upgradelcdkeydata(3);
                          }
                        },
                        child: const Text("??????LCD????????????"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const SizedBox(
            child: Center(
              child: Text("??????????????????????????????"),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: userTankBar(context),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xffeeeeee),
          appBar: TabBar(
              labelColor: const Color(0xff384c70),
              unselectedLabelColor: Colors.black,
              indicatorColor: const Color(0xff384c70),
              tabs: [
                Tab(
                  text: '?????????',
                  height: 20.h,
                ),
                Tab(
                  text: 'LCD',
                  height: 20.h,
                )
              ]),
          body: TabBarView(
            children: [cncupgrade(), lcdupgrade()],
          ),
        ),
      ),
    );
  }
}
