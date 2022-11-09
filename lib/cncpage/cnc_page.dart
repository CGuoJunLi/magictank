import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/cncpage/cncguide_page.dart';
import 'package:magictank/http/api.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';

import 'package:magictank/cncpage/upgrade/upgrading_page.dart';
import 'package:magictank/convers/convers.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/http/downfile.dart';

import 'package:magictank/main.dart';
import 'package:magictank/privacy_page.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../alleventbus.dart';
import 'bluecmd/cmd.dart';
import 'bluecmd/receivecmd.dart';

const debug = true;
String? filepath;

class CNCPage extends StatefulWidget {
  const CNCPage({Key? key}) : super(key: key);
  @override
  _CNCPageState createState() => _CNCPageState();
}

class _CNCPageState extends State<CNCPage> {
  // final _images = [
  //   {'name': 'NewAPP', 'link': 'http://resource.2m2.tech:808/imageZip.zip'},
  //   {'name': 'ImageData', 'link': 'http://resource.2m2.tech:808/imageZip.zip'},
  //   {'name': 'NewLcd', 'link': 'https://www.itying.com/images/flutter/1.png'},
  //   {'name': 'NewKey', 'link': 'https://www.itying.com/images/flutter/1.png'}
  // ];

  int progressValue = 0;

  //List<_TaskInfo>? _tasks;
  // late List<_ItemHolder> _items;
  //late bool _isLoading;
  // late bool _permissionReady;
  // ReceivePort _port = ReceivePort();
  late ProgressDialog pd;

  late StreamSubscription eventBusDf;
  bool getPowerAgin = true;
  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    // await FlutterDownloader.initialize();
    if (appData.cncguide) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(
            barrierDismissible: false,
            barrierColor: Colors.white10,
            context: context,
            builder: (c) {
              return const GuideMainPage();
            }).then((value) {
          if (value) {
            Navigator.pushNamed(context, '/cncsetting');
          }
        });
      });
    }
    pd = ProgressDialog(context: context);
    // _isLoading = true;
    // _permissionReady = false;
    // //_getallcarname(); //获得*-
    //_getallkeydata();
    //eventBus = EventBus();
    // 默认选中第一个颜色

    // 一次监听所有的事件

    // eventBus.on().listen((event) {
    //   // Print the runtime type. Such a set up could be used for logging.
    //   ////print(event.runtimeType);
    // });
    // 监听 某个具体的 事件
    eventBus.on<ErroEvent>().listen(
      (ErroEvent event) {
        setState(() {
          showDialog(
              context: context,
              builder: (context) {
                return MyTextDialog(
                  event.message[0] +
                      "\r\n" +
                      event.message[1] +
                      "\r\n" +
                      event.message[2] +
                      "\r\n" +
                      event.message[3],
                  button1: S.of(context).errorsolution,
                );
              }).then((value) {
            sendCmd([cncBtSmd.answer, event.no, event.no]);
            baseKey.readstate = false;
            eventBus.fire(CNCChangeXDStateEvent(false));
            if (appData.errorreturn) {
              Navigator.pop(context);
            }
          });
        });
      },
    );

    eventBus.on<PowerStateEvent>().listen((PowerStateEvent event) {
      if (event.dcstate == 1) {
        switch (event.state) {
          case 48:
            appData.powerstate = 6;
            break;
          case 49:
            appData.powerstate = 7;
            break;
          case 50:
            appData.powerstate = 8;
            break;
          case 51:
            appData.powerstate = 9;
            break;
          case 52:
            appData.powerstate = 10;
            break;
          case 53:
            appData.powerstate = 11;
            break;
        }
      } else {
        switch (event.state) {
          case 48:
            appData.powerstate = 0;
            break;
          case 49:
            appData.powerstate = 1;
            break;
          case 50:
            appData.powerstate = 2;
            break;
          case 51:
            appData.powerstate = 3;
            break;
          case 52:
            appData.powerstate = 4;
            break;
          case 53:
            appData.powerstate = 5;
            break;
        }
      }
      if (mounted) {
        getPowerAgin = true;
        setState(() {});
      }
    });

    eventBus.on<CNCGetVerEvent>().listen((event) {
      //pd.close();
      if (event.state) {
        checkUpgrade();
      }
      if (mounted) {
        setState(() {});
      }
    });

    checkUpgrade(); //检测升级 优先级 APP>钥匙数据包>tank固件
    //  awaitcheckUpgrade();
    super.initState();
  }

