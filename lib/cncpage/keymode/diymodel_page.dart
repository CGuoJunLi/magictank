import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:magictank/http/api.dart';

class DiyModelPage extends StatelessWidget {
  const DiyModelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const DiyMode(),
    );
  }
}

class DiyMode extends StatefulWidget {
  const DiyMode({Key? key}) : super(key: key);

  @override
  State<DiyMode> createState() => _DiyModeState();
}

class _DiyModeState extends State<DiyMode> {
  bool removestate = false;
  List<Map> myLModel = []; //服务器中的立铣胚数据
  List<Map> myPModel = []; //服务器中的平铣胚数据
  List modellist = [];
  late ProgressDialog pd;

  @override
  void initState() {
    pd = ProgressDialog(context: context);
    loaddata();
    super.initState();
  }

  Future<void> asyncServerData() async {
    //  try {
    if (modellist.isEmpty) {
      debugPrint("服务器获得数据");
      List result = await Api.getUserModel("userid=${appData.id}");
      //printresult);
      if (result.isNotEmpty) {
        for (var i = 0; i < result.length; i++) {
          result[i]["state"] = 1; //同步状态
          await appData.insertUserModel(result[i]);
        }
      }
    } else {
      for (var i = 0; i < modellist.length; i++) {
        switch (modellist[i]["state"]) {
          case 3:
            //print(modellist[i]);
            var data = await Api.delUserModel(modellist[i]);

            if (data["state"]) {
              await appData.deleUserModel(modellist[i]["id"].toString());
            }
            break;
          case 0:
            var data = await Api.upUserModel(modellist[i]);
            if (data["state"]) {
              await appData.deleUserModel(modellist[i]["id"].toString());
            }
            break;
          case 1:
            await appData.deleUserModel(modellist[i]["id"].toString());
            break;
        }
      }
      List result = await Api.getUserModel("userid=${appData.id}");
      ////print(result);
      if (result.isNotEmpty) {
        for (var i = 0; i < result.length; i++) {
          result[i]["state"] = 1; //同步状态
          await appData.insertUserModel(result[i]);
        }
      }
    }
    pd.close();
    loaddata();
    // } catch (e) {
    //   pd.close();
    //   showDialog(
    //       context: context,
    //       builder: (c) {
    //         return const MyTextDialog("同步失败");
    //       });
    // }
  }

//共享数据
  Future<void> enSharedData(Map keydata, price) async {
    ////print(keydata);
    ////print(price);
    var data = {
      "userid": appData.id,
      "username": appData.username,
      "timer": keydata["timer"],
      "data": keydata["data"],
      "price": price,
    };
    // try {
    var result = await Api.upSharedModel(data);

    if (result["state"]) {
      await appData.sharedUserModel(keydata["id"].toString(), "true");
      Fluttertoast.showToast(msg: S.of(context).shareok);
    } else {
      Fluttertoast.showToast(msg: S.of(context).shareerror);
    }
    pd.close();
    // } catch (e) {
    //   pd.close();
    //   Fluttertoast.showToast(msg: "共享失败");
    // }

    loaddata();
  }

  //关闭共享
  Future<void> disSharedData(keydata) async {
    var data = {
      "userid": appData.id,
      "username": appData.username,
      "timer": keydata["timer"],
      "data": keydata["data"],
    };
    try {
      var result = await Api.delSharedModel(data);

      if (result["state"]) {
        await appData.sharedUserModel(keydata["id"].toString(), "false");
        Fluttertoast.showToast(msg: S.of(context).shareclose);
      } else {
        if (result["errorcode"].toString() == "2") {
          await appData.sharedUserModel(keydata["id"].toString(), "false");
        }
        Fluttertoast.showToast(msg: S.of(context).sharecloseerror);
      }
      pd.close();
    } catch (e) {
      pd.close();
      Fluttertoast.showToast(msg: S.of(context).sharecloseerror);
    }
    loaddata();
  }

