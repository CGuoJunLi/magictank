import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:magictank/cncpage/basekey.dart';

import 'package:magictank/cncpage/bluecmd/receivecmd.dart';

import 'package:magictank/generated/l10n.dart';

import 'package:magictank/home4_page.dart';
import 'package:magictank/http/api.dart';

import 'package:magictank/dialogshow/dialogpage.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../appdata.dart';

class AllKeyDataPage extends StatefulWidget {
  const AllKeyDataPage({Key? key}) : super(key: key);

  @override
  _AllKeyDataPageState createState() => _AllKeyDataPageState();
}

class _AllKeyDataPageState extends State<AllKeyDataPage> {
  List<dynamic> originallist = [];
  List<dynamic> showlist = [];
  bool hightSearchState = false;
  var iconData = const Icon(Icons.keyboard_arrow_right);
  late ProgressDialog pd;
  List starkey = [];
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    pd = ProgressDialog(context: context);
    //_getlist();
    getkeylist();
    //keydata = List.from(allkeyllsit);

    if (appData.loginstate) {
      getStarKey();
    }
    // ////print(carbrand[carbrand.length]["cnname"]);
    // ////print(arguments["path"] + "/Newtank1.txt");
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
      "type": 1, //钥匙类型 默认为车型
      "state": 0,
    };
    var temp = await appData.insertUserStar(data);
    ////print(temp);
    ////print(arguments["type"]);
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
    originallist.addAll(appData.carkeyList);
    //originallist.addAll(appData.civilkeyList);
    showlist = List.from(originallist);
    List temp = [];
    showlist.forEach((element) {
      // if (element["toothDepth"][0] < element["toothDepth"][1]) {
      //   print(element["toothDepth"]);
      //   print(element["id"]);
      // }
      // if (element["locat"] == 0) {
      //   if (element["toothSA"][0] > element["toothSA"][1]) {
      //     print(element["id"]);
      //   }
      // } else {
      //   if (element["toothSA"][0] < element["toothSA"][1]) {
      //     print(element["id"]);
      //   }
      // }
      if (element["A"] != 0 ||
          element["AX"] != 0 ||
          element["B"] != 0 ||
          element["BX"] != 0) {
        temp.add(element["id"]);
        print(element["id"]);
      }
    });
    print(temp);
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

  Widget getkeydatalist(context, index) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
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
                              showlist[index]["cnname"],
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
                            showlist[index]["keynumbet"] == ""
                                ? ""
                                : "（" + showlist[index]["keynumbet"] + "）",
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
                                showlist[index]["picname"]),
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
                                _gettooth(showlist[index]) +
                                    S.of(context).keycuts,
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black),
                              ),
                              Text(
                                getkeylength(showlist[index]),
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black),
                              ),
                              Text(
                                showlist[index]["locat"].toString() == "0"
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
                                getkeyclass(showlist[index]),
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
                              if (isStar(showlist[index]["id"])) {
                                Fluttertoast.showToast(
                                    msg: S.of(context).removestar +
                                        showlist[index]["cnname"]);
                                removestarkey(showlist[index]["id"]);
                                //  starkey.indexOf(element)
                                // appData.deleUserStar(id);
                                // appData.starkey.remove(
                                //     showlist[i]["id"]);
                              } else {
                                if (appData.loginstate) {
                                  Fluttertoast.showToast(
                                      msg: S.of(context).star +
                                          showlist[index]["cnname"]);

                                  //getStarKey();
                                  addstarkey(showlist[index]["id"]);
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
                            child: Image.asset(isStar(showlist[index]["id"])
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
                (showlist[index]["chnote"] != "无" &&
                        showlist[index]["chnote"] != "null")
                    ? S.of(context).note + ":" + showlist[index]["chnote"]
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
        print(showlist[index]);
        //传入钥匙数据即可
        //先显示操作说明

        _focusNode.unfocus();
        baseKey.setcarname("");

        //如果 ID大于10000小于15000 并且showlist[index]["smart"] 为true 那么当前钥匙只有smart属性
        if (showlist[index]["id"] > 10000 &&
            showlist[index]["id"] < 15000 &&
            showlist[index]["smart"]) {
          baseKey.initdata(showlist[index], isSmartKey: true);

          Navigator.pushNamed(context, '/openclamp',
              arguments: {"keydata": showlist[index], "state": 0, "type": 1});
        } else {
          if (showlist[index]["smart"]) {
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
                                          baseKey.initdata(showlist[index]);
                                          Navigator.pushNamed(
                                              context, '/openclamp',
                                              arguments: {
                                                "keydata": showlist[index],
                                                "state": 0,
                                                "type": 1
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
                                        baseKey.initdata(showlist[index],
                                            isSmartKey: true);
                                        Navigator.pushNamed(
                                            context, '/openclamp', arguments: {
                                          "keydata": showlist[index],
                                          "state": 0,
                                          "type": 1
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
                                padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                                width: 150.w,
                                height: 40.h,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13.0))),
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
            if (showlist[index]["fixture"].length == 2 &&
                showlist[index]["fixture"][0] == 7) {
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
                                        S.of(context).seleclamp,
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
                                      Text(S.of(context).clamptype1),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            baseKey.initdata(showlist[index]);
                                            baseKey.fixture =
                                                showlist[index]["fixture"][0];
                                            Navigator.pushNamed(
                                                context, '/openclamp',
                                                arguments: {
                                                  "keydata": showlist[index],
                                                  "state": 0,
                                                  "type": 1
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
                                            showlist[index],
                                          );
                                          baseKey.fixture =
                                              showlist[index]["fixture"][1];
                                          Navigator.pushNamed(
                                              context, '/openclamp',
                                              arguments: {
                                                "keydata": showlist[index],
                                                "state": 0,
                                                "type": 1
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
                                  padding:
                                      EdgeInsets.only(top: 5.h, bottom: 5.h),
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
              baseKey.initdata(showlist[index]);
              Navigator.pushNamed(context, '/openclamp', arguments: {
                "keydata": showlist[index],
                "state": 0,
                "type": 1
              });
            }
          }
        }
        // Navigator.pushNamed(context, '/keyshow',
        // widget.arguments: {"keydata": showlist[i]});
      },
      onLongPress: () {},
    );
  }

  void _search(String text) {
    showlist = [];
    if (text.isEmpty) {
      //debugPrint("空");
      showlist = List.from(originallist);
    } else {
      List list = originallist.where((v) {
        //  ////print(v["cnname"].toLowerCase().contains(text.toLowerCase()));

        return (v["indexes"] + v["cnname"])
            .toLowerCase()
            .contains(text.toLowerCase());
      }).toList();
      if (list.isNotEmpty) {
        showlist = List.from(list);
      }
    }

    setState(() {});
  }

  void beginHighSearch(Map keydata) {
    ////print(originallist.length);
    // //print(keydata);
    pd.show(max: 100, msg: S.of(context).searching);
    ////print(originallist[0]);
    showlist = [];

    for (var i = 0; i < originallist.length; i++) {
      if (originallist[i]["class"] == keydata["class"] &&
          originallist[i]["locat"] == keydata["location"]) {
        if (keydata["class"] == 0 && keydata["class"] == 1) {
          //如果是平铣双边和平铣单边 不需要判断边数据
          if (keydata["wide"] != 0) {
            if (keydata["tooth"] != 0) {
              if (((originallist[i]["wide"] - keydata["wide"]).abs() < 10) &&
                  (originallist[i]["toothSA"].length == keydata["tooth"])) {
                showlist.add(originallist[i]);
              }
            } else {
              if ((originallist[i]["wide"] - keydata["wide"]).abs() < 10) {
                showlist.add(originallist[i]);
              }
            }
          } else {
            showlist.add(originallist[i]);
          }
        } else {
          //其它钥匙要判断边
          if (originallist[i]["side"] == keydata["side"]) {
            if (keydata["wide"] != 0) {
              if (keydata["tooth"] != 0) {
                if (((originallist[i]["wide"] - keydata["wide"]).abs() < 10) &&
                    (originallist[i]["toothSA"].length == keydata["tooth"])) {
                  showlist.add(originallist[i]);
                }
              } else {
                if ((originallist[i]["wide"] - keydata["wide"]).abs() < 10) {
                  showlist.add(originallist[i]);
                }
              }
            } else {
              showlist.add(originallist[i]);
            }
          }
        }
      }
    }
    pd.close();
    setState(() {});
    // print(keydata);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (!hightSearchState) {
            return true;
          } else {
            showlist = List.from(originallist);
            setState(() {});
            hightSearchState = false;
            return false;
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xffeeeeee),
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
                if (!hightSearchState) {
                  Navigator.pop(context);
                } else {
                  hightSearchState = false;
                  showlist = List.from(originallist);
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
          body: Column(
            children: [
              SizedBox(
                  height: 33.h,
                  child: Row(children: [
                    Text(
                      S.of(context).allkeydata,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 17.sp,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: 90.w,
                      height: 25.h,
                      child: OutlinedButton(
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                const BorderSide(color: Color(0xff384c70))),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13.0))),
                            // backgroundColor:
                            //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          if (appData.loginstate) {
                            Navigator.pushNamed(context, '/mycollection');
                          } else {
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return MyTextDialog(S.of(context).needlogin,
                                      button2: S.of(context).login);
                                }).then((value) {
                              if (value) {
                                Navigator.pushNamed(context, '/login');
                              }
                            });
                          }
                        },
                        child: Text(
                          S.of(context).userstar,
                          style: TextStyle(
                              fontSize: 12.sp, color: const Color(0xff384c70)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ])),
              Container(
                height: 13.h,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.0)),
                            borderSide: BorderSide(color: Color(0xff384c70)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.0)),
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
                    SizedBox(
                      width: 10.w,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13.0))),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        onPressed: () {
                          if (hightSearchState) {
                            hightSearchState = false;
                            showlist = List.from(originallist);
                            setState(() {});
                          } else {
                            Navigator.pushNamed(context, '/highsearch')
                                .then((value) {
                              if (value != null) {
                                beginHighSearch(value as Map);
                                hightSearchState = true;
                              } else {
                                hightSearchState = false;
                              }
                              setState(() {});
                            });
                          }
                        },
                        child: Text(hightSearchState
                            ? S.of(context).cancel
                            : S.of(context).highsearch)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: showlist.length,
                    itemBuilder: (context, index) {
                      return getkeydatalist(context, index);
                    }),
              ),
            ],
          ),
        ));
  }
}
