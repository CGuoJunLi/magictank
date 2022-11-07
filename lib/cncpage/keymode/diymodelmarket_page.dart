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

//服务器分组每次刷新10笔数据
//访问服务器时需要 提供页数
//服务器保存规则
//diytank1.json //保存品牌
//diytank3.json //保存数据
//先获取车型列表  再获取 钥匙列表
class DiyModelMarketPage extends StatelessWidget {
  const DiyModelMarketPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const DiyModelMarket(),
    );
  }
}

class DiyModelMarket extends StatefulWidget {
  const DiyModelMarket({Key? key}) : super(key: key);

  @override
  State<DiyModelMarket> createState() => _DiyModelMarketState();
}

class _DiyModelMarketState extends State<DiyModelMarket> {
  List origKeyDataList = [];
  List showKeyDataList = [];
  int state = 0; //加载状态
  late ProgressDialog pd;
  @override
  void initState() {
    pd = ProgressDialog(context: context);
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    //pd.show(max: 100, msg: "加载中...");
    origKeyDataList = await Api.getSharedModel("model=0");

    if (origKeyDataList.isEmpty) {
      state = 1; //空数据
    } else {
      state = 2;
    }
    showKeyDataList = List.of(origKeyDataList);
    // pd.close();
    setState(() {});
  }

