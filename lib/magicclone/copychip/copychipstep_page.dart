import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';
import 'package:magictank/magicclone/chipclass/progresschip.dart';
import 'package:magictank/userappbar.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../alleventbus.dart';
import '../network.dart';

class CopyChipInstructionsPage extends StatefulWidget {
  final Map? arguments;
  const CopyChipInstructionsPage({Key? key, this.arguments}) : super(key: key);

  @override
  _CopyChipInstructionsPageState createState() =>
      _CopyChipInstructionsPageState();
}

class _CopyChipInstructionsPageState extends State<CopyChipInstructionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: userCloneBar(context),
      body: CopyPageStep(
        arguments: widget.arguments,
      ),
    );
  }
}

class CopyPageStep extends StatefulWidget {
  final Map? arguments;
  const CopyPageStep({Key? key, this.arguments}) : super(key: key);

  @override
  _CopyPageStepState createState() => _CopyPageStepState();
}

class _CopyPageStepState extends State<CopyPageStep> {
  StreamSubscription? eventBusFn;
  StreamSubscription? chipWriteEventFn;
  late ProgressDialog pd;
  //List<Map> getchip = [];
  Timer? timer;
  Timer? times;
  int copystep = 0;
  bool netstate = false;
  // bool closeW = true;
  Duration timeout = const Duration(seconds: 10); //识别超时
  Duration othertime = const Duration(seconds: 5); //识别超时
  Duration serverout = const Duration(seconds: 10); //服务器超时
  Duration getout = const Duration(seconds: 10); //采集超时
  List<String> chip46list = [
    "46芯片拷贝",
    "智能卡拷贝",
    "现代起亚密码",
    "一键写比亚迪",
    "比亚迪全丢",
  ];
  String tips() {
    switch (widget.arguments != null
        ? widget.arguments!["chipnamebyte"][0]
        : progressChip.chipnamebyte[0]) {
      case 0x46:
        switch (copystep) {
          case 1:
            return S.of(context).chipdiscerntip;
          case 2:
          case 3:
            return S.of(context).chipcollection;
          case 4:
            return S.of(context).chipcollectionok;
          case 5:
            return S.of(context).inorignelkey;
          case 6:
            return S.of(context).inorignelkeyok;
          case 7:
            return S.of(context).connectnetserver;
          case 8:
          case 9:
            return S.of(context).updata;
          case 10:
            return "${progressChip.servertimer}s...";
          case 11:
            return S.of(context).readyencode;
          case 100:
            return S.of(context).encodeok;
          default:
            return "$copystep缺失说明";
        }
      case 0x4d:
        switch (copystep) {
          case 1:
            return S.of(context).chipdiscerntip;
          case 2:
            return "读取数据中请勿移动钥匙...";
          case 3:
            return S.of(context).connectnetserver;
          case 4:
            return S.of(context).updata;
          case 5:
            return "${progressChip.servertimer}秒...";
          case 6:
            return S.of(context).encodeing;
          case 100:
            return S.of(context).encodeok;
          default:
            return "$copystep缺失说明";
        }
      case 0x4c:
      case 0x8a:
      case 0x13:
      case 0xd5:
      case 0x11:
      case 0x12:
        switch (copystep) {
          case 1:
            return "请把原钥匙放在线圈中进行识别";
          case 100:
            return "解码完成,准备拷贝";
          default:
            return "$copystep缺失说明";
        }
      default:
        return "未知芯片 ${widget.arguments!["id"]}";
    }
  }

  String showpic() {
    switch (copystep) {
      case 10:
        return "image/mcclone/inchip.png";
      case 11:
        return "image/mcclone/inchip.png";
      case 1:
        return "image/mcclone/inkey.png";
      case 2:
        return "image/mcclone/inchip.png";
      case 3:
        return "image/mcclone/inchip.png";
      case 4:
        return "image/mcclone/inchip.png";
      case 5:
        return "image/mcclone/inchip.png";
      default:
        return "image/mcclone/inchip.png";
    }
  }

