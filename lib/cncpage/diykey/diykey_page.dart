import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/basekey.dart';

import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/main.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class DiyKeyPage extends StatefulWidget {
  const DiyKeyPage({Key? key}) : super(key: key);

  @override
  _DiyKeyPageState createState() => _DiyKeyPageState();
}

class _DiyKeyPageState extends State<DiyKeyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const DiyKey(),
    );
  }
}

class DiyKey extends StatefulWidget {
  const DiyKey({Key? key}) : super(key: key);

  @override
  _DiyKeyState createState() => _DiyKeyState();
}

class _DiyKeyState extends State<DiyKey> with RouteAware {
  late ProgressDialog pd;
  bool removestate = false;
  List orignllist = [];
  List showlist = [];
  @override
  void initState() {
    super.initState();
    loaddata();
    // eventBus.on<UpdatEvent>().listen((event) {
    //   //重新加载一次数据
    //   print("重新加载一次数据");
    //   loaddata();
    //   setState(() {});
    // });
    pd = ProgressDialog(context: context);
  }

  ///加载数据
  Future<void> loaddata() async {
    orignllist = await appData.getUserKey();
    showlist = List.from(orignllist);
    //print(keydatalist.length);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    loaddata();
    setState(() {});
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // void didPush() {
  //   debugPrint("didPush ${runtimeType}");
  // }

  // void didPop() {
  //   debugPrint("didPop ${runtimeType}");
  // }

  // void didPushNext() {
  //   debugPrint("didPushNext ${runtimeType}");
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   DynamicTheme.routeObserver.subscribe(this, ModalRoute.of(context));
  // }

  // @override
  // void didPopNext() {
  //   // Covering route was popped off the navigator.
  //   super.didPopNext();
  //   print('返回NewView');
  // }

  ///同步服务器的数据
  Future<void> asyncServerData() async {
    try {
      if (orignllist.isEmpty) {
        List result = await Api.getUserKey("userid=${appData.id}");

        if (result.isNotEmpty) {
          for (var i = 0; i < result.length; i++) {
            result[i]["state"] = 1; //同步状态
            await appData.insertUserKey(result[i]);
          }
        }
      } else {
        for (var i = 0; i < orignllist.length; i++) {
          switch (orignllist[i]["state"]) {
            case 3:
              var data = await Api.delUserKey(orignllist[i]);
              if (data["state"]) {
                await appData.deleUserKey(orignllist[i]["id"].toString());
              }
              break;
            case 0:
              var data = await Api.upUserKey(orignllist[i]);
              if (data["state"]) {
                await appData.deleUserKey(orignllist[i]["id"].toString());
              }
              break;
            case 1:
              await appData.deleUserKey(orignllist[i]["id"].toString());
              break;
            default:
              await Api.delUserKey(orignllist[i]);
              await appData.deleUserKey(orignllist[i]["id"].toString());
              break;
          }
        }
        List result = await Api.getUserKey("userid=${appData.id}");
        ////print(result);
        if (result.isNotEmpty) {
          for (var i = 0; i < result.length; i++) {
            result[i]["state"] = 1; //同步状态
            await appData.insertUserKey(result[i]);
          }
        }
      }
      pd.close();
      loaddata();
    } catch (e) {
      pd.close();
      showDialog(
          context: context,
          builder: (c) {
            return MyTextDialog(S.of(context).asyncerror);
          });
    }
    showlist = List.from(orignllist);
  }

  ///共享数据
  Future<void> enSharedData(Map keydata, price) async {
    ////print(keydata);
    ////print(price);
    var data = {
      "userid": appData.id,
      "account": appData.account,
      "username": appData.username,
      "timer": keydata["timer"],
      "data": keydata["data"],
      "price": price,
    };
    try {
      var result = await Api.upSharedKey(data);
      ////print(result);
      if (result["state"]) {
        await appData.sharedUserKey(keydata["id"].toString(), "true");
        Fluttertoast.showToast(msg: S.of(context).shareok);
      } else {
        Fluttertoast.showToast(msg: S.of(context).shareerror);
      }
      pd.close();
    } catch (e) {
      pd.close();
      Fluttertoast.showToast(msg: S.of(context).shareerror);
    }

    loaddata();
  }

  ///关闭共享
  Future<void> disSharedData(keydata) async {
    var data = {
      "userid": appData.id,
      "username": appData.username,
      "timer": keydata["timer"],
      "data": keydata["data"],
    };
    try {
      var result = await Api.delSharedKey(data);

      if (result["state"]) {
        await appData.sharedUserKey(keydata["id"].toString(), "false");
        Fluttertoast.showToast(msg: S.of(context).shareclose);
      } else {
        Fluttertoast.showToast(msg: S.of(context).sharecloseerror);
      }

      ///pd.close();
    } catch (e) {
      //  pd.close();
      Fluttertoast.showToast(msg: S.of(context).sharecloseerror);
    }
    loaddata();
  }

  ///删除数据
  Future<void> delKeyData(keydata) async {
    try {
      if (keydata["shared"] == "true") {
        await disSharedData(keydata); //先关闭共享
        print("关闭成功");
      }
      var result = await Api.delUserKey(keydata);
      if (result["state"]) {
        await appData.deleUserKey(keydata["id"].toString());
      } else {
        await appData.updateUserKey(keydata["id"].toString(), 3);
      }
    } catch (e) {
      await appData.updateUserKey(keydata["id"].toString(), 3);
    }
    loaddata();
  }

  String _gettooth(Map keydata) {
    int sideAtooth = 0;
    int sideBtooth = 0;
    List<int> temp = [];
    temp = List.from(keydata["toothSA"]);
    sideAtooth = temp.toSet().toList().length;
    temp = List.from(keydata["toothSB"]);
    sideBtooth = temp.toSet().toList().length;
    if (keydata["side"] == 3 && keydata["class"] != 0) {
      return "$sideAtooth-$sideBtooth";
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

  String getkeyclass(Map keydata) {
    switch (keydata["class"]) {
      case 0:
        if (keydata["fixture"][0] == 1) {
          return S.of(context).keyclass6;
        } else {
          return S.of(context).keyclass0;
        }
      case 1:
        return S.of(context).keyclass1;
      case 2:
        return S.of(context).keyclass2;
      case 3:
        if (keydata["fixture"][0] == 1) {
          return S.of(context).keyclass7;
        } else {
          return S.of(context).keyclass3;
        }
      case 4:
        return S.of(context).keyclass4;
      case 5:
      case 13:
        return S.of(context).keyclass5;
      case 7:
        return S.of(context).keyclass8;
      default:
        return "未知";
    }
  }

  List<Widget> keyListView() {
    List<Widget> temp = [];
    for (var i = 0; i < showlist.length; i++) {
      if (showlist[i]["state"] != null &&
          showlist[i]["state"].toString() != "3") {
        var keydata = json.decode(showlist[i]["data"]);
        temp.add(
          TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            child: Container(
              padding: EdgeInsets.only(left: 10.r, top: 5.r, right: 10.r),
              width: 342.w,
              height: 130.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 161.w,
                        height: 90.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 22.h,
                              child: Text(
                                keydata["cnname"],
                                style: TextStyle(
                                    color: showlist[i]["state"] != 1
                                        ? Colors.red
                                        : Colors.black,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              keydata["keynumbet"] == ""
                                  ? ""
                                  : S.of(context).keynumber +
                                      ":" +
                                      keydata["keynumbet"] +
                                      "",
                              style:
                                  TextStyle(fontSize: 10.sp, color: Colors.red),
                            ),
                            SizedBox(
                              width: 138.w,
                              height: 38.h,
                              child: Image.file(
                                File(appData.keyImagePath +
                                    "/key/" +
                                    keydata["picname"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 161.w,
                        height: 90.w,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    _gettooth(keydata) + S.of(context).keycuts,
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                    child: Text(
                                      getkeylength(keydata),
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                  Text(
                                    keydata["locat"].toString() == "0"
                                        ? (S.of(context).keyloact +
                                            ":" +
                                            S.of(context).keylocat0)
                                        : (S.of(context).keyloact +
                                            ":" +
                                            S.of(context).keylocat1),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  Text(
                                    getkeyclass(keydata),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),
                            removestate
                                ? Column(
                                    children: [
                                      Container(
                                        width: 50.w,
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: TextButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.zero)),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (c) {
                                                  return MyTextDialog(
                                                      S.of(context).deltip);
                                                }).then((value) async {
                                              if (value) {
                                                print(showlist[i]);

                                                await delKeyData(showlist[i]);
                                              }
                                            });
                                          },
                                          child: Text(S.of(context).del),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Container(
                                        width: 50.w,
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: const Color(0xff384c70),
                                                width: 1.w)),
                                        child: TextButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.zero)),
                                          onPressed: () {
                                            // print(appData.limit);
                                            // print(keydatalist[i]);
                                            if (showlist[i]["use"].toString() ==
                                                    "true" ||
                                                appData.limit == 10) {
                                              if (showlist[i]["shared"] ==
                                                  "true") {
                                                showDialog(
                                                    context: context,
                                                    builder: (c) {
                                                      return MyTextDialog(S
                                                          .of(context)
                                                          .shareclosetip);
                                                    }).then((value) async {
                                                  if (value) {
                                                    await disSharedData(
                                                        showlist[i]);
                                                  }
                                                });
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (c) {
                                                      return MyTextDialog(S
                                                          .of(context)
                                                          .sharetip);
                                                    }).then((value) {
                                                  if (value) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (c) {
                                                          return MychangDialog(
                                                              0,
                                                              title: S
                                                                  .of(context)
                                                                  .settoken);
                                                        }).then((value) async {
                                                      if (value["state"]) {
                                                        if (value["value"] <=
                                                            1000) {
                                                          await enSharedData(
                                                              showlist[i],
                                                              value["value"]);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg: S
                                                                  .of(context)
                                                                  .tokenerror);
                                                        }
                                                      }
                                                    });
                                                  }
                                                });
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (c) {
                                                    return MyTextDialog(S
                                                        .of(context)
                                                        .sharetip2);
                                                  });
                                            }
                                          },
                                          child: Text(
                                              showlist[i]["shared"] == "true"
                                                  ? S.of(context).sharestate1
                                                  : S.of(context).sharestate2),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Container(
                                        width: 50.w,
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: const Color(0xff384c70),
                                                width: 1.w)),
                                        child: TextButton(
                                            style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.zero)),
                                            child: Text(S.of(context).editdata),
                                            onPressed: () {
                                              if (showlist[i]["shared"]
                                                      .toString() ==
                                                  "true") {
                                                showDialog(
                                                    context: context,
                                                    builder: (c) {
                                                      return MyTextDialog(S
                                                          .of(context)
                                                          .needcloseshare);
                                                    });
                                              } else {
                                                Navigator.pushNamed(context,
                                                        "/changekeydata",
                                                        arguments: showlist[i])
                                                    .then((value) {
                                                  loaddata();
                                                });
                                              }
                                            }),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 332.w,
                    height: 20.w,
                    child: Text(
                      (keydata["chnote"] != "无" && keydata["chnote"] != "null")
                          ? S.of(context).note + ":" + keydata["chnote"]
                          : "",
                      // textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 10.sp,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              //print(keydata);
              //传入钥匙数据即可
              //先显示操作说明
              baseKey.initdata(keydata);
              baseKey.diykeysqlid = Map.from(showlist[i]);
              // showDialog(
              //     context: context,
              //     builder: (c) {
              //       return OpenClampPage({"keydata": keydata, "state": 0});
              //     }).then((value) {
              //       print("object");
              //     });
              Navigator.pushNamed(context, '/openclamp',
                  arguments: {"keydata": keydata, "state": 0, "type": 4});
              // Navigator.pushNamed(context, '/keyshow',
              // widget.arguments: {"keydata": keydatalist[i]});
            },
            onLongPress: () {},
          ),
        );
        temp.add(SizedBox(
          height: 5.r,
        ));
      }
    }
    return temp;
  }

  void _search(String text) {
    showlist = [];
    if (text.isEmpty) {
      //debugPrint("空");
      showlist = List.from(orignllist);
    } else {
      List list = orignllist.where((v) {
        var keydata = json.decode(v["data"]);
        return (keydata["cnname"].toString())
            .toLowerCase()
            .contains(text.toLowerCase());
      }).toList();
      if (list.isNotEmpty) {
        showlist = List.from(list);
      }
    }
    print(showlist);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          padding: EdgeInsets.all(10.r),
          height: 68.h,
          child: Stack(
            children: [
              Align(
                child: Text(
                  S.of(context).selekey,
                  style: TextStyle(fontSize: 17.sp),
                ),
                alignment: Alignment.topLeft,
              ),
              Align(
                child: Container(
                  width: 80.w,
                  height: 23.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xff384c70))),
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Text(
                      removestate ? S.of(context).okbt : S.of(context).editdata,
                      style: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      removestate = !removestate;
                      //print(removestate);
                      setState(() {});
                    },
                  ),
                ),
                alignment: Alignment.topRight,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: double.maxFinite,
                    height: 28.r,
                    //margin: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5.r)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            onChanged: ((value) {
                              _search(value);
                            }),
                          ),
                        ),
                        Icon(Icons.search)
                      ],
                    )),
              ),
            ],
          ),
        ),
        Container(
          height: 5.h,
          color: const Color(0xffdde2ea),
        ),
        Expanded(
            child: ListView(
          children: keyListView(),
        )),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100.w,
                height: 40.h,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff384c70))),
                  child: Text(S.of(context).createkey),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return MySeleDialog(
                            [
                              S.of(context).measurekey,
                              S.of(context).smartcreatekey,
                              "图片创建钥匙"
                            ],
                            title: S.of(context).createkey,
                          );
                        }).then((value) {
                      switch (value) {
                        case 1:
                          Navigator.pushNamed(context, '/diykeystep',
                                  arguments: false)
                              .then((value) {
                            loaddata();
                          });
                          break;
                        case 2:
                          Navigator.pushNamed(context, "/smartdiy",
                                  arguments: true)
                              .then((value) {
                            loaddata();
                          });
                          break;
                        case 3:
                          Navigator.pushNamed(context, "/photodiy",
                                  arguments: true)
                              .then((value) {
                            loaddata();
                          });
                          break;
                        default:
                          break;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 40.h,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff384c70))),
                  child: Text(S.of(context).asyncbt),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return MyTextDialog(S.of(context).asyncbt);
                        }).then((value) async {
                      if (value) {
                        pd.show(max: 100, msg: S.of(context).asyncing);
                        await asyncServerData();
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 40.h,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff384c70))),
                  child: Text(S.of(context).sharesmart),
                  onPressed: () {
                    Navigator.pushNamed(context, "/diykeymarket").then((value) {
                      loaddata();
                    });
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
