//芯片生成处理页面
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';
import 'package:magictank/magicclone/chipclass/progresschip.dart';
import 'package:magictank/userappbar.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';

class CreateChipHandlePage extends StatelessWidget {
  final Map? arguments;
  const CreateChipHandlePage({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userCloneBar(context),
      body: CreateChipHandle(arguments: arguments),
    );
  }
}

class CreateChipHandle extends StatefulWidget {
  final Map? arguments;
  const CreateChipHandle({Key? key, this.arguments}) : super(key: key);

  @override
  State<CreateChipHandle> createState() => _CreateChipHandleState();
}

class _CreateChipHandleState extends State<CreateChipHandle> {
  Map chipData = {};
  Map carData = {};
  late StreamSubscription chipWriteEventFn;
  late ProgressDialog pd;
  int currenPage = 0; //记录写入的当前页
  int writestep = 0; //写入步骤记录
  late StreamSubscription btStateEvent;
  @override
  void initState() {
    carData = Map.from(widget.arguments!);
    pd = ProgressDialog(context: context);
    debugPrint("$carData");
    chipWriteEventFn = eventBus.on<ChipReadEvent>().listen(
      (ChipReadEvent event) async {
        if (event.state) {
          pd.update(value: writestep);
          writestep++;
          if (chipData["id"] == 73 && writestep == 2) {
            //72G 单片机计算
            writestep = 100; //直接完成
          }
          writeChipData();
          setState(() {});
        } else {
          //写入
          pd.close();
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog(S.of(context).chipcreaterror);
              });
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    chipWriteEventFn.cancel();

    super.dispose();
  }

  _autoConnectBT() {
    if (appData.autoconnect &&
        mcbtmodel.blSwitch &&
        appData.mcbluetoothname != "") {
      pd.show(max: 100, msg: S.of(context).autoconnectbt);
      btStateEvent = eventBus.on<MCConnectEvent>().listen(
        (MCConnectEvent event) async {
          if (event.state) {
            //  progressChip.getver();
            btStateEvent.cancel();
            //   await Future.delayed(const Duration(seconds: 2));
            pd.close();
          } else {
            pd.close();
            btStateEvent.cancel();
            Navigator.pushNamed(context, "/selemc");
          }
        },
      );
      mcbtmodel.autoConnect();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const MyTextDialog("请先连接蓝牙");
          }).then((value) {
        if (value) {
          Navigator.pushNamed(context, '/selemc');
        }
      });
    }
  }

  List<Widget> txtNote() {
    List<Widget> temp = [];
    temp.add(Text(carData["name"]));
    temp.add(Text(S.of(context).supootchip + carData["support"]));
    return temp;
  }

  Map _getChipData(int id) {
    Map temp = {};
    debugPrint("${appData.chipData.length}");
    var result = appData.chipData.where((r) {
      if (r["id"] == id) {
        return true;
      } else {
        return false;
      }
    });
    List temp2 = List.from(result);
    if (temp2.length == 1) {
      return temp2[0];
    } else {
      return temp;
    }
  }

  writeChipData() {
    //数据处理状态标记为 4 生成 和写入 读取
    //List<int> temp = [];
    // progressChip.chipnamebyte = stringHexToIntList(chipData["chipname"]);
    // progressChip.chipnamebyte = List.from(chipData["chipnamebyte"]);
    // progressChip.chipname = chipData["chipname"];
    debugPrint("${progressChip.chipnamebyte}");
    switch (progressChip.chipnamebyte[0]) {
      case 0x8a:
        switch (writestep) {
          case 0:
            if (!pd.isOpen()) {
              pd.show(max: 3, msg: S.of(context).chipcreating);
            }
            progressChip.writeChipData(0);
            break;
          default:
            if (pd.isOpen()) {
              pd.close();
            }
            Fluttertoast.showToast(msg: S.of(context).chipcreatok);
            //如果进度条关闭说明 已经全部写如完毕
            showDialog(
                context: context,
                builder: (c) {
                  return MyTextDialog(S.of(context).chipcreatokagain);
                }).then((value) {
              if (value == true) {
                writestep = 0;
                writeChipData();
              }
            });
            break;
        }
        break;
      case 0x46:
        switch (writestep) {
          case 0: //先写P1
            if (!pd.isOpen()) {
              pd.show(max: 3, msg: S.of(context).chipcreating);
            }
            progressChip.writeChipData(1, model: true);
            break;
          case 1: //再写P2
            progressChip.writeChipData(2);
            break;
          case 2: //再写P4-P7-
            progressChip.writeChipData(4);
            break;
          case 3: //再写P3
            progressChip.writeChipData(3);
            break;
          case 4:
            if (pd.isOpen()) {
              pd.close();
            }
            Fluttertoast.showToast(msg: S.of(context).chipcreatok);
            //如果进度条关闭说明 已经全部写如完毕
            showDialog(
                context: context,
                builder: (c) {
                  return MyTextDialog(S.of(context).chipcreatokagain);
                }).then((value) {
              if (value) {
                writestep = 0;
                writeChipData();
              }
            });

            break;
        }
        break;
      case 0x48:
        if (!pd.isOpen()) {
          pd.show(max: 15, msg: S.of(context).chipcreating);
        }
        if (writestep == 16) {
          if (pd.isOpen()) {
            pd.close();
          }
          Fluttertoast.showToast(msg: S.of(context).chipcreatok);
          //如果进度条关闭说明 已经全部写如完毕
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog(S.of(context).chipcreatokagain);
              }).then((value) {
            if (value) {
              writestep = 0;
              writeChipData();
            }
          });
        } else {
          progressChip.writeChipData(writestep);
        }
        break;
      case 0x4d:
        if (!pd.isOpen()) {
          pd.show(max: 31, msg: S.of(context).chipcreating);
        }
        switch (writestep) {
          case 0: //识别  4D需要先识别
            progressChip.discernChip();
            //print("旧密码:${progressChip.old4DPW}");
            break;
          case 1:
            if (chipData["id"] == 73) {
              debugPrint("72G");
              progressChip.writeChipData(0, writemodel: true);
            }
            // print("解锁");
            // print("旧密码:${progressChip.old4DPW}");
            else {
              debugPrint("普通4D");
              progressChip.chipUnlock(0);
            }
            break;
          case 2: //先用旧密码写入所有数据
            progressChip.creatChipLoadData(chipData);
            // print("旧密码:${progressChip.old4DPW}");
            progressChip.writeChipData(30, model: true);
            // eventBus.fire(ChipReadEvent(true));
            break;
          case 3:
            progressChip.writeChipData(2, model: true);
            break;
          case 4:
            progressChip.writeChipData(3, model: true);
            break;
          case 5:
            progressChip.writeChipData(4, model: true);
            break;
          case 6:
            progressChip.writeChipData(8, model: true);
            break;
          case 7:
            progressChip.writeChipData(9, model: true);
            break;
          case 8:
            progressChip.writeChipData(10, model: true);
            break;
          case 9:
            progressChip.writeChipData(11, model: true);
            break;
          case 10:
            progressChip.writeChipData(12, model: true);
            break;
          case 11:
            progressChip.writeChipData(13, model: true);
            break;
          case 12:
            progressChip.writeChipData(14, model: true);
            break;
          case 13:
            progressChip.writeChipData(15, model: true);
            break;
          case 14:
            progressChip.writeChipData(18, model: true);
            break;
          case 15:
            progressChip.writeChipData(29, model: true);
            break;
          case 16:
            progressChip.writeChipData(1, model: true);
            break;
          case 17: //开始上锁
            if (progressChip.chipPageData[0]
                    [progressChip.chipPageData[0].length - 1] ==
                "1") {
              progressChip.chipLock(1);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }

            break;
          case 18:
            if (progressChip.chipPageData[1]
                    [progressChip.chipPageData[1].length - 1] ==
                "1") {
              progressChip.chipLock(2);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 19:
            if (progressChip.chipPageData[2]
                    [progressChip.chipPageData[2].length - 1] ==
                "1") {
              progressChip.chipLock(3);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 20:
            if (progressChip.chipPageData[3]
                    [progressChip.chipPageData[3].length - 1] ==
                "1") {
              progressChip.chipLock(4);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 21:
            if (progressChip.chipPageData[4]
                    [progressChip.chipPageData[4].length - 1] ==
                "1") {
              progressChip.chipLock(8);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 22:
            if (progressChip.chipPageData[5]
                    [progressChip.chipPageData[5].length - 1] ==
                "1") {
              progressChip.chipLock(9);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 23:
            if (progressChip.chipPageData[6]
                    [progressChip.chipPageData[6].length - 1] ==
                "1") {
              progressChip.chipLock(10);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 24:
            if (progressChip.chipPageData[7]
                    [progressChip.chipPageData[7].length - 1] ==
                "1") {
              progressChip.chipLock(11);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 25:
            if (progressChip.chipPageData[8]
                    [progressChip.chipPageData[8].length - 1] ==
                "1") {
              progressChip.chipLock(12);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 26:
            if (progressChip.chipPageData[9]
                    [progressChip.chipPageData[9].length - 1] ==
                "1") {
              progressChip.chipLock(13);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 27:
            if (progressChip.chipPageData[10]
                    [progressChip.chipPageData[10].length - 1] ==
                "1") {
              progressChip.chipLock(14);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 28:
            if (progressChip.chipPageData[11]
                    [progressChip.chipPageData[11].length - 1] ==
                "1") {
              progressChip.chipLock(15);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 29:
            if (progressChip.chipPageData[12]
                    [progressChip.chipPageData[12].length - 1] ==
                "1") {
              progressChip.chipLock(18);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 30:
            if (progressChip.chipPageData[13]
                    [progressChip.chipPageData[13].length - 1] ==
                "1") {
              progressChip.chipLock(29);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          case 31:
            if (progressChip.chipPageData[14]
                    [progressChip.chipPageData[14].length - 1] ==
                "1") {
              progressChip.chipLock(30);
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
            break;
          default:
            if (pd.isOpen()) {
              pd.close();
            }
            Fluttertoast.showToast(msg: S.of(context).chipcreatok);
            //如果进度条关闭说明 已经全部写如完毕
            showDialog(
                context: context,
                builder: (c) {
                  return MyTextDialog(S.of(context).chipcreatokagain);
                }).then((value) {
              if (value == true) {
                writestep = 0;
                writeChipData();
              }
            });
            break;
        }
        break;
      default:
        Fluttertoast.showToast(msg: "未支持的芯片:${chipData["chipname"]}");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: EdgeInsets.only(left: 21.w, top: 16.h, bottom: 16.h),
            child: Text(
              widget.arguments!["name"],
              style: TextStyle(fontSize: 30.sp),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Container(
          width: 340.w,
          height: 210.h,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
          child: Image.asset(
            "image/mcclone/inchip.png",
          ),
        ),
        SizedBox(
          width: double.maxFinite,
          height: 10.h,
        ),
        Container(
          width: 340.h,
          height: 190.h,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    S.of(context).carmodel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(carData["name"])
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Text(
                    S.of(context).supootchip,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(carData["support"])
                ],
              ),
            ],
          ),
        ),
        const Expanded(child: SizedBox()),
        SizedBox(
          width: double.maxFinite,
          height: 48.h,
          child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff50c5c4))),
              onPressed: () {
                // debugPrint(carData);
                if (mcbtmodel.getMcBtState()) {
                  chipData = Map.from(_getChipData(carData["id"]));
                  // debugPrint(chipData);
                  writestep = 0;

                  if (chipData["keylist"] != null) {
                    List<String> temp = [];
                    for (var i = 0; i < chipData["keylist"].length; i++) {
                      switch (chipData["id"]) {
                        case 51:
                        case 52:
                        case 73:
                          if (i < 4) {
                            temp.add(S.of(context).masterkey +
                                "${chipData["keylist"][i]}");
                          } else {
                            temp.add(S.of(context).secondarykey +
                                "${chipData["keylist"][i]}");
                          }
                          break;
                      }
                    }
                    showDialog(
                        context: context,
                        builder: (c) {
                          return MySeleDialog(temp,
                              title: S.of(context).selecreatkey);
                        }).then((value) {
                      if (value["state"] == true) {
                        progressChip.creatChipLoadData(chipData,
                            seleindex: value["data"]);

                        writeChipData();
                      }
                    });
                  } else {
                    progressChip.creatChipLoadData(chipData);
                    writeChipData();
                  }
                  setState(() {});
                } else {
                  _autoConnectBT();
                }
              },
              child: Text(
                S.of(context).chipcreatbt,
                style: const TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }
}