  @override
  void dispose() {
    progressChip.copy = false;
    super.dispose();
    if (eventBusFn != null) {
      eventBusFn!.cancel();
    }
    if (chipWriteEventFn != null) {
      chipWriteEventFn!.cancel();
    }
  }

  @override
  void initState() {
    pd = ProgressDialog(context: context);

    eventBus.on<NetStateEvent>().listen((event) {
      if (event.state == false) {
        setState(() {
          pd.close();
          Fluttertoast.showToast(msg: S.of(context).connectnetservererror);
          Navigator.pop(context);
        });
      }
    });

    eventBusFn = eventBus.on<ChipReadEvent>().listen(
      (ChipReadEvent event) {
        if (event.state == false) {
          if (copystep == 100) {
            if (times != null) {
              times!.cancel();
            }
            if (pd.isOpen()) {
              pd.close();
            }

            Fluttertoast.showToast(msg: S.of(context).copychiperror);
            copystep = 100;
            upgradeDialog(closeW: false);
            setState(() {});
          } else {
            //46芯片的第三步 会一直询问 采集状态.所以需要移除 为采集到数据的状态
            if (!(progressChip.chipnamebyte[0] == 0x46 &&
                (copystep == 3 || copystep == 5))) {
              if (times != null) {
                times!.cancel();
              }
              if (pd.isOpen()) {
                pd.close();
              }
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (c) {
                    return const MyTextDialog(
                      "出错了,请重试",
                    );
                  });
            }
          }
        } else {
          // timer!.cancel();
          if (times != null) {
            //需要循环发送的需要取消循环
            times!.cancel();
          }
          if (copystep == 100) {
            copystep = 100;
            pd.close();
            Fluttertoast.showToast(msg: S.of(context).copychipok);
            upgradeDialog(closeW: false);
          } else {
            copystep++;
            print(progressChip.chipnamebyte);
            switch (progressChip.chipnamebyte[0]) {
              case 0x4d:
                switch (copystep) {
                  case 2: //获取签名
                    if (progressChip.copy == true) {
                      copystep = 100;
                      upgradeDialog();
                      print("step2");
                    } else {
                      print("step2_1");
                      upgradeDialog();
                      progressChip.getsign(); //获取芯片的签名信息
                    }
                    break;
                  case 3: //准备网络解码 获得密码
                    print("step3");
                    upgradeDialog();
                    mqttManage.serverConnect();
                    break;
                  case 4: //发送数据到服务器
                    print("step4");
                    upgradeDialog();
                    progressChip.sendcmdtoserver();
                    timer = Timer(const Duration(seconds: 20), () {
                      Fluttertoast.showToast(msg: "上传超时");
                      mqttManage.serverDisconent();
                      Navigator.pop(context);
                    });
                    break;
                  case 5: //服务器返回排队情况
                    print("step5");
                    upgradeDialog();
                    if (timer != null) {
                      timer!.cancel();
                    }
                    serverout = Duration(seconds: progressChip.servertimer);
                    timer = Timer(serverout, () {
                      copystep = 0;
                      //  progressChip.netcloss(); //关闭流
                      mqttManage.serverDisconent();
                      showDialog(
                          context: context,
                          builder: (c) {
                            return MyTextDialog(
                                S.of(context).connectnetservertimerout);
                          }).then((value) {
                        setState(() {
                          timer!.cancel();
                          //   progressChip.netcloss(); //关闭流
                          Navigator.pop(context); //退出识别步骤
                        });
                      });
                    });
                    break;
                  case 6: //将密码发送至下位机进行解码  4d不会返回
                    if (timer != null) {
                      timer!.cancel();
                    }
                    print("step6");
                    upgradeDialog();
                    progressChip.encodeChip();
                    copystep = 100;
                    //  upgradeDialog();
                    setState(() {});
                    break;
                }
                break;
              case 0x46:
                switch (copystep) {
                  case 2: //进入采集页面
                    if (progressChip.copy == true) {
                      copystep = 100;
                      upgradeDialog();
                    } else {
                      upgradeDialog();
                      debugPrint("发送进入采集页面");
                      progressChip.chipCollection();
                    }
                    break;
                  case 3: //循环判断是否采集到数据
                    debugPrint("进入采集页面成功,询问是否获得数据");
                    upgradeDialog();
                    collectionChip();
                    break;
                  case 4: //采集完成
                    debugPrint("采集成功");
                    upgradeDialog();
                    progressChip.collectionChipOk();
                    break;
                  case 5: //确定插入原钥匙
                    upgradeDialog();
                    inOriginalKey(); //等待插入原钥匙
                    break;
                  case 6: //等待返回6组数据
                    upgradeDialog();
                    progressChip.getsign();
                    break;
                  case 7: //尝试连接服务为器
                    upgradeDialog();
                    mqttManage.serverConnect();
                    break;
                  case 8: //发送数据到服务器
                    upgradeDialog();
                    progressChip.sendcmdtoserver();
                    break;
                  case 9: //服务器返回排队情况
                    upgradeDialog();
                    progressChip.sendcmdtoserver();
                    break;
                  case 10: //根据返回数据确认超时解码超时信息
                    upgradeDialog();
                    if (timer != null) {
                      timer!.cancel();
                    }
                    serverout = Duration(seconds: progressChip.servertimer);
                    timer = Timer(serverout, () {
                      copystep = 0;
                      //  progressChip.netcloss(); //关闭流
                      mqttManage.serverDisconent();
                      showDialog(
                          context: context,
                          builder: (c) {
                            return MyTextDialog(
                                S.of(context).connectnetservertimerout);
                          }).then((value) {
                        timer!.cancel();
                        Navigator.pop(context); //退出识别步骤
                      });
                    });
                    break;
                  case 11:
                    if (timer != null) {
                      timer!.cancel();
                    }
                    ////print("准备解码");
                    upgradeDialog();
                    progressChip.encodeChip();
                    break;
                  case 12:
                    copystep = 100;
                    // upgradeDialog();
                    setState(() {});
                    break;
                  default:
                }
                break;
              case 0x8a:
              case 0x4c:
              case 0x13:
              case 0xd5:
              case 0x12:
              case 0x11:
                switch (copystep) {
                  case 2:
                    copystep = 100;
                    upgradeDialog();
                    break;
                  default:
                }
                break;
            }
          }
        }
        setState(() {});
      },
    );

