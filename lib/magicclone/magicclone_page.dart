import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';

//import 'package:archive/archive_io.dart';
//import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/http/downfile.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';
import 'package:magictank/magicclone/chipclass/progresschip.dart';
import 'package:magictank/magicclone/updata/upgrade_page.dart';

import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../main.dart';

//import 'package:flutter_archive/flutter_archive.dart';

const debug = true;
String? filepath;
//int isUp = 0; //否需要更新
//如果数据存在开始的时候就开始加载数据

class MagicClonePage extends StatefulWidget {
  const MagicClonePage({Key? key}) : super(key: key);

  @override
  _MagicClonePageState createState() => _MagicClonePageState();
}

class _MagicClonePageState extends State<MagicClonePage> {
  late ProgressDialog pd;
  double buttonsSpacing = 20;
  double imagescale = 2.0;
  Timer? timer;
  Timer? times;
  int step = 0;

  late StreamSubscription eventBusFn;
  late StreamSubscription eventBusDf;
  List<Map> getchip = [];
  late FlutterTts flutterTts;

  Duration timeout = const Duration(seconds: 120);
  // List<Map> buttonList = [
  //   {"name": "芯片生成", "picname": "image/mcclone/Icon_chipGreat.png"},
  //   {"name": "快速拷贝", "picname": "image/mcclone/Icon_chipGreat.png"},
  //   {"name": "识别复制", "picname": "image/mcclone/Icon_chipGreat.png"},
  //   {"name": "芯片模拟", "picname": "image/mcclone/Icon_chipGreat.png"},
  //   {"name": "IC卡云解码", "picname": "image/mcclone/Icon_chipGreat.png"},
  //   {"name": "门禁卡复制", "picname": "image/mcclone/Icon_chipGreat.png"},
  //   {"name": "芯片转接", "picname": "image/mcclone/Icon_chipGreat.png"},
  //   {"name": "点火线圈检测", "picname": "image/mcclone/Icon_chipGreat.png"},
  //   {"name": "密码计算", "picname": "image/mcclone/Icon_chipGreat.png"},
  // ];
  late StreamSubscription btStateEvent;
  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    // await FlutterDownloader.initialize();
    flutterTts = FlutterTts();
    pd = ProgressDialog(context: context);
    //eventBus = EventBus();

    // eventBus = EventBus();
    // 默认选中第一个颜色
    // 一次监听所有的事件
    // eventBus.on().listen((event) {
    //   // Print the runtime type. Such a set up could be used for logging.
    //   debugPrint(event.runtimeType);
    // });
    // 监听 某个具体的 事件
    // eventBusFn = eventBus.on<DownFileEvent>().listen((DownFileEvent event) {
    //   pd.update(value: event.progress);
    // });
    //监听蓝牙自动连接状态
    // btStateEvent = eventBus.on<MCConnectEvent>().listen((MCConnectEvent event) {
    //   if (event.state) {
    //     checkUpgrade();
    //   }
    //   setState(() {});
    // });
    btStateEvent = eventBus.on<MCGetVerEvent>().listen((MCGetVerEvent event) {
      if (event.state) {
        checkUpgrade();
      }
      setState(() {});
    });

