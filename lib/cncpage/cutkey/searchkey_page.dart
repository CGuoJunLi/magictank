import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';
//import 'package:flutter/scheduler.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/basekey.dart';

import 'package:magictank/cncpage/bluecmd/sendcmd.dart';

import 'package:magictank/cncpage/mycontainer.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';

import 'package:magictank/home4_page.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../alleventbus.dart';
import '../../convers/convers.dart';

class SearchKeyPage extends StatefulWidget {
  final List arguments;
  const SearchKeyPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  _SearchKeyPageState createState() => _SearchKeyPageState();
}

class _SearchKeyPageState extends State<SearchKeyPage> {
  String keytitle = "";
  bool previewstate = false;
  bool progressstate = false;
  late ProgressDialog pd;
  int currentnum = 0;
  int allnum = 0;
  List<int> ahNum = []; //预览返回的数据
  List<int> bhNum = []; //预览返回的数据
  List<int> sAhNum = []; //预览返回的数据
  List<int> sBhNum = []; //预览返回的数据
  int state = 0;
  List<Map> progressKeyList = [];
  int searchKeyIndex = 0;
  late StreamSubscription eventBusF;
  late StreamSubscription cncbusystate;
  List<Map> original = [];
  Map keydata = {
    "id": 0,
    "fixture": [5],
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
      "name": S.current.keyclass3,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass3.png"
    },
    {
      "name": S.current.keyclass4,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass4.png"
    },
    {
      "name": S.current.keyclass5,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass5.png"
    },
    {
      "name": S.current.keyclass7,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass31.png"
    },
    {
      "name": S.current.keyclass6,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass11.png"
    },
  ];
  List<int> keyclassid = [];
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
  List<String> keysidelist = [
    "A边",
    "B边",
  ];

  @override
  void initState() {
    state = 0;
    pd = ProgressDialog(context: context);
    baseKey.readstate == false;
    initKeyDataList();
    // baseKey.initdata(keydata);
    //("开始监听");
    eventBusF = eventBus.on<SearchKeyEvent>().listen((event) async {
      if (event.state) {
        // //print("找到钥匙");
        eventBusF.cancel();
        if (progressKeyList[searchKeyIndex]["side"] == 3 &&
            progressKeyList[searchKeyIndex]["class"] != 0) {
          String temp = "";
          temp = listStringToString(baseKey.ahNums) +
              "-" +
              listStringToString(baseKey.bhNums);

          Navigator.pushReplacementNamed(context, '/keyshow', arguments: {
            "keydata": progressKeyList[searchKeyIndex],
            "bitting": temp
          });
        } else {
          Navigator.pushReplacementNamed(context, '/keyshow', arguments: {
            "keydata": progressKeyList[searchKeyIndex],
            "bitting": baseKey.ahNums
          });
        }
      } else {
        // //print("不是:${progressKeyList[searchKeyIndex]}");
        if (searchKeyIndex + 1 == progressKeyList.length) {
          showDialog(
              context: context,
              builder: (c) {
                return const MyTextDialog("未找到钥匙!");
              });
        } else {
          searchKeyIndex++;
          // //print("下一笔");
          sendCmd([cncBtSmd.openClamp, 0, 0]);

          await Future.delayed(const Duration(milliseconds: 5000));
          sendSearchCmd(searchKeyIndex);
        }
      }
    });
    // eventBus.on<PreViewEvent>().listen((event) {
    //   {
    //     currentnum++;
    //     if (baseKey.side == 3 ||
    //         keydata["class"] == 5 ||
    //         keydata["class"] == 2) {
    //       allnum = event.tooth * 2;
    //     } else {
    //       allnum = event.tooth;
    //     }
    //     ////print(((currentnum / allnum) * 100).toInt());
    //     if (event.side == 0) {
    //       ahNum.add(event.toothdepth);
    //     } else {
    //       bhNum.add(event.toothdepth);
    //     }
    //     setState(() {
    //       //print("currentnum:$currentnum/$allnum");
    //       //print("wide:${event.wide}");
    //       //print("thickness:${event.thickness}");
    //       pd.update(value: ((currentnum / allnum) * 100).toInt());
    //       if (((currentnum / allnum) * 100).toInt() == 100) {
    //         //print(ahNum);
    //         //print(bhNum);
    //         previewstate = true;
    //         if (pd.isOpen()) {
    //           pd.close();
    //           previewstate = true;
    //         }
    //       }

    //       if (currentnum == allnum) {
    //         if (pd.isOpen()) {
    //           pd.close();
    //           previewstate = true;
    //         }
    //       }
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    eventBusF.cancel();
    super.dispose();
  }

  void initKeyDataList() {
    keyclassid = [];
    original = List.from(widget.arguments); //获取原数据

    original = original.toSet().toList(); //去重

    for (var i = 0; i < original.length; i++) {
      if (original[i]["class"] != 13 && original[i]["class"] != 7) {
        keyclassid.add(original[i]["class"]);
      }
    }
    keyclassid = keyclassid.toSet().toList(); //去重
    keyclassid.sort((a, b) => a.compareTo(b));
  }

  void sendSearchCmd(int index) {
    baseKey.initdata(progressKeyList[index]);
    List<int> temp = [];
    temp.add(cncBtSmd.checkKey);
    temp.add(0);
    temp.addAll(baseKey.creatkeydata(4));
    sendCmd(temp);
  }

  void searchkey() {
    progressKeyList = [];

    for (var i = 0; i < original.length; i++) {
      if (original[i]["class"] == keydata["class"] &&
          original[i]["locat"] == keydata["locat"] &&
          original[i]["side"] == keydata["side"]) {
        // calculation(widget.arguments[i]);
        progressKeyList.add(original[i]);
      }
    }
    progressKeyList = progressKeyList.toSet().toList();
  }

  void creatTooth() {
    //创建齿深
    // int currentTooth = 0;
    int beginTooth = 0;
    int endTooth = 0;
    bool begin = false;
    List<int> toothSA = [];
    List<int> toothSAH = [];
    ////print(List.from(ahNum.reversed));
    //  //print(bhNum);
    List<int> tempA = List.from(ahNum.reversed);
    for (var i = 0; i < tempA.length - 1; i++) {
      if ((tempA[i] == tempA[i + 1]) && !begin && tempA[i] != 0) {
        beginTooth = i;
        begin = true;
      }
      if ((begin && (tempA[i] != tempA[i + 1])) || (i == tempA.length - 1)) {
        endTooth = i;
        toothSA.add(endTooth * 20 - (endTooth * 20 - beginTooth * 20) ~/ 2);
        begin = false;
        toothSAH.add(tempA[i]);
      }
    }
    //  //print(toothSA.reversed);
    // //print(toothSAH.reversed);
  }

  void calculation(Map key) {}

