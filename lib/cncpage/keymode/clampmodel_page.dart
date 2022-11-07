//夹取模型

import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';

import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../basekey.dart';

class ClampModelPage extends StatefulWidget {
  final Map? arguments;
  const ClampModelPage(this.arguments, {Key? key}) : super(key: key);

  @override
  State<ClampModelPage> createState() => _ClampModelPageState();
}

class _ClampModelPageState extends State<ClampModelPage> {
  int side = 0;
  int no = 0;
  int type = 0;
  List<String> imagePath = [];
  List<String> tipMessage = [];
  String gifPath = "";
  late ProgressDialog pd;
  Map arguments = {};
  late StreamSubscription btstatet;
  @override
  void initState() {
    pd = ProgressDialog(context: context);

    _getSide();
    arguments = Map.from(widget.arguments!);

    no = arguments["no"];
    super.initState();
  }

  _getSide() {
    if (widget.arguments!["type"] == 2) {
      debugPrint("完成");
      side = 5;
    } else {
      switch (widget.arguments!["message"]) {
        case 13:
          side = 1;
          break;
        case 14:
          side = 2;
          break;
        case 15:
          side = 3;
          break;
        case 16:
          side = 4;
          break;
      }
    }
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

  List<Widget> clampkey() {
    List<Widget> temp = [];
    imagePath = [];
    tipMessage = [];

    switch (side) {
      case 1:
        if (cncVersion.fixtureType == 21) {
          //新夹具
          tipMessage.add(S.of(context).fixture_model_1_1_1);
          tipMessage.add(S.of(context).fixture_model_1_1_2);

          gifPath = appData.keyImagePath + "/fixture/model/1_0_1.gif";
          for (var i = 1; i < 3; i++) {
            imagePath.add("1_0_1_$i.png");
          }
        } else {
          //旧夹具
          tipMessage.add(S.of(context).fixture_model_0_1_1);
          tipMessage.add(S.of(context).fixture_model_0_1_1);

          gifPath = appData.keyImagePath + "/fixture/model/0_0_1.gif";
          for (var i = 1; i < 3; i++) {
            imagePath.add("0_0_1_$i.png");
          }
        }
        break;
      case 2:
        if (cncVersion.fixtureType == 21) {
          //新夹具
          tipMessage.add(S.of(context).fixture_model_1_2_1);
          tipMessage.add(S.of(context).fixture_model_1_2_2);

          //立铣类型 9
          gifPath = appData.keyImagePath + "/fixture/model/1_0_1.gif";
          for (var i = 1; i < 3; i++) {
            imagePath.add("1_0_2_$i.png");
          }
        } else {
          //旧家具
          tipMessage.add(S.of(context).fixture_model_0_2_1);
          tipMessage.add(S.of(context).fixture_model_0_2_2);

          //立铣类型 9
          gifPath = appData.keyImagePath + "/fixture/model/0_0_1.gif";
          for (var i = 1; i < 3; i++) {
            imagePath.add("0_0_2_$i.png");
          }
        }
        break;
      case 3:
        if (cncVersion.fixtureType == 21) {
          //新夹具
          if (baseKey.locat == 1) {
            tipMessage.add(S.of(context).fixture_model_1_3_1);
            tipMessage.add(S.of(context).fixture_model_1_3_2);

            gifPath = appData.keyImagePath + "/fixture/model/1_0_3.gif";
            for (var i = 1; i < 3; i++) {
              imagePath.add("1_0_3_$i.png");
            }
          } else {
            tipMessage.add(S.of(context).fixture_model_1_3_1);
            tipMessage.add(S.of(context).fixture_model_1_3_2);

            //立铣类型 9
            gifPath = appData.keyImagePath + "/fixture/model/1_0_5.gif";
            for (var i = 1; i < 3; i++) {
              imagePath.add("1_0_5_$i.png");
            }
          }
        } else {
          //旧家具
          if (baseKey.locat == 1) {
            tipMessage.add(S.of(context).fixture_model_0_3_1);
            tipMessage.add(S.of(context).fixture_model_0_3_2);

            //立铣类型 9
            gifPath = appData.keyImagePath + "/fixture/model/0_0_3.gif";
            for (var i = 1; i < 3; i++) {
              imagePath.add("0_0_1_$i.png");
            }
          } else {
            tipMessage.add(S.of(context).fixture_model_0_3_1);
            tipMessage.add(S.of(context).fixture_model_0_3_2);

            //立铣类型 9
            gifPath = appData.keyImagePath + "/fixture/model/0_0_5.gif";
            for (var i = 1; i < 4; i++) {
              imagePath.add("0_0_5_$i.png");
            }
          }
        }
        break;
      case 4:
        if (cncVersion.fixtureType == 21) {
          //新夹具
          if (baseKey.locat == 1) {
            tipMessage.add(S.of(context).fixture_model_1_4_1);
            tipMessage.add(S.of(context).fixture_model_1_4_2);

            //立铣类型 9
            gifPath = appData.keyImagePath + "/fixture/model/1_0_6.gif";
            for (var i = 1; i < 3; i++) {
              imagePath.add("1_0_4_$i.png");
            }
          } else {
            tipMessage.add(S.of(context).fixture_model_1_4_1);
            tipMessage.add(S.of(context).fixture_model_1_4_2);

            //立铣类型 9
            gifPath = appData.keyImagePath + "/fixture/model/1_0_3.gif";
            for (var i = 1; i < 3; i++) {
              imagePath.add("1_0_6_$i.png");
            }
          }
        } else {
          //旧家具
          if (baseKey.locat == 1) {
            tipMessage.add(S.of(context).fixture_model_0_4_1);
            tipMessage.add(S.of(context).fixture_model_0_4_2);

            //立铣类型 9
            gifPath = appData.keyImagePath + "/fixture/model/0_0_3.gif";
            for (var i = 1; i < 3; i++) {
              imagePath.add("0_0_4_$i.png");
            }
          } else {
            tipMessage.add(S.of(context).fixture_model_0_4_1);
            tipMessage.add(S.of(context).fixture_model_0_4_2);

            //立铣类型 9
            gifPath = appData.keyImagePath + "/fixture/model/0_0_6.gif";
            for (var i = 1; i < 3; i++) {
              imagePath.add("0_0_6_$i.png");
            }
          }
        }
        break;
      case 5:
        temp.add(SizedBox(
            width: 300.r,
            height: 300.r,
            child: Stack(
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
              ],
            )));
        // temp.add(const Text("完成"));
        break;
    }

    for (var i = 0; i < imagePath.length; i++) {
      // temp.add(Text(tipMessage[i]));
      // temp.add(Image.file(
      //     File(appData.keyImagePath + "/fixture/model/" + imagePath[i])));

      temp.add(Container(
        height: 178.h,
        margin: EdgeInsets.only(left: 10.w, right: 10.w),
        decoration: BoxDecoration(
            color: const Color(0xff384c70),
            borderRadius: BorderRadius.circular(17.w)),
        child: Column(
          children: [
            SizedBox(
              height: 35.h,
              child: Center(
                  child: Text(tipMessage[i],
                      style: TextStyle(color: Colors.white, fontSize: 12.sp))),
            ),
            Expanded(
                child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17.w)),
              child: Image.file(
                File(appData.keyImagePath + "/fixture/model/" + imagePath[i]),
              ),
            )),
          ],
        ),
      ));
      temp.add(SizedBox(
        height: 20.h,
      ));
    }
    return temp;
  }

  _autoConnectBT() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: clampkey(),
          )),
          Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff384c70))),
                  child: Text(
                    S.of(context).continuebt,
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  onPressed: () {
                    if (side != 5) {
                      if (getCncBtState()) {
                        if (arguments["first"]) {
                          List<int> temp = [];
                          temp.add(cncBtSmd.cutKeyModel);
                          temp.add(0);
                          temp.addAll(baseKey.creatkeydata(0));
                          sendCmd(temp);
                          Navigator.pushReplacementNamed(
                              context, '/cutkeymodel');
                        } else {
                          sendCmd([0x9a, 0]);
                          Navigator.pushReplacementNamed(
                              context, '/cutkeymodel');
                        }
                      } else {
                        _autoConnectBT();
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return const MyTextDialog("加工完成,是否再切一把?");
                          }).then((value) {
                        if (value) {
                          arguments = Map.from({
                            "type": 3,
                            "no": 0,
                            "message": getFirstClamp(baseKey.cKeyData),
                            "first": true,
                          });
                          _getSide();

                          setState(() {});
                        } else {
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                ),
              ),
              side != 5
                  ? SizedBox(
                      width: 40.w,
                    )
                  : Container(),
              side != 5
                  ? Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        child: Text(
                          "GIF",
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/gifshow',
                              arguments: gifPath);
                        },
                      ),
                    )
                  : Container(),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
