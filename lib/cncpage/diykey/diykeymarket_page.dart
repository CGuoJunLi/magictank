import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/userappbar.dart';

//服务器分组每次刷新10笔数据
//访问服务器时需要 提供页数
//服务器保存规则
//diytank1.json //保存品牌
//diytank3.json //保存数据
//先获取车型列表  再获取 钥匙列表
class DiyKeyMarketPage extends StatelessWidget {
  const DiyKeyMarketPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const DiyKeyMarket(),
    );
  }
}

class DiyKeyMarket extends StatefulWidget {
  const DiyKeyMarket({Key? key}) : super(key: key);

  @override
  State<DiyKeyMarket> createState() => _DiyKeyMarketState();
}

class _DiyKeyMarketState extends State<DiyKeyMarket> {
  List origKeyDataList = [];
  List showKeyDataList = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    origKeyDataList = await Api.getSharedKey("model=0");
    showKeyDataList = List.from(origKeyDataList);
    ////print(keyDataList);
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
      var result = await Api.upUserKey(data);
      if (result["state"]) {
        data["state"] = 1;
        await appData.insertUserKey(data);
      } else {
        await appData.insertUserKey(data);
      }
    } catch (e) {
      await appData.insertUserKey(data);
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${S.of(context).user}:${showKeyDataList[i]["username"]}",
                              style: TextStyle(fontSize: 15.sp),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "需要:${showKeyDataList[i]["price"]}积分",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 10.r),
                              textAlign: TextAlign.left,
                            )
                          ],
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
                                Fluttertoast.showToast(
                                    msg: S.of(context).havedata);
                              } else {
                                print(showKeyDataList[i]);
                                showDialog(
                                    context: (context),
                                    builder: (c) {
                                      return MyTextDialog(
                                          S.of(context).askdowndata +
                                              "${showKeyDataList[i]["price"]}");
                                    }).then((value) async {
                                  if (value) {
                                    debugPrint("下载");

                                    if (appData.integral <
                                        showKeyDataList[i]["price"]) {
                                      Fluttertoast.showToast(
                                          msg: S.of(context).tokenno);
                                    } else {
                                      var result = await Api.updatauserinfo({
                                        "account": appData.account,
                                        "integral": appData.integral -
                                            showKeyDataList[i]["price"]
                                      });
                                      if (result["state"]) {
                                        await appData.upgradeAppData({
                                          "integral": appData.integral -
                                              showKeyDataList[i]["price"]
                                        });
                                        await saveData(showKeyDataList[i]);
                                        Fluttertoast.showToast(
                                            msg: S.of(context).downfileok);
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
                                        print(result);
                                        Fluttertoast.showToast(
                                            msg: S.of(context).downfileerror);
                                      }
                                    }
                                    // Fluttertoast.showToast(
                                    // msg: "下载完成后,保存到我的钥匙,前提账户已登陆");
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
                          S.of(context).keynumber +
                              ":" +
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
                          S.of(context).note +
                              ":" +
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
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          _gettooth(keydata) + S.of(context).keycuts,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          getkeylength(keydata),
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          keydata["locat"].toString() == "0"
                              ? (S.of(context).keyloact +
                                  ":" +
                                  S.of(context).keylocat0)
                              : (S.of(context).keyloact +
                                  ":" +
                                  S.of(context).keylocat1),
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          getkeyclass(keydata),
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
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
          children: [
            Align(
              child: Text(
                S.of(context).sharesmart,
                style: const TextStyle(fontSize: 30),
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