//获取定位方式
  String getKeylocat() {
    switch (keydata["locat"]) {
      case 0:
        return "肩";
      case 1:
        return "头";
      default:
        return "未知";
    }
  }

  Map getKeyClass(int keyclass) {
    switch (keyclass) {
      case 0:
        return keyclasslist[0];
      case 1:
        return keyclasslist[1];
      case 2:
        return keyclasslist[2];
      case 3:
        return keyclasslist[3];
      case 4:
        return keyclasslist[4];
      case 5:
        return keyclasslist[5];
      default:
        return keyclasslist[0];
    }
  }

  Widget keyclassbt(index) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      onPressed: () {
        switch (keyclassid[index]) {
          case 0:
            keydata["class"] = 0;
            keydata["side"] = 3;
            break;
          case 1:
            keydata["class"] = 1;
            keydata["side"] = 0;
            break;
          case 2:
            keydata["class"] = 2;
            keydata["side"] = 3;
            break;
          case 3:
            keydata["class"] = 3;
            break;
          case 4:
            keydata["class"] = 4;
            keydata["side"] = 3;
            break;
          case 5:
            keydata["class"] = 5;
            break;
          case 8:
            break;
          case 9:
            break;
        }

        state = 1;
        setState(() {});
      },
      child: myContainer(
          155.w,
          126.h,
          23.h,
          getKeyClass(keyclassid[index])["name"],
          getKeyClass(keyclassid[index])["pic"],
          EdgeInsets.zero),
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
          child: index * 2 + 1 < keyclassid.length
              ? keyclassbt(index * 2 + 1)
              : SizedBox(
                  width: 155.w,
                  height: 126.h,
                ),
        ),
        SizedBox(
          width: 9.w,
        ),
      ],
    );
  }

  List<Widget> keylocate() {
    List<Widget> temp = [];

    for (var i = 0; i < keylocatelist.length; i++) {
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
            switch (keydata["class"]) {
              case 0:
              case 1:
              case 2:
              case 4:
                searchkey();
                state = 3;
                break;
              default:
                state = 2;
                break;
            }
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
    return appData.keyImagePath +
        "/fixture/diykey/${fixtruetype}_$keyfixture" +
        "${keydata["class"]}_${side}_${keydata["locat"]}.png";
  }

  List<Widget> keyfixture() {
    List<Widget> temp = [];
    // List<Widget> temp2 = [];
    //立铣外沟单边
    for (var i = 0; i < keysidelist.length; i++) {
      temp.add(
        Container(
          width: 340.w,
          height: 193.h,
          margin: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Color(0xff384c70),
            borderRadius: BorderRadius.all(Radius.circular(13.0)),
          ),
          child: TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            onPressed: () {
              switch (i) {
                case 0:
                  keydata["side"] = 0;
                  break;
                case 1:
                  keydata["side"] = 1;
                  break;
              }
              searchkey();
              state = 3;
              //state = 0;
              setState(() {});
            },
            child: Column(
              children: [
                SizedBox(
                    width: 340.w,
                    height: 23.h,
                    child: Text(
                      keysidelist[i],
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    )),
                Expanded(
                    child: Container(
                  width: 340.w,
                  color: Colors.white,
                  child: Image.file(File(getfixturepic(0, i % 2))),
                )),
              ],
            ),
          ),
        ),
      );
    }

    return temp;
  }

  List<Widget> keyside() {
    List<Widget> temp = [];
    // List<Widget> temp2 = [];
    //立铣外沟单边
    for (var i = 0; i < keysidelist.length; i++) {
      temp.add(
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                width: 3,
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: TextButton(
              onPressed: () {
                keydata["side"] = i;
                state = 2;
                setState(() {});
              },
              child: Row(
                children: [
                  const Expanded(
                    child: Text("图片"),
                  ),
                  Expanded(
                    child: Text(keysidelist[i]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      temp.add(const SizedBox(
        height: 20,
      ));
    }

    return temp;
  }

  String _gettooth(Map keydata) {
    if (keydata["side"] == 3 && keydata["class"] != 0) {
      return keydata["toothSA"].length.toString() +
          "-" +
          keydata["toothSA"].length.toString();
    } else {
      return keydata["toothSA"].length.toString();
    }
  }

  String getkeylength(Map keydata) {
    if (keydata["locat"] == 0) {
      return keydata["wide"].toString() +
          "*" +
          (keydata["toothSA"][keydata["toothSA"].length - 1] + 210).toString();
    } else {
      return keydata["wide"].toString() +
          "*" +
          keydata["toothSA"][0].toString();
    }
  }

  Widget showkeydata(context, index) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      child: SizedBox(
        width: 341.w,
        height: 130.h,
        child: Card(
          child: Column(
            children: [
              SizedBox(
                height: 11.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 22.h,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                progressKeyList[index]["cnname"],
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Expanded(child: SizedBox()),
                              Text(
                                progressKeyList[index]["keynumbet"] == ""
                                    ? ""
                                    : "（" +
                                        progressKeyList[index]["keynumbet"] +
                                        "）",
                                style: TextStyle(
                                    fontSize: 10.sp, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: 138.w,
                            height: 38.h,
                            child: Image.file(
                              File(appData.keyImagePath +
                                  "/key/" +
                                  progressKeyList[index]["picname"]),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 23.w,
                  ),
                  Expanded(
                      child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _gettooth(progressKeyList[index]) +
                                  S.of(context).keycuts,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              height: 10.h,
                              child: Text(
                                getkeylength(progressKeyList[index]),
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              progressKeyList[index]["locat"].toString() == "0"
                                  ? (S.of(context).keyloact +
                                      ":" +
                                      S.of(context).keylocat0)
                                  : (S.of(context).keyloact +
                                      ":" +
                                      S.of(context).keylocat1),
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
              SizedBox(
                height: 13.h,
              ),
              SizedBox(
                height: 22.h,
                width: 300.w,
                child: Text(
                  (progressKeyList[index]["chnote"] != "无" &&
                          progressKeyList[index]["chnote"] != "null")
                      ? S.of(context).note +
                          ":" +
                          progressKeyList[index]["chnote"]
                      : "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 10.sp,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        ////print(progressKeyList[index]);
        //传入钥匙数据即可
        //先显示操作说明
        baseKey.initdata(progressKeyList[index]);
        Navigator.pushNamed(context, '/openclamp',
            arguments: {"keydata": progressKeyList[index], "state": 0});

        // Navigator.pushNamed(context, '/keyshow',
        // widget.arguments: {"keydata": progressKeyList[index]});
      },
      onLongPress: () {},
    );
  }

  Widget processdatashow(context) {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Container(
            // color: Colors.white,
            width: 300.w,
            height: 250.h,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(13.0))),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                  child: Center(
                    child: Text(
                      "查找中..",
                      style: TextStyle(fontSize: 17.sp),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xffeeeeee),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 50.r,
                          height: 50.r,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                    "$searchKeyIndex/${progressKeyList.length}"),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                    width: 50.r,
                                    height: 50.r,
                                    child: const CircularProgressIndicator()),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 40.h,
                        child: OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff384c70)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13.0))),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            // return false;
                            if (progressstate) {
                              sendCmd([cncBtSmd.resume, 0, 0]);
                              progressstate = false;
                            } else {
                              sendCmd([cncBtSmd.pause, 0, 0]);
                              progressstate = true;
                            }

                            setState(() {});
                          },
                          child: Text(
                            progressstate ? "继续" : "暂停",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      progressstate
                          ? SizedBox(
                              width: 20.w,
                            )
                          : const SizedBox(),
                      progressstate
                          ? Expanded(
                              child: SizedBox(
                              height: 40.h,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xff384c70)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13.0))),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero)),
                                onPressed: () {
                                  sendCmd([cncBtSmd.stop, 0, 0]);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  S.of(context).stop,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ))
                          : const SizedBox(),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//根据state决定显示的内容
  Widget statewidget(context) {
    //print(keyclassid.length ~/ 2 + keyclassid.length % 2);
    //print(keyclassid.length);
    switch (state) {
      case 0: //选择钥匙类型
        return ListView.builder(
            itemCount: keyclassid.length ~/ 2 + keyclassid.length % 2,
            itemBuilder: (context, index) {
              return keyclass(context, index);
            });
      case 1: //选择使用定位方式
        return ListView(
          children: keylocate(),
        );
      case 2: //选择边
        return ListView(
          children: keyfixture(),
        );

      case 3: //读码切削页面
        keytitle = getKeyClass(keydata["class"])["name"];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 25,
                child: Text(
                  keytitle,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: progressKeyList.length,
                    itemBuilder: (context, index) {
                      return showkeydata(context, index);
                    })),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        child: const Text("查找"),
                        onPressed: () {
                          searchKeyIndex = 0;
                          if (progressKeyList.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return const MyTextDialog("无此类型的钥匙!");
                                });
                          } else {
                            baseKey.initdata(progressKeyList[searchKeyIndex]);
                            previewstate = false;
                            keydata["cnname"] = keytitle;
                            Navigator.pushNamed(context, '/openclamp',
                                arguments: {
                                  "keydata": progressKeyList[searchKeyIndex],
                                  "state": false,
                                }).then((value) {
                              // //print("查找中...");
                              if (value == true) {
                                sendCmd([cncBtSmd.cncState, 0, 0]);
                                cncbusystate = eventBus
                                    .on<CNCStateEvent>()
                                    .listen((CNCStateEvent event) {
                                  cncbusystate.cancel();
                                  if (event.state) {
                                    Fluttertoast.showToast(msg: "机器忙,请稍后再试");
                                  } else {
                                    sendSearchCmd(searchKeyIndex);
                                    Navigator.pushNamed(context, "/cncworking");
                                    // showDialog(
                                    //     barrierDismissible: false,
                                    //     context: context,
                                    //     builder: (c) {
                                    //       return processdatashow(context);
                                    //     });
                                  }
                                });
                              }
                              // baseKey.initdata(keydata, 0);
                              // List<int> temp = [];
                              // ////print(keydata);
                              // temp.add(cncBtSmd.COPYKEYREAD);
                              // temp.add(0);
                              // temp.addAll(baseKey.creatkeydata(0));
                              // sendCmd(temp);
                              // Navigator.pushNamed(context, '/cncworking')
                              //     .then((value) {
                              //   debugPrint("复制完成");
                              //   currentnum = 0;
                              //   ahNum = [];
                              //   bhNum = [];
                              //   sendCmd([0x9f, 10, 0]);
                              //   // pd.show(max: 100, msg: "查找中....");
                              // });
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
          height: double.maxFinite,
          width: double.maxFinite,
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
          switch (keydata["class"]) {
            case 0: //平铣双边
            case 1: //平铣单边
            case 2: //立铣内沟双边
            case 4: //立铣外沟双边
              if (state == 2) {
                state = 1;
              }
              break;
          }
          setState(() {});
          return false;
        }
      },
      child: Scaffold(
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
                switch (keydata["class"]) {
                  case 0: //平铣双边
                  case 1: //平铣单边
                  case 2: //立铣内沟双边
                  case 4: //立铣外沟双边
                    if (state == 2) {
                      state = 1;
                    }
                    break;
                }
                setState(() {});
              }
            },
            color: Colors.black,
            icon: SizedBox(
                width: 24.r,
                height: 20.r,
                child: Image.asset(
                  "image/share/Icon_back.png",
                  fit: BoxFit.cover,
                )),
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
              icon: SizedBox(
                  width: 24.r,
                  height: 20.r,
                  child: Image.asset(
                    "image/share/Icon_home.png",
                    fit: BoxFit.cover,
                  )),
            )
          ],
        ),
        body: statewidget(context),
      ),
    );
  }
}
