import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/cncpage/bluecmd/cmd.dart';

import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/cncpage/basekey.dart';

import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';

import 'package:magictank/home4_page.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../alleventbus.dart';
import '../mycontainer.dart';
import 'copykeypreview_page.dart';

class CopyKeyPage extends StatefulWidget {
  const CopyKeyPage({Key? key}) : super(key: key);

  @override
  _CopyKeyPageState createState() => _CopyKeyPageState();
}

class _CopyKeyPageState extends State<CopyKeyPage> {
  String keytitle = "";
  bool previewstate = false;
  late ProgressDialog pd;
  int currentnum = 0;
  int allnum = 0;
  List<int> ahNum = []; //预览返回的数据
  List<int> bhNum = []; //预览返回的数据
  int state = 0;
  String currentkeypic = "";
  String currentfixturepic = "";
  late StreamSubscription btstatet;
  late StreamSubscription preViewEvent;
  late StreamSubscription cncbusystate;
  Map keydata = {
    "id": 0,
    "fixture": [0],
    "class": 0,
    "locat": 0,
    "side": 0,
    "wide": 0,
    "thickness": 300,
    "length": 0,
    "depth": 110,
    "groove": 0,
    "A": 0,
    "AX": 0,
    "B": 0,
    "BX": 0,
    "toothDepth": [],
    "toothDepthName": [],
    "toothSA": [],
    "toothWideA": [],
    "toothSB": [],
    "toothWideB": [],
    "moreside": [],
  };
  List<Map> keyclasslist = [
    {
      "name": S.current.keyclass0,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass0.png"
    },
    {
      "name": S.current.keyclass1,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass1.png"
    },
    {
      "name": S.current.keyclass2,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass2.png"
    },
    {
      "name": S.current.keyclass5,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass5.png"
    },
    {
      "name": S.current.keyclass3,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass3.png"
    },
    {
      "name": S.current.keyclass4,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass4.png"
    },
    {
      "name": S.current.keyclass6,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass31.png"
    },
    {
      "name": S.current.keyclass7,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass11.png"
    },
  ];
  List<Map> keylocatelist = [
    {
      "name": S.current.keylocat1,
      "pic": appData.keyImagePath + "/fixture/diykey/locat_head.png"
    },
    {
      "name": S.current.keylocat0,
      "pic": appData.keyImagePath + "/fixture/diykey/locat_shoulder.png"
    },
  ];

  List<String> keyfixturelist = [
    S.current.keyside5,
    S.current.keyside6,
  ];
  List<String> keyfixturelis5 = [
    S.current.keyside6,
  ];
  List<String> keyfixturelist3 = [
    S.current.keyside0,
    S.current.keyside1,
    S.current.keyside3,
    S.current.keyside4,
  ];

