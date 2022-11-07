import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/cncpage/mycontainer.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../appdata.dart';

class DiyKeyStepPage extends StatefulWidget {
  const DiyKeyStepPage({Key? key}) : super(key: key);

  @override
  _DiyKeyStepPageState createState() => _DiyKeyStepPageState();
}

class _DiyKeyStepPageState extends State<DiyKeyStepPage> {
  late ProgressDialog pd;
  String keytitle = "";
  int seleside = 0;
  int atooth = 2;
  int toothnum = 2;
  int btooth = 2;
  int diykeystep = 1; //步骤记录器
  //final ScrollController _controller = ScrollController();
  late Map keydata;

  late FocusScopeNode _focusScopeNode;
  String cutdepth = "10-110";
  String keythinkness = "280-500";
  String groovewide = "280-500"; //沟槽宽度
  RegExp onlynum = RegExp(r'[0-9]+'); //数字和和字母组成
  List<Map> keyclasslist = [
    {
      "name": S.current.keyclass0,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass0.png"
    },
    {
      "name": S.current.keyclass1,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass1.png"
    },
    {
      "name": S.current.keyclass2,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass2.png"
    },
    {
      "name": S.current.keyclass5,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass5.png"
    },
    {
      "name": S.current.keyclass3,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass3.png"
    },
    {
      "name": S.current.keyclass4,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass4.png"
    },
    {
      "name": S.current.keyclass6,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass31.png"
    },
    {
      "name": S.current.keyclass7,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass11.png"
    },
  ];
  List<Map> keylocatelist = [
    {
      "name": S.current.keylocat1,
      "pic": appData.keyImagePath + "/fixture/diykey/locat_head.png"
    },
    {
      "name": S.current.keylocat0,
      "pic": appData.keyImagePath + "/fixture/diykey/locat_shoulder.png"
    },
  ];

  List<String> keyfixturelist = [
    S.current.keyside5,
    S.current.keyside6,
  ];
  List<String> keyfixturelis5 = [
    S.current.keyside6,
  ];
  List<String> keyfixturelist3 = [
    S.current.keyside0,
    S.current.keyside1,
    S.current.keyside3,
    S.current.keyside4,
  ];
  String currentkeypic = "";
  String currentfixturepic = "";
  late Map<String, dynamic> adddata;
  @override
  void initState() {
    _initkeydata();
    _focusScopeNode = FocusScopeNode();

    diykeystep = 1;
    pd = ProgressDialog(context: context);

    super.initState();
  }

  _initkeydata() {
    atooth = 2;
    toothnum = 2;
    btooth = 2;
    keydata = {
      "carname": "",
      "carmodel": "",
      "carmodeltime": "",
      "hide": false,
      "cnname": "",
      "enname": "",
      "picname": "",
      "indexes": "",
      "id": 0,
      "smart": false,
      "nonconductive": false,
      "fixture": [5],
      "groove": 0,
      "class": 0,
      "locat": 1,
      "side": 0,
      "wide": 0,
      "thickness": 0,
      "length": 0,
      "depth": 0,
      "A": 0,
      "AX": 0,
      "B": 0,
      "BX": 0,
      "headAx": 0,
      "headAy": 0,
      "headBx": 0,
      "headBy": 0,
      "headCx": 0,
      "headCy": 0,
      "headDx": 0,
      "headDy": 0,
      "toothSA": [0, 0],
      "toothWideA": [100, 100],
      "toothSB": [0, 0],
      "toothWideB": [100, 100],
      "toothDepth": [0, 0],
      "toothDepthName": ["1", "2"],
      "keynumbet": "",
      "chnote": "无",
      "ennote": "NULL",
      "moreside": [],
    };
  }

  Future<void> addDiyKey() async {
    adddata = {
      "userid": appData.id,
      "timer": DateTime.now().toString().substring(0, 19),
      "data": json.encode(keydata),
      "state": 0,
      "shared": "false",
      "use": "false",
    };
    try {
      var result = await Api.upUserKey(adddata);

      if (result["state"]) {
        adddata["state"] = 1;

        await appData.insertUserKey(adddata);
      } else {
        await appData.insertUserKey(adddata);
      }
    } catch (e) {
      await appData.insertUserKey(adddata);
    }
  }

  bool step4check() {
    switch (keydata["class"]) {
      case 2:
      case 3:
      case 4:
      case 5:
        if ((keydata["depth"] > keydata["thickness"])) {
          Fluttertoast.showToast(msg: S.of(context).diykeytip1);
          return false;
        }
        if (keydata["class"] == 5) {
          if ((keydata["groove"] > keydata["wide"])) {
            Fluttertoast.showToast(msg: S.of(context).diykeytip2);
            return false;
          }
        }
        break;

      default:
        if (keydata["wide"] < 400 || keydata["wide"] > 1100) {
          Fluttertoast.showToast(msg: S.of(context).diykeytip11);
          return false;
        }
        if ((keydata["thickness"] < 180 || keydata["thickness"] > 500) &&
            (keydata["class"] != 0 && keydata["class"] != 1)) {
          Fluttertoast.showToast(msg: S.of(context).diykeytip12);
          return false;
        }
        break;
    }
    if ((keydata["depth"] == 0 || keydata["depth"] > 110) &&
        (keydata["class"] != 0 && keydata["class"] != 1)) {
      Fluttertoast.showToast(msg: S.of(context).diykeytip13);
      return false;
    }
    return true;
  }

