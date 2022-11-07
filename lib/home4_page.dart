import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/cncpage/cnc_page.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';
import 'package:magictank/magicclone/magicclone_page.dart';
import 'package:magictank/magicsmart/bluetooth/msclonebt_mananger.dart';
import 'package:magictank/magicsmart/magicsmart_page.dart';
import 'package:magictank/main.dart';
import 'package:magictank/morepage/othermagess_page.dart';
import 'package:magictank/privacy_page.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart'; //权限管理
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/drawer_page.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'swiper/flutter_swiper_null_safety.dart';

class Tips4Page extends StatefulWidget {
  const Tips4Page({Key? key}) : super(key: key);

  @override
  State<Tips4Page> createState() => _Tips4PageState();
}

class _Tips4PageState extends State<Tips4Page> {
  int count = 10;
  Timer? timer;
  DateTime? lastPressedAt;
  late StreamSubscription cncbtstate;
  late StreamSubscription mcbtstate;
  late StreamSubscription msbtstate;
  late StreamSubscription btswitch;
  bool btswitchstate = false;
  //FlutterReactiveBle flutterBlue = FlutterReactiveBle();
  int pageindex = 0;
  List<Widget> allfunction = [
    const MagIcSmartPage(),
    const MagicClonePage(),
    const CNCPage(),
  ];
  List<Widget> function = [];
  List<Widget> alladditional = [
    const MagIcSmartBar(),
    const MagicCloneBar(),
    const CNCPageBar(),
  ];
  List<Widget> additional = [
    // const OtherMessagePageBar(),
  ];
  int machineType = 0; //当前页面机器类型
  late Location location;
  late ProgressDialog pd;
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  bool autoconnetedFlag = false;
  @override
  void initState() {
    //首先确定蓝牙状态

    pd = ProgressDialog(context: context);
    function = [];
    additional = [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openDownFileEvent();
      if (appData.welcomepage && !appData.inmainpage) {
        startTime();
      }
      if (!appData.agreeprivcy) {
        showDialog(
            context: context,
            builder: (c) {
              return const PrivacyTip();
            }).then((value) {
          if (value) {
            appData.upgradeAppData({"agreeprivcy": true});
            setState(() {});
          } else {
            SystemNavigator.pop();
          }
        });
      }
    });

    function.add(const OtherMessagePage());
    additional.add(const OtherMessagePageBar());
    // print("appData.lastPage:${appData.lastPage}");
    pageindex = appData.lastPage;

    for (var i = 0; i < appData.hidePage.length; i++) {
      if (appData.hidePage[i].toString() == "false") {
        function.add(allfunction[i]);
        additional.add(alladditional[i]);
      }
    }

    getmachineType();

