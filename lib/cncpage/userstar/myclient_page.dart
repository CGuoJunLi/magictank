import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/main.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../../appdata.dart';

class ClientPage extends StatelessWidget {
  const ClientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const ClientP(),
    );
  }
}

class ClientP extends StatefulWidget {
  const ClientP({Key? key}) : super(key: key);

  @override
  State<ClientP> createState() => _ClientPState();
}

class _ClientPState extends State<ClientP> {
  late ProgressDialog pd;

  ///客户资料 钥匙数据为ID
  // List myclientlist = [];

  ///将钥匙数据增加进去
  List originallist = [];

  ///显示的列表
  List showlist = [];

  bool edit = false;
  late FocusNode _focusNode;
  @override
  void initState() {
    _focusNode = FocusNode();
    showlist = [];
    loaddata();
    pd = ProgressDialog(context: context);
    super.initState();
  }

  Future<void> loaddata() async {
    //  myclientlist = [];
    originallist = [];
    originallist = await appData.getClient();
    //keylist.reversed;

    showlist = List.from(originallist);
    showlist.sort((a, b) => b['timer'].compareTo(a['timer']));
    print(showlist.length);
    setState(() {});
  }

  Map<String, dynamic> getkeydata(Map clientdata) {
    int keyid = clientdata["keyid"];
    int type = 1;
    if (clientdata["type"] != null) {
      type = clientdata["type"];
    }

    switch (type) {
      case 4: //自定义钥匙数据
        try {
          if (clientdata["keydata"] != null) {
            if (clientdata["keydata"].isEmpty) {
              debugPrint("keydata is empty");
              return {};
            } else {
              return json.decode(clientdata["keydata"]);
            }
          } else {
            debugPrint("keydata key is not");
            return {};
          }
        } catch (e) {
          return {};
        }

      case 1:
        var temp = appData.carkeyList.where((r) {
          return r["id"] == keyid ? true : false;
        });
        if (temp.isNotEmpty) {
          return temp.toList()[0];
        }
        return {};
      case 2:
        var temp = appData.civilkeyList.where((r) {
          return r["id"] == keyid ? true : false;
        });
        if (temp.isNotEmpty) {
          return temp.toList()[0];
        }
        return {};
      case 3:
        var temp = appData.motorkeyList.where((r) {
          return r["id"] == keyid ? true : false;
        });
        if (temp.isNotEmpty) {
          return temp.toList()[0];
        }
        return {};
      default:
        print("未知");
        var temp = appData.carkeyList.where((r) {
          return r["id"] == keyid ? true : false;
        });
        return temp.toList()[0];
    }
  }

