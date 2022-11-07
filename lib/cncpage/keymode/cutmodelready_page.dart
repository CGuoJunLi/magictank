import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';

import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class CutModelReadyPage extends StatefulWidget {
  final Map arguments;
  const CutModelReadyPage(this.arguments, {Key? key}) : super(key: key);
  @override
  State<CutModelReadyPage> createState() => _CutModelReadyPageState();
}

class _CutModelReadyPageState extends State<CutModelReadyPage> {
  bool changeXD = true;
  late ProgressDialog pd;
  late StreamSubscription btstatet;
  late StreamSubscription cncbusystate;
  @override
  void initState() {
    pd = ProgressDialog(context: context);
    super.initState();
  }

  int getFirstClamp(Map keymodel) {
    if (keymodel["alltype"] == 1 ||
        keymodel["alltype"] == 2 ||
        keymodel["alltype"] == 5 ||
        keymodel["alltype"] == 8 ||
        keymodel["headtype"] != 0) {
      return 13;
    } else {
      if (keymodel["modelthickness"] > keymodel["keythickness"]) {
        return 13;
      } else {
        return 15;
      }
    }
  }

  String getkeynumbet(Map keydata) {
    if (keydata["modelwide"] == 1000) {
      if (keydata["modelthickness"] == 220) {
        return "T胚";
      } else {
        return "L胚";
      }
    } else {
      return "S胚";
    }
  }

  String getImagePath(Map keydata) {
    if (keydata["modelwide"] == 1000) {
      if (keydata["modelthickness"] == 220) {
        return appData.keyImagePath + "/fixture/model/keymodel_t.png";
      } else {
        return appData.keyImagePath + "/fixture/model/keymodel_l.png";
      }
    } else {
      return appData.keyImagePath + "/fixture/model/keymodel_s.png";
    }
  }

  _autoConnectBT() {
    btstatet = eventBus.on<CNCConnectEvent>().listen((event) {
      if (event.state) {
        ////print(pd.isOpen());
        btstatet.cancel();
        if (pd.isOpen()) {
          pd.close();
        }
      } else {
        if (pd.isOpen()) {
          pd.close();
        }
        btstatet.cancel();
        showDialog(
            context: context,
            builder: (c) {
              return const MyTextDialog("连接失败,是否进入手动连接？");
            }).then((value) {
          if (value) {
            btstatet.cancel();
            Navigator.pushNamed(context, '/selecnc', arguments: 3);
          }
        });
      }
      setState(() {});
    });
    if (cncbtmodel.blSwitch) {
      if (appData.autoconnect && appData.cncbluetoothname != "") {
        pd.show(max: 100, msg: "连接中...");

        cncbt4model.autoConnect();
      } else {
        Navigator.pushNamed(context, '/selecnc', arguments: 3);
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return MyTextDialog(S.of(context).needbtopen);
          });
    }
  }

//检查是否需要更换铣刀
  bool checkChangeXd() {
    //定义类型0.无沟槽 1.单沟槽  2.中间沟槽+上下沟槽 3 上下沟槽  4边的沟槽在中间     5.双中间沟槽   key->Thick  6  单V沟槽, 7:V+上下 8 双中间沟槽(V+直)
    //print(widget.arguments["data"]["alltype"]);
    switch (widget.arguments["data"]["alltype"]) {
      case 1: //单中间沟槽
      case 2: //中间沟槽+上下沟槽
      case 4:
        if (widget.arguments["data"]["mgroovewide"] < 200) {
          return true;
        }
        break;
      case 5: //双中间沟槽
        if (widget.arguments["data"]["mgroovewide"] < 200) {
          return true;
        }
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userTankBar(context),
        body: Column(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "请准备:",
                      style: TextStyle(
                          color: const Color(0xff384c70), fontSize: 17.sp),
                    ),
                    SizedBox(
                      width: 27.w,
                    ),
                    Container(
                      width: 100.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff384c70),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          getkeynumbet(widget.arguments["data"]),
                          style:
                              TextStyle(color: Colors.white, fontSize: 24.sp),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 60.h,
                  ),
                  Image.file(File(getImagePath(widget.arguments["data"]))),
                ],
              ),
            ),
          )),
          SizedBox(
            width: double.maxFinite,
            height: 40.h,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff384c70))),
              child: Text(S.of(context).continuebt),
              onPressed: () {
                if (getCncBtState()) {
                  ////print(checkChangeXd());
                  if (checkChangeXd() && changeXD) {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (c) {
                          return MyTextDialog(
                            S.of(context).needchangexd1,
                            button1: S.of(context).changedxd,
                            button2: S.of(context).changexd,
                          );
                        }).then((value) {
                      changeXD = false;
                      if (value) {
                        sendCmd([cncBtSmd.replaceXd, 0, 0, 0]);
                        //updatacmd([0x71, 0, 0], false);
                        Navigator.pushNamed(
                          context,
                          '/toolswait',
                          arguments: {},
                        );
                      }
                    });
                  } else {
                    sendCmd([cncBtSmd.cncState, 0, 0]);
                    cncbusystate = eventBus
                        .on<CNCStateEvent>()
                        .listen((CNCStateEvent event) {
                      cncbusystate.cancel();
                      if (event.state) {
                        Fluttertoast.showToast(msg: "机器忙,请稍后再试");
                      } else {
                        baseKey.initdata(widget.arguments["data"],
                            isKeyModel: true);
                        if (checkChangeXd()) {
                          baseKey.xdR = 75;
                        }
                        sendCmd([cncBtSmd.openClamp, 0, 0]);
                        Navigator.pushNamed(context, "/clampmodel", arguments: {
                          "type": 3,
                          "no": 0,
                          "message": getFirstClamp(widget.arguments["data"]),
                          "first": true,
                        });
                      }
                    });
                  }
                } else {
                  _autoConnectBT();
                }
              },
            ),
          )
        ]));
  }
}