  bool step5check() {
    if (keydata["locat"] == 1) {
      for (var i = 0; i < atooth - 1; i++) {
        if (keydata["toothSA"][i] < keydata["toothSA"][i + 1]) {
          Fluttertoast.showToast(msg: S.of(context).diykeytip3);
          return false;
        }
        if (keydata["toothSA"][i] <= 0) {
          Fluttertoast.showToast(msg: S.of(context).diykeytip4);
          return false;
        }
      }
      if (keydata["side"] == 3) {
        for (var i = 0; i < btooth - 1; i++) {
          if (keydata["toothSB"][i] < keydata["toothSB"][i + 1]) {
            Fluttertoast.showToast(msg: S.of(context).diykeytip5);
            return false;
          }
          if (keydata["toothSB"][i] <= 0) {
            Fluttertoast.showToast(msg: S.of(context).diykeytip4);
            return false;
          }
        }
      }
    } else {
      for (var i = 0; i < atooth - 1; i++) {
        if (keydata["toothSA"][i] > keydata["toothSA"][i + 1]) {
          Fluttertoast.showToast(msg: S.of(context).diykeytip6);
          return false;
        }
        if (keydata["toothSA"][i] <= 0) {
          Fluttertoast.showToast(msg: S.of(context).diykeytip4);
          return false;
        }
      }
      if (keydata["side"] == 3) {
        for (var i = 0; i < btooth - 1; i++) {
          if (keydata["toothSB"][i] > keydata["toothSB"][i + 1]) {
            Fluttertoast.showToast(msg: S.of(context).diykeytip7);
            return false;
          }
          if (keydata["toothSB"][i] <= 0) {
            Fluttertoast.showToast(msg: S.of(context).diykeytip4);
            return false;
          }
        }
      }
    }

    return true;
  }

  bool step7check() {
    for (var i = 0; i < toothnum - 1; i++) {
      if (keydata["toothDepth"][i] < keydata["toothDepth"][i + 1]) {
        Fluttertoast.showToast(msg: S.of(context).diykeytip8);
        return false;
      }
      if (keydata["toothDepth"][i] <= 0) {
        Fluttertoast.showToast(msg: S.of(context).diykeytip9);
        return false;
      }
    }
    return true;
  }

  String getStep4Pic() {
    return appData.keyImagePath +
        "/fixture/diykey/${keydata["class"]}_${keydata["locat"]}_0_0.png";
  }

  String getStep5Pic() {
    return appData.keyImagePath +
        "/fixture/diykey/${keydata["class"]}_${keydata["locat"]}_${seleside}_1.png";
  }

  String getStep6Pic() {
    return appData.keyImagePath +
        "/fixture/diykey/${keydata["class"]}_${keydata["locat"]}_${seleside}_2.png";
  }

  String getStep7Pic() {
    return appData.keyImagePath +
        "/fixture/diykey/${keydata["class"]}_${keydata["locat"]}_${seleside}_3.png";
  }

  String getStep8Pic() {
    if (keydata["class"] == 3) {
      seleside = keydata["side"];
    }
    return appData.keyImagePath +
        "/fixture/diykey/head_${keydata["class"]}_$seleside.png";
  }

  String getStep9Pic() {
    return appData.keyImagePath + "/key/" + keydata["picname"];
  }

  String getfixturepic(int keyfixture, int side) {
    int fixtruetype = 0;

    if (cncVersion.fixtureType == 21) {
      fixtruetype = 1;
    } else {
      fixtruetype = 0;
    }
    currentfixturepic = appData.keyImagePath +
        "/fixture/diykey/${fixtruetype}_$keyfixture" +
        "${keydata["class"]}_${side}_${keydata["locat"]}.png";
    return currentfixturepic;
  }

