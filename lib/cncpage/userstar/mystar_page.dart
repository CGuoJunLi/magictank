//我的收藏

import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:flutter/material.dart';

import 'package:magictank/appdata.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class MyCollectionPage extends StatefulWidget {
  const MyCollectionPage({Key? key}) : super(key: key);

  @override
  _MyCollectionPageState createState() => _MyCollectionPageState();
}

class _MyCollectionPageState extends State<MyCollectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const MyCollection(),
    );
  }
}

class MyCollection extends StatefulWidget {
  const MyCollection({Key? key}) : super(key: key);

  @override
  _MyCollectionState createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  late ProgressDialog pd;
  List keydatalist = [];
  Map getkeydata(int keyid, int type) {
    switch (type) {
      case 1:
        var temp = appData.carkeyList.where((r) {
          return r["id"] == keyid ? true : false;
        });

        return temp.toList()[0];

      case 2:
        var temp = appData.motorkeyList.where((r) {
          return r["id"] == keyid ? true : false;
        });

        return temp.toList()[0];

      case 3:
        var temp = appData.civilList.where((r) {
          return r["id"] == keyid ? true : false;
        });
        return temp.toList()[0];
      default:
        var temp = appData.carkeyList.where((r) {
          return r["id"] == keyid ? true : false;
        });

        return temp.toList()[0];
    }
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

  List<Widget> showkeydata() {
    List<Widget> temp = [];

    for (var i = 0; i < keydatalist.length; i++) {
      if (keydatalist[i]["state"] != 3) {
        var keydata =
            getkeydata(keydatalist[i]["keyid"], keydatalist[i]["type"]);
        temp.add(TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
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
                                    keydata["cnname"],
                                    style: TextStyle(
                                        color: keydatalist[i]["state"] != 1
                                            ? Colors.red
                                            : Colors.black,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Text(
                                    keydata["keynumbet"] == ""
                                        ? ""
                                        : "（" + keydata["keynumbet"] + "）",
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
                                      keydata["picname"]),
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
                                  _gettooth(keydata) + S.of(context).keycuts,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  height: 10.h,
                                  child: Text(
                                    getkeylength(keydata),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
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
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: TextButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero)),
                                onPressed: () {
                                  Fluttertoast.showToast(
                                      msg: "取消收藏" + keydata["cnname"]);
                                  removestarkey(keydata["id"]);
                                  //  starkey.indexOf(element)
                                  // appData.deleUserStar(id);
                                  // appData.starkey.remove(
                                  //     showlist[i]["id"]);
                                },
                                child:
                                    Image.asset("image/share/Icon_mystar.png"),
                              ),
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
          ),
          onPressed: () {
            ////print(showlist[i]);
            //传入钥匙数据即可
            //先显示操作说明

            baseKey.initdata(keydata);
            Navigator.pushNamed(context, '/openclamp', arguments: {
              "keydata": keydata,
              "state": 0,
              "type": keydatalist[i]["type"]
            });

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
  void initState() {
    super.initState();
    pd = ProgressDialog(context: context);
    loaddata(check: true);
  }

  Future<void> loaddata({check = false}) async {
    keydatalist = await appData.getUserStar();
    ////print(keydatalist);
    setState(() {});
  }

  Future<void> asyncServerDate() async {
    ////print(keydatalist);
    try {
      if (keydatalist.isEmpty) {
        debugPrint("服务器获得数据");
        List result = await Api.getUserStars("userid=${appData.id}");
        if (result.isNotEmpty) {
          for (var i = 0; i < result.length; i++) {
            result[i]["state"] = 1; //同步状态
            await appData.insertUserStar(result[i]);
          }
        }
      } else {
        for (var i = 0; i < keydatalist.length; i++) {
          switch (keydatalist[i]["state"]) {
            case 3:
              var data = await Api.delUserStars(keydatalist[i]);
              if (data["state"]) {
                await appData.deleUserStar(keydatalist[i]);
              }
              break;
            case 0:
              var data = await Api.upUserStars(keydatalist[i]);
              if (data["state"]) {
                await appData.deleUserStar(keydatalist[i]);
              }
              break;
            case 1:
              await appData.deleUserStar(keydatalist[i]);
              break;
          }
        }
        List result = await Api.getUserStars("userid=${appData.id}");
        ////print(result);
        if (result.isNotEmpty) {
          for (var i = 0; i < result.length; i++) {
            result[i]["state"] = 1; //同步状态
            await appData.insertUserStar(result[i]);
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
            return const MyTextDialog("同步失败");
          });
    }
  }

  Future<void> removestarkey(int keyid) async {
    debugPrint("开始删除");
    for (var i = 0; i < keydatalist.length; i++) {
      ////print(keyid);
      ////print(starkey[i]);
      if (keydatalist[i]["keyid"].toString() == keyid.toString()) {
        //删除云端的数据库
        try {
          debugPrint("userid=${appData.id}&loaclid=${keydatalist[i]["id"]}");
          var result = await Api.delUserStars(keydatalist[i]);
          debugPrint("result[\"state\"]${result["state"]}");
          if (result != null) {
            //如果删除成功
            if (result["state"] == true) {
              await appData.deleUserStar(keydatalist[i]);
            } else //如果删除失败
            {
              debugPrint("删除失败");
              if (keydatalist[i]["state"] == 1) {
                debugPrint("更新数据");
                await appData.updateUserStar(keydatalist[i]["id"], 3);
              } else {
                debugPrint("删除数据");
                await appData.deleUserStar(keydatalist[i]);
              }
            }
          }
        } catch (e) {
          debugPrint("删除失败");
          ////print(starkey[i]["id"]);
          if (keydatalist[i]["state"] == 1) {
            await appData.updateUserStar(keydatalist[i]["id"].toString(), 3);
          } else {
            await appData.deleUserStar(keydatalist[i]);
          }
        }
        await loaddata();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
