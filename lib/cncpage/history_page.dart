import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/cncpage/basekey.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:magictank/http/api.dart';
import '../appdata.dart';
import 'bluecmd/receivecmd.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const HistoryP(),
    );
  }
}

class HistoryP extends StatefulWidget {
  const HistoryP({Key? key}) : super(key: key);

  @override
  State<HistoryP> createState() => _HistoryPState();
}

class _HistoryPState extends State<HistoryP> {
  late ProgressDialog pd;
  List<Map<String, dynamic>> keydatalist = [];
  bool removestate = false;
  String customerphone = "";
  String customercarnum = "";
  String customername = "";

  Map getkeydata(Map keydata) {
    // var temps = [];
    int keyid = keydata["keyid"];
    int type = 1;
    if (keydata["type"] != null) {
      type = keydata["type"];
    }

    switch (type) {
      case 4: //自定义钥匙数据
        try {
          if (keydata["keydata"] != null) {
            if (keydata["keydata"].isEmpty) {
              return {};
            } else {
              return json.decode(keydata["keydata"]);
            }
          } else {
            return {};
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "msg1");
          return {};
        }
      case 1:
        try {
          var temp = appData.carkeyList.where((r) {
            return r["id"] == keyid ? true : false;
          });
          if (temp.isNotEmpty) {
            return temp.toList()[0];
          } else {
            return {};
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "msg2");
          return {};
        }
      case 2:
        try {
          var temp = appData.civilkeyList.where((r) {
            return r["id"] == keyid ? true : false;
          });
          if (temp.isNotEmpty) {
            return temp.toList()[0];
          } else {
            return {};
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "msg3");
          return {};
        }
      case 3:
        try {
          var temp = appData.motorkeyList.where((r) {
            return r["id"] == keyid ? true : false;
          });
          if (temp.isNotEmpty) {
            return temp.toList()[0];
          } else {
            return {};
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "msg4");
          return {};
        }
      default:
        try {
          var temp = appData.carkeyList.where((r) {
            return r["id"] == keyid ? true : false;
          });
          if (temp.isNotEmpty) {
            return temp.toList()[0];
          } else {
            return {};
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "msg5");
          return {};
        }
    }
  }

  Future<void> delhisotry(Map<String, dynamic> data) async {
    try {
      var result = await Api.delUserHistory(data);
      //printresult);
      if (result["state"]) {
        await appData.deleHistory(data);
      } else {
        data["state"] = 3;
        await appData.updateHistory(data);
      }
    } catch (e) {
      //printe);
      data["state"] = 3;
      await appData.updateHistory(data);
      ////print(e);

    }
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
        return S.of(context).keyclass8;
      default:
        return "NULL";
    }
  }

  List<Widget> showkeydata() {
    List<Widget> temp = [];
    for (var i = 0; i < keydatalist.length; i++) {
      if (keydatalist[i]["keyid"] != null && keydatalist[i]["state"] != 3) {
        Map keydata = getkeydata(keydatalist[i]);
        if (keydata.isNotEmpty) {
          temp.add(TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Container(
              width: 342.w,
              height: 170.r,
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
                                          (keydatalist[i]["type"] == 5
                                              ? "(${S.of(context).nondatabase})"
                                              : ""),
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.black),
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
                                                  await delhisotry(
                                                      keydatalist[i]);
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
                                                showDialog(
                                                    context: context,
                                                    builder: (c) {
                                                      return editCustomerData();
                                                    }).then((value) {
                                                  if (value) {
                                                    //上传客户资料

                                                    updateCustomerData(
                                                        keydatalist[i]);
                                                  }
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
                  Text("${S.of(context).keytoothcode}：" +
                      keydatalist[i]["bitting"]),
                  Text("${S.of(context).timershow}：" + keydatalist[i]["timer"]),
                ],
              ),
            ),
            onPressed: () {
              ////print(showlist[i]);
              //传入钥匙数据即可
              //先显示操作说明

              bool isnonconductive = false;
              if (keydatalist[i]["type"] == 5) {
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
                    "type": keydatalist[i]["type"],
                    "bitting": keydatalist[i]["bitting"],
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
                                              S.of(context).keyclass,
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
                                            Text(S.of(context).keytype0),
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () {
                                                  baseKey.initdata(keydata);
                                                  Navigator.pushNamed(
                                                      context, '/openclamp',
                                                      arguments: {
                                                        "keydata": keydata,
                                                        "state": 0,
                                                        "type": keydatalist[i]
                                                            ["type"],
                                                        "bitting":
                                                            keydatalist[i]
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
                                            Text(S.of(context).keytype1),
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
                                                      "type": keydatalist[i]
                                                          ["type"],
                                                      "bitting": keydatalist[i]
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
                                                S.of(context).seleclamp,
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
                                              Text(S.of(context).clamptype1),
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
                                                          "type": keydatalist[i]
                                                              ["type"],
                                                          "bitting":
                                                              keydatalist[i]
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
                                              Text(S.of(context).clamptype2),
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
                                                        "type": keydatalist[i]
                                                            ["type"],
                                                        "bitting":
                                                            keydatalist[i]
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
                        "type": keydatalist[i]["type"],
                        "bitting": keydatalist[i]["bitting"],
                      });
                    }
                  }
                }
              } else {
                baseKey.initdata(keydata, isNonConductiveKey: isnonconductive);
                Navigator.pushNamed(context, '/openclamp', arguments: {
                  "keydata": keydata,
                  "state": 0,
                  "type": keydatalist[i]["type"],
                  "bitting": keydatalist[i]["bitting"],
                });
              }
              // Navigator.pushNamed(context, '/keyshow',
              // widget.arguments: {"keydata": showlist[i]});
            },
            onLongPress: () {},
          ));
        }
      }
    }
    return temp;
  }

