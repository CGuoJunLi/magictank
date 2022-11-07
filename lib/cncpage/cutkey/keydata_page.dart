import 'dart:async';

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/userappbar.dart';

import '../../appdata.dart';

class KeyDataPage extends StatefulWidget {
  final Map arguments;
  const KeyDataPage(this.arguments, {Key? key}) : super(key: key);

  @override
  _KeyDataPageState createState() => _KeyDataPageState();
}

class _KeyDataPageState extends State<KeyDataPage> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: KeyDataList(widget.arguments),
    );
  }
}

class KeyDataList extends StatefulWidget {
  final Map arguments;
  const KeyDataList(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  _KeyDataListState createState() {
    return _KeyDataListState();
  }
}

class _KeyDataListState extends State<KeyDataList> {
  late List<Map> keydata = [];
  late List<Map> showlist = [];

  var iconData = const Icon(Icons.keyboard_arrow_right);

  List starkey = [];
  List modelAllKey = [];
  @override
  void initState() {
    super.initState();

    //_getlist();
    getkeylist();
    //keydata = List.from(allkeyllsit);

    if (appData.loginstate) {
      getStarKey();
    }
    // ////print(carbrand[carbrand.length]["cnname"]);
    // ////print(widget.arguments["path"] + "/Newtank1.txt");
  }

  Future<void> getStarKey() async {
    starkey = await appData.getUserStar();
    ////print(starkey);
    setState(() {});
  }

  bool isStar(int keyid) {
    for (var i = 0; i < starkey.length; i++) {
      if (starkey[i]["state"] != 3) {
        if (starkey[i]["keyid"].toString() == keyid.toString()) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> removestarkey(int keyid) async {
    for (var i = 0; i < starkey.length; i++) {
      ////print(keyid);
      ////print(starkey[i]);
      if (starkey[i]["keyid"].toString() == keyid.toString()) {
        //删除云端的数据库
        try {
          debugPrint("userid=${appData.id}&loaclid=${starkey[i]["id"]}");
          var result = await Api.delUserStars(starkey[i]);
          debugPrint("result[\"state\"]${result["state"]}");
          if (result != null) {
            //如果删除成功
            if (result["state"] == true) {
              await appData.deleUserStar(starkey[i]);
            } else //如果删除失败
            {
              if (starkey[i]["state"] == 1) {
                await appData.updateUserStar(starkey[i]["id"], 3);
              } else {
                await appData.deleUserStar(starkey[i]);
              }
            }
          }
        } catch (e) {
          ////print(starkey[i]["id"]);
          if (starkey[i]["state"] == 1) {
            await appData.updateUserStar(starkey[i]["id"].toString(), 3);
          } else {
            await appData.deleUserStar(starkey[i]);
          }
        }
        await getStarKey();
        break;
      }
    }
  }

//先储存到本地
//然后上传到服务器
//如果成功 修改本地的数据的状态为 state3
  Future<void> addstarkey(int keyid) async {
    var data = {
      "timer": DateTime.now().toString().substring(0, 19),
      "userid": appData.id,
      "keyid": keyid,
      "type": widget.arguments["type"],
      "state": 0,
    };
    var temp = await appData.insertUserStar(data);
    ////print(temp);
    ////print(widget.arguments["type"]);
    ////print(appData.id);
    try {
      var result = await Api.upUserStars(data); //更新一条数据
      ////print(result);
      if (result != null) {
        if (result["state"]) {
          await appData.updateUserStar(temp.toString(), 1);
        }
      }
    } catch (e) {
      debugPrint("出错了");
    }

    await getStarKey();
  }

  void getkeylist() {
    //获取型号的年份列表
    List<Map> getkeydata = [];
    var modelid = List.from(widget.arguments["modellist"]);
    List<Map> temp = [];
    switch (widget.arguments["type"]) {
      case 1:
        temp = List.from(appData.carkeyList);
        break;
      case 2:
        temp = List.from(appData.civilkeyList);
        break;
      case 3:
        temp = List.from(appData.motorkeyList);
        break;
    }
    //allcarlist[widget.arguments["id"]]["model"][widget.arguments["id2"]]["time"];
    if (modelid.length == 1) {
      //说明只有一个数据,那么直接显示出来
      for (var i = 0; i < temp.length; i++) {
        if (modelid[0]["id"].contains(temp[i]["id"])) {
          //如果存在id 则将ID转换为钥匙数据
          getkeydata.add(temp[i]);
          modelAllKey.add(temp[i]);
        }
      }

      showlist.add({
        "time": modelid[0]["year"],
        "state": true,
        "keydata": getkeydata,
      });
      //showlist[0]["state"] = true;
    } else {
      //将钥匙数据拼接到年份年份的列表,即将ID换成钥匙数据

      for (var j = 0; j < modelid.length; j++) {
        getkeydata = [];
        for (var i = 0; i < temp.length; i++) {
          if (modelid[j]["id"].contains(temp[i]["id"])) {
            //如果存在id 则将ID转换为钥匙数据

            getkeydata.add(temp[i]);
            modelAllKey.add(temp[i]);
          }
        }
        showlist.add({
          "time": modelid[j]["year"],
          "state": j == 0 ? true : false,
          "keydata": List.from(getkeydata),
          "type": widget.arguments["type"]
        });
      }
    }
  }

  Widget showkeydata(context, index) {
    //////print(index);
    //////print(carbrand[index]["cnname"]);
    return Column(
      children: [
        TextButton(
          onPressed: () {
            for (var i = 0; i < showlist.length; i++) {
              if (i == index) {
                if (showlist[index]["state"] == false) {
                  showlist[index]["state"] = true;
                } else {
                  showlist[index]["state"] = false;
                }
              } else {
                showlist[i]["state"] = false;
              }
            }
            setState(() {});
          },
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          child: Container(
            width: double.maxFinite,
            height: 40.h,
            color: showlist[index]["state"] == false
                ? const Color(0xffeeeeee)
                : const Color(0xff384c70),
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  showlist[index]["time"] == "0"
                      ? S.of(context).allkeydata
                      : showlist[index]["time"],
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: showlist[index]["state"] == false
                          ? const Color(0xff384c70)
                          : Colors.white),
                ),
                const Expanded(child: SizedBox()),
                showlist[index]["state"] == false
                    ? const Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(0xff384c70),
                      )
                    : const Icon(Icons.keyboard_arrow_down,
                        color: Colors.white),
                SizedBox(
                  width: 20.w,
                ),
              ],
            ),
          ),
        ),
        showlist[index]["state"] == true
            ? Column(
                children: getkeydatalist(index),
              )
            : Container(),
      ],
    );
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