    checkPermission();
    location = Location();
    checkGpsServer();
    btswitch = _ble.statusStream.listen((event) {
      if (event == BleStatus.ready) {
        cncbtmodel.blSwitch = true;
        mcbtmodel.blSwitch = true;
        msbtmodel.blSwitch = true;
      } else if (event == BleStatus.poweredOff) {
        cncbtmodel.blSwitch = false;
        mcbtmodel.blSwitch = false;
        msbtmodel.blSwitch = false;
        print("蓝牙关闭?");
        cncbt4model.disconnect();
        mcbtmodel.disconnect();
      }
      setState(() {});
    });
    cncbtstate = eventBus.on<CNCConnectEvent>().listen((CNCConnectEvent event) {
      autoconnetedFlag = false;
      if (event.state) {
        // Fluttertoast.showToast(msg: S.of(context).btconnetok);
        cncbtmodel.state = true;
      } else {
        cncVersion.clear();
        //  Fluttertoast.showToast(msg: S.of(context).btconnetcerror);
        cncbtmodel.state = false;
      }
      setState(() {});
    });
    mcbtstate = eventBus.on<MCConnectEvent>().listen((MCConnectEvent event) {
      autoconnetedFlag = false;
      if (event.state) {
        appData.mcVer = "0";
        // Fluttertoast.showToast(msg: S.of(context).btconnetok);
        mcbtmodel.state = true;
      } else {
        // Fluttertoast.showToast(msg: S.of(context).btconnetcerror);
        mcbtmodel.state = false;
      }
      setState(() {});
    });
    msbtstate = eventBus.on<MSConnectEvent>().listen((MSConnectEvent event) {
      autoconnetedFlag = false;
      if (event.state) {
        msbtmodel.state = true;
      } else {
        msbtmodel.state = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    btswitch.cancel();
    cncbtstate.cancel();
    mcbtstate.cancel();
    msbtstate.cancel();
    //print("main dispose");
    super.dispose();
  }

  _openDownFileEvent() {
    //下载APP
    eventBus.on<DownAppEvent>().listen(
      (DownAppEvent event) {
        //安装过APP
        if (event.progress == -1) {
          Fluttertoast.showToast(msg: S.of(context).downfileerror);
        } else {
          context.read<AppProvid>().appProgress(event.progress);
          if (event.progress == 100) {
            OpenFile.open(appData.apkPath);
          }
        }
      },
    );
    //下载钥匙数据
    eventBus.on<DownKeyDataEvent>().listen(
      (DownKeyDataEvent event) async {
        if (event.progress == -1) {
          Fluttertoast.showToast(msg: S.of(context).downfileerror);
        } else {
          context.read<AppProvid>().keydataProgress(event.progress);

          if (event.progress == 100) {
            //下载完成后解压
            debugPrint("下载完成准备解压");
            await Future.delayed(const Duration(seconds: 3));
            appData.hideProgressDialog[1] = false;
            await appData.geizipfile(
                appData.keyDataZipPath, appData.tankRootPath);
            await appData.getAllCarName();
            await appData.getAllCarKeyData();
            await appData.getAllCivilName();
            await appData.getAllCivilKeyData();
            await appData.getAllMotorName();
            await appData.getAllMotorKeyData();
            await appData.pModelData();
            await appData.lModelData();
            await appData.getReadCodeData();
            appData.upgradeAppData(
                {"keydataver": appData.netkeydata["version"].toString()});
            imageCache.clear();
            imageCache.clearLiveImages();
            debugPrint("下解压完成");
          }
        }
      },
    );
    eventBus.on<DownChipDataEvent>().listen(
      (DownChipDataEvent event) async {
        if (event.progress == -1) {
          Fluttertoast.showToast(msg: S.of(context).downfileerror);
        } else {
          context.read<AppProvid>().chipdataProgress(event.progress);
          if (event.progress == 100) {
            //下载完成后解压
            debugPrint("芯片数据下载完成 准备解压");
            await Future.delayed(const Duration(seconds: 3));
            appData.hideProgressDialog[2] = false;
            await appData.geizipfile(
                appData.chipDataZipPath, appData.mcRootPath);
            await appData.getChipCarList();
            await appData.getChipIdList();
            await appData.getChipDataList();
            appData.upgradeAppData(
                {"chipversion": appData.netchipdata["version"].toString()});

            imageCache.clear();
            imageCache.clearLiveImages();
          }
        }
      },
    );
  }

  void autoconnect() {
    if (!appData.inmainpage && msbtmodel.blSwitch && appData.beginautobt) {
      appData.inmainpage = true;
      switch (machineType) {
        case 1: //子机下载器
          if (!getMsBtState() &&
              (appData.smartbluetoothname != "") &&
              appData.autoconnect) {
            autoconnetedFlag = true;
            msautoConnectBT();
          }
          break;
        case 2: //eclone
          print(mcbtmodel.getMcBtState());
          print(appData.mcbluetoothname);
          print(appData.autoconnect);
          if (!mcbtmodel.getMcBtState() &&
              (appData.mcbluetoothname != "") &&
              appData.autoconnect) {
            autoconnetedFlag = true;
            Fluttertoast.showToast(msg: S.of(context).connetctmc);
            mcbtmodel.autoConnect();
          }
          break;
        case 3: //数控机

          if (!getCncBtState() &&
              (appData.cncbluetoothname != "") &&
              appData.autoconnect) {
            autoconnetedFlag = true;
            Fluttertoast.showToast(msg: S.of(context).connetctcnc);
            cncbt4model.autoConnect();
          }
          break;
      }
    } else {
      cncbtmodel.blSwitch = false;
      appData.inmainpage = true;
    }
    setState(() {});
  }

  void startTime() async {
    //设置启动图生效时间
    var _duration = const Duration(seconds: 1);
    Timer(_duration, () {
      // 空等1秒之后再计时
      timer = Timer.periodic(const Duration(milliseconds: 1000), (v) {
        count--;
        if (count == 0) {
          timer!.cancel();
          autoconnect();
          setState(() {});
          // Navigator.pushReplacementNamed(context, "/");
        } else {
          setState(() {});
        }
      });
    });
  }

  Future<void> checkGpsServer() async {
    location.serviceEnabled().then((value) {
      if (!value) {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(S.of(context).needlocat);
            }).then((value) {
          if (value) AppSettings.openLocationSettings();
        });
      }
    });
  }