  Future<void> delclient(Map<String, dynamic> data) async {
    // try {
    var result = await Api.delUserClient(data);
    if (result["state"]) {
      //print("服务器删除成功");
      await appData.deleClient(data);
      //print("数据库删除成功");
    } else {
      data["state"] = 3;
      await appData.updateClient(data);
    }
    // } catch (e) {
    //   //printe);
    //   data["state"] = 3;
    //   await appData.updateClient(data);
    //   ////print(e);
    //   debugPrint("删除失败");
    // }
    loaddata();
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
        return "圆棍钥匙";
      default:
        return "未知";
    }
  }

  List<Widget> showkeydata() {
    List<Widget> temp = [];
    for (var i = 0; i < showlist.length; i++) {
      if (showlist[i]["keyid"] != null && showlist[i]["state"] != 3) {
        Map keydata = getkeydata(showlist[i]);
        if (keydata.isNotEmpty) {
          temp.add(TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Container(
              width: 342.w,
              height: 230.r,
              margin: EdgeInsets.only(top: 10.r),
              padding: EdgeInsets.only(left: 10.r, top: 5.r, right: 10.r),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 161.w,
                        height: 90.w,
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
                                    keydata["cnname"],
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  keydata["keynumbet"] == ""
                                      ? ""
                                      : "（" + keydata["keynumbet"] + "）",
                                  style: TextStyle(
                                      fontSize: 10.sp, color: Colors.red),
                                ),
                                const Expanded(child: SizedBox())
                              ],
                            ),
                            SizedBox(
                                width: 138.w,
                                height: 38.h,
                                child: Image.file(
                                  File(appData.keyImagePath +
                                      "/key/" +
                                      keydata["picname"]),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: 161.w,
                          height: 90.w,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      _gettooth(keydata) +
                                          S.of(context).keycuts,
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.black),
                                    ),
                                    Text(
                                      getkeylength(keydata),
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.black),
                                    ),
                                    Text(
                                      keydata["locat"].toString() == "0"
                                          ? (S.of(context).keyloact +
                                              ":" +
                                              S.of(context).keylocat0)
                                          : (S.of(context).keyloact +
                                              ":" +
                                              S.of(context).keylocat1),
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.black),
                                    ),
                                    Text(
                                      getkeyclass(keydata) +
                                          (showlist[i]["type"] == 5
                                              ? "(非导电)"
                                              : ""),
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              edit
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
                                                        "注意删除后不可恢复!");
                                                  }).then((value) async {
                                                if (value) {
                                                  if (value) {
                                                    await delclient(
                                                        Map.from(showlist[i]));
                                                  }
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
                                                  color:
                                                      const Color(0xff384c70),
                                                  width: 1.w)),
                                          child: TextButton(
                                              style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          EdgeInsets.zero)),
                                              child:
                                                  Text(S.of(context).editdata),
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                        "/myclientedit",
                                                        arguments: showlist[i])
                                                    .then((value) {
                                                  loaddata();
                                                  setState(() {});
                                                });
                                              }),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 22.h,
                    width: 332.w,
                    child: Text(
                      (keydata["chnote"] != "无" && keydata["chnote"] != "null")
                          ? S.of(context).note + ":" + keydata["chnote"]
                          : "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 10.sp,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Text("齿号：" + showlist[i]["bitting"]),
                  Text("时间：" + showlist[i]["timer"]),
                  Text("名称:" + showlist[i]["name"]),
                  Text("手机号:" + showlist[i]["phone"]),
                  Text("车牌号:" + showlist[i]["carnum"]),
                ],
              ),
            ),
            onPressed: () {
              ////print(showlist[i]);
              //传入钥匙数据即可
              //先显示操作说明
              bool isnonconductive = false;
              if (showlist[i]["type"] == 5) {
                isnonconductive = true;
              }
              baseKey.setcarname("");
              if (keydata["smart"] != null) {
                //如果 ID大于10000小于15000 并且keydata["smart"] 为true 那么当前钥匙只有smart属性
                if (keydata["id"] > 10000 &&
                    keydata["id"] < 15000 &&
                    keydata["smart"]) {
                  baseKey.initdata(keydata, isSmartKey: true);

                  Navigator.pushNamed(context, '/openclamp', arguments: {
                    "keydata": keydata,
                    "state": 0,
                    "type": showlist[i]["type"],
                    "bitting": showlist[i]["bitting"],
                  });
                } else {
                  if (keydata["smart"] && !isnonconductive) {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return Material(
                            type: MaterialType.transparency,
                            child: Center(
                              child: Container(
                                width: 300.w,
                                height: 400.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.w,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(13.0))),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.w,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(13.0))),
                                      height: 50.h,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "选择钥匙类型",
                                              style: TextStyle(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: const Color(0xffeeeeee),
                                        child: Column(
                                          children: [
                                            const Text("普通钥匙"),
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () {
                                                  baseKey.initdata(keydata);
                                                  Navigator.pushNamed(
                                                      context, '/openclamp',
                                                      arguments: {
                                                        "keydata": keydata,
                                                        "state": 0,
                                                        "type": showlist[i]
                                                            ["type"],
                                                        "bitting": showlist[i]
                                                            ["bitting"],
                                                      });
                                                },
                                                child: SizedBox(
                                                  width: 254.w,
                                                  height: 181.w,
                                                  child: Image.asset(
                                                      "image/tank/issmart2.png"),
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                            // VerticalDivider(),
                                            const Text("智能卡类型"),
                                            Expanded(
                                                child: TextButton(
                                              onPressed: () {
                                                baseKey.initdata(keydata,
                                                    isSmartKey: true);
                                                Navigator.pushNamed(
                                                    context, '/openclamp',
                                                    arguments: {
                                                      "keydata": keydata,
                                                      "state": 0,
                                                      "type": showlist[i]
                                                          ["type"],
                                                      "bitting": showlist[i]
                                                          ["bitting"],
                                                    });
                                              },
                                              child: SizedBox(
                                                width: 254.w,
                                                height: 181.w,
                                                child: Image.asset(
                                                    "image/tank/issmart.png"),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 5.h, bottom: 5.h),
                                        width: 150.w,
                                        height: 40.h,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13.0))),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xff384c70))),
                                          onPressed: () {
                                            Navigator.pop(context, 0);
                                            // return false;
                                          },
                                          child: Text(
                                            S.of(context).cancel,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    //HU66夹具选择
                    if (keydata["fixture"].length == 2 &&
                        keydata["fixture"][0] == 7 &&
                        !isnonconductive) {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return Material(
                              type: MaterialType.transparency,
                              child: Center(
                                child: Container(
                                  width: 300.w,
                                  height: 400.w,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.w,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(13.0))),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.w,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(13.0))),
                                        height: 50.h,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "选择装夹方式:",
                                                style: TextStyle(
                                                    fontSize: 17.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: const Color(0xffeeeeee),
                                          child: Column(
                                            children: [
                                              const Text("装夹方式1:"),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () {
                                                    baseKey.initdata(keydata);
                                                    baseKey.fixture =
                                                        keydata["fixture"][0];
                                                    Navigator.pushNamed(
                                                        context, '/openclamp',
                                                        arguments: {
                                                          "keydata": keydata,
                                                          "state": 0,
                                                          "type": showlist[i]
                                                              ["type"],
                                                          "bitting": showlist[i]
                                                              ["bitting"],
                                                        });
                                                  },
                                                  child: SizedBox(
                                                    width: 254.w,
                                                    height: 181.w,
                                                    child: Image.file(File(appData
                                                            .keyImagePath +
                                                        "/fixture/${cncVersion.fixtureType == 21 ? 1 : 0}_7_0_${cncVersion.fixtureType == 21 ? 3 : 2}.png")),
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                              // VerticalDivider(),
                                              const Text("装夹方式2:"),
                                              Expanded(
                                                  child: TextButton(
                                                onPressed: () {
                                                  baseKey.initdata(
                                                    keydata,
                                                  );
                                                  baseKey.fixture =
                                                      keydata["fixture"][1];
                                                  Navigator.pushNamed(
                                                      context, '/openclamp',
                                                      arguments: {
                                                        "keydata": keydata,
                                                        "state": 0,
                                                        "type": showlist[i]
                                                            ["type"],
                                                        "bitting": showlist[i]
                                                            ["bitting"],
                                                      });
                                                },
                                                child: SizedBox(
                                                  width: 254.w,
                                                  height: 181.w,
                                                  child: Image.file(File(appData
                                                          .keyImagePath +
                                                      "/fixture/${cncVersion.fixtureType == 21 ? 1 : 0}_8_0_${cncVersion.fixtureType == 21 ? 3 : 2}.png")),
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50.h,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 5.h, bottom: 5.h),
                                          width: 150.w,
                                          height: 40.h,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        13.0))),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        const Color(
                                                            0xff384c70))),
                                            onPressed: () {
                                              Navigator.pop(context, 0);
                                              // return false;
                                            },
                                            child: Text(
                                              S.of(context).cancel,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      baseKey.initdata(keydata,
                          isNonConductiveKey: isnonconductive);
                      Navigator.pushNamed(context, '/openclamp', arguments: {
                        "keydata": keydata,
                        "state": 0,
                        "type": showlist[i]["type"],
                        "bitting": showlist[i]["bitting"],
                      });
                    }
                  }
                }
              } else {
                baseKey.initdata(keydata, isNonConductiveKey: isnonconductive);
                Navigator.pushNamed(context, '/openclamp', arguments: {
                  "keydata": keydata,
                  "state": 0,
                  "type": showlist[i]["type"],
                  "bitting": showlist[i]["bitting"],
                });
              }
              // Navigator.pushNamed(context, '/keyshow',
              // widget.arguments: {"keydata": showlist[i]});
            },
            onLongPress: () {},
          ));
        } else {
          print("showlist is 空");
        }
      }
    }
    return temp;
  }

  // List<Widget> showkeydataold() {
  //   List<Widget> temp = [];
  //   for (var i = 0; i < showlist.length; i++) {
  //     Map keydata = showlist[i]["keydata"];
  //     if (keydata.isNotEmpty) {
  //       temp.add(
  //         TextButton(
  //           style: ButtonStyle(
  //               padding: MaterialStateProperty.all(EdgeInsets.zero)),
  //           child: SizedBox(
  //             width: 341.w,
  //             height: 230.h,
  //             child: Card(
  //               child: Column(
  //                 children: [
  //                   SizedBox(
  //                     height: 11.h,
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: Column(
  //                           children: [
  //                             SizedBox(
  //                               height: 22.h,
  //                               child: Row(
  //                                 children: [
  //                                   SizedBox(
  //                                     width: 10.w,
  //                                   ),
  //                                   Text(
  //                                     keydata["cnname"],
  //                                     style: TextStyle(
  //                                         color: showlist[i]["state"] != 1
  //                                             ? Colors.red
  //                                             : Colors.black,
  //                                         fontSize: 17.sp,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                   const Expanded(child: SizedBox()),
  //                                   Text(
  //                                     keydata["keynumbet"] == ""
  //                                         ? ""
  //                                         : "（" + keydata["keynumbet"] + "）",
  //                                     style: TextStyle(
  //                                         fontSize: 10.sp, color: Colors.red),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             SizedBox(
  //                                 width: 138.w,
  //                                 height: 38.h,
  //                                 child: Image.file(
  //                                   File(appData.keyImagePath +
  //                                       "/key/" +
  //                                       keydata["picname"]),
  //                                 )),
  //                           ],
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: 23.w,
  //                       ),
  //                       Expanded(
  //                         child: Stack(
  //                           children: [
  //                             Align(
  //                               alignment: Alignment.topLeft,
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                     _gettooth(keydata) +
  //                                         S.of(context).keycuts,
  //                                     style: TextStyle(fontSize: 12.sp),
  //                                   ),
  //                                   SizedBox(
  //                                     height: 10.h,
  //                                   ),
  //                                   SizedBox(
  //                                     height: 10.h,
  //                                     child: Text(
  //                                       getkeylength(keydata),
  //                                       style: TextStyle(fontSize: 12.sp),
  //                                     ),
  //                                   ),
  //                                   SizedBox(
  //                                     height: 10.h,
  //                                   ),
  //                                   Text(
  //                                     keydata["locat"].toString() == "0"
  //                                         ? (S.of(context).keyloact +
  //                                             ":" +
  //                                             S.of(context).keylocat0)
  //                                         : (S.of(context).keyloact +
  //                                             ":" +
  //                                             S.of(context).keylocat1),
  //                                     style: TextStyle(fontSize: 12.sp),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             edit
  //                                 ? Align(
  //                                     alignment: Alignment.topRight,
  //                                     child: Column(
  //                                       children: [
  //                                         Container(
  //                                           width: 50.w,
  //                                           height: 20.h,
  //                                           decoration: BoxDecoration(
  //                                             color: Colors.red,
  //                                             borderRadius:
  //                                                 BorderRadius.circular(8),
  //                                           ),
  //                                           child: TextButton(
  //                                             style: ButtonStyle(
  //                                                 padding:
  //                                                     MaterialStateProperty.all(
  //                                                         EdgeInsets.zero)),
  //                                             onPressed: () {
  //                                               showDialog(
  //                                                   context: context,
  //                                                   builder: (c) {
  //                                                     return const MyTextDialog(
  //                                                         "是否删除？删除后不可恢复！");
  //                                                   }).then((value) async {
  //                                                 if (value) {
  //                                                   Map<String, dynamic> data =
  //                                                       Map.from(showlist[i]);

  //                                                   data.remove("keydata");
  //                                                   //print(showlist[i]);

  //                                                   await delclient(data);
  //                                                 }
  //                                               });
  //                                             },
  //                                             child: Text(S.of(context).del),
  //                                           ),
  //                                         ),
  //                                         SizedBox(
  //                                           height: 5.h,
  //                                         ),
  //                                         Container(
  //                                           width: 50.w,
  //                                           height: 20.h,
  //                                           decoration: BoxDecoration(
  //                                             color: Colors.red,
  //                                             borderRadius:
  //                                                 BorderRadius.circular(8),
  //                                           ),
  //                                           child: TextButton(
  //                                               style: ButtonStyle(
  //                                                   padding:
  //                                                       MaterialStateProperty
  //                                                           .all(EdgeInsets
  //                                                               .zero)),
  //                                               onPressed: () {
  //                                                 Navigator.pushNamed(context,
  //                                                         "/myclientedit",
  //                                                         arguments:
  //                                                             showlist[i])
  //                                                     .then((value) {
  //                                                   loaddata();
  //                                                   setState(() {});
  //                                                 });
  //                                               },
  //                                               child: Text(
  //                                                   S.of(context).editdata)),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   )
  //                                 : Container(),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 13.h,
  //                   ),
  //                   SizedBox(
  //                       height: 22.h,
  //                       width: 300.w,
  //                       child: Text("齿号：" + showlist[i]["bitting"])),
  //                   SizedBox(
  //                       height: 22.h,
  //                       width: 300.w,
  //                       child: Text("时间：" + showlist[i]["timer"])),
  //                   SizedBox(
  //                       height: 22.h,
  //                       width: 300.w,
  //                       child: Text("名称:" + showlist[i]["name"])),
  //                   SizedBox(
  //                       height: 22.h,
  //                       width: 300.w,
  //                       child: Text("手机号:" + showlist[i]["phone"])),
  //                   SizedBox(
  //                       height: 22.h,
  //                       width: 300.w,
  //                       child: Text("车牌号:" + showlist[i]["carnum"])),
  //                   SizedBox(
  //                     height: 22.h,
  //                     width: 300.w,
  //                     child: Text(
  //                       (keydata["chnote"] != "无" &&
  //                               keydata["chnote"] != "null")
  //                           ? S.of(context).note + ":" + keydata["chnote"]
  //                           : "",
  //                       textAlign: TextAlign.left,
  //                       style: TextStyle(
  //                           color: Colors.red,
  //                           fontSize: 10.sp,
  //                           overflow: TextOverflow.ellipsis),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           onPressed: () {
  //             //print(keydatalist[i]);
  //             //传入钥匙数据即可
  //             //先显示操作说明
  //             baseKey.initdata(keydata);
  //             Navigator.pushNamed(context, '/openclamp', arguments: {
  //               "keydata": keydata,
  //               "state": 0,
  //               "type": showlist[i]["type"],
  //               "bitting": showlist[i]["bitting"],
  //             });
  //             // Navigator.pushNamed(context, '/keyshow',
  //             // widget.arguments: {"keydata": keydatalist[i]});
  //           },
  //           onLongPress: () {},
  //         ),
  //       );
  //     }
  //   }
  //   return temp;
  // }

//同步服务器的数据
  Future<void> asyncServerDate() async {
    try {
      if (originallist.isEmpty) {
        debugPrint("服务器获得数据");
        List result = await Api.getUserClient("userid=${appData.id}");
        print(result);
        if (result.isNotEmpty) {
          for (var i = 0; i < result.length; i++) {
            result[i]["state"] = 1; //同步状态
            await appData.insertClient(result[i]);
          }
        }
      } else {
        for (var i = 0; i < originallist.length; i++) {
          switch (originallist[i]["state"]) {
            case 3:
              var data = await Api.delUserClient(originallist[i]);
              if (data["state"]) {
                await appData.deleClient(originallist[i]);
              }
              break;
            case 0:
              var data = await Api.upUserClient(originallist[i]);
              if (data["state"]) {
                await appData.deleClient(originallist[i]);
              }
              break;
            case 1:
              await appData.deleClient(originallist[i]);
              break;
            default:
              await appData.deleClient(originallist[i]);
              break;
          }
        }
        List result = await Api.getUserClient("userid=${appData.id}");
        ////print(result);
        if (result.isNotEmpty) {
          for (var i = 0; i < result.length; i++) {
            result[i]["state"] = 1; //同步状态
            await appData.insertClient(result[i]);
          }
        }
      }
      pd.close();
      await loaddata();
    } catch (e) {
      pd.close();
      showDialog(
          context: context,
          builder: (c) {
            return const MyTextDialog("同步失败");
          });
    }
  }

  void _search(String text) {
    showlist = [];
    if (text.isEmpty) {
      //debugPrint("空");
      showlist = List.from(originallist);
    } else {
      List list = originallist.where((v) {
        //  ////print(v["cnname"].toLowerCase().contains(text.toLowerCase()));

        if (locales!.languageCode == "zh") {
          return (v["name"] +
                  v["phone"] +
                  v["carnum"] +
                  v["timer"].replaceAll("-", "") +
                  v["keydata"]["cnname"])
              .toLowerCase()
              .contains(text.toLowerCase());
        } else {
          return (v["name"] +
                  v["phone"] +
                  v["carnum"] +
                  v["timer"].replaceAll("-", "") +
                  v["keydata"]["enname"])
              .toLowerCase()
              .contains(text.toLowerCase());
        }
      }).toList();
      if (list.isNotEmpty) {
        showlist = List.from(list);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          height: 48.h,
          child: Stack(
            children: [
              Align(
                child: Text(
                  S.of(context).selekey,
                  style: TextStyle(fontSize: 17.sp),
                ),
                alignment: Alignment.centerLeft,
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
                      edit ? S.of(context).okbt : S.of(context).editdata,
                      style: TextStyle(fontSize: 15.sp, color: Colors.black),
                    ),
                    onPressed: () {
                      edit = !edit;
                      //print(edit);
                      setState(() {});
                    },
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
        ),
        Container(
          height: 5.h,
          color: const Color(0xffdde2ea),
        ),
        Container(
          width: double.maxFinite,
          height: 28.h,
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  //   inputFormatters: [
                  //  //RegExp accountRegExp = RegExp(r'[A-Za-z0-9_]+'); //数字和和字母组成
                  //     FilteringTextInputFormatter(accountRegExp, allow: true),
                  //   ],
                  focusNode: _focusNode,
                  onChanged: (instring) {
                    _search(instring);
                  },
                  style: TextStyle(fontSize: 12.sp),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.search,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      borderSide: BorderSide(color: Color(0xff384c70)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      borderSide: BorderSide(color: Color(0xff384c70)),
                    ),
                    hintText: S.of(context).inputkeyname,
                    contentPadding: const EdgeInsets.only(bottom: 0),
                    hintStyle: TextStyle(fontSize: 12.sp),
                    // border: OutlineInputBorder(
                    //   borderRadius: const BorderRadius.all(
                    //     Radius.circular(4.0),
                    //   ),
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: showkeydata(),
          ),
        ),
        SizedBox(
          // color: Colors.blue,
          width: double.maxFinite,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff384c70))),
            child: const Text(
              "同步服务器的数据",
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const MyTextDialog("是否同步数据?");
                  }).then((value) async {
                if (value) {
                  pd.show(max: 100, msg: "同步中");
                  await asyncServerDate();
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