  Widget keydatawidget(String name, Map keydata) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      child: Container(
        width: 342.w,
        height: 130.r,
        margin: EdgeInsets.only(top: 10.r),
        padding: EdgeInsets.only(left: 10.r, top: 5.r, right: 10.r),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.r)),
        child: Column(
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
                              name,
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
                            style:
                                TextStyle(fontSize: 10.sp, color: Colors.red),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              Text(
                                getkeyclass(keydata),
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: TextButton(
                            style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero)),
                            onPressed: () {
                              if (isStar(keydata["id"])) {
                                Fluttertoast.showToast(
                                    msg: S.of(context).removestar +
                                        keydata["cnname"]);
                                removestarkey(keydata["id"]);
                                //  starkey.indexOf(element)
                                // appData.deleUserStar(id);
                                // appData.starkey.remove(
                                //     showlist[i]["id"]);
                              } else {
                                if (appData.loginstate) {
                                  Fluttertoast.showToast(
                                      msg: S.of(context).star +
                                          keydata["cnname"]);

                                  //getStarKey();
                                  addstarkey(keydata["id"]);
                                  // appData.starkey.add(
                                  //     showlist[i]["id"]);
                                } else {
                                  showDialog(
                                      context: (context),
                                      builder: (c) {
                                        return MyTextDialog(
                                          S.of(context).needlogin,
                                          button2: S.of(context).login,
                                        );
                                      }).then((value) {
                                    if (value) {
                                      Navigator.pushNamed(context, "/login");
                                    }
                                  });
                                }
                              }
                            },
                            child: Image.asset(isStar(keydata["id"])
                                ? "image/share/Icon_mystar.png"
                                : "image/share/Icon_mystar1.png"),
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
          ],
        ),
      ),
      onPressed: () {
        ////print(showlist[index]["keydata"][i]);
        //传入钥匙数据即可
        //先显示操作说明

        if (keydata["smart"]) {
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(13.0))),
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
                                    S.of(context).selekey,
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
                                            context, '/openclamp', arguments: {
                                          "keydata": keydata,
                                          "state": 0,
                                          "type": widget.arguments["type"]
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
                                      Navigator.pushNamed(context, '/openclamp',
                                          arguments: {
                                            "keydata": keydata,
                                            "state": 0,
                                            "type": widget.arguments["type"]
                                          });
                                    },
                                    child: SizedBox(
                                      width: 254.w,
                                      height: 181.w,
                                      child:
                                          Image.asset("image/tank/issmart.png"),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50.h,
                            child: Container(
                              padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                              width: 150.w,
                              height: 40.h,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13.0))),
                                    backgroundColor: MaterialStateProperty.all(
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
          baseKey.initdata(keydata);
          Navigator.pushNamed(context, '/openclamp', arguments: {
            "keydata": keydata,
            "state": 0,
            "type": widget.arguments["type"]
          });
        }

        // Navigator.pushNamed(context, '/keyshow',
        // widget.arguments: {"keydata": showlist[index]["keydata"][i]});
      },
      onLongPress: () {},
    );
  }

  int selekeysys() {
    for (var i = 0; i < appData.keysyssele.length; i++) {
      if (appData.keysyssele[i] == "true") {
        return i;
      }
    }
    return 0;
  }

  List<Widget> getkeydatalist(int index) {
    List<Widget> temp = [];
    for (int i = 0; i < showlist[index]["keydata"].length; i++) {
      var keydata = showlist[index]["keydata"][i];
      if (keydata["silca"] != null &&
          keydata["keyline"] != null &&
          keydata["ilcon"] != null &&
          keydata["jma"] != null) {
        switch (selekeysys()) {
          case 0:
            for (var i = 0; i < keydata["silca"].length; i++) {
              print(keydata["silca"][i]);
              temp.add(keydatawidget(keydata["silca"][i], keydata));
            }
            break;
          case 1:
            for (var i = 0; i < keydata["keyline"].length; i++) {
              temp.add(keydatawidget(keydata["keyline"][i], keydata));
            }
            break;
          case 2:
            for (var i = 0; i < keydata["ilcon"].length; i++) {
              temp.add(keydatawidget(keydata["ilcon"][i], keydata));
            }
            break;
          case 3:
            for (var i = 0; i < keydata["jma"].length; i++) {
              temp.add(keydatawidget(keydata["jma"][i], keydata));
            }
            break;
          default:
        }
      } else {
        temp.add(keydatawidget(keydata["cnname"], keydata));
      }
    }

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: double.maxFinite,
            height: 70.r,
            child: Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.arguments["carname"],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 10.sp,
                    ),
                  ),

                  Text(
                    widget.arguments["modelname"]!,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 17.sp,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "当前钥匙胚系统:",
                        style: TextStyle(color: Colors.red, fontSize: 10.sp),
                      ),
                      SizedBox(
                        // width: 56.r,
                        height: 30.r,
                        child: DropdownButton(
                            value: selekeysys(),
                            items: [
                              DropdownMenuItem(
                                value: 0,
                                child: Text(
                                  "Silca",
                                  style: TextStyle(
                                      color: Color(0xff384c70),
                                      fontSize: 10.sp),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  "Keyline",
                                  style: TextStyle(
                                      color: Color(0xff384c70),
                                      fontSize: 10.sp),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(
                                  "Ilcon",
                                  style: TextStyle(
                                      color: Color(0xff384c70),
                                      fontSize: 10.sp),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text(
                                  "JMA",
                                  style: TextStyle(
                                      color: Color(0xff384c70),
                                      fontSize: 10.sp),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              switch (value) {
                                case 0:
                                  appData.keysyssele[0] = "true";
                                  appData.keysyssele[1] = "false";
                                  appData.keysyssele[2] = "false";
                                  appData.keysyssele[3] = "false";
                                  break;
                                case 1:
                                  appData.keysyssele[0] = "false";
                                  appData.keysyssele[1] = "true";
                                  appData.keysyssele[2] = "false";
                                  appData.keysyssele[3] = "false";
                                  break;
                                case 2:
                                  appData.keysyssele[0] = "false";
                                  appData.keysyssele[1] = "false";
                                  appData.keysyssele[2] = "true";
                                  appData.keysyssele[3] = "false";
                                  break;
                                case 3:
                                  appData.keysyssele[0] = "false";
                                  appData.keysyssele[1] = "false";
                                  appData.keysyssele[2] = "false";
                                  appData.keysyssele[3] = "true";
                                  break;
                              }
                              appData.upgradeAppData(
                                  {"keysyssele": appData.keysyssele});
                              setState(() {});
                            }),
                      ),
                    ],
                  )
                  // Expanded(child: Container()),
                  //Expanded(child: SizedBox()),
                  // Text("当前钥匙胚系统:"),
                  // SizedBox(
                  //   width: 50.r,
                  //   height: 50.r,
                  //   child: DropdownButton(
                  //       value: 0,
                  //       items: [
                  //         DropdownMenuItem(
                  //           value: 0,
                  //           child: Text("Silca"),
                  //         ),
                  //         DropdownMenuItem(
                  //           value: 1,
                  //           child: Text("Keyline"),
                  //         ),
                  //         DropdownMenuItem(
                  //           value: 2,
                  //           child: Text("Ilcon"),
                  //         ),
                  //         DropdownMenuItem(
                  //           value: 3,
                  //           child: Text("JMA"),
                  //         ),
                  //       ],
                  //       onChanged: (value) {
                  //         setState(() {});
                  //       }),
                  // ),
                  //   ],
                  // ),
                ],
              ),
              const Expanded(child: SizedBox()),

              //钥匙识别
              appData.limit > 0
                  ? SizedBox(
                      width: 81.w,
                      height: 25.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70)),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          Navigator.pushNamed(context, "/searchkey",
                              arguments: modelAllKey);
                        },
                        child: Text(
                          S.of(context).keydiscern,
                          style:
                              TextStyle(fontSize: 15.sp, color: Colors.white),
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                width: 10.w,
              ),
            ])),
        Container(
          height: 13.h,
          color: const Color(0xffdde2ea),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: showlist.length,
            // primary: true,
            itemBuilder: (context, index) {
              return showkeydata(context, index);
            },
          ),
        ),
      ],
    );
  }
}
