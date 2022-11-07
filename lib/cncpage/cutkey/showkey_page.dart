import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/cncpage/bluecmd/cmd.dart';

import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/cncpage/cutkey/canvas.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';

import 'package:magictank/convers/convers.dart';

import 'package:magictank/dialogshow/dialogpage.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../main.dart';
import 'cutready_page.dart';
import 'readready_page.dart';

class ShowKeyPage extends StatefulWidget {
  final Map arguments;
  const ShowKeyPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  _ShowKeyPageState createState() => _ShowKeyPageState();
}

class _ShowKeyPageState extends State<ShowKeyPage>
    with TickerProviderStateMixin {
  // late Map keydata;
  // List<int> ahNum = [];
  // List<int> bhNum = [];
  String customerphone = "";
  String customername = "";
  String customercarnum = "";
  late List<int> ahNumDif;
  late List<int> bhNumDif;
  // List<String> ahNums = [];
  // List<String> bhNums = [];
  //List<Widget> toolsWidget = [];
  String filepath = ""; //排在看齿
  int pageindex = 1;
  bool highmodel = false;
  int cutsindex = 0;
  int cuttingSideNum = 0; //切削面数记录方式
  String test = "test";
  late List<int> toothSADif;
  late List<int> toothSBDif;
  //late int tooth;
  int readstate = 0; //读码状态
  List<String> keyaxis = ["A", "B", "C"];
  String currentaxis = "A";

  bool searchstate = false; //缺齿查询的状态 如果查询成功的 状态为true 如果按下按键 状态为false
  List searchresult = []; //记录查询结果
  late ProgressDialog pd;
  bool dir = false;

  late StreamSubscription btstatet;
  late StreamSubscription cncbusystate;
  late StreamSubscription changexdstate; //更换铣刀导针状态
  TabController? _tabController;
  int currentTab = 0;
  int currentToothDepthBt = -2;
  final ImagePicker _picker = ImagePicker();

//绘制路径

  @override
  void initState() {
    // if (widget.arguments["dir"] != null) {
    //   dir = widget.arguments["dir"];
    //   if (dir) {
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // //设置状态栏隐藏
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    //  }
    // }
    ////print(arguments);

    switch (widget.arguments["type"]) {
      case 4:
        debugPrint("自定义钥匙数据4");
        break;
      case 1:
        debugPrint("汽车1");
        break;
      case 2:
        debugPrint("民用2");
        break;
      case 3:
        debugPrint("摩托车3");
        break;
      case 5: //非导电钥匙数据
        debugPrint("非导电5");
        break;
      default:
        debugPrint("其它:${widget.arguments["type"]}");
        break;
    }
    _tabControllerset(2);
    pd = ProgressDialog(context: context);
    //keydata = Map.from(widget.arguments["keydata"]);

    if (widget.arguments["bitting"] != null) {
      // //print(widget.arguments["bitting"]);
      if (baseKey.keyClass == 2 || baseKey.keyClass == 4) {
        //String temp = "";
        ////print(arguments["bitting"].split("-"));

        for (var i = 0; i < baseKey.cuts; i++) {
          baseKey.ahNums[i] = (widget.arguments["bitting"].split("-"))[0][i];
          baseKey.bhNums[i] = (widget.arguments["bitting"].split("-"))[1][i];
        }
        _gettoothhnum();
      } else {
        if (baseKey.keySerNum == 158 ||
            baseKey.keySerNum == 159 ||
            baseKey.keySerNum == 242) {
          baseKey.axhNums =
              List.from((widget.arguments["bitting"].split("-"))[0].split(""));
          if (baseKey.keySerNum != 242) {
            baseKey.bxhNums = List.from(
                (widget.arguments["bitting"].split("-"))[1].split(""));

            baseKey.cxhNums = List.from(
                (widget.arguments["bitting"].split("-"))[2].split(""));
          }
        } else {
          for (var i = 0; i < baseKey.cuts; i++) {
            baseKey.ahNums[i] = widget.arguments["bitting"][i];
            baseKey.bhNums[i] = widget.arguments["bitting"][i];
          }
          _gettoothhnum();
        }
      }
    }
    _baseKeyDataInit();

    checkNeedChangXD();

    super.initState();
  }

  @override
  void dispose() {
    // if (dir) {
    //   SystemChrome.setPreferredOrientations([
    //     // DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
    //     DeviceOrientation.landscapeLeft,
    //     DeviceOrientation.landscapeRight
    //   ]);
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // }
    super.dispose();
  }

  _tabControllerset(int num) {
    if (_tabController != null) {
      _tabController!.dispose();
    }

    _tabController = TabController(initialIndex: 0, length: num, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.index.toDouble() ==
          _tabController!.animation!.value) {
        switch (_tabController!.index) {
          case 0:
            //print(_tabController!.index);
            currentTab = _tabController!.index;
            setState(() {});
            break;
          case 1:
            //print(_tabController!.index);
            currentTab = _tabController!.index;
            setState(() {});
            break;
          case 2:
            //print(_tabController!.index);
            currentTab = _tabController!.index;
            setState(() {});
            break;
        }
      }
    });
  }

  List<Widget> toolsPage() {
    List<Widget> temp = [];

    temp.add(_toothKeybord());
    if (highmodel) {
      temp.add(_tuneParameter());
    }
    temp.add(_readmessage());
    return temp;
  }

  List<Widget> toolsBartitle() {
    List<Widget> temp = [];
    temp.add(
      Tab(
        child: Container(
          width: 113.w,
          height: 36.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: currentTab == 0
                ? const Color(0xff384c70)
                : const Color(0xffdde1ea),
          ),
          child: Center(
            child: Text(
              '齿深键盘',
              style: TextStyle(
                fontSize: 13.sp,
                color: currentTab == 0 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
    if (highmodel) {
      temp.add(
        Tab(
          child: Container(
            width: 113.w,
            height: 36.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: currentTab == 1
                  ? const Color(0xff384c70)
                  : const Color(0xffdde1ea),
            ),
            child: Center(
              child: Text(
                '参数微调',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: currentTab == 1 ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    }
    temp.add(
      Tab(
        child: Container(
          width: 113.w,
          height: 36.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: (currentTab == 2 || (!highmodel && currentTab == 1))
                ? const Color(0xff384c70)
                : const Color(0xffdde1ea),
          ),
          child: Center(
            child: Text(
              '学习详情',
              style: TextStyle(
                fontSize: 13.sp,
                color: (currentTab == 2 || (!highmodel && currentTab == 1))
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );

    return temp;
  }

//自动连接蓝牙
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
    if (cncbtmodel.blSwitch) {
      if (appData.autoconnect && appData.cncbluetoothname != "") {
        pd.show(max: 100, msg: S.of(context).btconnecting);

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

//缺齿查询
  _searchData() async {
    // print(searchstate);
    if (!searchstate) {
      pd.show(max: 100, msg: S.of(context).searching);
      String bitting = "";
      if (baseKey.side == 3 &&
          baseKey.keyClass != 0 &&
          baseKey.keyClass != 13) {
        bitting = listStringToString(baseKey.ahNums) +
            "-" +
            listStringToString(baseKey.bhNums);
      } else {
        bitting = listStringToString(baseKey.ahNums);
      }

      try {
        var result = await Api.searchBittng(
            "language=${(locales!.languageCode == "zh" ? "0" : "1")}&carname=${baseKey.getcarname}&bitting=$bitting&keyid=${baseKey.keySerNum}");

        searchresult = result;
        if (searchresult.isNotEmpty) {
          searchstate = true;
        }
        pd.close();
      } catch (e) {
        pd.close();
      }
    }
    if (searchresult.isNotEmpty) {
      Navigator.pushNamed(context, '/searchresult', arguments: searchresult)
          .then((value) {
        if (value != null) {
          int index = value as int;

          if (baseKey.side == 3 && baseKey.keyClass != 0) {
            //String temp = "";
            ////print(arguments["bitting"].split("-"));
            for (var i = 0; i < baseKey.cuts; i++) {
              baseKey.ahNums[i] = (searchresult[index].split("-"))[0][i];
              baseKey.bhNums[i] = (searchresult[index].split("-"))[1][i];
            }
          } else {
            for (var i = 0; i < baseKey.cuts; i++) {
              baseKey.ahNums[i] = searchresult[index][i];
              baseKey.bhNums[i] = searchresult[index][i];
            }
          }
          _gettoothhnum();
        }
        setState(() {});
      });
    } else {
      baseKey.setcarname("");
      Fluttertoast.showToast(msg: S.of(context).searchno);
    }
  }

//缺齿查询
  Future<void> searchbitting() async {
    //如果还未查找过数据
    if (baseKey.getcarname == "") {
      //先查找车型
      Fluttertoast.showToast(msg: S.of(context).needcarmode);
      List<String> carname = [];
      // List<int> a = [];

      for (var i = 0; i < appData.carList.length; i++) {
        // print(appData.carList[i]);
        if (appData.carList[i]["model"][0]["time"][0]["id"]
                .indexOf(baseKey.keySerNum) !=
            -1) {
          carname.add(appData.carList[i]["chbrand"]);
        }
      }
      showDialog(
          context: context,
          builder: (c) {
            return MySeleDialog(
              carname,
              title: S.of(context).selecarmode,
            );
          }).then((value) {
        if (value != 0) {
          baseKey.setcarname(carname[value - 1]);
          _searchData();
        }
      });
    } else {
      _searchData();
    }
  }

  // @override
  // void didChangeDependencies() {
  //  // checkNeedChangXD();
  //   super.didChangeDependencies();
  // }
//检查是否需要更换铣刀
  Future<void> checkNeedChangXD() async {
    // await Future.delayed(Duration(milliseconds: 1000));

    switch (baseKey.keySerNum) {
      case 158:
      case 159:
      case 242:
        baseKey.needChangeXD = true;
        break;
    }
  }

  _baseKeyDataInit() {
    toothSADif = List.filled(baseKey.cuts, 0); //参数微调
    toothSBDif = List.filled(baseKey.cuts, 0); //参数微调
    ahNumDif = List.filled(baseKey.cuts, 0); //参数微调
    bhNumDif = List.filled(baseKey.cuts, 0); //参数微调
    // print("baseKey.keySerNum:${baseKey.keySerNum}");
    // print(baseKey.axhNums);
    // print(baseKey.bxhNums);
    ////print(baseKey.cxhNums);
    if (baseKey.axhNums.isNotEmpty &&
        (baseKey.keySerNum == 158 ||
            baseKey.keySerNum == 159 ||
            baseKey.keySerNum == 242)) {
      baseKey.ahNums = List.from(baseKey.axhNums);
      baseKey.bhNums = List.from(baseKey.axhNums);
      _gettoothhnum();
    }
    if (baseKey.bxhNums.isNotEmpty && baseKey.keySerNum == 510) {
      baseKey.ahNums = List.from(baseKey.bxhNums);
      baseKey.bhNums = List.from(baseKey.bxhNums);
      _gettoothhnum();
    }
    if (baseKey.cxhNums.isNotEmpty && baseKey.keySerNum == 511) {
      baseKey.ahNums = List.from(baseKey.cxhNums);
      baseKey.bhNums = List.from(baseKey.cxhNums);
      _gettoothhnum();
    }
  }

  void _gettoothhnum() {
    //重新整理齿深数据

    for (var i = 0; i < baseKey.cuts; i++) {
      for (var j = 0; j < baseKey.toothDepth.length; j++) {
        if (baseKey.toothDepthName[j] == baseKey.ahNums[i]) {
          if (baseKey.keyClass == 13) {
            if (j > 4) {
              baseKey.ahNum[i] = baseKey.toothDepth[j];
            } else {
              baseKey.ahNum[i] =
                  baseKey.wide - baseKey.groove - baseKey.toothDepth[j];
            }
          } else {
            baseKey.ahNum[i] = baseKey.toothDepth[j];
          }
        } else if (baseKey.ahNums[i] == "?") {
          baseKey.ahNum[i] = baseKey.toothDepth[0];
        }
        if (baseKey.toothDepthName[j] == baseKey.bhNums[i]) {
          if (baseKey.keyClass == 13) {
            if (j <= 4) {
              baseKey.bhNum[i] = baseKey.toothDepth[j];
            } else {
              baseKey.bhNum[i] =
                  baseKey.wide - baseKey.groove - baseKey.toothDepth[j];
            }
          } else {
            baseKey.bhNum[i] = baseKey.toothDepth[j];
          }
        } else if (baseKey.bhNums[i] == "?") {
          baseKey.bhNum[i] = baseKey.toothDepth[0];
        }
      }
    }
    if (baseKey.keySerNum == 158 ||
        baseKey.keySerNum == 159 ||
        baseKey.keySerNum == 242) {
      baseKey.axhNums = List.from(baseKey.ahNums);
    }
    if (baseKey.keySerNum == 510) {
      baseKey.bxhNums = List.from(baseKey.ahNums);
    }
    if (baseKey.keySerNum == 511) {
      baseKey.cxhNums = List.from(baseKey.ahNums);
    }

    // print("test:");
    // print(baseKey.axhNums);
    // print(baseKey.bxhNums);
    // print(baseKey.cxhNums);
  }

//齿深键盘
  Widget _toothKeybord() {
    List<Widget> toothNum = [];

    for (var i = 0; i < baseKey.toothDepth.length; i++) {
      toothNum.add(
        GestureDetector(
          child: Container(
            height: 50.r,
            width: 50.r,
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: const Color(0xff3b8be8)),
                borderRadius: BorderRadius.circular(8.0),
                color: currentToothDepthBt == i
                    ? const Color(0xff384c70)
                    : const Color(0xffdde1ea)),
            child: Center(
              child: Text(
                baseKey.toothDepthName[i],
                style: TextStyle(
                    color: currentToothDepthBt == i
                        ? Colors.white
                        : const Color(0xff384c70),
                    fontSize: 30.sp),
              ),
            ),
          ),
          onPanDown: (d) {
            currentToothDepthBt = i;
            baseKey.readstate = false;
            searchstate = false;

            if (baseKey.side == 3 &&
                baseKey.keyClass != 0 &&
                baseKey.keyClass != 13) {
              //如果双边齿一样
              if (baseKey.sideAtooth == baseKey.sideBtooth) {
                if (cutsindex < baseKey.toothSA.length) {
                  baseKey.ahNums[cutsindex] = baseKey.toothDepthName[i];
                } else {
                  int bcutsindex = baseKey.cuts;
                  baseKey.bhNums[cutsindex - bcutsindex] =
                      baseKey.toothDepthName[i];
                }
                cutsindex++;

                if (cutsindex > baseKey.cuts * 2 - 1) {
                  cutsindex = 0;
                }
              } else {
                //双边齿数不同
                if (cutsindex < baseKey.sideAtooth) {
                  baseKey.ahNums[cutsindex] = baseKey.toothDepthName[i];
                  //如果A边的齿比B边的齿少
                  if (baseKey.sideAtooth < baseKey.sideBtooth) {
                    for (var i = 0;
                        i < (baseKey.sideAtooth - baseKey.sideBtooth).abs();
                        i++) {
                      baseKey.ahNums[baseKey.sideAtooth + i] =
                          baseKey.ahNums[baseKey.sideAtooth - 1];
                    }
                  }
                } else {
                  baseKey.bhNums[cutsindex - baseKey.sideAtooth] =
                      baseKey.toothDepthName[i];
                  //如果A边的齿比B边的齿多

                  if (baseKey.sideAtooth > baseKey.sideBtooth) {
                    for (var i = 0;
                        i < (baseKey.sideAtooth - baseKey.sideBtooth).abs();
                        i++) {
                      if (cutsindex >=
                          baseKey.sideAtooth + baseKey.sideBtooth) {
                        baseKey.bhNums[cutsindex - baseKey.sideAtooth + i] =
                            baseKey.bhNums[cutsindex - baseKey.sideAtooth];
                      }
                    }
                  }
                }
                cutsindex++;

                //A边的齿数大于于B边的齿数
                if (baseKey.sideAtooth > baseKey.sideBtooth) {
                  if (cutsindex == baseKey.sideAtooth + baseKey.sideBtooth) {
                    baseKey.bhNums[cutsindex - baseKey.sideAtooth] =
                        baseKey.toothDepthName[i];
                    cutsindex++;
                    //print(baseKey.bhNums);
                  }
                }
                if (cutsindex > baseKey.sideAtooth + baseKey.sideBtooth - 1) {
                  cutsindex = 0;
                }
              }
            } else {
              baseKey.ahNums[cutsindex] = baseKey.toothDepthName[i];
              baseKey.bhNums[cutsindex] = baseKey.toothDepthName[i];

              cutsindex++;

              if (cutsindex > baseKey.cuts - 1) {
                cutsindex = 0;
              }
            }
            _gettoothhnum();
            setState(() {});
          },
        ),
      );
    }
    toothNum.add(
      GestureDetector(
        child: Container(
          height: 50.r,
          width: 50.r,
          decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: const Color(0xff3b8be8)),
              borderRadius: BorderRadius.circular(8.0),
              color: currentToothDepthBt == -1
                  ? const Color(0xff384c70)
                  : const Color(0xffdde1ea)),
          child: Center(
            child: Text(
              "?",
              style: TextStyle(
                  color: currentToothDepthBt == -1
                      ? Colors.white
                      : const Color(0xff384c70),
                  fontSize: 30.sp),
            ),
          ),
        ),
        onPanDown: (d) {
          currentToothDepthBt = -1;
          baseKey.readstate = false;
          searchstate = false;

          if (baseKey.side == 3 &&
              baseKey.keyClass != 0 &&
              baseKey.keyClass != 13) {
            if (cutsindex < baseKey.toothSA.length) {
              baseKey.ahNums[cutsindex] = "?";
            } else {
              int bcutsindex = baseKey.cuts;
              baseKey.bhNums[cutsindex - bcutsindex] = "?";
            }
            cutsindex++;
            if (cutsindex > baseKey.cuts * 2 - 1) {
              cutsindex = 0;
            }
          } else {
            baseKey.ahNums[cutsindex] = "?";
            baseKey.bhNums[cutsindex] = "?";

            cutsindex++;
            if (cutsindex > baseKey.cuts - 1) {
              cutsindex = 0;
            }
          }
          _gettoothhnum();
          setState(() {});
        },
      ),
    );
    return GridView.count(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
        crossAxisSpacing: 10.h,
        mainAxisSpacing: 10.h,
        crossAxisCount: baseKey.toothDepth.length + 1 > 10 ? 6 : 5,
        children: toothNum);
  }

  //参数微调列表
  List<Widget> _tuneParameterlist() {
    List<Widget> temp = [];
    //int index = baseKey.ahNums.indexOf("?");
    ////print(index);
    for (var i = 0; i < baseKey.toothSA.length; i++) {
      temp.add(
        SizedBox(
          height: 37.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 40.w,
                child: Text(
                  "A${i + 1}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              SizedBox(
                width: 40.w,
                child: Text(
                  baseKey.hide ? "*" : baseKey.toothSA[i].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              SizedBox(
                width: 40.w,
                child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  child: Text(
                    "${toothSADif[i]}",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: toothSADif[i] >= 0
                            ? const Color(0xff4b7cd3)
                            : Colors.red),
                  ),
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (c) {
                          return MychangDialog(toothSADif[i]);
                        }).then((value) {
                      if (value["state"]) {
                        setState(() {
                          toothSADif[i] = value["value"];
                        });
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                width: 40.w,
                child: Text(
                  baseKey.hide ? "*" : "${baseKey.ahNum[i]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              SizedBox(
                width: 40.w,
                child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  child: Text(
                    "${ahNumDif[i]}",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: ahNumDif[i] >= 0
                            ? const Color(0xff4b7cd3)
                            : Colors.red),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return MychangDialog(ahNumDif[i]);
                        }).then((value) {
                      ////print(value);
                      if (value["state"]) {
                        setState(() {
                          ahNumDif[i] = value["value"];
                        });
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
      temp.add(Divider(height: 1.h));
    }
    for (var i = 0; i < baseKey.toothSA.length; i++) {
      if (baseKey.side == 3) {
        temp.add(
          SizedBox(
            height: 37.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 40.w,
                  child: Text(
                    "B${i + 1}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                SizedBox(
                  width: 40.w,
                  child: Text(
                    baseKey.hide ? "*" : baseKey.toothSB[i].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Text(
                      "${toothSBDif[i]}",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: toothSBDif[i] >= 0
                              ? const Color(0xff4b7cd3)
                              : Colors.red),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return MychangDialog(toothSADif[i]);
                          }).then((value) {
                        ////print(value);
                        if (value["state"]) {
                          setState(() {
                            toothSBDif[i] = value["value"];
                          });
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 40.w,
                  child: Text(
                    baseKey.hide ? "*" : "${baseKey.bhNum[i]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                SizedBox(
                  width: 40.w,
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Text(
                      "${bhNumDif[i]}",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: bhNumDif[i] >= 0
                              ? const Color(0xff4b7cd3)
                              : Colors.red),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return MychangDialog(bhNumDif[i]);
                          }).then((value) {
                        ////print(value);
                        if (value["state"]) {
                          setState(() {
                            bhNumDif[i] = value["value"];
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
      temp.add(Divider(height: 1.h));
    }
    return temp;
  }

  //参数微调
  Widget _tuneParameter() {
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        SizedBox(
          height: 14.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // SizedBox(
              //   width: 10.w,
              // ),
              SizedBox(
                width: 40.w,
                child: Text(
                  S.of(context).keytoothnum,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              SizedBox(
                width: 40.w,
                child: Text(
                  S.of(context).keytoothsa,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              SizedBox(
                width: 40.w,
                child: Text(
                  S.of(context).diffdata,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              SizedBox(
                width: 40.w,
                child: Text(
                  S.of(context).keytoothdepth,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              SizedBox(
                width: 40.w,
                child: Text(
                  S.of(context).diffdata,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              // SizedBox(
              //   width: 10,
              // ),
            ],
          ),
        ),
        Expanded(
          child: baseKey.checkkeydata(0) == false
              ? Center(child: Text(S.of(context).needreadcode))
              : ListView(
                  children: _tuneParameterlist(),
                ),
        ),
      ],
    );
  }

//学习详情
  List<Widget> __readmessagelist() {
    List<Widget> temp = [];

    if (baseKey.side == 0 || baseKey.side == 3) {
      for (var i = 0; i < baseKey.sideAtooth; i++) {
        temp.add(
          SizedBox(
            height: 37.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 40.w,
                    child: Text(
                      "A${i + 1}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    )),
                SizedBox(
                    width: 40.w,
                    child: Text(
                      baseKey.ahNums[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    )),
                SizedBox(
                    width: 40.w,
                    child: Text(
                      baseKey.hide ? "*" : "${baseKey.ahNum[i]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    )),
                SizedBox(
                    width: 40.w,
                    child: Text(
                      "${baseKey.sAhNum[i]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    )),
                SizedBox(
                  width: 40.w,
                  child: Text("${baseKey.sAhNum[i] - baseKey.ahNum[i]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: baseKey.sAhNum[i] > baseKey.ahNum[i]
                            ? Colors.red
                            : const Color(0xff4b7cd3),
                      )),
                ),
              ],
            ),
          ),
        );
      }
      temp.add(const SizedBox(
        height: 5,
      ));
    }

    if ((baseKey.side == 1 || baseKey.side == 2 || baseKey.side == 3) &&
        baseKey.keyClass != 13) {
      for (var i = 0; i < baseKey.sideBtooth; i++) {
        temp.add(SizedBox(
            height: 37.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 40.w,
                    child: Text(
                      "B${i + 1}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    )),
                SizedBox(
                    width: 40.w,
                    child: Text(
                      baseKey.bhNums[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    )),
                SizedBox(
                    width: 40.w,
                    child: Text(
                      baseKey.hide ? "*" : "${baseKey.bhNum[i]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    )),
                SizedBox(
                    width: 40.w,
                    child: Text(
                      "${baseKey.sBhNum[i]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    )),
                SizedBox(
                  width: 40.w,
                  child: Text("${baseKey.sBhNum[i] - baseKey.bhNum[i]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: baseKey.sBhNum[i] > baseKey.bhNum[i]
                            ? Colors.red
                            : const Color(0xff4b7cd3),
                      )),
                ),
              ],
            )));

        // temp.add(SizedBox(
        //     height: 37.h,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         SizedBox(width: 40.w, child: Text("B${i + 1}")),
        //         SizedBox(width: 40.w, child: Text(baseKey.bhNums[i])),
        //         SizedBox(width: 40.w, child: Text("${baseKey.bhNum[i]}")),
        //         SizedBox(width: 40.w, child: Text("${baseKey.sBhNum[i]}")),
        //         SizedBox(
        //           width: 40.w,
        //           child: Text(
        //             "${baseKey.sBhNum[i] - baseKey.bhNum[i]}",
        //             style: TextStyle(
        //                 color: baseKey.sBhNum[i] > baseKey.bhNum[i]
        //                     ? Colors.red
        //                     : Colors.green),
        //           ),
        //         ),
        //       ],
        //     )));

        temp.add(const SizedBox(
          height: 5,
        ));
      }
    }
    return temp;
  }

  Widget _readmessage() {
    //学习详情
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        SizedBox(
          height: 14.h,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            SizedBox(
              width: 40.w,
              child: Text(
                S.of(context).keytoothnum,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            SizedBox(
              width: 40.w,
              child: Text(
                S.of(context).keytoothcode,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            SizedBox(
              width: 40.w,
              child: Text(
                S.of(context).reference,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            SizedBox(
              width: 40.w,
              child: Text(
                S.of(context).really,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            SizedBox(
              width: 40.w,
              child: Text(
                S.of(context).diffdata,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
          ]),
        ),
        Expanded(
          child: ListView(
            children: __readmessagelist(),
          ),
        ),
      ],
    );
  }

  Widget _toolsbar() {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: AppBar(
        backgroundColor: const Color(0xffdde1ea),
        toolbarHeight: 36.h,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: TabBar(
            controller: _tabController,
            //  physics: _scrollPhysics,
            // labelColor: Colors.white,
            // unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.zero,
            // onTap: (value) {
            // //print(value);
            // },
            tabs: toolsBartitle()),
      ),

      //切换tab的view
      body: TabBarView(controller: _tabController, children: toolsPage()),
    );
  }

  String listStr(List data) {
    String temp = "";
    for (var i = 0; i < data.length; i++) {
      temp = temp + data[i];
    }
    return temp;
  }

//切削准备界面
  Future<void> updateHistory() async {
    debugPrint("上传历史记录");
    String bitting = "";
    int keyid = 0;
    Map keydata = {};
    switch (baseKey.keySerNum) {
      case 158:
      case 159:
      case 510:
      case 511:
        bitting =
            "${listStr(baseKey.axhNums)}-${listStr(baseKey.bxhNums)}-${listStr(baseKey.cxhNums)}";
        if (baseKey.axhNums.length == 9) {
          keyid = 158;
        } else {
          keyid = 159;
        }
        break;
      default:
        if (baseKey.side == 3 &&
            baseKey.keyClass != 0 &&
            baseKey.keyClass != 13) {
          bitting = "${listStr(baseKey.ahNums)}-${listStr(baseKey.bhNums)}";
        } else {
          bitting = listStr(baseKey.ahNums);
        }
        keyid = baseKey.keySerNum;
        break;
    }
    if (widget.arguments["type"] == 4) {
      keydata = baseKey.cKeyData;
    }
    var data = {
      "timer": DateTime.now().toString().substring(0, 19),
      "userid": appData.id,
      "keyid": keyid,
      "type": widget.arguments["type"],
      "bitting": bitting,
      "keydata": json.encode(keydata),
      "state": 0,
    };
    //print(data);
    try {
      ////print(data);
      var result = await Api.upUserHistory(data);
      if (result["state"]) {
        data["state"] = 1;
        await appData.insertHistory(data);
      } else {
        await appData.insertHistory(data);
      }
    } catch (e) {
      await appData.insertHistory(data);
    }
  }

//上传客户资料
  Future<void> updateCustomerData() async {
    String bitting = "";
    int keyid = 0;
    switch (baseKey.keySerNum) {
      case 158:
      case 159:
      case 510:
      case 511:
        bitting =
            "${listStr(baseKey.axhNums)}-${listStr(baseKey.bxhNums)}-${listStr(baseKey.cxhNums)}";
        if (baseKey.axhNums.length == 9) {
          keyid = 158;
        } else {
          keyid = 159;
        }
        break;
      default:
        if (baseKey.side == 3 &&
            baseKey.keyClass != 0 &&
            baseKey.keyClass != 13) {
          bitting = "${listStr(baseKey.ahNums)}-${listStr(baseKey.bhNums)}";
        } else {
          bitting = listStr(baseKey.ahNums);
        }
        keyid = baseKey.keySerNum;
        break;
    }

    var data = {
      "timer": DateTime.now().toString().substring(0, 19),
      "userid": appData.id,
      "keyid": keyid,
      "type": widget.arguments["type"],
      "bitting": bitting,
      "name": customername,
      "phone": customerphone,
      "carnum": customercarnum,
      "state": 0,
    };
    //print(data);
    try {
      ////print(data);
      var result = await Api.upUserClient(data);
      if (result["state"]) {
        data["state"] = 1;
        await appData.insertClient(data);
      } else {
        await appData.insertClient(data);
      }
    } catch (e) {
      await appData.insertClient(data);
    }
  }

//编辑客户资料
  Widget editCustomerData() {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            backgroundColor: const Color(0x00ffffff),
            body: Center(
              child: Container(
                // color: Colors.white,
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                    color: const Color(0XFFEEEEEE),
                    borderRadius: BorderRadius.all(Radius.circular(8.r))),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8.r))),
                      height: 50.h,
                      child: Center(
                        child: Text(S.of(context).customerinf),
                      ),
                    ),
                    // const Expanded(child: SizedBox()),
                    // SizedBox(
                    //   height: 22.h,
                    //   child: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 20.w,
                    //       ),
                    //       Text(S.of(context).customername),
                    //       const Expanded(child: SizedBox()),
                    //       SizedBox(
                    //         width: 150.w,
                    //         child: TextField(
                    //             controller: TextEditingController(text: ""),
                    //             onChanged: (value) {
                    //               customername = value;
                    //             }),
                    //       ),
                    //       SizedBox(
                    //         width: 20.w,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const Expanded(child: SizedBox()),
                    // SizedBox(
                    //   height: 22.h,
                    //   child: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 20.w,
                    //       ),
                    //       Text(S.of(context).customerphone),
                    //       const Expanded(child: SizedBox()),
                    //       SizedBox(
                    //         width: 150.w,
                    //         child: TextField(
                    //             controller: TextEditingController(text: ""),
                    //             onChanged: (value) {
                    //               customerphone = value;
                    //             }),
                    //       ),
                    //       SizedBox(
                    //         width: 20.w,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const Expanded(child: SizedBox()),
                    // SizedBox(
                    //   height: 22.h,
                    //   child: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 20.w,
                    //       ),
                    //       Text(S.of(context).customercarnum),
                    //       const Expanded(child: SizedBox()),
                    //       SizedBox(
                    //         width: 150.w,
                    //         child: TextField(
                    //             controller: TextEditingController(text: ""),
                    //             onChanged: (value) {
                    //               customercarnum = value;
                    //             }),
                    //       ),
                    //       SizedBox(
                    //         width: 20.w,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const Expanded(child: SizedBox()),
                    Expanded(
                        child: ListView(
                      children: [
                        SizedBox(
                          height: 33.5.h,
                        ),
                        SizedBox(
                          height: 22.h,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(S.of(context).customername),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                width: 150.w,
                                child: TextField(
                                    controller: TextEditingController(text: ""),
                                    onChanged: (value) {
                                      customername = value;
                                    }),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 33.5.h,
                        ),
                        SizedBox(
                          height: 22.h,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(S.of(context).customerphone),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                width: 150.w,
                                child: TextField(
                                    controller: TextEditingController(text: ""),
                                    onChanged: (value) {
                                      customerphone = value;
                                    }),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 33.5.h,
                        ),
                        SizedBox(
                          height: 22.h,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(S.of(context).customercarnum),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                width: 150.w,
                                child: TextField(
                                    controller: TextEditingController(text: ""),
                                    onChanged: (value) {
                                      customercarnum = value;
                                    }),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 33.5.h,
                        ),
                      ],
                    )),

                    SizedBox(
                        height: 40.h,
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // return false;
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13.r))),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xff384c70))),
                                child: Text(S.of(context).cancel),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                //多功能按钮
                                onPressed: () {
                                  if (customername == "" &&
                                      customercarnum == "" &&
                                      customerphone == "") {
                                    Fluttertoast.showToast(
                                        msg: S.of(context).lestone);
                                  } else {
                                    updateCustomerData();
                                    Navigator.pop(context);
                                  }
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13.r))),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xff384c70))),
                                child: Text(S.of(context).okbt),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  //标记 自定义钥匙已使用 更新自定义钥匙使用状态
  upDiyKeyUse() async {
    if (baseKey.diykeysqlid["use"].toString() != "true") {
      try {
        //尝试删除网络上的数据
        Map<String, dynamic> temp = Map.from(baseKey.diykeysqlid);
        var data = await Api.delUserKey(temp);
        //如果删除成功
        if (data["state"]) {
          await appData.deleUserKey(baseKey.diykeysqlid["id"].toString());
          baseKey.diykeysqlid["state"] = 0;
          baseKey.diykeysqlid["use"] = "true";
          temp = Map.from(baseKey.diykeysqlid);
          var data = await Api.upUserKey(temp);
          if (data["state"]) {
            baseKey.diykeysqlid["state"] = 1;
            await appData.insertUserKey(baseKey.diykeysqlid);
          } else {
            await appData.insertUserKey(baseKey.diykeysqlid);
          }
        } else {
          //删除失败  服务器不存在当前数据
          await appData.deleUserKey(baseKey.diykeysqlid["id"].toString());
          baseKey.diykeysqlid["state"] = 0;
          baseKey.diykeysqlid["use"] = "true";
          await appData.insertUserKey(baseKey.diykeysqlid);
        }
      } catch (e) {
        debugPrint("设置标志位失败");
      }
      //  eventBus.fire(UpdatEvent(0));
    }
  }

  ///切削模式选择 0:标准 1实际值 2:单齿
  _showCuttingWidget(int cutmodel) {
    showDialog(
        barrierDismissible: false,
        context: (context),
        builder: (c) {
          return CutReadyPage(
            baseKey.cKeyData,
            highmodel,
          );
        }).then((value) {
      if (value["state"]) {
        sendCmd([cncBtSmd.cncState, 0, 0]);
        cncbusystate =
            eventBus.on<CNCStateEvent>().listen((CNCStateEvent event) {
          cncbusystate.cancel();
          if (event.state) {
            Fluttertoast.showToast(msg: "机器忙,请稍后再试");
          } else {
            List<int> temp = [];
            switch (cutmodel) {
              case 0:
              case 1:
                if (cncVersion.version >= 2022102001) {
                  temp.add(cncBtSmd.newCuttingKey);
                } else {
                  temp.add(cncBtSmd.cuttingKey);
                }
                print(temp);
                break;
              case 2:
                temp.add(cncBtSmd.cuttingoneKey);
                break;
              default:
                break;
            }
            temp.add(0);
            if (value["model"] || baseKey.isnonconductive) {
              //非导电的钥匙夹具号为13
              //print("非导电");
              temp.addAll(baseKey.creatkeydata(2));
            } else {
              if (cutmodel == 1) {
                temp.addAll(baseKey.creatkeydata(5));
              } else {
                temp.addAll(baseKey.creatkeydata(1));
              }
            }
            sendCmd(temp);
            Navigator.pushNamed(context, "/cncworking").then((value) {
              if (value == 2) {
                //  sendCmd([cncBtSmd.openClamp, 0, 0, 0]);
                if (appData.loginstate) {
                  if (widget.arguments["type"] == 4) {
                    //if()
                    upDiyKeyUse();
                    // updateHistory();
                    // Fluttertoast.showToast(msg: S.of(context).diykeycuttip);
                  }
                  // else
                  //   {
                  switch (baseKey.keySerNum) {
                    case 1:
                    case 2:
                    case 785:
                    case 1400:
                    case 1513:
                      updateHistory();
                      showDialog(
                          context: context,
                          builder: (c) {
                            return editCustomerData();
                          });
                      break;
                    case 158:
                    case 159:
                    case 510:
                    case 511:
                      if ((!baseKey.axhNums.contains("?") &&
                              baseKey.axhNums.isNotEmpty) &&
                          (!baseKey.bxhNums.contains("?") &&
                              baseKey.bxhNums.isNotEmpty) &&
                          (!baseKey.cxhNums.contains("?") &&
                              baseKey.cxhNums.isNotEmpty)) {
                        updateHistory();
                        showDialog(
                            context: context,
                            builder: (c) {
                              return editCustomerData();
                            });
                      }
                      break;
                    default:
                      if (baseKey.keyClass == 0 || baseKey.keyClass == 1) {
                        updateHistory();
                        showDialog(
                            context: context,
                            builder: (c) {
                              return editCustomerData();
                            });
                      } else {
                        if (cuttingSideNum == 1) {
                          updateHistory();
                          showDialog(
                              context: context,
                              builder: (c) {
                                return editCustomerData();
                              });
                        }
                      }

                      break;
                  }
                  // }
                } else {
                  Fluttertoast.showToast(msg: S.of(context).nologinhistorytip);
                }
                cuttingSideNum++;
                if (baseKey.dir == 1 && cuttingSideNum == 1) {
                  baseKey.dir = 1;
                  showDialog(
                      context: context,
                      builder: (c) {
                        return MyTextDialog(S.of(context).smartkeyside2clamp);
                      }).then((value) {
                    Navigator.pushNamed(context, '/openclamp',
                        arguments: {"state": false, "side": 2});
                  });
                }
                if (cuttingSideNum == 2) {
                  cuttingSideNum = 0;
                  baseKey.dir = 0;
                }
              }
            });
          }
        });
      }
    });
  }

  ///切削模式选择 0:标准 1实际值 2:单齿
  _cutmodelsele(int cutmodel) {
    if (getCncBtState()) {
      if (!baseKey.checkkeydata(0)) {
        showDialog(
            context: (context),
            builder: (c) {
              return MyTextDialog(S.of(context).needreadcode);
            });
      } else {
        // _showCuttingWidget();
        if (baseKey.needChangeXD) {
          showDialog(
              context: context,
              builder: (c) {
                return MySeleDialog(const ["1.5mm", "1.9mm"],
                    title: S.of(context).selexd);
              }).then((value) {
            if (value != 0) {
              cncbusystate = eventBus
                  .on<CNCChangeXDStateEvent>()
                  .listen((CNCChangeXDStateEvent event) {
                cncbusystate.cancel();
                if (event.state) {
                  switch (value) {
                    case 1:
                      baseKey.needChangeXD = false;
                      baseKey.xdR = 75;
                      break;
                    case 2:
                      baseKey.needChangeXD = false;
                      baseKey.xdR = 95;
                      break;
                    default:
                  }
                } else {
                  Fluttertoast.showToast(msg: "更换失败!");
                }
              });
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
          if (baseKey.isnonconductive && baseKey.locat == 1) {
            showDialog(
                context: context,
                builder: (c) {
                  return MyTextDialog(S.of(context).cutnontip);
                }).then((value) {
              _showCuttingWidget(cutmodel);
            });
          } else {
            _showCuttingWidget(cutmodel);
          }
        }
      }
    } else {
      _autoConnectBT();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () async {
        if (!baseKey.needChangeXD &&
                (baseKey.keySerNum == 158 || baseKey.keySerNum == 159) ||
            baseKey.manualChangeXD) {
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog(S.of(context).checkxdchange);
              }).then((value) {
            if (value) {
              baseKey.needChangeXD = true;
              baseKey.xdR = 100;
              sendCmd([cncBtSmd.replaceXd, 0, 0, 0]);
              Navigator.pushNamed(
                context,
                '/toolswait',
                arguments: {},
              );

              // Navigator.pop(context);
            } else {
              Navigator.pop(context);
              return true;
            }
          });
          return true;
        } else {
          Navigator.pop(context);
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffeeeeee),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 32.r,
          elevation: 0.0,
          title: SizedBox(
            width: 97.r,
            height: 18.r,
            child: Image.asset(
              "image/tank/Icon_tankbar.png",
              // fit: BoxFit.cover,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              if (!baseKey.needChangeXD &&
                      (baseKey.keySerNum == 158 || baseKey.keySerNum == 159) ||
                  baseKey.manualChangeXD) {
                showDialog(
                    context: context,
                    builder: (c) {
                      return MyTextDialog(S.of(context).checkxdchange);
                    }).then((value) {
                  if (value) {
                    baseKey.needChangeXD = true;
                    baseKey.xdR = 100;
                    sendCmd([cncBtSmd.replaceXd, 0, 0, 0]);
                    // Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/toolswait',
                      arguments: {},
                    );
                  } else {
                    Navigator.pop(context);
                  }
                });
              } else {
                Navigator.pop(context);
              }
            },
            color: Colors.black,
            icon: Image.asset("image/share/Icon_back.png"),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: const Color(0xffdde1ea),
              height: 48.h,
              child: Row(
                children: [
                  SizedBox(
                    width: 11.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        baseKey.cKeyData["cnname"],
                        style: TextStyle(
                            fontSize: 17.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 64.w,
                        height: 15.w,
                        child: TextButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/openclamp',
                                arguments: {
                                  "keydata": baseKey.cKeyData,
                                  "state": false
                                });
                          },
                          child: Row(children: [
                            Text(
                              S.of(context).fixkey,
                              style: TextStyle(
                                  fontSize: 10.sp, color: Colors.black),
                            ),
                            Image.asset("image/tank/Icon_lookfixture.png")
                          ]),
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 80.w,
                        height: 23.h,
                        child: OutlinedButton(
                          style: ButtonStyle(
                              side: MaterialStateProperty.all(const BorderSide(
                                  width: 1.0, color: Colors.black)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0))),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          child: highmodel
                              ? Text(
                                  S.of(context).highmodel,
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.black),
                                )
                              : Text(
                                  S.of(context).standardmodel,
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.black),
                                ), //
                          onPressed: () {
                            // Navigator.pushNamed(context, '/openclamp',
                            //     arguments: {"keydata": keydata, "state": false});
                            highmodel = !highmodel;
                            currentTab = 0;
                            if (highmodel) {
                              _tabControllerset(3);
                            } else {
                              _tabControllerset(2);
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        width: 96.w,
                        height: 15.w,
                        child: TextButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            if (getCncBtState()) {
                              showDialog(
                                  context: context,
                                  builder: (c) {
                                    return MySeleDialog(
                                        const ["2.0mm", "1.5mm", "1.9mm"],
                                        title: S.of(context).selexd);
                                  }).then((value) {
                                print(value);
                                if (value != 0) {
                                  cncbusystate = eventBus
                                      .on<CNCChangeXDStateEvent>()
                                      .listen((CNCChangeXDStateEvent event) {
                                    cncbusystate.cancel();
                                    if (event.state) {
                                      switch (value) {
                                        case 1:
                                          baseKey.xdR = 100;
                                          break;
                                        case 2:
                                          baseKey.manualChangeXD = true;
                                          baseKey.xdR = 75;
                                          break;
                                        case 3:
                                          baseKey.manualChangeXD = true;
                                          baseKey.xdR = 95;
                                          break;
                                        default:
                                      }
                                    } else {
                                      Fluttertoast.showToast(msg: "更换失败!");
                                    }
                                    setState(() {});
                                  });
                                  sendCmd([cncBtSmd.replaceXd, 0, 0, 0]);
                                  //updatacmd([0x71, 0, 0], false);
                                  Navigator.pushNamed(
                                    context,
                                    '/toolswait',
                                    arguments: {},
                                  ).then((value2) {});
                                }
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: S.of(context).needconnectbt);
                            }
                          },
                          child: Row(children: [
                            Image.asset(
                              "image/tank/Icon_down.png",
                            ),
                            Text(
                              S.of(context).xdr + ":${baseKey.xdR * 2 / 100}mm",
                              style: TextStyle(
                                  fontSize: 10.sp, color: Colors.black),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 11.w,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    child: CustomPaint(
                      //willChange: true,
                      size: const Size(double.maxFinite, double.maxFinite),
                      painter: FlutterPainter(cutsindex),
                    ),
                    alignment: Alignment.center,
                  ),
                  Align(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_left,
                        color: Color(0xff384c70),
                      ),
                      iconSize: 40.h,
                      onPressed: () {
                        setState(() {
                          cutsindex--;
                          if (baseKey.side == 3 &&
                              baseKey.keyClass != 0 &&
                              baseKey.keyClass != 13) {
                            if (baseKey.sideAtooth == baseKey.sideBtooth) {
                              if (cutsindex < 0) {
                                cutsindex = baseKey.toothSA.length * 2 - 1;
                              }
                            } else {
                              //如果A边的齿数小于B边的齿数
                              if (cutsindex < 0) {
                                cutsindex =
                                    baseKey.sideAtooth + baseKey.sideBtooth - 1;
                              }
                              if (baseKey.sideAtooth < baseKey.sideBtooth) {
                                if (cutsindex == baseKey.sideAtooth + 1) {
                                  cutsindex--;
                                }
                              }
                              if (baseKey.sideAtooth > baseKey.sideBtooth) {
                                if (cutsindex ==
                                    baseKey.sideAtooth + baseKey.sideBtooth) {
                                  cutsindex--;
                                }
                              }
                            }
                          } else {
                            if (cutsindex < 0) {
                              cutsindex = baseKey.toothSA.length - 1;
                            }
                          }
                        });
                      },
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_right,
                        color: Color(0xff384c70),
                      ),
                      iconSize: 40.h,
                      onPressed: () {
                        setState(() {
                          cutsindex++;
                          if (baseKey.side == 3 &&
                              baseKey.keyClass != 0 &&
                              baseKey.keyClass != 13) {
                            if (baseKey.sideAtooth == baseKey.sideBtooth) {
                              if (cutsindex > baseKey.toothSA.length * 2 - 1) {
                                cutsindex = 0;
                              }
                            } else {
                              if (baseKey.sideAtooth < baseKey.sideBtooth) {
                                if (cutsindex == baseKey.sideAtooth + 1) {
                                  cutsindex++;
                                }
                              }
                              if (baseKey.sideAtooth > baseKey.sideBtooth) {
                                if (cutsindex ==
                                    baseKey.sideAtooth + baseKey.sideBtooth) {
                                  cutsindex++;
                                }
                              }

                              if (cutsindex >
                                  baseKey.sideAtooth + baseKey.sideBtooth - 1) {
                                cutsindex = 0;
                              }
                            }
                          } else {
                            if (cutsindex > baseKey.toothSA.length - 1) {
                              cutsindex = 0;
                            }
                          }
                        });
                      },
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {
                        _cutmodelsele(1);
                      },
                      child: Container(
                        width: 60.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffeeeeee),
                          border: Border.all(color: const Color(0xff384c70)),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).reallycut,
                            style: TextStyle(
                                color: const Color(0xff384c70),
                                fontSize: 10.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {
                        if (baseKey.keyClass != 5 &&
                                baseKey.keyClass != 7 &&
                                baseKey.keyClass != 13 ||
                            baseKey.issmart ||
                            baseKey.isnonconductive) {
                          _cutmodelsele(2);
                        } else {
                          Fluttertoast.showToast(
                              msg: S.of(context).nosupportonecut);
                        }
                      },
                      child: Container(
                        width: 60.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffeeeeee),
                          border: Border.all(color: const Color(0xff384c70)),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).onecut,
                            style: TextStyle(
                                color: const Color(0xff384c70),
                                fontSize: 10.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  baseKey.otherAxis.isNotEmpty
                      ? Align(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xff384c70)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              // child: SizedBox(
                              //     width: 40.w,
                              //     height: 20.h,
                              //     child: Row(children: [
                              //       Text(currentaxis),
                              //       // const Expanded(child: SizedBox()),
                              //       // const Icon(Icons.arrow_drop_down_outlined),
                              //     ])),
                              child: Text(currentaxis),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (c) {
                                      return MySeleDialog(
                                          keyaxis.sublist(
                                              0, baseKey.otherAxis.length + 1),
                                          title: S.of(context).seleaxis);
                                    }).then((value) {
                                  if (value != 0 && value != null) {
                                    //如果==0说明选择了取消
                                    setState(() {
                                      currentaxis = keyaxis[value - 1];
                                      baseKey.dir = 0;
                                      if (value == 1) {
                                        cutsindex = 0;
                                        baseKey.initdata(baseKey.cKeyData,
                                            initcKeydata: false,
                                            isSmartKey: baseKey.issmart);
                                        _baseKeyDataInit();
                                      } else {
                                        // baseKey.cKeyData =
                                        //     Map.from(baseKey.otherAxis[value - 2]);
                                        cutsindex = 0;
                                        baseKey.initdata(
                                            Map.from(
                                                baseKey.otherAxis[value - 2]),
                                            initcKeydata: false,
                                            isSmartKey: baseKey.issmart);
                                        _baseKeyDataInit();
                                        if (baseKey.issmart && (value == 2)) {
                                          baseKey.dir = 1;
                                          showDialog(
                                              context: context,
                                              builder: (c) {
                                                return MyTextDialog(
                                                    S.of(context).smart162tb);
                                              }).then((value) {
                                            if (value) {
                                              Navigator.pushNamed(
                                                  context, '/openclamp',
                                                  arguments: {
                                                    "state": false,
                                                    "side": 0
                                                  });
                                            }
                                          });
                                        }
                                      }
                                    });
                                  }
                                });
                              }),
                          alignment: Alignment.topLeft,
                        )
                      : Container(),
                ],
              ),
              // flex: 6,
            ),
            Expanded(
              child: _toolsbar(),
            ),
            SizedBox(
              height: 48.h,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: Image.asset("image/tank/Icon_camer.png"),
                            ),
                            Text(
                              S.of(context).photokey,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),
                            ),
                          ]),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return MySeleDialog([
                                S.of(context).photoalbum,
                                S.of(context).carmerphoto
                              ]);
                            }).then((value) {
                          switch (value) {
                            case 1:
                              _onImageButtonPressed(ImageSource.gallery);
                              break;
                            case 2:
                              _onImageButtonPressed(ImageSource.camera);
                              break;
                            default:
                              debugPrint("取消");
                              break;
                          }
                        });
                        setState(() {
                          // Navigator.pushNamed(context, "/camerdiscernkey",
                          //     arguments: {"keydata": keydata});
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: Image.asset(
                                    "image/tank/Icon_keyfindbitting.png")),
                            Text(
                              S.of(context).findbitting,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),
                            ),
                          ]),
                      onPressed: () {
                        if (!baseKey.checkkeydata(4)) {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return MyTextDialog(
                                    S.of(context).searchbittingtip);
                              });
                        } else {
                          if (!baseKey.checkkeydata(0) || searchstate) {
                            searchbitting();
                          } else {
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return MyTextDialog(S.of(context).searchno);
                                });
                          }
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child:
                                    Image.asset("image/tank/Icon_keyread.png")),
                            Text(
                              S.of(context).readkey,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),
                            ),
                          ]),
                      onPressed: () {
                        if (getCncBtState()) {
                          if (baseKey.isnonconductive || baseKey.fixture == 6) {
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return MyTextDialog(S.of(context).readnontip);
                                }).then((value) {
                              if (value) {
                                // debugPrint("跳转到拍照看齿");
                                showDialog(
                                    context: context,
                                    builder: (c) {
                                      return MySeleDialog([
                                        S.of(context).photoalbum,
                                        S.of(context).carmerphoto
                                      ]);
                                    }).then((value) {
                                  switch (value) {
                                    case 1:
                                      Navigator.pushNamed(
                                          context, "/discoverkey",
                                          arguments: {
                                            "keydata": baseKey.cKeyData,
                                            "isVideo": false,
                                            "selemodel": 0,
                                          });
                                      break;
                                    case 2:
                                      Navigator.pushNamed(
                                          context, "/discoverkey",
                                          arguments: {
                                            "isVideo": false,
                                            "selemodel": 1,
                                          });

                                      break;
                                    default:
                                      debugPrint("取消");
                                      break;
                                  }
                                });
                              }
                            });
                          } else {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (c) {
                                  return const ReadReadyPage();
                                }).then((value) {
                              if (value) {
                                debugPrint("准备读码...");

                                sendCmd([cncBtSmd.cncState, 0, 0]);
                                cncbusystate = eventBus
                                    .on<CNCStateEvent>()
                                    .listen((CNCStateEvent event) {
                                  cncbusystate.cancel();
                                  if (event.state) {
                                    Fluttertoast.showToast(msg: "机器忙,请稍后再试");
                                  } else {
                                    baseKey.readstate = false;
                                    List<int> temp = [];
                                    temp.add(cncBtSmd.readKey);
                                    temp.add(0);
                                    temp.addAll(baseKey.creatkeydata(0));
                                    sendCmd(temp);
                                    Navigator.pushNamed(context, "/cncworking")
                                        .then((value) {
                                      if (value == 1) {
                                        if (baseKey.errorkey) {
                                          showDialog(
                                              context: context,
                                              builder: (c) {
                                                return const MyTextDialog(
                                                    "当前钥匙可能存在问题!");
                                              });
                                          baseKey.errorkey = false;
                                        }
                                        setState(() {});
                                      }
                                    });
                                  }
                                });

                                //Navigator.pushNamed(context, "/read")
                              }
                            });
                          }
                        } else {
                          _autoConnectBT();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child:
                                    Image.asset("image/tank/Icon_keycut.png")),
                            Text(
                              S.of(context).cuttingkey,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),
                            ),
                          ]),
                      onPressed: () {
                        _cutmodelsele(0);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onImageButtonPressed(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        // maxWidth: 100.0,
        // maxHeight: 100.0,
        // imageQuality: quality,
      );

      filepath = pickedFile!.path;
      if (filepath != "") {
        Navigator.pushNamed(context, "/discoverkey", arguments: {
          "isVideo": false,
          "selemodel": 1,
          "filepath": filepath,
        }).then((value) {
          setState(() {});
        });
      }
    } catch (e) {
      debugPrint("$e");
      //setState(() {
      // _pickImageError = e;
      //});
    }
  }
}