  Future<void> saveData(Map keydata) async {
    var data = {
      "userid": appData.id,
      "timer": DateTime.now().toString().substring(0, 19),
      "data": keydata["data"],
      "state": 0,
      "shared": "false",
      "use": "false",
    };
    try {
      var result = await Api.upUserModel(data);
      if (result["state"]) {
        data["state"] = 1;
        await appData.insertUserModel(data);
      } else {
        await appData.insertUserModel(data);
      }
    } catch (e) {
      await appData.insertUserModel(data);
    }
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

  List<Widget> keyDataWidget() {
    List<Widget> temp = [];
    for (var i = 0; i < showKeyDataList.length; i++) {
      var keydata = jsonDecode(showKeyDataList[i]["data"]);

      temp.add(Container(
        width: 340.r,
        height: 193.r,
        margin: EdgeInsets.all(10.r),
        padding:
            EdgeInsets.only(left: 5.r, right: 5.r, top: 10.r, bottom: 10.r),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
        child: Column(
          children: [
            SizedBox(
                width: 330.r,
                height: 65.r,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "用户名:${showKeyDataList[i]["username"]}",
                          style: TextStyle(fontSize: 15.sp),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              //边框

                              fixedSize:
                                  MaterialStateProperty.all(Size(68.r, 28.r)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff384c70)),
                            ),
                            onPressed: () {
                              if (showKeyDataList[i]["userid"].toString() ==
                                  appData.id.toString()) {
                                Fluttertoast.showToast(msg: "已有此资源,无需下载");
                              } else {
                                showDialog(
                                    context: (context),
                                    builder: (c) {
                                      return MyTextDialog(
                                          "是否消耗${showKeyDataList[i]["price"]}积分下载此资源?");
                                    }).then((value) async {
                                  if (value) {
                                    debugPrint("下载");
                                    if (appData.integral <
                                        showKeyDataList[i]["price"]) {
                                      Fluttertoast.showToast(msg: "积分不足");
                                    } else {
                                      var result = await Api.updatauserinfo({
                                        "account": appData.account,
                                        "integral": appData.integral
                                      });
                                      if (result["state"]) {
                                        appData.upgradeAppData({
                                          "integral": appData.integral -
                                              showKeyDataList[i]["price"]
                                        });
                                        await saveData(showKeyDataList[i]);
                                        Fluttertoast.showToast(msg: "下载成功!");
                                        result = await Api.getuserinfo({
                                          "account": showKeyDataList[i]
                                              ["account"],
                                        });

                                        result = await Api.updatauserinfo({
                                          "account": showKeyDataList[i]
                                              ["account"],
                                          "integral": (result["integral"] +
                                              showKeyDataList[i]["price"])
                                        });
                                      } else {
                                        Fluttertoast.showToast(msg: "下载失败!");
                                      }
                                    }
                                  }
                                });
                              }
                            },
                            child: Text(S.of(context).download)),
                      ],
                    )),
                  ],
                )),
            Container(
              width: 330.r,
              height: 108.r,
              padding: EdgeInsets.only(
                  top: 10.r, bottom: 10.r, left: 5.r, right: 5.r),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff084c70),
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          keydata["cnname"],
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "钥匙胚号:" +
                              (keydata["keynumbet"] == ""
                                  ? "无"
                                  : keydata["keynumbet"]),
                          style: TextStyle(fontSize: 10.sp, color: Colors.red),
                        ),
                      ),
                      Expanded(
                        child: Image.file(
                          File(appData.keyImagePath +
                              "/key/" +
                              keydata["picname"]),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "备注:" +
                              (keydata["chnote"] == ""
                                  ? "无"
                                  : keydata["chnote"]),
                          style: TextStyle(fontSize: 10.sp, color: Colors.red),
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("中间沟槽:" + (getmgroove(keydata) ? "有" : "无")),
                      Text("上沟槽:" + (getugroove(keydata) ? "有" : "无")),
                      Text("下沟槽:" + (getlgroove(keydata) ? "有" : "无")),
                      Text("头部:" + (keydata["headtype"] == 0 ? "无" : "有")),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ));
    }
    return temp;
  }

  // List<Widget> keyDataWidget() {
  //   List<Widget> temp = [];
  //   for (var i = 0; i < keyDataList.length; i++) {
  //     var keydata = json.decode(keyDataList[i]["data"]);
  //     temp.add(TextButton(
  //       style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
  //       child: SizedBox(
  //         width: 341.w,
  //         height: 200.h,
  //         child: Card(
  //           child: Column(
  //             children: [
  //               SizedBox(
  //                 height: 11.h,
  //               ),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     flex: 3,
  //                     child: Column(
  //                       children: [
  //                         SizedBox(
  //                           height: 22.h,
  //                           child: Row(
  //                             children: [
  //                               SizedBox(
  //                                 width: 10.w,
  //                               ),
  //                               Text(
  //                                 keydata["cnname"],
  //                                 style: TextStyle(
  //                                     fontSize: 17.sp,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                               const Expanded(child: SizedBox()),
  //                             ],
  //                           ),
  //                         ),
  //                         Row(
  //                           children: [
  //                             SizedBox(
  //                               width: 10.w,
  //                             ),
  //                             Text(
  //                               keydata["keynumbet"] == ""
  //                                   ? ""
  //                                   : "（" + keydata["keynumbet"] + "）",
  //                               style: TextStyle(
  //                                   fontSize: 10.sp, color: Colors.red),
  //                             ),
  //                             Expanded(child: SizedBox())
  //                           ],
  //                         ),
  //                         SizedBox(
  //                             width: 138.w,
  //                             height: 38.h,
  //                             child: Image.file(
  //                               File(appData.keyImagePath +
  //                                   "/key/" +
  //                                   keydata["picname"]),
  //                             )),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 23.w,
  //                   ),
  //                   Expanded(
  //                       flex: 2,
  //                       child: Stack(
  //                         children: [
  //                           Align(
  //                             alignment: Alignment.topLeft,
  //                             child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text("中间沟槽:" +
  //                                       (getmgroove(keydata) ? "有" : "无")),
  //                                   Text("上沟槽:" +
  //                                       (getugroove(keydata) ? "有" : "无")),
  //                                   Text("下沟槽:" +
  //                                       (getlgroove(keydata) ? "有" : "无")),
  //                                   Text("头部:" +
  //                                       (keydata["headtype"] == 0 ? "无" : "有")),
  //                                   Container(
  //                                       width: 68.r,
  //                                       height: 28.r,
  //                                       decoration: BoxDecoration(
  //                                           color: Color(0xff384c70)),
  //                                       child: TextButton(
  //                                         style: ButtonStyle(
  //                                             padding:
  //                                                 MaterialStateProperty.all(
  //                                                     EdgeInsets.zero)),
  //                                         onPressed: () {
  //                                           if (keyDataList[i]["userid"]
  //                                                   .toString() ==
  //                                               appData.id.toString()) {
  //                                             Fluttertoast.showToast(
  //                                                 msg: "已有此资源,无需下载");
  //                                           } else {
  //                                             showDialog(
  //                                                 context: (context),
  //                                                 builder: (c) {
  //                                                   return MyTextDialog(
  //                                                       "是否消耗${keyDataList[i]["price"]}积分下载此资源?");
  //                                                 }).then((value) async {
  //                                               if (value) {
  //                                                 debugPrint("下载");
  //                                                 if (appData.integral <
  //                                                     keyDataList[i]["price"]) {
  //                                                   Fluttertoast.showToast(
  //                                                       msg: "积分不足");
  //                                                 } else {
  //                                                   var result = await Api
  //                                                       .updatauserinfo({
  //                                                     "account":
  //                                                         appData.account,
  //                                                     "integral":
  //                                                         appData.integral
  //                                                   });
  //                                                   if (result["state"]) {
  //                                                     appData.upgradeAppData({
  //                                                       "integral":
  //                                                           appData.integral -
  //                                                               keyDataList[i]
  //                                                                   ["price"]
  //                                                     });
  //                                                     await saveData(
  //                                                         keyDataList[i]);
  //                                                     Fluttertoast.showToast(
  //                                                         msg: "下载成功!");
  //                                                   } else {
  //                                                     Fluttertoast.showToast(
  //                                                         msg: "下载失败!");
  //                                                   }
  //                                                 }
  //                                                 // Fluttertoast.showToast(
  //                                                 // msg: "下载完成后,保存到我的钥匙,前提账户已登陆");
  //                                               }
  //                                             });
  //                                           }
  //                                         },
  //                                         child: Text("下载"),
  //                                       )),
  //                                 ]),
  //                           ),
  //                         ],
  //                       )),
  //                   SizedBox(
  //                     width: 10.w,
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 13.h,
  //               ),
  //               SizedBox(
  //                 height: 22.h,
  //                 width: 300.w,
  //                 child: Text(
  //                   "备注",
  //                   textAlign: TextAlign.left,
  //                   style: TextStyle(
  //                       color: Colors.red,
  //                       fontSize: 10.sp,
  //                       overflow: TextOverflow.ellipsis),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 22.h,
  //                 width: 300.w,
  //                 child: Text("用户名:${keyDataList[i]["username"]}"),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       onPressed: () {
  //         // Navigator.pushNamed(context, '/keyshow',
  //         // widget.arguments: {"keydata": showlist[i]});
  //       },
  //       onLongPress: () {},
  //     ));
  //     // temp.add(
  //     //   Container(
  //     //     height: 150.0,
  //     //     decoration: BoxDecoration(
  //     //       color: Colors.grey[200],
  //     //       border: Border.all(
  //     //         width: 3,
  //     //         color: Colors.grey,
  //     //       ),
  //     //       borderRadius: const BorderRadius.all(Radius.circular(20.0)),
  //     //     ),
  //     //     child: Row(
  //     //       children: [
  //     //         Expanded(
  //     //           child: Column(
  //     //             crossAxisAlignment: CrossAxisAlignment.start,
  //     //             children: [
  //     //               Text("用户名:${keyDataList[i]["username"]}"),
  //     //               Text("品牌:${keyDataList[i]["carname"]}"),
  //     //               Text("特殊说明:${keyDataList[i]["chnote"]}"),
  //     //             ],
  //     //           ),
  //     //         ),
  //     //         Expanded(
  //     //           child: Column(
  //     //             crossAxisAlignment: CrossAxisAlignment.end,
  //     //             children: [
  //     //               TextButton(
  //     //                 onPressed: () {},
  //     //                 child: const Icon(Icons.favorite_border),
  //     //               ),
  //     //               ElevatedButton(
  //     //                 onPressed: () {
  //     //                   if (keyDataList[i]["userid"].toString() ==
  //     //                       appData.id.toString()) {
  //     //                     Fluttertoast.showToast(msg: "已有此资源,无需下载");
  //     //                   } else {
  //     //                     showDialog(
  //     //                         context: (context),
  //     //                         builder: (c) {
  //     //                           return MyTextDialog(
  //     //                               "是否消耗${keyDataList[i]["price"]}积分下载此资源?");
  //     //                         }).then((value) async {
  //     //                       if (value) {
  //     //                         debugPrint("下载");
  //     //                         if (appData.integral < keyDataList[i]["price"]) {
  //     //                           Fluttertoast.showToast(msg: "积分不足");
  //     //                         } else {
  //     //                           var result = await Api.updatauserinfo({
  //     //                             "account": appData.account,
  //     //                             "integral": appData.integral
  //     //                           });
  //     //                           if (result["state"]) {
  //     //                             appData.upgradeAppData({
  //     //                               "integral": appData.integral -
  //     //                                   keyDataList[i]["price"]
  //     //                             });
  //     //                             await saveData(keyDataList[i]);
  //     //                             Fluttertoast.showToast(msg: "下载成功!");
  //     //                           } else {
  //     //                             Fluttertoast.showToast(msg: "下载失败!");
  //     //                           }
  //     //                         }
  //     //                         // Fluttertoast.showToast(
  //     //                         // msg: "下载完成后,保存到我的钥匙,前提账户已登陆");
  //     //                       }
  //     //                     });
  //     //                   }
  //     //                 },
  //     //                 child: const Text("下载"),
  //     //               ),
  //     //               Text("此资源需要${keyDataList[i]["price"]}积分"),
  //     //               const Text("已有10人点赞"),
  //     //             ],
  //     //           ),
  //     //         ),
  //     //       ],
  //     //     ),
  //     //   ),
  //     // );

  //     // temp.add(const SizedBox(
  //     //   height: 20,
  //     // ));
  //   }
  //   return temp;
  // }

  Widget stateWidget() {
    switch (state) {
      case 0:
        return const Expanded(
            child: SizedBox(
                child: Center(
          child: Text("加载中。。。"),
        )));
      case 1:
        return const Expanded(
            child: SizedBox(
                child: Center(
          child: Text(
            "未找到数据。。。",
          ),
        )));
      default:
        return const SizedBox();
    }
  }

  _search(text) {
    showKeyDataList = [];
    if (text.isEmpty) {
      //debugPrint("空");
      showKeyDataList = List.from(origKeyDataList);
    } else {
      List list = origKeyDataList.where((v) {
        //  ////print(v["cnname"].toLowerCase().contains(text.toLowerCase()));
        var keydata = json.decode(v["data"]);

        return (keydata["carname"] + keydata["cnname"] + keydata["enname"])
            .toLowerCase()
            .contains(text.toLowerCase());
      }).toList();
      if (list.isNotEmpty) {
        showKeyDataList = List.from(list);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: const [
            Align(
              child: Text(
                "模型共享市场",
                style: TextStyle(fontSize: 30),
              ),
              alignment: Alignment.center,
            ),
          ],
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
                  //    focusNode: _focusNode,
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
            children: keyDataWidget(),
          ),
        ),
      ],
    );
  }
}