  Future<void> delModelData(keydata) async {
    try {
      if (keydata["shared"] == true) {
        await disSharedData(keydata); //先关闭共享
      }
      var result = await Api.delUserModel(keydata);

      if (result["state"]) {
        await appData.deleUserModel(keydata["id"].toString());
      } else {
        await appData.updateUserModel(keydata["id"].toString(), 3);
      }
    } catch (e) {
      await appData.updateUserModel(keydata["id"].toString(), 3);
    }
    loaddata();
  }

  Future<void> loaddata() async {
    // pd.show(max: 100, msg: "msg");
    modellist = await appData.getUserModel();

    setState(() {});
  }

  ///是否有中间沟槽
  bool getmgroove(Map data) {
    if (data["alltype"] == 1 || data["alltype"] == 2) {
      return true;
    }
    return false;
  }

  ///是否有下沟槽
  bool getlgroove(Map data) {
    if (data["alltype"] == 3 || data["alltype"] == 2) {
      if (data["lgroovelength"] > 0) {
        return true;
      }
      return false;
    }
    return false;
  }

  ///是否有上间沟槽
  bool getugroove(Map data) {
    if (data["alltype"] == 3 || data["alltype"] == 2) {
      if (data["ugroovelength"] > 0) {
        return true;
      }
      return false;
    }
    return false;
  }