  @override
  void initState() {
    state = 0;
    baseKey.readstate = false;
    pd = ProgressDialog(context: context);

    // baseKey.initdata(keydata);
    preViewEvent = eventBus.on<PreViewEvent>().listen((event) {
      {
        currentnum = currentnum + event.toothdepth.length;
        if (baseKey.side == 3 ||
            keydata["class"] == 5 ||
            keydata["class"] == 2) {
          allnum = event.tooth * 2;
        } else {
          allnum = event.tooth;
        }

        if (event.side == 0) {
          ahNum.addAll(event.toothdepth);
        } else {
          bhNum.addAll(event.toothdepth);
        }
        setState(() {
          print("currentnum$currentnum,$allnum,${event.tooth}");
          pd.update(value: ((currentnum / allnum) * 100).toInt());
          if (((currentnum / allnum) * 100).toInt() == 100) {
            previewstate = true;
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    preViewEvent.cancel();
    super.dispose();
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

  Widget keyclassbt(index) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      onPressed: () {
        setState(() {
          keytitle = "";
          keytitle = keytitle + keyclasslist[index]["name"];
          currentkeypic = keyclasslist[index]["pic"];
          switch (index) {
            case 0:
              keydata["class"] = 0;
              keydata["side"] = 2;
              keydata["fixture"] = [5];
              break;
            case 1:
              keydata["class"] = 1;
              keydata["side"] = 0;
              keydata["fixture"] = [5];
              break;
            case 2:
              keydata["class"] = 2;
              break;
            case 3:
              keydata["class"] = 5;
              break;
            case 4:
              keydata["class"] = 3;
              break;
            case 5:
              keydata["class"] = 4;
              break;
            case 6:
              keydata["class"] = 3;
              keydata["fixture"] = [1];
              keydata["side"] = 0;
              break;
            case 7:
              keydata["class"] = 1;
              keydata["fixture"] = [1];
              keydata["side"] = 0;
              break;
            case 8:
              break;
            case 9:
              break;
          }
          state = 1;
        });
      },
      child: myContainer(155.r, 126.r, 25.r, keyclasslist[index]["name"],
          keyclasslist[index]["pic"], EdgeInsets.zero),
    );
  }

  Widget keyclass(context, index) {
    return Row(
      children: [
        SizedBox(
          width: 9.w,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.r, bottom: 45.r),
          child: keyclassbt(index * 2),
        ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.only(right: 10.r, bottom: 45.r),
          child: keyclassbt(index * 2 + 1),
        ),
        SizedBox(
          width: 9.w,
        ),
      ],
    );
  }

  List<Widget> keylocate() {
    List<Widget> temp = [];
    int a = 0;
    int b = 0;
    if (keydata["fixture"][0] == [1]) {
      if (keydata["class"] == 1) {
        a = 1;
      } else {
        b = 1;
      }
    }

    for (var i = a; i < keylocatelist.length - b; i++) {
      temp.add(
        TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            keytitle = keytitle + "-" + keylocatelist[i]["name"];
            switch (i) {
              case 0:
                keydata["locat"] = 1;
                break;
              case 1:
                keydata["locat"] = 0;
                break;
              default:
            }

            state = 2;
            setState(() {});
          },
          child: Container(
            width: 340.w,
            height: 126.h,
            margin: EdgeInsets.only(
                left: 10.w, right: 10.w, top: 20.h, bottom: 20.h),
            decoration: BoxDecoration(
                color: const Color(0xff384c70),
                borderRadius: BorderRadius.circular(13)),
            child: Column(
              children: [
                SizedBox(
                  height: 23.h,
                  child: Text(
                    keylocatelist[i]["name"],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: 340.w,
                  height: 103.h,
                  color: Colors.white,
                  child: Image.file(
                    File(keylocatelist[i]["pic"]),
                  ),
                ))
              ],
            ),
          ),
        ),
      );
    }
    return temp;
  }

  String getfixturepic(int keyfixture, int side) {
    int fixtruetype = 0;

    if (cncVersion.fixtureType == 21) {
      fixtruetype = 1;
    } else {
      fixtruetype = 0;
    }
    currentfixturepic = appData.keyImagePath +
        "/fixture/diykey/${fixtruetype}_$keyfixture" +
        "${keydata["class"]}_${side}_${keydata["locat"]}.png";
    return currentfixturepic;
  }

  List<Widget> keyfixture() {
    List<Widget> temp = [];
    // List<Widget> temp2 = [];
    //立铣外沟单边
    switch (keydata["class"]) {
      case 3:
        if (keydata["fixture"][0] == 1) {
          temp.add(TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              onPressed: () {
                setState(() {
                  state = 3;
                });
              },
              child: myContainer(340.w, 193.w, 23.w, S.of(context).keyclass7,
                  getfixturepic(1, 0), EdgeInsets.all(10.w))));
        } else {
          for (var i = 0; i < keyfixturelist3.length; i++) {
            temp.add(TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: () {
                  setState(() {
                    switch (i) {
                      case 0:
                        keydata["side"] = 0;
                        keydata["fixture"] = [4];
                        getfixturepic(i > 1 ? 5 : 0, i % 2);
                        break;
                      case 1:
                        keydata["side"] = 1;
                        keydata["fixture"] = [3];
                        getfixturepic(i > 1 ? 5 : 0, i % 2);
                        break;
                      case 2: //薄
                        keydata["side"] = 0;
                        keydata["fixture"] = [5];
                        getfixturepic(i > 1 ? 5 : 0, i % 2);
                        break;

                      case 3: //薄
                        keydata["side"] = 1;
                        keydata["fixture"] = [5];
                        getfixturepic(i > 1 ? 5 : 0, i % 2);
                        break;
                    }
                    state = 3;
                    //state = 0;
                  });
                },
                child: myContainer(
                    340.w,
                    193.w,
                    23.w,
                    keyfixturelist3[i],
                    getfixturepic(i > 1 ? 5 : 0, i % 2),
                    EdgeInsets.all(10.w))));
          }
        }
        break;
      case 0:
      case 1:
        temp.add(TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            onPressed: () {
              setState(() {
                state = 3;
              });
            },
            child: myContainer(
                340.w,
                193.w,
                23.w,
                keydata["fixture"][0] == 1
                    ? S.of(context).keyclass6
                    : keyfixturelis5[0],
                getfixturepic(
                    keydata["fixture"][0], keydata["class"] == 0 ? 2 : 0),
                EdgeInsets.all(10.w))));
        break;
      default:
        for (var i = 0; i < keyfixturelist.length; i++) {
          temp.add(TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              onPressed: () {
                setState(() {
                  keydata["side"] = 3;
                  if (i == 0) {
                    keydata["fixture"] = [0];
                    getfixturepic(i == 0 ? 0 : 5, 2);
                  } else {
                    keydata["fixture"] = [5];
                    getfixturepic(i == 0 ? 0 : 5, 2);
                  }
                  state = 3;
                  //state = 0;
                });
              },
              child: myContainer(340.w, 193.w, 23.w, keyfixturelist[i],
                  getfixturepic(i == 0 ? 0 : 5, 2), EdgeInsets.all(10.w))));
        }
        break;
    }

    return temp;
  }