//上传客户资料
  Future<void> updateCustomerData(Map hiskeydata) async {
    print(hiskeydata["keydata"] is String);
    var data = {
      "timer": hiskeydata["timer"],
      "userid": hiskeydata["userid"],
      "keyid": hiskeydata["keyid"],
      "type": hiskeydata["type"],
      "bitting": hiskeydata["bitting"],
      "name": customername,
      "phone": customerphone,
      "carnum": customercarnum,
      "keydata": hiskeydata["keydata"],
      "state": 2,
    };
    print(data);
    try {
      var result = await Api.upUserClient(data);
      if (result["state"]) {
        data["state"] = 1;
        await appData.insertClient(data);
      } else {
        await appData.insertClient(data);
      }
      Fluttertoast.showToast(msg: S.of(context).saveok);
    } catch (e) {
      print(e);
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
                                  Navigator.pop(context, false);
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
                                  if (customerphone == "" &&
                                      customercarnum == "" &&
                                      customername == "") {
                                    Fluttertoast.showToast(
                                        msg: S.of(context).lestone);
                                  } else {
                                    Navigator.pop(context, true);
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

  @override
  void initState() {
    loaddata();
    super.initState();
    pd = ProgressDialog(context: context);
  }

  Future<void> loaddata() async {
    //返回
    var temp = await appData.getHistory();
    keydatalist = List.from(temp);

    keydatalist.sort((a, b) => b['timer'].compareTo(a['timer']));

    setState(() {});
  }

  Future<void> asyncServerDate() async {
    try {
      if (keydatalist.isEmpty) {
        List result = await Api.getUserHistory("userid=${appData.id}");

        if (result.isNotEmpty) {
          for (var i = 0; i < result.length; i++) {
            result[i]["state"] = 1; //同步状态
            await appData.insertHistory(result[i]);
          }
        }
      } else {
        for (var i = 0; i < keydatalist.length; i++) {
          switch (keydatalist[i]["state"]) {
            case 3:
              var data = await Api.delUserHistory(keydatalist[i]);
              if (data["state"]) {
                await appData.deleHistory(keydatalist[i]);
              }
              break;
            case 0:
              var data = await Api.upUserHistory(keydatalist[i]);
              if (data["state"]) {
                await appData.deleHistory(keydatalist[i]);
              }
              break;
            case 1:
              await appData.deleHistory(keydatalist[i]);
              break;
          }
        }
        List result = await Api.getUserHistory("userid=${appData.id}");
        ////print(result);
        if (result.isNotEmpty) {
          for (var i = 0; i < result.length; i++) {
            result[i]["state"] = 1; //同步状态
            await appData.insertHistory(result[i]);
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
                      removestate ? S.of(context).okbt : S.of(context).editdata,
                      style: TextStyle(fontSize: 15.sp, color: Colors.black),
                    ),
                    onPressed: () {
                      removestate = !removestate;
                      //print(removestate);
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
        Expanded(
          child: ListView(
            children: showkeydata(),
          ),
        ),
        SizedBox(
          // color: Colors.blue,
          width: double.maxFinite,
          child: OutlinedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff384c70))),
            child: Text(
              S.of(context).asyncbt,
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              pd.show(
                max: 100,
                msg: S.of(context).asyncing,
              );
              await asyncServerDate();
            },
          ),
        ),
      ],
    );
  }
}