  checkPermission() async {
    if (await Permission.storage.request().isGranted) {
      // 干你该干的事
    }
    if (await Permission.camera.request().isGranted) {
      // 干你该干的事
    }
    if (await Permission.bluetooth.request().isGranted) {
      // 干你该干的事
    }
    if (await Permission.location.request().isGranted) {
      // 干你该干的事
    }
    if (await Permission.bluetoothAdvertise.request().isGranted) {
      // 干你该干的事
    }
    if (await Permission.bluetoothConnect.request().isGranted) {
      // 干你该干的事
    }
    if (await Permission.bluetoothScan.request().isGranted) {
      // 干你该干的事
    }
  }

  Widget getBluState() {
    if (cncbtmodel.blSwitch) {
      switch (machineType) {
        case 1:
          if (msbtmodel.state) {
            return const Icon(
              Icons.bluetooth_connected,
              color: Colors.green,
            );
          } else {
            return const Icon(
              Icons.bluetooth,
              color: Colors.black,
            );
          }

        case 2:
          if (mcbtmodel.state) {
            return const Icon(
              Icons.bluetooth_connected,
              color: Colors.green,
            );
          } else {
            return const Icon(
              Icons.bluetooth,
              color: Colors.black,
            );
          }

        case 3:
          if (cncbtmodel.state) {
            return const Icon(
              Icons.bluetooth_connected,
              color: Colors.green,
            );
          } else {
            return const Icon(
              Icons.bluetooth,
              color: Colors.black,
            );
          }
        default:
          if (msbtmodel.state) {
            return const Icon(
              Icons.bluetooth_connected,
              color: Colors.green,
            );
          } else {
            return const Icon(
              Icons.bluetooth,
              color: Colors.black,
            );
          }
      }
    } else {
      return const Icon(
        Icons.bluetooth_disabled,
        color: Colors.red,
      );
    }
  }

  void getmachineType() {
    for (var i = 0; i < allfunction.length; i++) {
      if (function[pageindex] == allfunction[i]) {
        switch (i) {
          case 0: //子机下载器
            machineType = 1;
            break;
          case 1: //拷贝机
            machineType = 2;
            break;
          case 2: //坦克数控机
            machineType = 3;
            break;
          default:
            machineType = 0;
            break;
        }
      }
    }
  }