    super.initState();
  }

//更新弹窗显示
  void upgradeDialog({bool closeW = true}) {
    if (closeW) {
      Navigator.pop(context);
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c) {
          // return copystepshow(state);
          return copystepshow();
        }).then((value) {
      debugPrint("$value");
      if (copystep == 100 && value == true) {
        //发送拷贝命令
        pd.show(max: 100, msg: S.of(context).copychiping);
        debugPrint("发送拷贝命令");
        progressChip.copyCurrentChip();
      }
    });
  }

//识别芯片
  Future<void> checkChip() async {
    //Duration duration=

    if (widget.arguments!["needcheck"]) {
      //需要检测芯片
      progressChip.discernChip();
    } else {
      //不需要检测芯片,直接进入破解流程
      eventBus.fire(ChipReadEvent(true));
    }

    // times = Timer.periodic(const Duration(seconds: 10), (times) {
    //   debugPrint("开始识别芯片");
    //   progressChip.discernChip();
    // });
  }

//46采集芯片
  Future<void> collectionChip() async {
    //Duration duration=
    times = Timer.periodic(const Duration(seconds: 10), (times) {
      debugPrint("询问是否采集到数据");
      progressChip.collectionChipState();
    });
  }

  Future<void> inOriginalKey() async {
    //Duration duration=
    times = Timer.periodic(const Duration(seconds: 10), (times) {
      debugPrint("询问是否插入原厂钥匙");
      progressChip.inoriginal();
    });
  }

