import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:archive/archive_io.dart';
//import 'package:flutter_archive/flutter_archive.dart';
//import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/magicsmart/bluetooth/sendcmd.dart';
import 'package:marquee/marquee.dart';

import 'package:provider/provider.dart';

import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../main.dart';

//import 'package:flutter_archive/flutter_archive.dart';

const debug = true;
String? filepath;

//如果数据存在开始的时候就开始加载数据

class MagIcSmartPage extends StatefulWidget {
  const MagIcSmartPage({Key? key}) : super(key: key);

  @override
  _MagIcSmartPageState createState() => _MagIcSmartPageState();
}

class _MagIcSmartPageState extends State<MagIcSmartPage> {
  late ProgressDialog pd;
  double buttonsSpacing = 20;
  double imagescale = 2.0;
  Timer? timer;
  Timer? times;
  int step = 0;

  late StreamSubscription eventBusFn;
  late StreamSubscription eventBusDf;
  List<Map> getchip = [];
  //late FlutterTts flutterTts;

  Duration timeout = const Duration(seconds: 120);

  late StreamSubscription btStateEvent;
  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    // await FlutterDownloader.initialize();
    // flutterTts = FlutterTts();
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
    eventBusFn = eventBus.on<DownFileEvent>().listen((DownFileEvent event) {
      pd.update(value: event.progress);
    });
    //监听蓝牙自动连接状态