  Widget adpage() {
    return Scaffold(
      body: Stack(
        alignment: const Alignment(1.0, -1.0), // 右上角对齐
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: CachedNetworkImage(
              imageUrl:
                  "https://www.xingruiauto.com/tank/downpic/?picname=ad.png",
              errorWidget: (context, s, dynamic) {
                return Image.asset("image/ad.png");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 10.0, 0.0),
            child: TextButton(
              // color: const Color.fromRGBO(0, 0, 0, 0.3),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20)),
              child: Text(
                "$count S",
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
              ),
              onPressed: () {
                timer!.cancel();

                autoconnect();
                setState(() {});
                //  Navigator.pushReplacementNamed(context, "/");
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ((appData.welcomepage && !appData.inmainpage) ||
            (!appData.agreeprivcy))
        ? adpage()
        : WillPopScope(
            onWillPop: () async {
              // 点击返回键即触发该事件
              if (lastPressedAt == null) {
                //首次点击提示...信息
                Fluttertoast.showToast(
                  msg: S.of(context).exitapptip,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey[400],
                  textColor: Colors.white,
                  fontSize: 12.sp,
                );
              }
              if (lastPressedAt == null ||
                  DateTime.now().difference(lastPressedAt!) >
                      const Duration(seconds: 3)) {
                //两次点击间隔超过1秒则重新计时
                //lastPressedAt = null;
                lastPressedAt = DateTime.now();
                return false; // 不退出
              }
              // disconnect();
              return true; //退出
            },
            child: Scaffold(
              backgroundColor: const Color(0xffeeeeee),
              resizeToAvoidBottomInset: false,
              drawer: Drawer(
                child: DrawerPage(machineType),
              ),
              appBar: AppBar(
                toolbarHeight: 32.r,
                elevation: 0.0,
                iconTheme: const IconThemeData(color: Colors.black),
                title: SizedBox(
                  width: 97.r,
                  height: 18.r,
                  child: Image.asset(
                    "image/tank/Icon_tankbar.png",
                    // fit: BoxFit.cover,
                  ),
                ),
                actions: [
                  pageindex != 0
                      ? IconButton(
                          onPressed: () {
                            switch (machineType) {
                              case 1:
                                Navigator.pushNamed(context, '/selems',
                                        arguments: machineType)
                                    .then((value) {
                                  setState(() {});
                                });
                                break;
                              case 2:
                                if (autoconnetedFlag) {
                                  Fluttertoast.showToast(msg: "设备自动连接中。。。");
                                } else {
                                  Navigator.pushNamed(context, '/selemc',
                                          arguments: machineType)
                                      .then((value) {
                                    setState(() {});
                                  });
                                }
                                break;
                              case 3:
                                if (autoconnetedFlag) {
                                  Fluttertoast.showToast(msg: "设备自动连接中。。。");
                                } else {
                                  Navigator.pushNamed(context, '/selecnc',
                                          arguments: machineType)
                                      .then((value) {
                                    setState(() {});
                                  });
                                }
                                break;
                              default:
                            }
                          },
                          icon: getBluState(),
                        )
                      : Container(),
                ],
              ),
              // PreferredSize(
              //   preferredSize: Size(double.maxFinite, 28.h),
              //   child: Builder(
              //     builder: (context) {
              //       return SizedBox(
              //         width: double.maxFinite,
              //         height: 28.h,
              //         child: Stack(
              //           children: [
              //             Align(
              //               alignment: Alignment.centerLeft,
              //               child: IconButton(
              //                   onPressed: () {
              //                     Scaffold.of(context).openDrawer();
              //                   },
              //                   icon: const Icon(
              //                     Icons.menu,
              //                     color: Colors.black,
              //                   )),
              //             ),
              //             Align(
              //               alignment: Alignment.center,
              //               child: Image.asset(
              //                 "image/share/mainappbar.png",
              //                 // fit: BoxFit.cover,
              //               ),
              //             ),
              //             pageindex != 0
              //                 ? Align(
              //                     alignment: Alignment.centerRight,
              //                     child: IconButton(
              //                       onPressed: () {
              //                         switch (machineType) {
              //                           case 1:
              //                             Navigator.pushNamed(
              //                                     context, '/selems',
              //                                     arguments: machineType)
              //                                 .then((value) {
              //                               setState(() {});
              //                             });
              //                             break;
              //                           case 2:
              //                             if (autoconnetedFlag) {
              //                               mcbtmodel.disconnect();
              //                             }
              //                             Navigator.pushNamed(
              //                                     context, '/selemc',
              //                                     arguments: machineType)
              //                                 .then((value) {
              //                               setState(() {});
              //                             });
              //                             break;
              //                           case 3:
              //                             Navigator.pushNamed(
              //                                     context, '/selecnc',
              //                                     arguments: machineType)
              //                                 .then((value) {
              //                               setState(() {});
              //                             });
              //                             break;
              //                           default:
              //                         }
              //                       },
              //                       icon: getBluState(),
              //                     ))
              //                 : Container(),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
              body: Column(
                children: [
                  Expanded(
                    child: Swiper(
                      index: appData.lastPage,
                      itemBuilder: (BuildContext context, int index) {
                        return function[index];
                      },
                      itemCount: function.length,
                      // pagination:  SwiperPagination(
                      //   alignment: Alignment.bottomCenter,
                      //   margin: EdgeInsets.zero,
                      //   builder: SwiperPagination.dots,
                      // ),
                      pagination: SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.zero,
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.white,
                            activeColor: Colors.blue,
                            size: 5.r,
                            activeSize: 6.r),
                      ),
                      onIndexChanged: (index) {
                        pageindex = index;
                        getmachineType();

                        appData.upgradeAppData({"lastpage": pageindex});
                        setState(() {});
                      },
                      // control: new SwiperControl(),
                    ),
                  ),
                  additional[pageindex],
                ],
              ),
            ),
          );
  }
}