  List<Widget> modelListView() {
    List<Widget> temp = [];
    for (var i = 0; i < modellist.length; i++) {
      if (modellist[i]["state"] != null &&
          modellist[i]["state"].toString() != "3") {
        var keydata = json.decode(modellist[i]["data"]);
        temp.add(
          TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
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
                                          color: modellist[i]["state"] != 1
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
                                    Text(S.of(context).mgroove +
                                        (getmgroove(keydata)
                                            ? S.of(context).have
                                            : S.of(context).nullnone)),
                                    Text(S.of(context).ugroove +
                                        (getugroove(keydata)
                                            ? S.of(context).have
                                            : S.of(context).nullnone)),
                                    Text(S.of(context).lgroove +
                                        (getlgroove(keydata)
                                            ? S.of(context).have
                                            : S.of(context).nullnone)),
                                    Text(S.of(context).modelhead +
                                        (keydata["headtype"] == 0
                                            ? S.of(context).nullnone
                                            : S.of(context).have)),
                                  ],
                                ),
                              ),
                              removestate
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: Column(
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
                                                    await delModelData(
                                                        modellist[i]);
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
                                              onPressed: () {
                                                // print(appData.limit);
                                                // print(keydatalist[i]);
                                                if (modellist[i]["use"]
                                                            .toString() ==
                                                        "true" ||
                                                    appData.limit == 10) {
                                                  if (modellist[i]["shared"] ==
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
                                                            modellist[i]);
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
                                                                          .plaseseletoken);
                                                                })
                                                            .then(
                                                                (value) async {
                                                          if (value["state"]) {
                                                            await enSharedData(
                                                                modellist[i],
                                                                value["value"]);
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
                                              child: Text(modellist[i]
                                                          ["shared"] ==
                                                      "true"
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
                                                    color:
                                                        const Color(0xff384c70),
                                                    width: 1.w)),
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets
                                                                .zero)),
                                                child: Text(
                                                    S.of(context).editdata),
                                                onPressed: () {
                                                  if (modellist[i]["shared"]
                                                          .toString() ==
                                                      "true") {
                                                    showDialog(
                                                        context: context,
                                                        builder: (c) {
                                                          return const MyTextDialog(
                                                              "当前数据已共享,请先关闭共享后再进行编辑操作!");
                                                        });
                                                  } else {
                                                    Navigator.pushNamed(context,
                                                            "/changemodeldata",
                                                            arguments:
                                                                modellist[i])
                                                        .then((value) {
                                                      loaddata();
                                                    });
                                                  }
                                                }),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
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
                        (keydata["chnote"] != "无" &&
                                keydata["chnote"] != "null")
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
              //print(keydata);
              //传入钥匙数据即可
              //先显示操作说明
              Navigator.pushNamed(context, "/cutmodelready",
                  arguments: {"data": keydata});
              // showDialog(
              //     context: context,
              //     builder: (c) {
              //       return OpenClampPage({"keydata": keydata, "state": 0});
              //     }).then((value) {
              //       print("object");
              //     });
              // Navigator.pushNamed(context, '/openclamp',
              //     arguments: {"keydata": keydata, "state": 0});
              // // Navigator.pushNamed(context, '/keyshow',
              // widget.arguments: {"keydata": keydatalist[i]});
            },
            onLongPress: () {},
          ),
        );
      }
    }
    return temp;
  }

  // List<Widget> modelListView() {
  //   List<Widget> temp = [];
  //   for (var i = 0; i < modellist.length; i++) {
  //     var keydata = json.decode(modellist[i]["data"]);
  //     if (modellist[i]["state"].toString() != "3") {
  //       temp.add(
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Row(children: [
  //                 Expanded(child: Column(children: [
  //                   Text(
  //                   keydata["cnname"],)
  //                 ],)),
  //                 Expanded(child:Column(children: [],)),

  //               ],),
  //               ListTile(
  //                 title: Text(
  //                   keydata["cnname"],
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onTap: () {
  //                   //  //print(keydata);
  //                   Navigator.pushNamed(context, "/cutmodelready",
  //                       arguments: {"data": keydata});
  //                 },
  //               ),
  //             ),
  //             removestate
  //                 ? Column(
  //                     children: [
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           showDialog(
  //                               context: context,
  //                               builder: (c) {
  //                                 return const MyTextDialog(
  //                                     "是否删除数据?\r\n注意:此操作不可恢复!\r\n共享的资源也会被删除!");
  //                               }).then((value) async {
  //                             if (value == true) {
  //                               await delModelData(modellist[i]);
  //                             }
  //                           });
  //                         },
  //                         child: const Text("删除"),
  //                       ),
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           if (modellist[i]["use"] == "true") {
  //                             if (modellist[i]["shared"] == "true") {
  //                               showDialog(
  //                                   context: context,
  //                                   builder: (c) {
  //                                     return const MyTextDialog("是否取消共享?\r\n");
  //                                   }).then((value) async {
  //                                 await disSharedData(modellist[i]);
  //                               });
  //                             } else {
  //                               showDialog(
  //                                   context: context,
  //                                   builder: (c) {
  //                                     return const MyTextDialog("是否共享数据?\r\n");
  //                                   }).then((value) {
  //                                 showDialog(
  //                                     context: context,
  //                                     builder: (c) {
  //                                       return const MychangDialog(0,
  //                                           title: "请选择多少积分可以下载");
  //                                     }).then((value) async {
  //                                   ////print(value);
  //                                   await enSharedData(
  //                                       modellist[i], value["value"]);
  //                                 });
  //                               });
  //                             }
  //                           } else {
  //                             showDialog(
  //                                 context: context,
  //                                 builder: (c) {
  //                                   return const MyTextDialog("请先使用一次再共享!\r\n");
  //                                 });
  //                           }
  //                         },
  //                         child: Text(
  //                             modellist[i]["shared"] == "true" ? "已共享" : "共享"),
  //                       )
  //                     ],
  //                   )
  //                 : Container(),
  //           ],
  //         ),
  //       );
  //     }
  //   }
  //   return temp;
  // }

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
                  S.of(context).selemodel,
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
                      S.of(context).editdata,
                      style: const TextStyle(fontSize: 15),
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
        Expanded(child: ListView(children: modelListView())),
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
                  child: Text(S.of(context).creatmodel),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return MySeleDialog(
                            [
                              S.of(context).measuremodel,
                              S.of(context).smartmodel,
                            ],
                            title: S.of(context).creatmodel,
                          );
                        }).then((value) {
                      if (value == 1) {
                        Navigator.pushNamed(context, '/diymodelstep')
                            .then((value) {
                          loaddata();
                        });
                      }
                      if (value == 2) {
                        Navigator.pushNamed(context, '/smartdiymodelstep')
                            .then((value) {
                          loaddata();
                        });
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
                          return const MyTextDialog("是否立即同步数据?");
                        }).then((value) async {
                      if (value) {
                        pd.show(max: 100, msg: "同步数据中...");
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
                  child: const Text("共享市场"),
                  onPressed: () {
                    Navigator.pushNamed(context, "/diymodelmarket")
                        .then((value) {
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