//等待检测。。
  Future<void> checkUpgrade() async {
    //检测APP升级
    // ////print(appData.appversion);
    if (appData.netapp.isEmpty) {
      var result = await Api.appIsUp(appData.appversion);
      appData.netapp = Map.from(result);
      if (result["isUpdate"]) {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(
                S.of(context).checkapptip +
                    ":${result["version"]}," +
                    S.of(context).checktip +
                    ":${result["description"]}",
                button2: S.of(context).updatanow,
              );
            }).then((value) {
          if (value) {
            Api.downfile(result["url"], appData.apkPath, 0);
            showDialog(
                context: context,
                builder: (c) {
                  return MyProgressDialog(
                    S.of(context).downing,
                    progresssmodel: 0,
                  );
                }).then((value) {
              switch (value) {
                case 0:
                  break;
                case 1: //隐藏
                  appData.hideProgressDialog[0] = true;
                  break;
                case 2:
                  break;
                case 3: //下载完成
                  break;
              }
            });
          } else {
            context.read<AppProvid>().upgradeTip(0, S.of(context).findnewapp);
          }
        });
      }
    }
    // var result = await Api.keydataIsUp(appData.keydataver.toString());
    if (appData.netkeydata.isEmpty) {
      var result = await Api.keydataIsUp(
          "version=${appData.keydataver}&limit=${appData.limit}&lanuage=${(locales!.languageCode == "zh" ? "0" : "1")}");
      appData.netkeydata = Map.from(result);

      if (result["isUpdate"]) {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(
                S.of(context).checkdatatip +
                    ":${result["version"]}," +
                    S.of(context).checktip +
                    ":${result["description"]}",
                button2: S.of(context).updatanow,
              );
            }).then((value) {
          if (value) {
            downdatafiles();
          } else {
            context
                .read<AppProvid>()
                .upgradeTip(2, S.of(context).findnewkeydata);
          }
        });
      } else {
        File file = File(appData.keyDataZipPath);
        if (await file.exists()) {
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog(S.of(context).continuedown);
              }).then((value) {
            if (value) {
              downdatafiles();
            }
          });
        }
      }
    }
    if (cncVersion.verPCB > 0 &&
        cncVersion.verJG > 0 &&
        appData.nettank.isEmpty) {
      var result = await Api.tankIsUp(
          (locales!.languageCode == "zh" ? "0" : "1"),
          cncVersion.version,
          cncVersion.verPCB,
          cncVersion.verJG,
          intToFormatStringHex(cncVersion.sn));
      ////print(result);
      appData.nettank = Map.from(result);
      if (result["isUpdate"]) {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(S.of(context).checkfirmwaretip +
                  ":${result["ver"]}\r\n," +
                  S.of(context).checktip +
                  ":${result["description"]}");
            }).then((value) async {
          if (value) {
            // getUpgradeDat();
            var data = await Api.encryptBin(result["upUrl"].split("?")[1]);
            cncVersion.ran = data["ran"];
            cncVersion.binbase64 = data["bin-base64"];
            cncVersion.w = data["w"];
            cncVersion.ranbase64 = data["ran-base64"];

            ////print(cncVersion.binbase64.codeUnits.length);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (c) {
                  return UpgradingPage(
                    {
                      "data": base64Decode(cncVersion.binbase64),
                      "version": data["ver"]
                    },
                  );
                });
          } else {
            context.read<AppProvid>().upgradeTip(1, S.of(context).findnewcnc);
          }
        });
      } else {
        //print(result);
      }
    }
    if (cncVersion.lcdPCB > 0 &&
        cncVersion.lcdJG > 0 &&
        appData.netlcd.isEmpty) {
      var result = await Api.lcdIsUp(
        (locales!.languageCode == "zh" ? "0" : "1"),
        cncVersion.lcdVersion,
        cncVersion.lcdPCB,
        cncVersion.lcdJG,
      );
      ////print(result);
      appData.netlcd = Map.from(result);
      if (result["isUpdate"]) {
        showDialog(
            context: context,
            builder: (c) {
              return MyTextDialog(S.of(context).checkfirmwaretip +
                  ":${result["ver"]}\r\n," +
                  S.of(context).checktip +
                  ":${result["description"]}");
            }).then((value) async {
          if (value) {
            // getUpgradeDat();
            var data = await Api.encryptBin(result["upUrl"].split("?")[1]);
            cncVersion.ran = data["ran"];
            cncVersion.binbase64 = data["bin-base64"];
            cncVersion.w = data["w"];
            cncVersion.ranbase64 = data["ran-base64"];

            ////print(cncVersion.binbase64.codeUnits.length);
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (c) {
                  return UpgradingPage(
                    {
                      "data": base64Decode(cncVersion.binbase64),
                      "version": data["ver"]
                    },
                  );
                });
          } else {
            context.read<AppProvid>().upgradeTip(1, S.of(context).findnewcnc);
          }
        });
      } else {
        // print(result);
      }
    }
  }