//根据state决定显示的内容
  Widget statewidget(context) {
    switch (state) {
      case 0: //选择钥匙类型
        return ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return keyclass(context, index);
            });
//         return GridView.builder(
//           itemCount: 8,
//           padding:
//               EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w, bottom: 20.h),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //横轴元素个数
//             crossAxisCount: 2,
// //纵轴间距
//             mainAxisSpacing: 45.h,
// //横轴间距
//             crossAxisSpacing: 30.w,
// //子组件宽高长度比例
//             childAspectRatio: 1.24,
//           ),
//           itemBuilder: (BuildContext context, int index) {
//             return keyclass(context, index);
//           },
//         );
      case 1: //选择定位方式
        return ListView(
          children: keylocate(),
        );
      case 2: //选择使用的夹具
        return ListView(
          children: keyfixture(),
        );
      case 3: //读码切削页面
        return Column(
          children: [
            Container(
              width: 340.w,
              height: 40.h,
              decoration: const BoxDecoration(
                  color: Color(0xff384c70),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(13.0),
                      topRight: Radius.circular(13.0))),
              child: Center(
                child: Text(
                  keytitle,
                  style: TextStyle(fontSize: 15.sp, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: previewstate
                  ? Center(
                      child: CustomPaint(
                        size: const Size(double.maxFinite, double.maxFinite),
                        painter: CopyPainter(
                          keydata,
                          ahNum,
                          bhNum,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      width: 340.w,
                      child: Image.file(File(currentkeypic)),
                    ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(13.0),
                        bottomRight: Radius.circular(13.0))),
                width: 340.w,
                child: Center(
                  child: Image.file(
                    File(currentfixturepic),
                  ),
                ),
              ),
              flex: 2,
            ),
            SizedBox(
              height: 48.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          // backgroundColor:
                          //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Text(S.of(context).readkey),
                      onPressed: () {
                        baseKey.readstate = false;
                        baseKey.initdata(keydata);
                        ////读码的时候将状态置为false
                        if (getCncBtState()) {
                          //print("state");
                          previewstate = false;
                          keydata["cnname"] = keytitle;
                          sendCmd([cncBtSmd.openClamp, 0, 0]);
                          Navigator.pushNamed(context, '/openclamp',
                              arguments: {
                                "keydata": keydata,
                                "state": false,
                                "copykey": true,
                              }).then((value) {
                            if (value == true) {
                              sendCmd([cncBtSmd.cncState, 0, 0]);
                              cncbusystate = eventBus
                                  .on<CNCStateEvent>()
                                  .listen((CNCStateEvent event) {
                                cncbusystate.cancel();
                                if (event.state) {
                                  Fluttertoast.showToast(
                                      msg: S.of(context).isworking);
                                } else {
                                  switch (baseKey.keyClass) {
                                    case 0:
                                      baseKey.side = 3;
                                      baseKey.locat = 1;
                                      baseKey.depth = 320;
                                      baseKey.thickness = 270;
                                      break;
                                    case 1:
                                      baseKey.side = 0;
                                      baseKey.locat = 1;
                                      baseKey.depth = 320;
                                      baseKey.thickness = 270;
                                      break;
                                    case 2:
                                    case 3: //
                                    case 4:
                                    case 5:
                                      // key->fixture=5;
                                      baseKey.locat = 1;
                                      if (baseKey.fixture == 5) {
                                        baseKey.depth = 80;
                                        baseKey.thickness = 200; //Ô¿³×Åßºñ¶È
                                      } else {
                                        baseKey.depth = 110;
                                        baseKey.thickness = 300;
                                      }
                                      break;
                                  }
                                  List<int> temp = [];
                                  ////print(keydata);
                                  temp.add(cncBtSmd.copyKeyRead);
                                  temp.add(0);
                                  temp.addAll(baseKey.creatkeydata(0));
                                  sendCmd(temp);

                                  Navigator.pushNamed(context, '/cncworking')
                                      .then((value) {
                                    debugPrint("复制完成");
                                  });
                                }
                              });
                            }
                          });
                        } else {
                          _autoConnectBT();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          // backgroundColor:
                          //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Text(S.of(context).copykeypreview),
                      onPressed: () {
                        if (baseKey.readstate == false) {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return MyTextDialog(S.of(context).copykeytip);
                              });
                        } else {
                          currentnum = 0;
                          ahNum = [];
                          bhNum = [];
                          sendCmd([0x9f, 11, 0]);
                          pd.show(max: 100, msg: S.of(context).getdata);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          // backgroundColor:
                          //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Text(S.of(context).cuttingkey),
                      onPressed: () {
                        if (baseKey.readstate == false) {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return MyTextDialog(S.of(context).copykeytip);
                              });
                        } else {
                          //开始切削
                          sendCmd([cncBtSmd.copyKeyCut, 0, 0]);
                          Navigator.pushNamed(context, '/cncworking');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case 4:
        return ListView();
      case 5:
        return ListView();
      default:
        return const SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Center(
            child: Text("状态丢失"),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (state == 0) {
          return true;
        } else {
          state--;
          setState(() {});
          return false;
        }
      },
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
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
              if (state == 0) {
                Navigator.pop(context);
              } else {
                state--;
                setState(() {});
              }
            },
            color: Colors.black,
            icon: Image.asset("image/share/Icon_back.png"),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const Tips4Page();
                }), (route) => false);
              },
              color: Colors.black,
              icon: Image.asset("image/share/Icon_home.png"),
            )
          ],
        ),
        body: statewidget(context),
      ),
    );
  }
}