    if (!mcbtmodel.getMcBtState()) {
      //没有自动时自动检测升级
      checkUpgrade();
    }
    //testICON();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    debugPrint('didChangeDependencies');
    super.didChangeDependencies();
  }

  //当State对象从渲染树中移出的时候,就会调用!即将销毁!
  @override
  void deactivate() {
    debugPrint("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint("取消监听");

    super.dispose();
  }

  Future<void> checkUpgrade() async {
    //检测APP升级
    // print("检测升级");
    Map result = {};
    if (appData.netapp.isEmpty) {
      result = await Api.appIsUp(appData.appversion);
      appData.netapp = Map.from(result);
      debugPrint("$result");
      if (result["isUpdate"]) {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(
                "检测到新APP,版本号:${result["version"]},更新内容:${result["description"]}",
                button2: "现在更新",
              );
            }).then((value) {
          if (value) {
            Api.downfile(result["url"], appData.apkPath, 0);
            showDialog(
                context: context,
                builder: (c) {
                  return const MyProgressDialog(
                    "升级APP中",
                    progresssmodel: 0,
                  );
                }).then((value) {
              switch (value) {
                case 0:
                  break;
                case 1: //隐藏
                  appData.hideProgressDialog[0] = true;
                  Fluttertoast.showToast(msg: "窗口已隐藏,可在升级中心中查看");
                  break;
                case 2:
                  break;
                case 3: //下载完成?
                  break;
              }
            });
          } else {
            context.read<AppProvid>().upgradeTip(0, "发现新APP,");
          }
        });
      }
    }
    //检测数据升级
    if (appData.netchipdata.isEmpty) {
      result = await Api.chipIsUp(appData.chipversion);
      debugPrint("$result");
      appData.netchipdata = Map.from(result);

      if (result["isUpdate"]) {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(
                "检测到新芯片数据,版本号:${result["version"]},更新内容:${result["description"]}",
                button2: "现在更新",
              );
            }).then((value) {
          if (value) {
            debugPrint(appData.chipDataPath);
            Api.downfile(
                appData.netchipdata["url"], appData.chipDataZipPath, 2);
            showDialog(
                context: context,
                builder: (c) {
                  return const MyProgressDialog(
                    "下载芯片数据中...",
                    progresssmodel: 2,
                  );
                }).then((value) {
              switch (value) {
                case 0:
                  cancelDown(appData.netchipdata["url"]);
                  appData.hideProgressDialog[2] = false;
                  break;
                case 1:
                  appData.hideProgressDialog[2] = true;
                  break;
                default:
              }
            });
          } else {
            context.read<AppProvid>().upgradeTip(4, "发现芯片数据,");
          }
        });
      }
    }
    //检测固件升级
    if (appData.netmc.isEmpty && mcbtmodel.getMcBtState()) {
      result = await Api.mcIsUp(appData.mcVer);
      debugPrint("$result");
      appData.netmc = Map.from(result);

      if (result["isUpdate"]) {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(
                "检测到新固件数据,版本号:${result["version"]},更新内容:${result["description"]}",
                button2: "现在更新",
              );
            }).then((value) {
          if (value) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (c) {
                  return Upgrade(appData.netmc["url"]);
                }).then((value) {
              if (value) {
                Fluttertoast.showToast(msg: S.of(context).upgradeok);
              } else {
                Fluttertoast.showToast(msg: S.of(context).upgradeerror);
              }
            });
          } else {
            context.read<AppProvid>().upgradeTip(3, "发现新固件,");
          }
        });
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  bool checkchipdatafile() {
    File file = File(appData.chipDataPath + "/chipdata.json");
    if (file.existsSync()) {
      //如果文件已经存在 说明有资源包
      return true;
    }
    return false;
  }

  void quickcopy() {
    eventBusFn = eventBus.on<ChipReadEvent>().listen(
      (ChipReadEvent event) {
        if (event.state == false) {
          pd.close();
          timer!.cancel();
          eventBusFn.cancel();
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog(S.of(context).chipdiscernerrortip);
              });
        } else {
          timer!.cancel();
          eventBusFn.cancel();
          debugPrint("识别成功");
          getchip = List.from(progressChip.chipdata);
          pd.close();
          Navigator.pushNamed(context, '/copychipinstructions', arguments: {
            "name": getchip[0]["防盗类型"],
            "chipnamebyte": List.from(progressChip.chipnamebyte),
          });
        }
      },
    );
    pd.show(max: 100, msg: S.of(context).chipdiscerning);
    progressChip.discernChip();

    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(timeout, () {
      pd.close();
      showDialog(
          context: context,
          builder: (c) {
            return MyTextDialog(S.of(context).chipdiscernerrortip);
          });
    });
  }

  // _autoConnectBT() {
  //   if (appData.autoconnect && mcbtmodel.blSwitch) {
  //     pd.show(max: 100, msg: S.of(context).autoconnectbt);
  //     btStateEvent = eventBus.on<MCConnectEvent>().listen(
  //       (MCConnectEvent event) async {
  //         if (event.state) {
  //           //  progressChip.getver();
  //           btStateEvent.cancel();
  //           //   await Future.delayed(const Duration(seconds: 2));
  //           pd.close();
  //         } else {
  //           pd.close();
  //           btStateEvent.cancel();
  //           Navigator.pushNamed(context, "/selemc");
  //         }
  //       },
  //     );
  //     mcbtmodel.autoConnect();
  //   } else {
  //     showDialog(
  //         context: context,
  //         builder: (c) {
  //           return const MyTextDialog("请先连接蓝牙");
  //         }).then((value) {
  //       if (value) {
  //         Navigator.pushNamed(context, '/selemc');
  //       }
  //     });
  //   }
  // }

  Widget userbuttonstyle(
      int buttonindex, String buttonimage, String buttongstr) {
    return SizedBox(
      width: 86.w,
      height: 50.h,
      child: TextButton(
        onPressed: () {
          if (checkchipdatafile()) {
            switch (buttonindex) {
              case 0:
                Navigator.pushNamed(context, '/createchip');
                break;
              case 1:

                // quickcopy();
                Navigator.pushNamed(context, '/setsuperchip');

                break;
              case 2:
                Navigator.pushNamed(context, "/copychip");
                break;
              case 3:
                break;
              case 4:
                for (var i = 0; i < appData.chipData.length; i++) {
                  if (appData.chipData[i]["chipnamebyte"][0] == 0x4d) {
                    if (appData.chipData[i]["data"][0] == "1900") {
                      for (var j = 0; j < appData.chipCarList.length; j++) {
                        for (var k = 0;
                            k < appData.chipCarList[j]["sub"].length;
                            k++) {
                          for (var l = 0;
                              l <
                                  appData.chipCarList[j]["sub"][k]["content"]
                                      .length;
                              l++) {
                            if (appData.chipCarList[j]["sub"][k]["content"][l]
                                    ["id"] ==
                                appData.chipData[i]["id"]) {
                              break;
                            }
                          }
                        }
                      }
                    }
                  }
                }
                break;
              case 5:
                break;
              case 6:
                break;
              case 7:
                Navigator.pushNamed(context, '/firecheck');

                break;
              case 8:
                break;
              default:
            }
          } else {
            if (appData.hideProgressDialog[2]) {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const MyProgressDialog(
                      "下载芯片数据中...",
                      progresssmodel: 2,
                    );
                  }).then((value) {
                switch (value) {
                  case 0:
                    cancelDown(appData.netchipdata["url"]);
                    appData.hideProgressDialog[2] = false;
                    break;
                  case 1:
                    appData.hideProgressDialog[2] = true;
                    break;
                  default:
                }
              });
            } else {
              showDialog(
                  context: context,
                  builder: (contex) {
                    return MyTextDialog(S.of(context).needdownloaddata);
                  }).then((value) {
                if (value) {
                  Api.downfile(
                      appData.netchipdata["url"], appData.chipDataZipPath, 2);
                  showDialog(
                      context: context,
                      builder: (c) {
                        return const MyProgressDialog(
                          "下载芯片数据中...",
                          progresssmodel: 2,
                        );
                      }).then((value) {
                    switch (value) {
                      case 0:
                        cancelDown(appData.netchipdata["url"]);
                        appData.hideProgressDialog[2] = false;
                        break;
                      case 1:
                        appData.hideProgressDialog[2] = true;
                        break;
                      default:
                    }
                  });
                }
              });
            }
          }
        },
        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        child: Column(
          children: [
            SizedBox(
              width: 22.r,
              height: 22.r,
              child: Image.asset(
                buttonimage,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: Center(
                child: Text(
                  buttongstr,
                  style: TextStyle(color: Colors.black, fontSize: 13.sp),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: const Color(0xffeeeeee),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            width: 340.w,
            height: 150.h,
            child: Card(
              child: Stack(
                children: [
                  Positioned(
                    left: 26.w,
                    top: 51.h,
                    child: SizedBox(
                      width: 85.w,
                      height: 15.h,
                      child: Image.asset(
                        "image/mcclone/Icon_mclogo.png",
                      ),
                    ),
                  ),
                  Positioned(
                    left: 26.w,
                    top: 86.h,
                    child: Text(
                      S.of(context).mcclonename,
                    ),
                  ),
                  Positioned(
                    left: 186.w,
                    top: 7.h,
                    child: SizedBox(
                      width: 101.w,
                      height: 128.h,
                      child: Image.asset("image/mcclone/mcclone.png"),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 340.w,
            height: 235.h,
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: 14.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 19.w,
                      ),
                      userbuttonstyle(0, "image/mcclone/Icon_chipGreat.png",
                          S.of(context).chipcreat),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(
                          1, "image/mcclone/Icon_superChip.png", "超模芯片"),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(2, "image/mcclone/Icon_chipAnalog.png",
                          S.of(context).chipcopy),
                      SizedBox(
                        width: 19.w,
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      SizedBox(
                        width: 19.w,
                      ),
                      userbuttonstyle(
                          3,
                          "image/mcclone/Icon_chipsiMulation.png",
                          S.of(context).chipsimulation),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(4, "image/mcclone/Icon_icCloud.png",
                          S.of(context).iccardcloud),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(5, "image/mcclone/Icon_doorIC.png",
                          S.of(context).doorcopy),
                      SizedBox(
                        width: 19.w,
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      SizedBox(
                        width: 19.w,
                      ),
                      userbuttonstyle(6, "image/mcclone/Icon_chipChange.png",
                          S.of(context).chipswitch),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(7, "image/mcclone/Icon_firCheck.png",
                          S.of(context).firecheck),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(8, "image/mcclone/Icon_pwdCr.png",
                          S.of(context).pwcalculation),
                      SizedBox(
                        width: 19.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                ],
              ),
            ),
          ),

          const Expanded(child: SizedBox()),
          Divider(
            color: Colors.grey,
            height: 1.h,
          ),

          //跑马灯
          SizedBox(
            height: 29.h,
            width: double.maxFinite,
            child: Row(
              children: [
                SizedBox(
                  width: 22.r,
                  height: 29.r,
                  child: const Icon(
                    Icons.volume_up,
                    color: Color(0xff0f83c6),
                    //  size: 16.sp,
                  ),
                ),
                SizedBox(
                  width: 338.w,
                  height: 29.h,
                  child: Marquee(
                    text: context.watch<AppProvid>().mctip == ""
                        ? "欢迎使用TANK拷贝机!"
                        : context.watch<AppProvid>().mctip + "请在升级中心中更新!",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 11.h,
                        color: const Color(0xff0f83c6)),
                    scrollAxis: Axis.horizontal,
                    blankSpace: 338.w,
                    velocity: 50.0,
                    // pauseAfterRound: Duration(seconds: 1),
                    // startPadding: 10.0,
                    // accelerationDuration: Duration(seconds: 1),
                    // accelerationCurve: Curves.linear,
                    // decelerationDuration: Duration(milliseconds: 1),
                    // decelerationCurve: Curves.easeOut,
                  ),
                ),
                //padding: EdgeInsets.all(1),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }
}

class MagicCloneBar extends StatelessWidget {
  const MagicCloneBar({Key? key}) : super(key: key);

  Widget userbuttonstyle(
      BuildContext context, int index, String imagepath, String buttonstr) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            SizedBox(
              width: 20.r,
              height: 20.r,
              child: Image.asset(imagepath),
            ),
            const Expanded(child: SizedBox()),
            Text(
              buttonstr,
              style: TextStyle(color: Colors.black, fontSize: 11.sp),
            ),
          ],
        ),
        onPressed: () {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/upgradecenter');
              break;
            case 1:
              break;
            case 2:
              break;
            case 3:
              Navigator.pushNamed(context, '/mccloneinf');
              break;
            default:
          }
        },
      ),
      flex: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 48.r,
      // color: const Color(0XFF6E66AA),
      padding: EdgeInsets.only(bottom: 5.w),
      child: Row(
        children: [
          userbuttonstyle(context, 0, "image/share/Icon_download.png",
              S.of(context).upgradecenter),
          const VerticalDivider(), //垂直分割线
          userbuttonstyle(context, 1, "image/share/Icon_deviceinfo.png",
              S.of(context).techinf),
          const VerticalDivider(), //垂直分割线
          userbuttonstyle(
              context, 2, "image/share/Icon_parts.png", S.of(context).mcparts),
          const VerticalDivider(), //垂直分割线
          userbuttonstyle(context, 3, "image/share/Icon_deviceinfo.png",
              S.of(context).deviceinfo),
        ],
      ),
    );
  }
}

// class _TaskInfo {
//   final String? name;
//   final String? link;

//   String? taskId;
//   int? progress = 0;
//   DownloadTaskStatus? status = DownloadTaskStatus.undefined;

//   _TaskInfo({this.name, this.link});
// }

// class _ItemHolder {
//   final String? name;
//   final _TaskInfo? task;
//   _ItemHolder({this.name, this.task});
// }