//手动下载数据文件
  void downdatafiles() async {
    {
      await Api.downfile(appData.netkeydata["url"], appData.keyDataZipPath, 1);
      showDialog(
          context: context,
          builder: (c) {
            return MyProgressDialog(
              S.of(context).downing,
              progresssmodel: 1,
            );
          }).then((value) {
        switch (value) {
          case 1:
            appData.hideProgressDialog[1] = true;
            break;
          case 0:
            cancelDown(appData.netkeydata["url"]);
            break;
          default:
            break;
        }
      });
    }
  }

  //跑马灯显示的字符

  @override
  void dispose() {
    super.dispose();
  }

//检测文件存在
  bool checkkeydatafile() {
    File file = File(appData.tankRootPath + "/tank1.json");
    if (file.existsSync()) {
      //如果文件已经存在 说明有资源包
      return true;
    } else {
      return false;
    }
  }

  Widget userbuttonstyle(
      int buttonindex, String buttonimage, String buttongstr) {
    return SizedBox(
      width: 86.w,
      height: 50.h,
      child: TextButton(
        onPressed: () {
          if (checkkeydatafile()) {
            switch (buttonindex) {
              case 0:
                Navigator.pushNamed(context, '/selekeydatabase');
                break;
              case 1:
                // Navigator.pushNamed(
                //   context,
                //   '/testkey',
                //);
                // showDialog(
                //     context: context,
                //     builder: (c) {
                //       return PrivacyTip();
                //     });
                Fluttertoast.showToast(
                  msg: S.of(context).comingsoon,
                );
                break;
              case 2:
                Navigator.pushNamed(context, '/allkeydata');
                break;
              case 3:
                Navigator.pushNamed(context, '/alllost');
                break;
              case 4:
                Navigator.pushNamed(context, "/cardata",
                    arguments: {"type": 1});
                break;
              case 5:
                Navigator.pushNamed(context, '/copykey');
                break;
              case 6:
                Navigator.pushNamed(context, '/keymodel');
                break;
              case 7:
                if (appData.loginstate) {
                  Navigator.pushNamed(context, '/diykey');
                } else {
                  Fluttertoast.showToast(msg: S.of(context).needlogin);
                }
                break;
              case 8:
                Navigator.pushNamed(context, '/unlocktoolslist');
                break;
              default:
            }
          } else {
            if (appData.hideProgressDialog[1]) {
              showDialog(
                  context: context,
                  builder: (contex) {
                    return MyProgressDialog(
                      S.of(context).downing,
                      progresssmodel: 1,
                    );
                  }).then((value) {
                if (value != null) {
                  switch (value) {
                    case 1:
                      appData.hideProgressDialog[1] = true;
                      break;
                    case 0:
                      cancelDown(appData.netkeydata["url"]);
                      appData.hideProgressDialog[1] = false;
                      break;
                  }
                }
              });
            } else {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (contex) {
                    return MyTextDialog(S.of(context).needdownloaddata);
                  }).then((value) {
                if (value) {
                  if (value) {
                    downdatafiles();
                  }
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

  String getpowerstate() {
    switch (appData.powerstate) {
      case 0:
        return "image/share/Icon_0p0.png";
      case 1:
        return "image/share/Icon_0p1.png";
      case 2:
        return "image/share/Icon_0p2.png";
      case 3:
        return "image/share/Icon_0p3.png";
      case 4:
        return "image/share/Icon_0p4.png";
      case 5:
        return "image/share/Icon_0p5.png";
      case 6:
        return "image/share/Icon_1p0.png";
      case 7:
        return "image/share/Icon_1p1.png";
      case 8:
        return "image/share/Icon_1p2.png";
      case 9:
        return "image/share/Icon_1p3.png";
      case 10:
        return "image/share/Icon_1p4.png";
      case 11:
        return "image/share/Icon_1p5.png";
      default:
        return "image/share/Icon_0p5.png";
    }
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
                      width: 64.w,
                      height: 10.h,
                      child: Image.asset("image/tank/Icon_logo.png"),
                    ),
                  ),
                  getCncBtState()
                      ? Positioned(
                          left: 305.w,
                          top: 25.h,
                          child: SizedBox(
                              width: 25.w,
                              height: 10.h,
                              child: TextButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero)),
                                onPressed: () {
                                  if (getPowerAgin) {
                                    getPowerAgin = false;
                                    Fluttertoast.showToast(
                                        msg: S.of(context).getpower);
                                    sendCmd([0X73, 0, 0]);
                                  }
                                },
                                child: Image.asset(getpowerstate()),
                              )),
                        )
                      : Container(),
                  Positioned(
                    left: 26.w,
                    top: 86.h,
                    child: Text(
                      S.of(context).mctankname,
                    ),
                  ),
                  Positioned(
                    left: 186.w,
                    top: 7.h,
                    child: SizedBox(
                      width: 101.w,
                      height: 128.h,
                      child: Image.asset("image/tank/tank2pro.png"),
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
                      userbuttonstyle(0, "image/tank/Icon_keybase.png",
                          S.of(context).keydatabase),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(1, "image/tank/Icon_testkey.png",
                          S.of(context).testkey),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(2, "image/tank/Icon_keycodecut.png",
                          S.of(context).keycodecut),
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
                      userbuttonstyle(3, "image/tank/Icon_alllost.png",
                          S.of(context).alllost),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(4, "image/tank/Icon_bittingfind.png",
                          S.of(context).findbitting),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(5, "image/tank/Icon_copykey.png",
                          S.of(context).copykey),
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
                      userbuttonstyle(6, "image/tank/Icon_model.png",
                          S.of(context).keymodelcut),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(7, "image/tank/Icon_diykey.png",
                          S.of(context).diykey),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(8, "image/tank/Icon_keytools.png",
                          S.of(context).keytools),
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
                    text: context.watch<AppProvid>().cnctip == ""
                        ? S.of(context).welcomemctank
                        : context.watch<AppProvid>().cnctip,
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

class CNCPageBar extends StatefulWidget {
  const CNCPageBar({Key? key}) : super(key: key);

  @override
  State<CNCPageBar> createState() => _CNCPageBarState();
}

class _CNCPageBarState extends State<CNCPageBar> {
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
              Navigator.pushNamed(
                context,
                '/upgrade',
              );
              break;
            case 1:
              if (appData.loginstate == false) {
                showDialog(
                    context: context,
                    builder: (c) {
                      return MyTextDialog(
                        S.of(context).needlogin,
                        button2: S.of(context).login,
                      );
                    }).then((value) {
                  if (value) {
                    Navigator.pushNamed(context, '/login').then((value) {
                      setState(() {});
                    });
                  }
                });
              } else {
                if (appData.keydataver == "0") {
                  showDialog(
                      context: context,
                      builder: (c) {
                        return MyTextDialog(S.of(context).needdownloaddata);
                      });
                } else {
                  Navigator.pushNamed(context, "/history");
                }
              }
              break;
            case 2:
              if (appData.loginstate) //如果有登陆
              {
                if (appData.keydataver == "0") {
                  showDialog(
                      context: context,
                      builder: (c) {
                        return MyTextDialog(S.of(context).needdownloaddata);
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (c) {
                        return MySeleDialog([
                          S.of(context).userstar,
                          S.of(context).customerinf
                        ]);
                      }).then((value) {
                    switch (value) {
                      case 1:
                        Navigator.pushNamed(context, '/mycollection');
                        break;
                      case 2:
                        Navigator.pushNamed(context, '/myclient');
                        break;
                    }
                  });
                }
              } else {
                showDialog(
                    context: context,
                    builder: (c) {
                      return MyTextDialog(
                        S.of(context).needlogin,
                        button2: S.of(context).login,
                      );
                    }).then((value) {
                  if (value) {
                    Navigator.pushNamed(context, '/login').then((value) {
                      setState(() {});
                    });
                  }
                });
              }
              break;
            case 3:
              Navigator.pushNamed(
                context,
                '/cncsetting',
              );
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
      padding: EdgeInsets.only(bottom: 5.w),
      // color: const Color(0XFF6E66AA),
      child: Row(
        children: [
          userbuttonstyle(context, 0, "image/share/Icon_download.png",
              S.of(context).upgradecenter),
          const VerticalDivider(), //垂直分割线
          userbuttonstyle(context, 1, "image/share/Icon_history.png",
              S.of(context).userhistory),
          const VerticalDivider(), //垂直分割线
          userbuttonstyle(
              context, 2, "image/share/Icon_star.png", S.of(context).userstar),
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