    checkUpgrade();

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
            downAPPFiles();
          } else {
            context.read<AppProvid>().upgradeTip(0, "发现新APP,");
          }
        });
      }
    }
    if (appData.netsmartdata.isEmpty) {
      result = await Api.smartIsUp(appData.smartversion);
      debugPrint("$result");
      appData.netsmartdata = Map.from(result);
      if (result["isUpdate"]) {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(
                " ,版本号:${result["version"]},更新内容:${result["description"]}",
                button2: "现在更新",
              );
            }).then((value) {
          if (value) {
            debugPrint(appData.smartDataPath);
            downSmartDataFiles();
          } else {
            context.read<AppProvid>().upgradeTip(6, "发现新遥控数据,");
          }
        });
      }
    }
    setState(() {});
  }

  void downSmartDataFiles() async {
    if (!pd.isOpen()) {
      pd.show(max: 100, msg: "更新数据...");
    }
    Api.downfile(appData.netsmartdata["url"], appData.smartDataZipPath, 4);
    eventBusDf = eventBus.on<DownFileEvent>().listen(
      (DownFileEvent event) async {
        if (event.progress == -1) {
          if (pd.isOpen()) {
            pd.close();
            Fluttertoast.showToast(msg: "网络异常,请稍后再试!");
          }
        } else {
          pd.update(value: event.progress);
          debugPrint("${event.progress}");
          if (!pd.isOpen() || event.progress == 100) {
            pd.close();
            eventBusDf.cancel();
            await _geizipfile();
            await appData.getSmartDataList();
            pd.close();
            appData.upgradeAppData(
                {"smartversion": appData.netsmartdata["version"].toString()});
          }
          setState(() {});
        }
      },
    );
  }

  void downAPPFiles() async {
    if (!pd.isOpen()) {
      pd.show(max: 100, msg: "下载文件中...");
    }
    Api.downfile(appData.netapp["url"], appData.apkPath, 1);

    eventBusDf = eventBus.on<DownFileEvent>().listen(
      (DownFileEvent event) async {
        if (event.progress == -1) {
          if (pd.isOpen()) {
            pd.close();
            Fluttertoast.showToast(msg: "网络异常,请稍后再试!");
          }
        } else {
          pd.update(value: event.progress);
          debugPrint("${event.progress}");
          if (!pd.isOpen() || event.progress == 100) {
            pd.close();
            eventBusDf.cancel();
          }
          setState(() {});
        }
      },
    );
  }

  Future<void> _geizipfile() async {
    File file = File(appData.smartDataZipPath);
    if (file.existsSync()) {
      //如果文件已经存在 说明有资源包
      debugPrint("文件存在");
      pd.show(max: 100, msg: "解压资源中...");
      debugPrint(appData.smartDataZipPath); //appData.smartdatazippath
      final inputStream = InputFileStream(appData.smartDataZipPath);
      // Decode the zip from the InputFileStream. The archive will have the contents of the
      // zip, without having stored the data in memory.
      final archive = ZipDecoder().decodeBuffer(inputStream);
      // For all of the entries in the archive

      for (var file in archive.files) {
        // If it's a file and not a directory
        if (file.isFile) {
          // Write the file content to a directory called 'out'.
          // In practice, you should make sure file.name doesn't include '..' paths
          // that would put it outside of the extraction directory.
          // An OutputFileStream will write the data to disk.
          final outputStream =
              OutputFileStream('${appData.smartRootPath}/${file.name}');
          // The writeContent method will decompress the file content directly to disk without
          // storing the decompressed data in memory.
          file.writeContent(outputStream);
          // Make sure to close the output stream so the File is closed.
          outputStream.close();
        }
      }
      if (pd.isOpen()) {
        pd.close();
      }
      Fluttertoast.showToast(msg: "解压完成");
    } else {
      debugPrint("文件不存在");
    }
  }

  bool checksmartdatafile() {
    File file = File(appData.smartDataPath + "/smart.json");
    if (file.existsSync()) {
      //如果文件已经存在 说明有资源包
      return true;
    }
    return false;
  }

  bool checkdoordatafile() {
    File file = File(appData.smartDataPath + "/door.json");
    if (file.existsSync()) {
      //如果文件已经存在 说明有资源包
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.black,
      child: Column(
        children: [
          Image.asset(
            "image/mcclone/magicCloneThem.png",
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
          SizedBox(
            width: double.infinity,
            height: 72.h,
            child: Row(
              children: [
                Expanded(child: Container()),
                SizedBox(
                  width: 96.r,
                  height: 72.r,
                  child: OutlinedButton(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "image/smart/Icon_carsmart.png",
                          ),
                        ),
                        Text(
                          "汽车遥控",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 13.sp,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (checksmartdatafile()) {
                        Navigator.pushNamed(context, '/createsmart');
                      } else {
                        showDialog(
                            context: context,
                            builder: (contex) {
                              return const MyTextDialog("需要先下载资源!");
                            }).then((value) {
                          if (value) {
                            downSmartDataFiles();
                          }
                        });
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: 96.r,
                  height: 72.r,
                  child: OutlinedButton(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "image/smart/Icon_doorsmart.png",
                          ),
                        ),
                        Text(
                          "车库遥控",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 13.sp,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (checksmartdatafile()) {
                        // setState(() {
                        //   if (getblstate()) {
                        //   } else {
                        //     if (btmodel.blSwitch) {
                        //       btStateEvent = eventBus.on<BTStateEvent>().listen(
                        //         (BTStateEvent event) async {
                        //           if (event.state == 4) {
                        //             debugPrint("返回");
                        //             progressChip.getver();
                        //             btStateEvent.cancel();
                        //             await Future.delayed(
                        //                 const Duration(seconds: 2));
                        //             pd.close();
                        //             //    quickcopy();
                        //           } else {
                        //             disconnect();
                        //             pd.close();
                        //             Fluttertoast.showToast(msg: "设备连接失败,请手动连接");
                        //             btStateEvent.cancel();
                        //             Navigator.pushNamed(context, "/selecnc");
                        //           }
                        //         },
                        //       );
                        //       autoconnect(appData.bluetoothname);
                        //       pd.show(max: 100, msg: "自动连接设备中..");
                        //     } else {
                        //       showDialog(
                        //           context: context,
                        //           builder: (c) {
                        //             return const MyTextDialog("请先连接蓝牙");
                        //           }).then((value) {
                        //         if (value) {
                        //           Navigator.pushNamed(context, '/selecnc');
                        //         }
                        //       });
                        //     }
                        //   }
                        // });
                      } else {
                        showDialog(
                            context: context,
                            builder: (contex) {
                              return const MyTextDialog("需要先下载资源!");
                            }).then((value) {
                          if (value) {
                            downSmartDataFiles();
                          }
                        });
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: 96.r,
                  height: 72.r,
                  child: OutlinedButton(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "image/smart/Icon_smartcopy.png",
                          ),
                        ),
                        Text(
                          "遥控拷贝",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 13.sp,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (checksmartdatafile()) {
                        //     Navigator.pushNamed(context, "/copychip");
                      } else {
                        showDialog(
                            context: context,
                            builder: (contex) {
                              return const MyTextDialog("需要先下载资源!");
                            }).then((value) {
                          if (value) {
                            downSmartDataFiles();
                          }
                        });
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),

          Expanded(
            child: Container(),
            flex: 1,
          ),
          SizedBox(
            width: double.infinity,
            height: 72.h,
            child: Row(
              children: [
                Expanded(child: Container()),
                SizedBox(
                  width: 96.r,
                  height: 72.r,
                  child: OutlinedButton(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "image/smart/Icon_checkfreq.png",
                          ),
                        ),
                        Text(
                          "频率检测",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 13.sp,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _geizipfile();
                      // if (checkchipdatafile()) {
                      //   //  Navigator.pushNamed(context, "/copychip");
                      // } else {
                      //   showDialog(
                      //       context: context,
                      //       builder: (contex) {
                      //         return const MyTextDialog("需要先下载资源!");
                      //       }).then((value) {
                      //     if (value) {
                      //       downChipDataFiles();
                      //     }
                      //   });
                      // }
                    },
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: 96.r,
                  height: 72.r,
                  child: OutlinedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "image/smart/Icon_checkpower.png",
                          ),
                        ),
                        Text(
                          "电池检测",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 13.sp,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (checksmartdatafile()) {
                        // Navigator.pushNamed(context, "/copychip");
                      } else {
                        showDialog(
                            context: context,
                            builder: (contex) {
                              return const MyTextDialog("需要先下载资源!");
                            }).then((value) {
                          if (value) {
                            downSmartDataFiles();
                          }
                        });
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: 96.r,
                  height: 72.r,
                  child: OutlinedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "image/smart/Icon_inpower.png",
                          ),
                        ),
                        Text(
                          "电池充电",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 13.sp,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (checksmartdatafile()) {
                        //   Navigator.pushNamed(context, "/copychip");
                      } else {
                        showDialog(
                            context: context,
                            builder: (contex) {
                              return const MyTextDialog("需要先下载资源!");
                            }).then((value) {
                          if (value) {
                            downSmartDataFiles();
                          }
                        });
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),

          Expanded(
            child: Container(),
            flex: 1,
          ),
          SizedBox(
            width: double.infinity,
            height: 72.h,
            child: Row(
              children: [
                Expanded(child: Container()),
                SizedBox(
                  width: 96.r,
                  height: 72.r,
                  child: OutlinedButton(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "image/smart/Icon_note.png",
                          ),
                        ),
                        Text(
                          "说明书",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 13.sp,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (checksmartdatafile()) {
                        //  Navigator.pushNamed(context, "/copychip");
                        // A5 FF 06 46 00 FF 01 F0
                        // dataCallsendBle([165, 255, 6, 70, 0, 255, 1, 240]);
                      } else {
                        showDialog(
                            context: context,
                            builder: (contex) {
                              return const MyTextDialog("需要先下载资源!");
                            });
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: 96.r,
                  height: 72.r,
                  child: OutlinedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "image/smart/Icon_dpm.png",
                          ),
                        ),
                        Text(
                          "合作开发",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 13.sp,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      if (checksmartdatafile()) {
                        // await flutterTts.setLanguage("zh-CN");
                        // await flutterTts.setSpeechRate(1.0);
                        // await flutterTts.setVolume(1.0);
                        // await flutterTts.setPitch(1.0);
                        // await appData.speakText("识别成功,识别到的芯片为:4,8,0,0");
                        // await appData.speakText("识别失败,请检查后再试吧!");
                        // await appData.speakText("识别超时,请检查后再试吧!");
                        senddata([0x60], 0x06, [0x03]);
                        // await flutterTts.isLanguageAvailable("en-US");

// iOS and Web only
                        // await flutterTts.pause();

// iOS, macOS, and Android only
                        // await flutterTts.synthesizeToFile("Hello World",
                        //     Platform.isAndroid ? "tts.wav" : "tts.caf");

                        //  await flutterTts
                        //     .setVoice({"name": "Karen", "locale": "en-AU"});

                        //  socketManage.connectSocket();
                        //A5 FF 05 46 00 FF 09 F7
                        //  progressChip.discernChip();
                        //dataCallsendBle([165, 255, 5, 70, 0, 255, 9, 247]);
                        //   Navigator.pushNamed(context, "/copychip");
                      } else {
                        showDialog(
                            context: context,
                            builder: (contex) {
                              return const MyTextDialog("需要先下载资源!");
                            });
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: 96.r,
                  height: 72.r,
                  child: OutlinedButton(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "image/smart/Icon_video.png",
                          ),
                        ),
                        Text(
                          "视频教程",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 13.sp,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (checksmartdatafile()) {
                        //   socketManage.socketClose();
                        //    Navigator.pushNamed(context, "/copychip");
                        senddata([0x60], 0x07, [0x1e, 0xff, 0x00, 0x46, 0x1]);
                      } else {
                        showDialog(
                            context: context,
                            builder: (contex) {
                              return const MyTextDialog("需要先下载资源!");
                            });
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),

          Expanded(
            child: Container(),
            flex: 3,
          ),
          const Divider(
            color: Colors.grey,
          ),
          //跑马灯
          SizedBox(
            height: 20.h,
            child: Row(
              children: [
                SizedBox(
                  width: 22.r,
                  height: 20.r,
                  child: const Icon(
                    Icons.volume_up,
                    color: Color(0xff0f83c6),
                    //  size: 16.sp,
                  ),
                ),

                SizedBox(
                  width: 338.w,
                  height: 20.r,
                  child: Marquee(
                    text: context.watch<AppProvid>().mstip == ""
                        ? "欢迎使用TANK子机下载器!"
                        : context.watch<AppProvid>().mstip + "请在升级中心中更新!",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: Colors.white),
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
          // Expanded(child: MagicCloneBar())
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}

class MagIcSmartBar extends StatelessWidget {
  const MagIcSmartBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 55.h,
      color: const Color(0XFF6E66AA),
      child: Row(
        children: [
          const VerticalDivider(),
          Expanded(
            child: TextButton(
              style: const ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                  ),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      context.watch<AppProvid>().mstip == ""
                          ? "image/share/Icon_download.png"
                          : "image/share/Icon_download1.png",
                    ),
                  ),
                  Text("下载更新",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                      )),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/smartupgradecenter");
              },
            ),
            flex: 1,
          ),
          const VerticalDivider(), //垂直分割线
          Expanded(
            child: TextButton(
              style: const ButtonStyle(
                  //backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                  ),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      "image/share/Icon_techInfo.png",
                    ),
                  ),
                  Text("技术资讯",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                      )),
                ],
              ),
              onPressed: () {
                // Navigator.pushNamed(
                //   context,
                //   '/upgrade',
                // );
              },
            ),
            flex: 1,
          ),
          const VerticalDivider(), //垂直分割线
          Expanded(
            child: TextButton(
              style: const ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                  ),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      "image/share/Icon_parts.png",
                    ),
                  ),
                  Text("材料配件",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                      )),
                ],
              ),
              onPressed: () {},
            ),
            flex: 1,
          ),
          const VerticalDivider(), //垂直分割线
          Expanded(
            child: TextButton(
              style: const ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                  ),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      "image/share/Icon_setting.png",
                    ),
                  ),
                  Text("设置",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                      )),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/appsetting');
              },
            ),
            flex: 1,
          ),
          const VerticalDivider(),
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