//复制步骤显示
  Widget copystepshow() {
    return WillPopScope(
      onWillPop: () async {
        switch (progressChip.chipnamebyte[0]) {
          case 0x46:
            if (copystep == 3) {
              showDialog(
                  context: context,
                  builder: (c) {
                    return MyTextDialog(S.of(context).outtip);
                  }).then((value) {
                if (value) {
                  if (times != null) {
                    times!.cancel();
                  }
                  if (pd.isOpen()) {
                    pd.close();
                  }
                  Navigator.pop(context);
                  return true;
                } else {
                  return false;
                }
              });
              return false;
            } else {
              return false;
            }
          default:
            return false;
        }
      },
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            // color: Colors.white,
            width: 300.w,
            height: 400.h,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                  child: Center(
                      child: Text(
                    S.of(context).chipdiscerning,
                    style: const TextStyle(fontSize: 20),
                  )),
                ),
                Container(
                  width: 300.w,
                  height: 300.h,
                  color: const Color(0xffeeeeee),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(showpic()),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(tips()),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: copystep == 100
                      ? Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                  // return false;
                                },
                                child: Text(
                                  S.of(context).returnbt,
                                  style:
                                      const TextStyle(color: Color(0xff50c5c4)),
                                ),
                              ),
                            ),
                            const VerticalDivider(),
                            Expanded(
                              child: ElevatedButton(
                                //多功能按钮
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text(
                                  S.of(context).copybt,
                                  style:
                                      const TextStyle(color: Color(0xff50c5c4)),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(
                          color: Color(0xff50c5c4),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //根据芯片主页显示的内容
  Widget setwidget() {
    switch (widget.arguments != null
        ? widget.arguments!["chipnamebyte"][0]
        : progressChip.chipnamebyte[0]) {
      case 0x46:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.r, top: 10.r, bottom: 10.r),
                  child: Text(
                    widget.arguments!["name"],
                    style: TextStyle(fontSize: 30.sp),
                  ),
                )),
            Container(
              width: 340.w,
              height: 180.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r)),
              child: Image.asset("image/mcclone/inkey.png"),
            ),
            Container(
              width: 340.w,
              height: 180.h,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListView(
                children: [
                  const Text("1.将原车钥匙放入MagicClone线圈进行识别。"),
                  const Text("2.将MagicClone靠近汽车点火开关(识别线圈)处进行采集。"),
                  const Text(
                      "如果是非智能钥匙,插入原车钥匙,打开点火开关,关闭点火开关,拔出原车钥匙。重复该步骤直到提示采集数据结束。"),
                  const Text(
                      "如果是智能钥匙,需要取出智能钥匙电池,将智能钥匙靠近感应区并点亮仪表,关闭点火开关,移走钥匙。重复该步骤直到提示采集数据结束。"),
                  widget.arguments!["id"] == 2
                      ? const Text(
                          "如果是沃尔沃等部分车型每次只能采集一次数据,需要断开电瓶采集下一组数据",
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                  const Text("3.将原车钥匙放入MagicClone线圈进行计算。"),
                  const Text("4.从服务器查询计算结果。"),
                  const Text("5.拷贝芯片。"),
                ],
              ),
            ),
            SizedBox(
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "识别",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(
                    Icons.arrow_forward_sharp,
                    color: Color(0xff50c5c4),
                  ),
                  Text(
                    "采集",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(
                    Icons.arrow_forward_sharp,
                    color: Color(0xff50c5c4),
                  ),
                  Text(
                    "上传",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(
                    Icons.arrow_forward_sharp,
                    color: Color(0xff50c5c4),
                  ),
                  Text(
                    "计算",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(
                    Icons.arrow_forward_sharp,
                    color: Color(0xff50c5c4),
                  ),
                  Text(
                    "查询",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              height: 48.h,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0XFF50c5c4))),
                child: const Text(
                  "开始拷贝",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  copystep = 1;
                  progressChip.initstep();
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (c) {
                        // return copystepshow(state);
                        return copystepshow();
                      });
                  checkChip(); //每秒发送一次识别命令
                },
              ),
            ),
          ],
        );

      case 0x4d:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.r, top: 10.r, bottom: 10.r),
                  child: Text(
                    widget.arguments!["name"],
                    style: TextStyle(fontSize: 30.sp),
                  ),
                )),
            Container(
              width: 340.w,
              height: 180.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r)),
              child: Image.asset("image/mcclone/inkey.png"),
            ),
            Container(
              width: 340.w,
              height: 180.h,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListView(
                children: const [
                  Text("1.将原车钥匙放入MagicClone线圈进行识别。"),
                  Text("2.将原车钥匙放入MagicClone线圈进行计算。"),
                  Text("3.从服务器查询计算结果。"),
                  Text("4.拷贝芯片。"),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "识别",
                    style: TextStyle(
                        color: copystep >= 1 ? Colors.red : Colors.black),
                  ),
                  const Icon(
                    Icons.arrow_forward_sharp,
                    color: Color(0XFF50C5C4),
                  ),
                  Text(
                    "上传",
                    style: TextStyle(
                        color: copystep >= 2 ? Colors.red : Colors.black),
                  ),
                  const Icon(
                    Icons.arrow_forward_sharp,
                    color: Color(0XFF50C5C4),
                  ),
                  Text(
                    "计算",
                    style: TextStyle(
                        color: copystep >= 3 ? Colors.red : Colors.black),
                  ),
                  const Icon(
                    Icons.arrow_forward_sharp,
                    color: Color(0XFF50C5C4),
                  ),
                  Text(
                    "查询",
                    style: TextStyle(
                        color: copystep >= 4 ? Colors.red : Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 40.h,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0XFF50C5C4))),
                child: const Text(
                  "开始拷贝",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  setState(() {
                    if (mcbtmodel.getMcBtState()) {
                      copystep = 1;
                      if (widget.arguments!["needcheck"]) {
                        progressChip.initstep(needclearchip: false);
                      }
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (c) {
                            // return copystepshow(state);
                            return copystepshow();
                          });
                      checkChip(); //每秒发送一次识别命令
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return const MyTextDialog("请先连接蓝牙");
                          }).then((value) {
                        if (value) {
                          Navigator.pushNamed(context, '/selemc', arguments: 2);
                        }
                      });
                    }
                  });
                },
              ),
            ),
          ],
        );
      case 0x4c:
      case 0x8a:
      case 0x13:
      case 0xd5:
      case 0x11:
      case 0x12:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.r, top: 10.r, bottom: 10.r),
                  child: Text(
                    widget.arguments!["name"],
                    style: TextStyle(fontSize: 30.sp),
                  ),
                )),
            Container(
              width: 340.w,
              height: 180.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r)),
              child: Image.asset("image/mcclone/inkey.png"),
            ),
            Container(
              width: 340.w,
              height: 180.h,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListView(
                children: const [
                  Text("1.将原车钥匙放入MagicClone线圈进行识别。"),
                  Text("2.拷贝芯片。"),
                ],
              ),
            ),
            SizedBox(
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "识别",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(
                    Icons.arrow_forward_sharp,
                    color: Color(0xff50c5c4),
                  ),
                  Text(
                    "拷贝",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 40.h,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff50c5c4))),
                child: const Text(
                  "开始拷贝",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  copystep = 1;
                  progressChip.initstep();
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (c) {
                        // return copystepshow(state);
                        return copystepshow();
                      });
                  checkChip(); //每秒发送一次识别命令

                  // showDialog(
                  //     barrierDismissible: false,
                  //     context: context,
                  //     builder: (c) {
                  //       return MySeleDialog(
                  //         chip46list,
                  //         //Title: "拷贝方式",
                  //       );
                  //     }).then(
                  //   (value) {
                  //     if (value["state"]) {
                  //       switch (value["data"]) {
                  //         case 0: //46芯片拷贝
                  //           showDialog(
                  //               barrierDismissible: false,
                  //               context: context,
                  //               builder: (c) {
                  //                 // return copystepshow(c, state);\
                  //                 copystep = 1;
                  //                 return copystepshow();
                  //               });

                  //           checkChip();
                  //           break;

                  //         default:
                  //           break;
                  //       }
                  //       debugPrint(value["data"]);
                  //     }
                  //   },
                  // );
                },
              ),
            ),
          ],
        );
      case 6:
        return Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 35,
              child: Text(
                widget.arguments!["name"],
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Expanded(
              child: Image.asset("image/mcclone/Icon_copychip.png"),
              flex: 1,
            ),
            Expanded(
              child: ListView(
                children: const [
                  Text("1.将原车钥匙放入MagicClone线圈进行识别。"),
                  Text("2.MagicStart超模芯片放入MagicClone线圈进行初始化"),
                  Text("3.从服务器查询计算结果。"),
                  Text("4.拷贝芯片。"),
                ],
              ),
              flex: 2,
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "识别",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.arrow_forward_sharp),
                  Text(
                    "初始化",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.arrow_forward_sharp),
                  Text(
                    "计算",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.arrow_forward_sharp),
                  Text(
                    "拷贝",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 50,
              child: TextButton(
                child: const Text("开始拷贝"),
                onPressed: () {},
              ),
            ),
          ],
        );
      case 7:
      case 11:
      case 12:
      case 13:
      case 14:
        return Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 35,
              child: Text(
                widget.arguments!["name"],
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Expanded(
              child: Image.asset("image/mcclone/Icon_copychip.png"),
              flex: 1,
            ),
            Expanded(
              child: ListView(
                children: const [
                  Text("1.将原车钥匙放入MagicClone线圈进行识别。"),
                  Text("2.拷贝芯片。"),
                ],
              ),
              flex: 2,
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "识别",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.arrow_forward_sharp),
                  Text(
                    "拷贝",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 50,
              child: TextButton(
                child: const Text("开始拷贝"),
                onPressed: () {},
              ),
            ),
          ],
        );
      case 8:
        return Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 35,
              child: Text(
                widget.arguments!["name"],
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Expanded(
              child: Image.asset("image/mcclone/Icon_copychip.png"),
              flex: 1,
            ),
            Expanded(
              child: ListView(
                children: const [
                  Text(
                    "注意：需要先用子机生成铃木启锐选项",
                    style: TextStyle(color: Colors.red),
                  ),
                  Text("1.将原车钥匙放入MagicClone线圈进行识别。"),
                  Text("2.MagicStart超模芯片放入MagicClone线圈进行初始化"),
                  Text("3.从服务器查询计算结果。"),
                  Text("4.拷贝芯片。"),
                ],
              ),
              flex: 2,
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "识别",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.arrow_forward_sharp),
                  Text(
                    "计算",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.arrow_forward_sharp),
                  Text(
                    "拷贝",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 50,
              child: TextButton(
                child: const Text("开始拷贝"),
                onPressed: () {},
              ),
            ),
          ],
        );
      case 9:
      case 10:
        return const Text("需要先连接蓝牙");
      default:
        return Column(
          children: [
            const Expanded(child: Text("未支持的芯片类型!")),
            TextButton(
              child: const Text("返回"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
    }

    //return Container();
  }

  @override
  Widget build(BuildContext context) {
    return setwidget();
  }
}