  Widget keyclassbt(index) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      onPressed: () {
        setState(() {
          keytitle = "";
          keytitle = keytitle + keyclasslist[index]["name"];
          _initkeydata();
          // currentkeypic = keyclasslist[index]["pic"];
          switch (index) {
            case 0:
              keydata["class"] = 0;
              keydata["side"] = 2;
              keydata["fixture"] = [5];
              break;
            case 1:
              keydata["class"] = 1;
              keydata["side"] = 0;
              keydata["fixture"] = [5];
              break;
            case 2:
              keydata["class"] = 2;
              break;
            case 3:
              keydata["class"] = 5;
              break;
            case 4:
              keydata["class"] = 3;
              break;
            case 5:
              keydata["class"] = 4;
              break;
            case 6:
              keydata["class"] = 3;
              keydata["fixture"] = [1];
              keydata["side"] = 0;
              break;
            case 7:
              keydata["class"] = 1;
              keydata["fixture"] = [1];
              keydata["side"] = 0;
              break;
            case 8:
              break;
            case 9:
              break;
          }
          diykeystep = 2;
        });
      },
      child: myContainer(155.w, 126.h, 23.h, keyclasslist[index]["name"],
          keyclasslist[index]["pic"], EdgeInsets.zero),
    );
  }

  Widget keyclass(context, index) {
    return Row(
      children: [
        SizedBox(
          width: 9.w,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.r, bottom: 45.r),
          child: keyclassbt(index * 2),
        ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.only(right: 10.r, bottom: 45.r),
          child: keyclassbt(index * 2 + 1),
        ),
        SizedBox(
          width: 9.w,
        ),
      ],
    );
  }

  List<Widget> keyfixture() {
    List<Widget> temp = [];
    // List<Widget> temp2 = [];
    //立铣外沟单边
    if (keydata["class"] == 3 || keydata["class"] == 5) {
      if (keydata["fixture"][0] == 1) {
        temp.add(
          TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              onPressed: () {
                setState(() {
                  diykeystep = 4;
                });
              },
              child: myContainer(340.w, 193.w, 23.w, S.of(context).keyfixture1,
                  getfixturepic(1, 0), EdgeInsets.only(top: 10.w))),
        );
      } else {
        for (var i = 0; i < keyfixturelist3.length; i++) {
          temp.add(
            TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: () {
                  setState(() {
                    switch (i) {
                      case 0:
                        keydata["side"] = 0;
                        seleside = 0;
                        keydata["fixture"] = [3];
                        break;
                      case 1:
                        keydata["side"] = 1;
                        seleside = 1;
                        keydata["fixture"] = [4];
                        break;
                      case 2: //薄
                        keydata["side"] = 0;
                        seleside = 0;
                        keydata["fixture"] = [5];
                        break;

                      case 3: //薄
                        keydata["side"] = 1;
                        seleside = 1;
                        keydata["fixture"] = [5];
                        break;
                    }

                    diykeystep = 4;
                    //state = 0;
                  });
                },
                child: myContainer(
                    340.w,
                    193.w,
                    23.w,
                    keyfixturelist3[i],
                    getfixturepic(i > 1 ? 5 : 0, i % 2),
                    EdgeInsets.only(top: 10.w))),
          );
        }
      }
    } else {
      if (keydata["class"] != 0 && keydata["class"] != 1) {
        for (var i = 0; i < keyfixturelist.length; i++) {
          temp.add(
            TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: () {
                  setState(() {
                    keydata["side"] = 3;
                    if (i == 0) {
                      keydata["fixture"] = [0];
                    } else {
                      keydata["fixture"] = [5];
                    }
                    diykeystep = 4;
                    //state = 0;
                  });
                },
                child: myContainer(
                    340.w,
                    193.w,
                    23.w,
                    keyfixturelist[i],
                    getfixturepic(i == 0 ? 0 : 5, 2),
                    EdgeInsets.only(top: 10.w))),
          );
        }
      } else {
        //平铣类型
        temp.add(
          TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              onPressed: () {
                if (keydata["fixture"][0] == 5 && keydata["class"] > 1) {
                  keythinkness = "100-300";
                }
                setState(() {
                  diykeystep = 4;
                });
              },
              child: myContainer(
                  340.w,
                  193.w,
                  23.w,
                  keydata["fixture"][0] == 1
                      ? S.of(context).keyfixture1
                      : keyfixturelis5[0],
                  getfixturepic(
                      keydata["fixture"][0], keydata["class"] == 0 ? 2 : 0),
                  EdgeInsets.only(top: 10.w))),
        );
      }
    }

    return temp;
  }

  List<Widget> keylocate() {
    List<Widget> temp = [];
    int a = 0;
    int b = 0;
    if (keydata["fixture"] == 1) {
      if (keydata["class"] == 1) {
        a = 1;
      } else {
        b = 1;
      }
    }

    for (var i = a; i < keylocatelist.length - b; i++) {
      temp.add(
        TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            onPressed: () {
              keytitle = keytitle + "-" + keylocatelist[i]["name"];
              switch (i) {
                case 0:
                  keydata["locat"] = 1;
                  break;
                case 1:
                  keydata["locat"] = 0;
                  break;
                default:
              }

              diykeystep = 3;
              getkeypng();
              setState(() {});
            },
            child: myContainer(340.w, 126.w, 23.h, keylocatelist[i]["name"],
                keylocatelist[i]["pic"], EdgeInsets.only(top: 23.r))),
      );
    }
    return temp;
  }

  List<Widget> keyclip() {
    List<Widget> temp = [
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: SizedBox(
          height: 20,
          child: Stack(
            children: const [
              Align(
                child: Text(""),
              )
            ],
          ),
        ),
      )
    ];
    return temp;
  }

  RegExp limteinput(int num) {
    RegExp temp = RegExp(r'([1-9][0-9]{0,' + num.toString() + '})'); //数字和和字母组成
    return temp;
  }

  List<DropdownMenuItem<dynamic>> toothnumitem() {
    List<DropdownMenuItem<dynamic>> temp = [];
    for (var i = 2; i < 16; i++) {
      temp.add(
        DropdownMenuItem(
          child: Text("$i"),
          value: i - 2,
        ),
      );
    }
    return temp;
  }

  Widget onetoothshow(index) {
    return SizedBox(
        width: 137.w,
        height: 18.h,
        child: Row(
          children: [
            Text("${S.of(context).keytoothnum}:${index + 1}:"),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: seleside == 0
                        ? "${keydata["toothSA"][index]}"
                        : "${keydata["toothSB"][index]}"),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  //Pattern x
                  FilteringTextInputFormatter.allow(
                      RegExp(r'([1-9][0-9]{0,3})')),
                  // WhitelistingTextInputFormatter(accountRegExp),
                ],
                onChanged: (value) {
                  if (value == "") {
                    seleside == 0
                        ? keydata["toothSA"][index] = 0
                        : keydata["toothSB"][index] = 0;
                  } else {
                    seleside == 0
                        ? keydata["toothSA"][index] = int.parse(value)
                        : keydata["toothSB"][index] = int.parse(value);
                  }
                },
              ),
            ),
          ],
        ));
  }

  Widget gettoothListData(context, index) {
    int sideindex = seleside == 0 ? atooth : btooth;
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          onetoothshow(index * 2),
          (sideindex % 2 == 1 && index * 2 + 1 == sideindex)
              ? SizedBox(
                  width: 137.w,
                  height: 18.h,
                )
              : onetoothshow(index * 2 + 1)
        ],
      ),
    );
  }

  Widget onetoothwideshow(index) {
    return SizedBox(
        width: 137.w,
        height: 18.h,
        child: Row(
          children: [
            Text("${S.of(context).keytoothwide}:${index + 1}"),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: seleside == 0
                        ? "${keydata["toothWideA"][index]}"
                        : "${keydata["toothWideB"][index]}"),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  //Pattern x
                  FilteringTextInputFormatter.allow(
                      RegExp(r'([1-9][0-9]{0,3})')),
                  // WhitelistingTextInputFormatter(accountRegExp),
                ],
                onChanged: (value) {
                  if (value == "") {
                    seleside == 0
                        ? keydata["toothWideA"][index] = 0
                        : keydata["toothWideB"][index] = 0;
                  } else {
                    seleside == 0
                        ? keydata["toothWideA"][index] = int.parse(value)
                        : keydata["toothWideB"][index] = int.parse(value);
                  }
                },
              ),
            ),
          ],
        ));
  }

  Widget gettoothwideListData(context, index) {
    int sideindex = seleside == 0 ? atooth : btooth;

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          onetoothwideshow(index * 2),
          (sideindex % 2 == 1 && index * 2 + 1 == sideindex)
              ? SizedBox(
                  width: 137.w,
                  height: 18.h,
                )
              : onetoothwideshow(index * 2 + 1)
        ],
      ),
    );
  }

  Widget onetoothdepthshow(index) {
    return SizedBox(
        width: 137.w,
        height: 18.h,
        child: Row(
          children: [
            Text("${S.of(context).keytoothdepth}:${index + 1}"),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: "${keydata["toothDepth"][index]}"),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  //Pattern x
                  FilteringTextInputFormatter.allow(
                      RegExp(r'([1-9][0-9]{0,3})')),
                  // WhitelistingTextInputFormatter(accountRegExp),
                ],
                onChanged: (value) {
                  if (value == "") {
                    keydata["toothDepth"][index] = 0;
                  } else {
                    keydata["toothDepth"][index] = int.parse(value);
                  }
                },
              ),
            ),
          ],
        ));
  }

  Widget gettoothdepthListData(context, index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          onetoothdepthshow(index * 2),
          (toothnum % 2 == 1 && index * 2 + 1 == toothnum)
              ? SizedBox(
                  width: 137.w,
                  height: 18.h,
                )
              : onetoothdepthshow(index * 2 + 1)
        ],
      ),
    );
  }

  getkeypng() {
    if (keydata["class"] == 0 || keydata["class"] == 1) {
      if (keydata["locat"] == 0) {
        keydata["picname"] = "GPJ.png";
      } else {
        keydata["picname"] = "GPT.png";
      }
    } else {
      if (keydata["locat"] == 0) {
        keydata["picname"] = "GLJ.png";
      } else {
        keydata["picname"] = "GLT.png";
      }
    }
  }

  List<Widget> headPointList() {
    List<Widget> temp = [];
    int pointx1 = 0;
    int pointy1 = 0;
    int pointx2 = 0;
    int pointy2 = 0;
    if (seleside == 0) {
      pointx1 = keydata["headAx"];
      pointy1 = keydata["headAy"];
      pointx2 = keydata["headBx"];
      pointy2 = keydata["headBy"];
    } else {
      pointx1 = keydata["headCx"];
      pointy1 = keydata["headCy"];
      pointx2 = keydata["headDx"];
      pointy2 = keydata["headDy"];
    }
    temp.add(Container(
      width: 320.w,
      height: 125.h,
      margin: EdgeInsets.only(left: 21.w, right: 21.w, top: 15.h, bottom: 15.h),
      child: Center(child: Image.file(File(getStep8Pic()))),
      color: Colors.white,
    ));

    temp.add(Row(
      children: [
        const Expanded(
          child: const SizedBox(),
          flex: 1,
        ),
        const Text("AX:"),
        SizedBox(
            width: 100.r,
            child: TextField(
              controller: TextEditingController(text: pointx1.toString()),
              showCursor: true,
              enableInteractiveSelection: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                //  LengthLimitingTextInputFormatter(16),
                //  WhitelistingTextInputFormatter(accountRegExp),
                FilteringTextInputFormatter(onlynum, allow: true),
              ],
              onChanged: (value) {
                if (value != "") {
                  if (seleside == 0) {
                    keydata["headAx"] = int.parse(value);
                  } else {
                    keydata["headCx"] = int.parse(value);
                  }
                } else {
                  if (seleside == 0) {
                    keydata["headAx"] = 0;
                  } else {
                    keydata["headCX"] = 0;
                  }
                }
              },
            )),
        const Expanded(
          child: SizedBox(),
          flex: 2,
        ),
        const Text("AY:"),
        SizedBox(
          width: 100.r,
          child: TextField(
            controller: TextEditingController(text: pointy1.toString()),
            showCursor: true,
            enableInteractiveSelection: false,
            keyboardType: TextInputType.number,
            inputFormatters: [
              //  LengthLimitingTextInputFormatter(16),
              //  WhitelistingTextInputFormatter(accountRegExp),
              FilteringTextInputFormatter(onlynum, allow: true),
            ],
            onChanged: (value) {
              if (value != "") {
                if (seleside == 0) {
                  keydata["headAy"] = int.parse(value);
                } else {
                  keydata["headCy"] = int.parse(value);
                }
              } else {
                if (seleside == 0) {
                  keydata["headAy"] = 0;
                } else {
                  keydata["headCy"] = 0;
                }
              }
            },
          ),
        ),
        const Expanded(
          child: SizedBox(),
          flex: 1,
        ),
      ],
    ));
    if (keydata["class"] != 0 && keydata["class"] != 1) {
      temp.add(Row(
        children: [
          const Expanded(
            child: SizedBox(),
            flex: 1,
          ),
          const Text("BX:"),
          SizedBox(
              width: 100.r,
              child: TextField(
                controller: TextEditingController(text: pointx2.toString()),
                showCursor: true,
                enableInteractiveSelection: false,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  //  LengthLimitingTextInputFormatter(16),
                  //  WhitelistingTextInputFormatter(accountRegExp),
                  FilteringTextInputFormatter(onlynum, allow: true),
                ],
                onChanged: (value) {
                  if (value != "") {
                    if (seleside == 0) {
                      keydata["headBx"] = int.parse(value);
                    } else {
                      keydata["headDx"] = int.parse(value);
                    }
                  } else {
                    if (seleside == 0) {
                      keydata["headBx"] = 0;
                    } else {
                      keydata["headDX"] = 0;
                    }
                  }
                },
              )),

          const Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          const Text("BY:"),
          SizedBox(
              width: 100.r,
              child: TextField(
                controller: TextEditingController(text: pointy2.toString()),
                showCursor: true,
                enableInteractiveSelection: false,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  //  LengthLimitingTextInputFormatter(16),
                  //  WhitelistingTextInputFormatter(accountRegExp),
                  FilteringTextInputFormatter(onlynum, allow: true),
                ],
                onChanged: (value) {
                  if (value != "") {
                    if (seleside == 0) {
                      keydata["headBy"] = int.parse(value);
                    } else {
                      keydata["headDy"] = int.parse(value);
                    }
                  } else {
                    if (seleside == 0) {
                      keydata["headBy"] = 0;
                    } else {
                      keydata["headDy"] = 0;
                    }
                  }
                },
              )),
          const Expanded(
            child: SizedBox(),
            flex: 1,
          ),
          // Text("一般Y为0即可"),
        ],
      ));
    }

    return temp;
  }

  Widget setawidget() {
    //print(keydata);
    switch (diykeystep) {
      case 1: //钥匙类型
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/9)${S.of(context).keyclass}",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return keyclass(context, index);
                  }),
            ),
          ],
        );
      case 2: //定位方式
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/9)" + S.of(context).keyloact,
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: keylocate(),
              ),
            ),
          ],
        );
      case 3: //装夹方式
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/9)${S.of(context).keyfixture}",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: keyfixture(),
              ),
            ),
          ],
        );
      case 4: //钥匙形状
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/9)${S.of(context).keyoutline}",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              width: 320.r,
              height: 150.r,
              child: Center(child: Image.file(File(getStep4Pic()))),
            ),
            Expanded(
              child: FocusScope(
                node: _focusScopeNode,
                child: ListView(children: [
                  Container(
                    height: 40.h,
                    color: const Color(0xffdde2ea),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "A:${S.of(context).keywide}:",
                        ),
                        SizedBox(
                          width: 200.w,
                          child: TextField(
                            controller: TextEditingController(
                                text: keydata["wide"] == 0
                                    ? ""
                                    : "${keydata["wide"]}"),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true),
                            decoration:
                                const InputDecoration(hintText: "550-1100"),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(16),
                              //Pattern x

                              FilteringTextInputFormatter.allow(
                                  RegExp(r'([1-9][0-9]{0,3})')),
                              // WhitelistingTextInputFormatter(accountRegExp),
                            ],
                            onChanged: (value) {
                              if (value == "") {
                                keydata["wide"] = 0;
                              } else {
                                keydata["wide"] = int.parse(value);
                              }
                              if (keydata["wide"] == 0) {
                                setState(() {});
                              }
                            },
                            onEditingComplete: () {
                              _focusScopeNode.nextFocus();
                              groovewide = "150-${keydata["wide"] / 2}";
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    height: 40.h,
                    color: const Color(0xffdde2ea),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "B:${S.of(context).keythickness}:",
                        ),
                        SizedBox(
                          width: 200.w,
                          child: TextField(
                            controller: TextEditingController(
                                text: keydata["thickness"] == 0
                                    ? ""
                                    : "${keydata["thickness"]}"),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true),
                            decoration: InputDecoration(hintText: keythinkness),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(16),
                              //Pattern x

                              FilteringTextInputFormatter.allow(
                                  RegExp(r'([1-9][0-9]{0,2})')),
                              // WhitelistingTextInputFormatter(accountRegExp),
                            ],
                            onChanged: (value) {
                              if (value == "") {
                                keydata["thickness"] = 0;
                              } else {
                                keydata["thickness"] = int.parse(value);
                              }
                              if (keydata["class"] == 0 ||
                                  keydata["class"] == 1) {
                                keydata["depth"] = keydata["thickness"];
                              }
                              if (keydata["thickness"] == 0) {
                                setState(() {});
                              }
                            },
                            onEditingComplete: () {
                              _focusScopeNode.nextFocus();

                              if (keydata["fixture"][0] != 5 &&
                                  keydata["class"] > 1) {
                                cutdepth =
                                    "10-${(keydata["thickness"] - 20) ~/ 2}";
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (keydata["class"] != 0 && keydata["class"] != 1)
                      ? Container(
                          height: 40.h,
                          color: const Color(0xffdde2ea),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("E:${S.of(context).keydepth}:"),
                              SizedBox(
                                width: 200.w,
                                child: TextField(
                                  readOnly:
                                      keydata["thickness"] == 0 ? true : false,
                                  controller: TextEditingController(
                                      text: keydata["depth"] == 0
                                          ? ""
                                          : "${keydata["depth"]}"),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: keydata["thickness"] == 0
                                        ? S.of(context).inputkeythicknesstip
                                        : cutdepth,
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(16),
                                    //Pattern x

                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'([1-9][0-9]{0,2})')),
                                    // WhitelistingTextInputFormatter(accountRegExp),
                                  ],
                                  onChanged: (value) {
                                    if (value == "") {
                                      keydata["depth"] = 0;
                                    } else {
                                      keydata["depth"] = int.parse(value);
                                    }
                                  },
                                  onTap: () {
                                    if (keydata["thickness"] == 0) {
                                      Fluttertoast.showToast(
                                          msg: S.of(context).inputkeywidetip);
                                    } else {}
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10.h,
                  ),
                  (keydata["class"] == 5)
                      ? Container(
                          height: 40.h,
                          color: const Color(0xffdde2ea),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("F:${S.of(context).keygroove}:"),
                              SizedBox(
                                width: 200.w,
                                child: TextField(
                                  readOnly: keydata["wide"] == 0 ? true : false,
                                  controller: TextEditingController(
                                      text: keydata["groove"] == 0
                                          ? ""
                                          : "${keydata["groove"]}"),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: keydata["wide"] == 0
                                        ? S.of(context).inputkeywidetip
                                        : groovewide,
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(16),
                                    //Pattern x

                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'([1-9][0-9]{0,2})')),
                                    // WhitelistingTextInputFormatter(accountRegExp),
                                  ],
                                  onChanged: (value) {
                                    if (value == "") {
                                      keydata["groove"] = 0;
                                    } else {
                                      keydata["groove"] = int.parse(value);
                                    }
                                  },
                                  onTap: () {
                                    if (keydata["wide"] == 0) {
                                      Fluttertoast.showToast(
                                          msg: S.of(context).inputkeywidetip);
                                    } else {
                                      groovewide =
                                          "150-${keydata["wide"] ~/ 2}";
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Text(
                    S.of(context).diykeytip10,
                    style: const TextStyle(color: Colors.red),
                  ),
                ]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                  height: 40.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: const Color(0xff384c70),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: TextButton(
                    child: Text(
                      S.of(context).nextstep,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      switch (diykeystep) {
                        case 4:
                          if (step4check()) {
                            setState(() {
                              diykeystep = 5;
                            });
                          }
                          break;
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      case 5: //钥匙齿距
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/9)" + S.of(context).keytoothsa,
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                children: [
                  keydata["side"] == 3
                      ? Container(
                          width: double.maxFinite,
                          height: 48.h,
                          color: const Color(0XFF384C70),
                          child: Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                  width: 100.w,
                                  height: 48.h,
                                  child: CheckboxListTile(
                                      title: const Text("A",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      value: seleside == 0 ? true : false,
                                      onChanged: (v) {
                                        seleside = 0;
                                        setState(() {});
                                      })),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                  width: 100.w,
                                  height: 48.h,
                                  child: CheckboxListTile(
                                      title: const Text("B",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      value: seleside == 1 ? true : false,
                                      onChanged: (v) {
                                        seleside = 1;
                                        setState(() {});
                                      })),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  Container(
                    width: 320.w,
                    height: 125.h,
                    margin: EdgeInsets.only(
                        left: 21.w, right: 21.w, top: 15.h, bottom: 15.h),
                    child: Center(
                      child: Image.file(File(getStep5Pic())),
                    ),
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 21.w,
                      ),
                      Text("${S.of(context).keytooth}:"),
                      SizedBox(
                        width: 10.w,
                      ),
                      DropdownButton<dynamic>(
                        value: seleside == 0 ? atooth - 2 : btooth - 2,
                        items: toothnumitem(),
                        onChanged: (value) {
                          value = value + 2;
                          if (keydata["side"] == 3) {
                            if (seleside == 0) {
                              //选择A边
                              atooth = value;
                              keydata["toothSA"] = [];
                              keydata["toothWideA"] = [];
                              for (var i = 0; i < atooth; i++) {
                                keydata["toothSA"].add(0);
                                keydata["toothWideA"].add(100);
                              }
                            } else {
                              //选择B边
                              btooth = value;
                              keydata["toothSB"] = [];
                              keydata["toothWideB"] = [];
                              for (var i = 0; i < btooth; i++) {
                                keydata["toothSB"].add(0);
                                keydata["toothWideB"].add(100);
                                //     }
                                ////print("keydata[\"toothWideB\"]${keydata["toothWideB"]}");
                              }
                            }
                          } else {
                            atooth = value;
                            btooth = value;
                            //  btooth= atooth - 2
                            //seleside == 0 ? atooth = value : btooth = value;
                            //   if (seleside == 0) {
                            keydata["toothSA"] = [];
                            keydata["toothWideA"] = [];
                            for (var i = 0; i < atooth; i++) {
                              keydata["toothSA"].add(0);
                              keydata["toothWideA"].add(100);
                            }
                            //   } else {
                            keydata["toothSB"] = [];
                            keydata["toothWideB"] = [];
                            for (var i = 0; i < btooth; i++) {
                              keydata["toothSB"].add(0);
                              keydata["toothWideB"].add(100);
                              //     }
                              ////print("keydata[\"toothWideB\"]${keydata["toothWideB"]}");
                            }
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 21.w),
                    child: Text(
                        keydata["locat"] == 1
                            ? S.of(context).diykeytip3
                            : S.of(context).diykeytip6,
                        style: const TextStyle(color: Colors.red)),
                  ),
                  Container(
                    height: 36.h,
                    color: const Color(0xffdde1ea),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 21.w,
                        ),
                        Text(S.of(context).diykeytip10),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          width: 90.w,
                          height: 20.h,
                          child: OutlinedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                                // backgroundColor:
                                //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero)),
                            child: Text(
                              S.of(context).autoinput,
                              style: const TextStyle(color: Color(0XFF384C70)),
                            ),
                            onPressed: () {
                              setState(() {
                                if (seleside == 0) {
                                  if (keydata["locat"] == 0) {
                                    if (keydata["toothSA"][0] >
                                            keydata["toothSA"][1] ||
                                        keydata["toothSA"][1] == 0) {
                                      Fluttertoast.showToast(
                                          msg: S.of(context).diykeytip3 +
                                              S.of(context).diykeytip4);
                                    } else {
                                      for (var i = 0; i < atooth; i++) {
                                        keydata["toothSA"][i] =
                                            keydata["toothSA"][0] +
                                                (keydata["toothSA"][1] -
                                                        keydata["toothSA"][0]) *
                                                    i;
                                      }
                                    }
                                  } else {
                                    if (keydata["toothSA"][0] <
                                            keydata["toothSA"][1] ||
                                        keydata["toothSA"][1] == 0) {
                                      Fluttertoast.showToast(
                                          msg: S.of(context).diykeytip3 +
                                              S.of(context).diykeytip4);
                                    } else {
                                      for (var i = 0; i < atooth; i++) {
                                        keydata["toothSA"][i] =
                                            keydata["toothSA"][0] -
                                                (keydata["toothSA"][0] -
                                                        keydata["toothSA"][1]) *
                                                    i;
                                      }
                                    }
                                  }
                                } else {
                                  if (keydata["locat"] == 0) {
                                    if (keydata["toothSB"][0] >
                                            keydata["toothSB"][1] ||
                                        keydata["toothSB"][1] == 0) {
                                      Fluttertoast.showToast(
                                          msg: S.of(context).diykeytip6 +
                                              S.of(context).diykeytip4);
                                    } else {
                                      for (var i = 0; i < btooth; i++) {
                                        keydata["toothSB"][i] =
                                            keydata["toothSB"][0] +
                                                (keydata["toothSB"][1] -
                                                        keydata["toothSB"][0]) *
                                                    i;
                                      }
                                    }
                                  } else {
                                    if (keydata["toothSB"][0] <
                                            keydata["toothSB"][1] ||
                                        keydata["toothSB"][1] == 0) {
                                      Fluttertoast.showToast(
                                          msg: S.of(context).diykeytip3 +
                                              S.of(context).diykeytip4);
                                    } else {
                                      for (var i = 0; i < btooth; i++) {
                                        keydata["toothSB"][i] =
                                            keydata["toothSB"][0] -
                                                (keydata["toothSB"][0] -
                                                        keydata["toothSB"][1]) *
                                                    i;
                                      }
                                    }
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: seleside == 0
                          ? (atooth ~/ 2 + atooth % 2)
                          : (btooth ~/ 2 + btooth % 2),
                      itemBuilder: gettoothListData)
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  margin:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                  height: 40.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: const Color(0xff384c70),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: TextButton(
                    child: Text(
                      S.of(context).nextstep,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (keydata["side"] != 3) {
                        if (keydata["side"] == 0 || keydata["side"] == 2) {
                          keydata["toothSB"] = List.from(keydata["toothSA"]);
                          keydata["toothWideB"] =
                              List.from(keydata["toothWideA"]);
                        } else {
                          keydata["toothSA"] = List.from(keydata["toothSB"]);
                          keydata["toothWideA"] =
                              List.from(keydata["toothWideB"]);
                        }
                      }
                      setState(() {
                        if (step5check()) {
                          diykeystep = 6;
                        }
                      });
                    },
                  ))
            ])
          ],
        );

      case 6: //钥匙齿宽
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/9)${S.of(context).keytoothwide}",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                children: [
                  keydata["side"] == 3
                      ? Container(
                          height: 48.h,
                          color: const Color(0XFF384C70),
                          child: Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                  width: 100.w,
                                  height: 48.h,
                                  child: CheckboxListTile(
                                      title: const Text("A",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      value: seleside == 0 ? true : false,
                                      onChanged: (v) {
                                        seleside = 0;
                                        setState(() {});
                                      })),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                  width: 100.w,
                                  height: 48.h,
                                  child: CheckboxListTile(
                                      title: const Text("B",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      value: seleside == 1 ? true : false,
                                      onChanged: (v) {
                                        seleside = 1;
                                        setState(() {});
                                      })),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  Container(
                    width: 320.w,
                    height: 125.h,
                    margin: EdgeInsets.only(
                        left: 21.w, right: 21.w, top: 15.h, bottom: 15.h),
                    child: Center(
                      child: Image.file(File(getStep6Pic())),
                    ),
                    color: Colors.white,
                  ),
                  Container(
                    height: 36.h,
                    color: const Color(0xffdde1ea),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 21.w,
                        ),
                        Text(S.of(context).diykeytip10),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          width: 90.w,
                          height: 20.h,
                          child: OutlinedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                                // backgroundColor:
                                //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero)),
                            child: Text(
                              S.of(context).autoinput,
                              style: const TextStyle(color: Color(0XFF384C70)),
                            ),
                            onPressed: () {
                              setState(() {
                                if (seleside == 0) {
                                  if (keydata["toothWideA"][0] == 0) {
                                    Fluttertoast.showToast(
                                        msg: S.of(context).diykeytip14);
                                  } else {
                                    for (var i = 0; i < atooth; i++) {
                                      keydata["toothWideA"][i] =
                                          keydata["toothWideA"][0];
                                    }
                                  }
                                } else {
                                  if (keydata["toothWideB"][0] == 0) {
                                    Fluttertoast.showToast(
                                        msg: S.of(context).diykeytip14);
                                  } else {
                                    for (var i = 0; i < btooth; i++) {
                                      keydata["toothWideB"][i] =
                                          keydata["toothWideB"][0];
                                    }
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: seleside == 0
                          ? (atooth ~/ 2 + atooth % 2)
                          : (btooth ~/ 2 + btooth % 2),
                      itemBuilder: gettoothwideListData)
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  margin:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                  height: 40.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: const Color(0xff384c70),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: TextButton(
                    child: Text(
                      S.of(context).nextstep,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (keydata["side"] != 3) {
                        keydata["toothWideB"] =
                            List.from(keydata["toothWideA"]);
                      }

                      if (keydata["toothWideB"].indexOf(0) == -1 &&
                          keydata["toothWideA"].indexOf(0) == -1) {
                        diykeystep = 7;
                      } else {
                        Fluttertoast.showToast(msg: S.of(context).diykeytip14);
                      }

                      setState(() {});
                    },
                  ))
            ])
          ],
        );

      case 7: //钥匙齿深
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/9)${S.of(context).keytoothdepth}",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    width: 320.w,
                    height: 125.h,
                    margin: EdgeInsets.only(
                        left: 21.w, right: 21.w, top: 15.h, bottom: 15.h),
                    child: Center(
                      child: Image.file(File(getStep7Pic())),
                    ),
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 21.w,
                      ),
                      Text(S.of(context).keytoothdepthnum),
                      SizedBox(
                        width: 10.w,
                      ),
                      DropdownButton<dynamic>(
                        value: toothnum - 2,
                        items: toothnumitem(),
                        onChanged: (value) {
                          ////print(value);
                          setState(() {
                            value = value + 2;
                            toothnum = value;
                            keydata["toothDepth"] = [];
                            for (var i = 0; i < toothnum; i++) {
                              keydata["toothDepth"].add(0);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 21.w),
                    child: Text(S.of(context).diykeytip8,
                        style: const TextStyle(color: Colors.red)),
                  ),
                  Container(
                      height: 36.h,
                      color: const Color(0xffdde1ea),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 21.w,
                          ),
                          Text(S.of(context).diykeytip10),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          SizedBox(
                            width: 90.w,
                            height: 20.h,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  // backgroundColor:
                                  //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              child: Text(
                                S.of(context).autoinput,
                                style:
                                    const TextStyle(color: Color(0XFF384C70)),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (keydata["toothDepth"][0] <
                                          keydata["toothDepth"][1] ||
                                      keydata["toothDepth"][1] == 0) {
                                    Fluttertoast.showToast(
                                        msg: S.of(context).diykeytip8 +
                                            S.of(context).diykeytip9);
                                  } else {
                                    for (var i = 0; i < toothnum; i++) {
                                      keydata["toothDepth"][i] =
                                          keydata["toothDepth"][0] -
                                              (keydata["toothDepth"][0] -
                                                      keydata["toothDepth"]
                                                          [1]) *
                                                  i;
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: toothnum ~/ 2 + toothnum % 2,
                      itemBuilder: gettoothdepthListData)
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  margin:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                  height: 40.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: const Color(0xff384c70),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: TextButton(
                    child: Text(
                      S.of(context).nextstep,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      keydata["toothDepthName"] = [];
                      for (var i = 0; i < keydata["toothDepth"].length; i++) {
                        keydata["toothDepthName"].add("${i + 1}");
                      }
                      setState(() {
                        if (step7check()) {
                          diykeystep = 8;
                        }
                      });
                    },
                  ))
            ])
          ],
        );
      case 8: //头部处理
        return Column(children: [
          Container(
            height: 40.h,
            color: const Color(0xffdde1ea),
            child: Center(
              child: Text(
                "($diykeystep/9)${S.of(context).opendata}",
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          keydata["class"] != 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                seleside == 0
                                    ? Colors.red
                                    : const Color(0xff384c70))),
                        onPressed: () {
                          seleside = 0;
                          setState(() {});
                        },
                        child: const Text("A")),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                seleside == 1
                                    ? Colors.red
                                    : const Color(0xff384c70))),
                        onPressed: () {
                          seleside = 1;
                          setState(() {});
                        },
                        child: const Text("B")),
                  ],
                )
              : const SizedBox(),
          Expanded(
              child: ListView(
            children: headPointList(),
          )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                height: 40.h,
                width: 150.w,
                decoration: BoxDecoration(
                    color: const Color(0xff384c70),
                    borderRadius: BorderRadius.circular(13.0)),
                child: TextButton(
                  child: Text(
                    S.of(context).nextstep,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    diykeystep = 9;
                    setState(() {});
                  },
                ))
          ])
        ]);
      case 9: //钥匙名称
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/9)${S.of(context).keyname}",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(children: [
                Container(
                  width: 320.w,
                  height: 125.h,
                  margin: EdgeInsets.only(
                      left: 21.w, right: 21.w, top: 15.h, bottom: 15.h),
                  child: Center(child: Image.file(File(getStep9Pic()))),
                  color: Colors.white,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      Text(S.of(context).keyname),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          //  keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              hintText: S.of(context).mustinput),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            //WhitelistingTextInputFormatter(accountRegExp),
                          ],
                          onChanged: (value) {
                            keydata["cnname"] = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      Text(S.of(context).modelbrand),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          //   keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              hintText: S.of(context).mustinput),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            //WhitelistingTextInputFormatter(accountRegExp),
                          ],
                          onChanged: (value) {
                            setState(() {
                              keydata["carname"] = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      Text(S.of(context).brandcar),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          //  keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            // WhitelistingTextInputFormatter(accountRegExp),
                          ],
                          onChanged: (value) {
                            keydata["carmodel"] = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      Text(S.of(context).keynumber),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          // keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            // WhitelistingTextInputFormatter(accountRegExp),
                          ],
                          onChanged: (value) {
                            setState(() {
                              keydata["keynumbet"] = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      Text(S.of(context).note),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          // keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            // WhitelistingTextInputFormatter(accountRegExp),
                          ],
                          onChanged: (value) {
                            setState(() {
                              keydata["chnote"] = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  margin:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                  height: 40.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: const Color(0xff384c70),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: TextButton(
                    child: Text(
                      S.of(context).complete,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (keydata["carname"] == "") {
                        Fluttertoast.showToast(
                            msg: S.of(context).needmodelbrand);
                      } else if (keydata["cnname"] == "") {
                        Fluttertoast.showToast(msg: S.of(context).needkeyname);
                      } else {
                        await addDiyKey();
                        showDialog(
                            context: context,
                            builder: (c) {
                              return MyTextDialog(S.of(context).asknowuse);
                            }).then((value) {
                          if (value) {
                            ////print(keydata);
                            baseKey.initdata(keydata);
                            Navigator.pushNamed(context, '/openclamp',
                                arguments: {"keydata": keydata, "state": 0});
                            //  Navigator.pushNamed(context,);
                          } else {
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                  ))
            ])
          ],
        );
      case 9:
        return Container();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (diykeystep == 1) {
          return true;
        } else {
          setState(() {
            diykeystep--;
          });

          return false;
        }
      },
      child: Scaffold(
        appBar: userTankBar(context),
        body: setawidget(),
      ),
    );
  }
}
