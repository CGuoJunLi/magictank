import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class GetCodeListPage extends StatefulWidget {
  final Map arguments;
  const GetCodeListPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  _GetCodeListPageState createState() => _GetCodeListPageState();
}

class _GetCodeListPageState extends State<GetCodeListPage> {
  late String carname;
  late String code;
  List<Map> getkeylist = [];

  @override
  void initState() {
    getkeylist = List.from(widget.arguments["data"]);

    super.initState();
  }

  Map getkeydata(int id) {
//通过ID获得钥匙数据
    for (var i = 0; i < appData.carkeyList.length; i++) {
      if (id == appData.carkeyList[i]["id"]) {
        return appData.carkeyList[i];
      }
    }
    for (var i = 0; i < appData.motorList.length; i++) {
      if (id == appData.motorList[i]["id"]) {
        return appData.motorList[i];
      }
    }
    for (var i = 0; i < appData.civilList.length; i++) {
      if (id == appData.civilList[i]["id"]) {
        return appData.civilList[i];
      }
    }
    return {};
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

  List<Widget> keylistview() {
    List<Widget> temp = [];
    for (var i = 0; i < getkeylist.length; i++) {
      Map keydata = getkeydata(int.parse(getkeylist[i]["keyid"]));
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
                color: Colors.white, borderRadius: BorderRadius.circular(5.r)),
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
                                    : "(" + keydata["keynumbet"] + ")",
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
                                    _gettooth(keydata) + S.of(context).keycuts,
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
                                ],
                              ),
                            ),
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
                Text("齿号：" + getkeylist[i]["bitting"]),
                Text("说明:" + getkeylist[i]["note"]),
              ],
            ),
          ),
          onPressed: () {
            ////print(showlist[i]);
            //传入钥匙数据即可
            //先显示操作说明

            bool isnonconductive = false;
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
                  "type": 1,
                  "bitting": getkeylist[i]["bitting"],
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
                                                      "type": 1,
                                                      "bitting": getkeylist[i]
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
                                                    "type": 1,
                                                    "bitting": getkeylist[i]
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
                                          borderRadius: const BorderRadius.all(
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
                                                        "type": 1,
                                                        "bitting": getkeylist[i]
                                                            ["bitting"]
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
                                                      "type": 1,
                                                      "bitting": getkeylist[i]
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
                    baseKey.initdata(keydata,
                        isNonConductiveKey: isnonconductive);
                    Navigator.pushNamed(context, '/openclamp', arguments: {
                      "keydata": keydata,
                      "state": 0,
                      "type": 1,
                      "bitting": getkeylist[i]["bitting"],
                    });
                  }
                }
              }
            } else {
              baseKey.initdata(keydata, isNonConductiveKey: isnonconductive);
              Navigator.pushNamed(context, '/openclamp', arguments: {
                "keydata": keydata,
                "state": 0,
                "type": 1,
                "bitting": getkeylist[i]["bitting"],
              });
            }
            // Navigator.pushNamed(context, '/keyshow',
            // widget.arguments: {"keydata": showlist[i]});
          },
          onLongPress: () {},
        ));
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 48.h,
            padding: EdgeInsets.only(left: 20.w, top: 16.h),
            child: Text(
              widget.arguments["carname"],
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: ListView(
            children: keylistview(),
          )),
        ],
      ),
    );
  }
}
