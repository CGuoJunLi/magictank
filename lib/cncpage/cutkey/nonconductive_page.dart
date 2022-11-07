import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../appdata.dart';

class NonConductivePage extends StatefulWidget {
  const NonConductivePage({Key? key}) : super(key: key);

  @override
  _NonConductivePageState createState() => _NonConductivePageState();
}

class _NonConductivePageState extends State<NonConductivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: const KeyDataList(),
    );
  }
}

class KeyDataList extends StatefulWidget {
  const KeyDataList({Key? key}) : super(key: key);

  @override
  _KeyDataListState createState() => _KeyDataListState();
}

class _KeyDataListState extends State<KeyDataList> {
  List<dynamic> originallist = [];
  List<dynamic> showlist = [];
  bool hightSearchState = false;
  var iconData = const Icon(Icons.keyboard_arrow_right);
  late ProgressDialog pd;
  List starkey = [];
  @override
  void initState() {
    super.initState();
    pd = ProgressDialog(context: context);
    //_getlist();
    getkeylist();
    //keydata = List.from(allkeyllsit);
  }

//先储存到本地
//然后上传到服务器
//如果成功 修改本地的数据的状态为 state3
  void getkeylist() {
    originallist = [];
    for (var i = 0; i < appData.carkeyList.length; i++) {
      if (appData.carkeyList[i]["nonconductive"]) {
        originallist.add(appData.carkeyList[i]);
      }
    }
    // originallist.addAll(appData.carkeyList);
    showlist = List.from(originallist);
  }

  String toothshow(Map keydata) {
    if (keydata["side"] == 3 && keydata["class"] != 0) {
      return "${keydata["toothSA"].length}-${keydata["toothSA"].length}齿";
    } else {
      return "${keydata["toothSA"].length}齿";
    }
  }

  String wideshow(Map keydata) {
    if (keydata["locat"] == 1) {
      return "${keydata["wide"]}*${keydata["toothSA"][0] + 500}";
    } else {
      return "${keydata["wide"]}*${keydata["toothSA"][keydata["toothSA"].length - 1] + 500}";
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

  List<Widget> getkeydatalist() {
    List<Widget> temp = [];
    for (int index = 0; index < showlist.length; index++) {
      temp.add(TextButton(
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
          //传入钥匙数据即可
          //先显示操作说明
          // baseKey.nonconductive = true;
          //baseKey.cKeyData = Map.from(showlist[i]);
          // //print(showlist[i]);
          baseKey.initdata(showlist[index], isNonConductiveKey: true);
          if (showlist[index]["locat"] == 0) {
            Navigator.pushNamed(context, '/openclamp',
                arguments: {"state": 0, "type": 5});
          } else {
            Navigator.pushNamed(context, '/keyshow', arguments: {"type": 5});
          }
          // Navigator.pushNamed(context, '/keyshow',
          // arguments: {"keydata": showlist[index]["keydata"][i]});
        },
      ));
    }
    return temp;
  }

  void _search(String text) {
    if (text.isEmpty) {
      //debugPrint("空");
      showlist = List.from(originallist);
    } else {
      List list = originallist.where((v) {
        //  ////print(v["cnname"].toLowerCase().contains(text.toLowerCase()));
        return v["cnname"].toLowerCase().contains(text.toLowerCase());
      }).toList();
      showlist = List.from(list);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  // focusNode: _focusNode,
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
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: getkeydatalist(),
          ),
        ),
      ],
    );
  }
}
