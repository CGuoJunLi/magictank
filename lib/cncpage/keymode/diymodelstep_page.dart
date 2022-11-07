//注意 上下沟槽的宽度 是实际程序中的深度 上下沟槽的深度是实际程序中的宽度
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/cncpage/mycontainer.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';

import 'package:magictank/home4_page.dart';
import 'package:magictank/http/api.dart';
import '../../appdata.dart';

class DiyModelStepPage extends StatefulWidget {
  const DiyModelStepPage({Key? key}) : super(key: key);

  @override
  State<DiyModelStepPage> createState() => _DiyModelStepPageState();
}

class _DiyModelStepPageState extends State<DiyModelStepPage> {
  int step = 0;
  bool mg = false; //中间沟槽
  bool ug = false; //上沟槽
  bool lg = false; //下沟槽
  bool lineg = false; //直槽
  bool vg = false; //V形槽
  bool doubleg = false; //双直槽
  bool headtype = true; //头部类型 true 宽头 false窄头
  RegExp intRegExp = RegExp(r'[0-9]+'); //参数 必须使用int
  List<Map> modelclassname = [
    {
      "title": "立铣-头部定位",
      "pic": appData.keyImagePath + "/fixture/model/diymodel/9_1.png"
    },
    {
      "title": "立铣-肩部定位",
      "pic": appData.keyImagePath + "/fixture/model/diymodel/9_0.png"
    }
    // "平铣-头部定位",
    // "平铣-肩部定位",
  ];
  Map modeldata = {
    "cnname": "",
    "enname": "",
    "brand": "",
    "Index": "",
    "picname": "",
    "Indexes": "",
    "id": 0,
    "fixture": 9,
    "class": 9,
    "modelwide": 0,
    "modelthickness": 0,
    "keywide": 0,
    "keythickness": 0,
    "alltype": 0,
    "locat": 0,
    "locatlength": 0,
    "locatwide": 0,
    "locathill": 0,
    "headtype": 0,
    "headlength": 0,
    "headwide": 0,
    "groovetype": 0,
    "mgroovelength": 0,
    "mgroovedepth": 0,
    "mgroovewide": 0,
    "mgroovedistance": 0,
    "ugroovedepth": 0,
    "ugroovewide": 0,
    "ugroovelength": 0,
    "lgroovewide": 0,
    "lgroovedepth": 0,
    "lgroovelength": 0,
    "v2groovedepth": 0,
    "v2groovelength": 0,
    "v2groovewide": 0,
    "v2groovedistance": 0,
    "hu71depth": 0,
    "hu71length": 0,
    "hu71hill": 0,
    "keynumbet": "L",
    "chnote": "无",
    "ennote": "NULL"
  };
  Future<void> addDiyModel() async {
    var data = {
      "userid": appData.id,
      "timer": DateTime.now().toString().substring(0, 19),
      "data": json.encode(modeldata),
      "state": 0,
      "shared": "false",
      "use": "false",
    };
    try {
      var result = await Api.upUserModel(data);
      //printresult);
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

  List<Widget> modelclass() {
    List<Widget> temp = [];
    for (var i = 0; i < modelclassname.length; i++) {
      temp.add(TextButton(
        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        onPressed: () {
          switch (i) {
            case 0:
              modeldata["class"] = 9;
              modeldata["locat"] = 1;
              modeldata["picname"] = "GLT.png";
              break;
            case 1:
              modeldata["class"] = 9;
              modeldata["locat"] = 0;
              modeldata["picname"] = "GLJ.png";
              break;
            case 2:
              modeldata["class"] = 10;
              modeldata["locat"] = 1;
              break;
            case 3:
              modeldata["class"] = 10;
              modeldata["locat"] = 0;
              break;
          }
          step = 1;
          setState(() {});
        },
        child: myContainer(340.w, 193.h, 23.h, modelclassname[i]["title"],
            modelclassname[i]["pic"], EdgeInsets.all(10.r)),
      ));
    }
    return temp;
  }

  _nextpage() {
    //根据当前的步骤确定下个步骤
    switch (step) {
      case 0: //选择类型 选择钥匙胚类型 平铣立铣 对头对肩
        step = 1;
        break;
      case 1: //选择特征 选择沟槽信息
        step = 2;
        break;
      case 2: //基本特征 输入宽度
        if (modeldata["locat"] == 0) {
          step = 3;
          break;
        }
        if (ug) {
          step = 4;
          break;
        }
        if (lg) {
          step = 5;
          break;
        }
        if (mg && lineg) {
          step = 6;
          break;
        }
        if (mg && doubleg) {
          step = 7;
          break;
        }
        if (mg && vg) {
          step = 8;
          break;
        }
        if (modeldata["headtype"] > 0) {
          step = 9;
          break;
        }
        step = 10;
        break;
      case 3: //肩膀特征
        if (ug) {
          step = 4;
          break;
        }
        if (lg) {
          step = 5;
          break;
        }
        if (mg && lineg) {
          step = 6;
          break;
        }
        if (mg && doubleg) {
          step = 7;
          break;
        }
        if (mg && vg) {
          step = 8;
          break;
        }
        if (modeldata["headtype"] > 0) {
          step = 9;
          break;
        }
        step = 10;
        break;
      case 4: //上沟槽

        if (lg) {
          step = 5;
          break;
        }
        if (mg && lineg) {
          step = 6;
          break;
        }
        if (mg && doubleg) {
          step = 7;
          break;
        }
        if (mg && vg) {
          step = 8;
          break;
        }
        if (modeldata["headtype"] > 0) {
          step = 9;
          break;
        }
        step = 10;
        break;
      case 5: //下沟槽

        if (mg && lineg) {
          step = 6;
          break;
        }
        if (mg && doubleg) {
          step = 7;
          break;
        }
        if (mg && vg) {
          step = 8;
          break;
        }
        if (modeldata["headtype"] > 0) {
          step = 9;
          break;
        }
        step = 10;
        break;
      case 6: //中间沟槽
        if (mg && doubleg) {
          step = 7;
          break;
        }
        if (mg && vg) {
          step = 8;
          break;
        }
        if (modeldata["headtype"] > 0) {
          step = 9;
          break;
        }
        step = 10;
        break;
      case 7: //第二中间沟槽

        if (mg && vg) {
          step = 8;
          break;
        }
        if (modeldata["headtype"] > 0) {
          step = 9;
          break;
        }
        step = 10;
        break;
      case 8: //V槽
        if (modeldata["headtype"] > 0) {
          step = 9;
          break;
        }
        step = 10;
        break;
      case 9:
        step = 10;
        break;
      default:
        return 0;
    }
  }

  _uppage() {
    switch (step) {
      case 10:
        if (modeldata["head"] != 0) {
          step = 9;
          break;
        }
        if (mg & vg) {
          step = 8;
          break;
        }
        if (mg && doubleg) {
          step = 7;
          break;
        }
        if (mg && lineg) {
          step = 6;
          break;
        }
        if (lg) {
          step = 5;
          break;
        }
        if (ug) {
          step = 4;
          break;
        }
        if (modeldata["locat"] == 0) {
          step = 3;
          break;
        }
        step = 2;
        break;
      case 9:
        if (mg & vg) {
          step = 8;
          break;
        }
        if (mg && doubleg) {
          step = 7;
          break;
        }
        if (mg && lineg) {
          step = 6;
          break;
        }
        if (lg) {
          step = 5;
          break;
        }
        if (ug) {
          step = 4;
          break;
        }
        if (modeldata["locat"] == 0) {
          step = 3;
          break;
        }
        step = 2;
        break;
      case 8:
        if (mg && doubleg) {
          step = 7;
          break;
        }
        if (mg && lineg) {
          step = 6;
          break;
        }
        if (lg) {
          step = 5;
          break;
        }
        if (ug) {
          step = 4;
          break;
        }
        if (modeldata["locat"] == 0) {
          step = 3;
          break;
        }
        step = 2;
        break;

      case 7:
        if (mg && lineg) {
          step = 6;
          break;
        }
        if (lg) {
          step = 5;
          break;
        }
        if (ug) {
          step = 4;
          break;
        }
        if (modeldata["locat"] == 0) {
          step = 3;
          break;
        }
        step = 2;
        break;

      case 6:
        if (lg) {
          step = 5;
          break;
        }
        if (ug) {
          step = 4;
          break;
        }
        if (modeldata["locat"] == 0) {
          step = 3;
          break;
        }
        step = 2;
        break;
      case 5:
        if (ug) {
          step = 4;
          break;
        }
        if (modeldata["locat"] == 0) {
          step = 3;
          break;
        }
        step = 2;
        break;
      case 4:
        if (modeldata["locat"] == 0) {
          step = 3;
          break;
        }
        step = 2;
        break;

      case 3:
        step = 2;
        break;
      case 2:
        step = 1;
        break;
      case 1:
        step = 0;
        break;
    }
  }

//上沟槽
  List<Widget> ugroovedata() {
    List<Widget> temp = [];

    temp.add(Container(
      height: 175.h,
      color: Colors.white,
      child: getStepPic(),
    ));
    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("A上沟槽宽度"),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: InputDecoration(
                    hintText: "5-${(modeldata["keywide"] - 550)}"),
                controller: TextEditingController(
                    text: modeldata["ugroovewide"] == 0
                        ? ""
                        : modeldata["ugroovewide"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["ugroovewide"] = 0;
                  } else {
                    modeldata["ugroovewide"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));
    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("B上沟槽长度"),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: const InputDecoration(hintText: "500-4000"),
                controller: TextEditingController(
                    text: modeldata["ugroovelength"] == 0
                        ? ""
                        : modeldata["ugroovelength"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["ugroovelength"] = 0;
                  } else {
                    modeldata["ugroovelength"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("C上沟槽深度"),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: InputDecoration(
                    hintText: "5-${(modeldata["keythickness"] * 2 ~/ 3)}"),
                controller: TextEditingController(
                    text: modeldata["ugroovedepth"] == 0
                        ? ""
                        : modeldata["ugroovedepth"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["ugroovedepth"] = 0;
                  } else {
                    modeldata["ugroovedepth"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    return temp;
  }

//中间沟槽
  List<Widget> mgroovedata() {
    List<Widget> temp = [];

    temp.add(Container(
      height: 175.h,
      color: Colors.white,
      child: getStepPic(),
    ));

    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("A中间沟槽宽度"),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: InputDecoration(
                    hintText: "150-${modeldata["keywide"] * 2 / 3}"),
                controller: TextEditingController(
                    text: modeldata["mgroovewide"] == 0
                        ? ""
                        : modeldata["mgroovewide"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["mgroovewide"] = 0;
                  } else {
                    modeldata["mgroovewide"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("B中间沟槽距离"),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: InputDecoration(
                    hintText: "150-${modeldata["keywide"] - 150}"),
                controller: TextEditingController(
                    text: modeldata["mgroovedistance"] == 0
                        ? ""
                        : modeldata["mgroovedistance"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["mgroovedistance"] = 0;
                  } else {
                    modeldata["mgroovedistance"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));
    temp.add(
      Container(
          height: 40.h,
          color: const Color(0xffdde2ea),
          margin: EdgeInsets.only(bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("C中间沟槽长度"),
              SizedBox(
                  width: 200.w,
                  child: TextField(
                    decoration: const InputDecoration(hintText: "550-4000"),
                    controller: TextEditingController(
                        text: modeldata["mgroovelength"] == 0
                            ? ""
                            : modeldata["mgroovelength"].toString()),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18),
                      FilteringTextInputFormatter(intRegExp, allow: true),
                    ],
                    onChanged: (value) {
                      if (value == "") {
                        modeldata["mgroovelength"] = 0;
                      } else {
                        modeldata["mgroovelength"] = int.parse(value);
                      }
                      // setState(() {});
                    },
                  ))
            ],
          )),
    );
    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("D中间沟槽深度"),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: InputDecoration(
                    hintText: "5-${(modeldata["keythickness"] - 150)}"),
                controller: TextEditingController(
                    text: modeldata["mgroovedepth"] == 0
                        ? ""
                        : modeldata["mgroovedepth"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["mgroovedepth"] = 0;
                  } else {
                    modeldata["mgroovedepth"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    return temp;
  }

//中间2沟槽
  List<Widget> doublegroovedata() {
    List<Widget> temp = [];

    temp.add(Container(
      height: 175.h,
      color: Colors.white,
      child: getStepPic(),
    ));
    temp.add(
      Container(
          height: 40.h,
          color: const Color(0xffdde2ea),
          margin: EdgeInsets.only(bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(S.of(context).mgroovelen),
              SizedBox(
                  width: 200.w,
                  child: TextField(
                    decoration: const InputDecoration(hintText: "180-300"),
                    controller: TextEditingController(
                        text: modeldata["mgroovelength"] == 0
                            ? ""
                            : modeldata["mgroovelength"].toString()),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18),
                      FilteringTextInputFormatter(intRegExp, allow: true),
                    ],
                    onChanged: (value) {
                      if (value == "") {
                        modeldata["mgroovelength"] = 0;
                      } else {
                        modeldata["mgroovelength"] = int.parse(value);
                      }
                      // setState(() {});
                    },
                  ))
            ],
          )),
    );

    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(S.of(context).mgroovewide),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: const InputDecoration(hintText: "180-300"),
                controller: TextEditingController(
                    text: modeldata["mgroovewide"] == 0
                        ? ""
                        : modeldata["mgroovewide"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["mgroovewide"] = 0;
                  } else {
                    modeldata["mgroovewide"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(S.of(context).mgroovedistance),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: const InputDecoration(hintText: "180-300"),
                controller: TextEditingController(
                    text: modeldata["mgroovedistance"] == 0
                        ? ""
                        : modeldata["mgroovedistance"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["mgroovedistance"] = 0;
                  } else {
                    modeldata["mgroovedistance"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(S.of(context).mgroovedepth),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: const InputDecoration(hintText: "180-300"),
                controller: TextEditingController(
                    text: modeldata["mgroovedepth"] == 0
                        ? ""
                        : modeldata["mgroovedepth"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["mgroovedepth"] = 0;
                  } else {
                    modeldata["mgroovedepth"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    return temp;
  }

//V沟槽
  List<Widget> vgroovedata() {
    List<Widget> temp = [];

    temp.add(Container(
      height: 175.h,
      color: Colors.white,
      child: getStepPic(),
    ));
    temp.add(
      Container(
          height: 40.h,
          color: const Color(0xffdde2ea),
          margin: EdgeInsets.only(bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(S.of(context).mgroovelen),
              SizedBox(
                  width: 200.w,
                  child: TextField(
                    decoration: const InputDecoration(hintText: "180-300"),
                    controller: TextEditingController(
                        text: modeldata["mgroovelength"] == 0
                            ? ""
                            : modeldata["mgroovelength"].toString()),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18),
                      FilteringTextInputFormatter(intRegExp, allow: true),
                    ],
                    onChanged: (value) {
                      if (value == "") {
                        modeldata["mgroovelength"] = 0;
                      } else {
                        modeldata["mgroovelength"] = int.parse(value);
                      }
                      // setState(() {});
                    },
                  ))
            ],
          )),
    );

    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(S.of(context).mgroovewide),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: const InputDecoration(hintText: "180-300"),
                controller: TextEditingController(
                    text: modeldata["mgroovewide"] == 0
                        ? ""
                        : modeldata["mgroovewide"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["mgroovewide"] = 0;
                  } else {
                    modeldata["mgroovewide"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(S.of(context).mgroovedistance),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: const InputDecoration(hintText: "180-300"),
                controller: TextEditingController(
                    text: modeldata["mgroovedistance"] == 0
                        ? ""
                        : modeldata["mgroovedistance"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["mgroovedistance"] = 0;
                  } else {
                    modeldata["mgroovedistance"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(S.of(context).mgroovedepth),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: const InputDecoration(hintText: "180-300"),
                controller: TextEditingController(
                    text: modeldata["mgroovedepth"] == 0
                        ? ""
                        : modeldata["mgroovedepth"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["mgroovedepth"] = 0;
                  } else {
                    modeldata["mgroovedepth"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    return temp;
  }

  //下沟槽
  List<Widget> lgroovedata() {
    List<Widget> temp = [];

    temp.add(Container(
      height: 175.h,
      color: Colors.white,
      child: getStepPic(),
    ));
    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("A下沟槽宽度"),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: InputDecoration(
                    hintText: "5-${(modeldata["keywide"] - 550)}"),
                controller: TextEditingController(
                    text: modeldata["lgroovewide"] == 0
                        ? ""
                        : modeldata["lgroovewide"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["lgroovewide"] = 0;
                  } else {
                    modeldata["lgroovewide"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));
    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(S.of(context).lgroovelen),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: const InputDecoration(hintText: "500-4000"),
                controller: TextEditingController(
                    text: modeldata["lgroovelength"] == 0
                        ? ""
                        : modeldata["lgroovelength"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["lgroovelength"] = 0;
                  } else {
                    modeldata["lgroovelength"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    temp.add(Container(
      height: 40.h,
      color: const Color(0xffdde2ea),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("C下沟槽深度"),
          SizedBox(
              width: 200.w,
              child: TextField(
                decoration: InputDecoration(
                    hintText: "5-${(modeldata["keythickness"] * 2 ~/ 3)}"),
                controller: TextEditingController(
                    text: modeldata["lgroovedepth"] == 0
                        ? ""
                        : modeldata["lgroovedepth"].toString()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter(intRegExp, allow: true),
                ],
                onChanged: (value) {
                  if (value == "") {
                    modeldata["lgroovedepth"] = 0;
                  } else {
                    modeldata["lgroovedepth"] = int.parse(value);
                  }
                },
              ))
        ],
      ),
    ));

    return temp;
  }

  ///宽厚数据检查
  bool check2step() {
    if (modeldata["locat"] == 0) {
      if (modeldata["keywide"] <= 900 &&
          modeldata["keywide"] >= 500 &&
          modeldata["keythickness"] <= 300 &&
          modeldata["keythickness"] >= 200) {
        return true;
      } else {
        return false;
      }
    } else {
      if (modeldata["keywide"] <= 1000 &&
          modeldata["keywide"] >= 500 &&
          modeldata["keythickness"] <= 300 &&
          modeldata["keythickness"] >= 200) {
        return true;
      } else {
        return false;
      }
    }
  }

  ///肩膀数据检查
  bool check3step() {
    if (modeldata["locatwide"] > 1000 ||
        modeldata["locatlength"] >= 4000 ||
        modeldata["locatlength"] < 500 ||
        modeldata["locatwide"] < modeldata["keywide"]) {
      return false;
    } else {
      return true;
    }
  }

  ///上沟槽数据检查
  bool check4step() {
    if (modeldata["ugroovedepth"] > (modeldata["keywide"] - 550) ||
        modeldata["ugroovedepth"] < 5) {
      return false;
    }
    if (modeldata["ugroovewide"] > modeldata["keythickness"] * 2 / 3 ||
        modeldata["ugroovewide"] < 5) {
      return false;
    }
    if (modeldata["ugroovelength"] > 4000 || modeldata["ugroovelength"] < 550) {
      return false;
    }
    return true;
  }

  ///下沟槽数据检查
  bool check5step() {
    if (modeldata["lgroovedepth"] > (modeldata["keywide"] - 550) ||
        modeldata["lgroovedepth"] < 5) {
      return false;
    }
    if (modeldata["lgroovewide"] > modeldata["keythickness"] * 2 / 3 ||
        modeldata["lgroovewide"] < 5) {
      return false;
    }
    if (modeldata["lgroovelength"] > 4000 || modeldata["ugroovelength"] < 550) {
      return false;
    }
    return true;
  }

  ///中间沟槽数据检查
  bool check6step() {
    if (modeldata["mgroovedepth"] > (modeldata["keythickness"] - 150) ||
        modeldata["mgroovedepth"] < 5) {
      return false;
    }
    if (modeldata["mgroovewide"] > modeldata["keywide"] * 2 ~/ 3) {
      return false;
    }
    if (modeldata["mgroovelength"] > 4000 || modeldata["mgroovelength"] < 550) {
      return false;
    }
    // if (modeldata["mgroovedistance"] >
    //     modeldata["keywide"] - modeldata["mgroovewide"]) {
    //   return false;
    // }

    if (modeldata["mgroovedistance"] > modeldata["keywide"] - 150 ||
        modeldata["mgroovedistance"] < 150) {
      return false;
    }
    return true;
  }

  ///头部长度检测
  bool check9step() {
    if (modeldata["headlength"] > 1000 || modeldata["headlength"] < 150) {
      return false;
    }
    return true;
  }

//选择特征时候的图片
  Widget getStepPic1() {
    String imagepath = appData.keyImagePath +
        "/fixture/model/diymodel/9_${modeldata["locat"]}_0_0_${mg ? 1 : 0}_${ug ? 1 : 0}_${lg ? 1 : 0}.png";
    return Image.file(File(imagepath));
  }

//获取每个特征的图片
  Widget getStepPic() {
    String imagepath = appData.keyImagePath +
        "/fixture/model/diymodel/9_${modeldata["locat"]}_0_0_${mg ? 1 : 0}_${ug ? 1 : 0}_${lg ? 1 : 0}_${step - 1}.png";
    return Image.file(File(imagepath));
  }

  Widget stempWidget() {
    //print(step);
    switch (step) {
      case 0:
        return Column(
          children: [
            Container(
              width: double.maxFinite,
              color: const Color(0xffdde1ea),
              height: 40.h,
              child: Center(
                child: Text(
                  "选择类型",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: modelclass(),
              ),
            ),
          ],
        );
      case 1: //特征选择
        return Column(
          children: [
            Container(
              width: double.maxFinite,
              color: const Color(0xffdde1ea),
              height: 40.h,
              child: Center(
                child: Text(
                  "选择特征",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  getStepPic1(),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    height: 40.h,
                    color: const Color(0xffdde2ea),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(S.of(context).mgroove),
                        const Expanded(child: SizedBox()),
                        Checkbox(
                            value: mg,
                            onChanged: (value) {
                              mg = !mg;
                              if (mg) {
                                lineg = true;
                              } else {
                                lineg = false;
                              }
                              setState(() {});
                            }),
                        SizedBox(
                          width: 33.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  /*    mg
                      ? CheckboxListTile(
                          title: const Text("是否有双中间沟槽"),
                          value: doubleg,
                          onChanged: (value) {
                            doubleg = !doubleg;
                            if (doubleg) {
                              lineg = true;
                              ug = false;
                              lg = false;
                              vg = false;
                            }
                            setState(() {});
                          })
                      : Container(),
                  mg
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.green,
                                height: 100,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        )
                      : Container(),*/
                  /*  mg
                      ? Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                  title: const Text("直槽"),
                                  value: lineg,
                                  onChanged: (value) {
                                    if (!doubleg) {
                                      if (vg) {
                                        lineg = !lineg;
                                      }
                                      if (vg) {
                                        ug = false;
                                        lg = false;
                                      }
                                    }

                                    setState(() {});
                                  }),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                  title: const Text("V槽"),
                                  value: vg,
                                  onChanged: (value) {
                                    if (!doubleg) {
                                      vg = !vg;
                                      if (!vg && !lineg) {
                                        lineg = true;
                                      }
                                      if (lineg & vg) {
                                        ug = false;
                                        lg = false;
                                      }
                                    }
                                    setState(() {});
                                  }),
                            ),
                          ],
                        )
                      : Container(),*/

                  Container(
                    height: 40.h,
                    color: const Color(0xffdde2ea),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(S.of(context).ugroove),
                        const Expanded(child: SizedBox()),
                        Checkbox(
                            value: ug,
                            onChanged: (value) {
                              if (!doubleg && !(lineg && vg)) {
                                ug = !ug;
                              }
                              setState(() {});
                            }),
                        SizedBox(
                          width: 33.w,
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
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(S.of(context).lgroove),
                        const Expanded(child: SizedBox()),
                        Checkbox(
                            value: lg,
                            onChanged: (value) {
                              if (!doubleg && !(lineg && vg)) {
                                lg = !lg;
                              }
                              setState(() {});
                            }),
                        SizedBox(
                          width: 33.w,
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
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(S.of(context).headabrase),
                        const Expanded(child: SizedBox()),
                        Checkbox(
                            value: modeldata["headtype"] > 0 ? true : false,
                            onChanged: (value) {
                              if (value!) {
                                modeldata["headtype"] = 1;
                              } else {
                                modeldata["headtype"] = 0;
                              }
                              setState(() {});
                            }),
                        SizedBox(
                          width: 33.w,
                        ),
                      ],
                    ),
                  ),
                  modeldata["headtype"] > 0
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 100.r,
                                color: Colors.white,
                                child: Image.file(File(appData.keyImagePath +
                                    "/fixture/model/diymodel/sele_head2.png")),
                              ),
                            ),
                            const VerticalDivider(),
                            Expanded(
                              child: Container(
                                height: 100.r,
                                color: Colors.white,
                                child: Image.file(File(appData.keyImagePath +
                                    "/fixture/model/diymodel/sele_head1.png")),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  modeldata["headtype"] > 0
                      ? Container(
                          height: 40.h,
                          color: const Color(0xffdde2ea),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(S.of(context).wdiemodelhead0),
                              SizedBox(
                                width: 79.w,
                              ),
                              Checkbox(
                                value: headtype,
                                onChanged: (v) {
                                  headtype = !headtype;
                                  if (!headtype) {
                                    modeldata["headwide"] = 100;
                                  } else {
                                    modeldata["headwide"] = 200;
                                  }
                                  setState(() {});
                                },
                              ),

                              Text(S.of(context).wdiemodelhead1),
                              // SizedBox(
                              //   width: 79.w,
                              // ),
                              const Expanded(child: SizedBox()),
                              Checkbox(
                                  value: !headtype,
                                  onChanged: (v) {
                                    headtype = !headtype;
                                    if (!headtype) {
                                      modeldata["headwide"] = 100;
                                    } else {
                                      modeldata["headwide"] = 200;
                                    }
                                    setState(() {});
                                  }),
                              SizedBox(
                                width: 33.w,
                              )
                            ],
                          ))
                      : Container(),
                  // modeldata["headtype"] > 0
                  //     ? Container(
                  //         height: 100,
                  //         color: Colors.red,
                  //       )
                  //     : Container(),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                step = 2;
                if (mg && lineg && !vg & !doubleg) {
                  if (ug || lg) {
                    modeldata["alltype"] = 2;
                  } else {
                    modeldata["alltype"] = 1;
                  }
                }
                if (mg && !lineg && vg & !doubleg) {
                  if (ug || lg) {
                    modeldata["alltype"] = 7;
                  } else {
                    modeldata["alltype"] = 6;
                  }
                }
                if (mg && lineg && vg) {
                  modeldata["alltype"] = 8;
                }
                if (mg && doubleg) {
                  modeldata["alltype"] = 5;
                }
                if (!mg && (ug || lg)) {
                  modeldata["alltype"] = 3;
                }

                // print(modeldata["alltype"]);
                setState(() {});
              },
              child: Container(
                width: 150.w,
                height: 30.h,
                decoration: BoxDecoration(
                    color: const Color(0xff384c70),
                    borderRadius: BorderRadius.circular(13.r)),
                child: Center(
                  child: Text(
                    S.of(context).nextstep,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      case 2: //基本特征
        return Column(children: [
          Container(
            width: double.maxFinite,
            color: const Color(0xffdde1ea),
            height: 40.h,
            child: Center(
              child: Text(
                "基本特征",
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: Colors.white,
                  height: 175.h,
                  child: getStepPic(),
                ),
                Container(
                    height: 40.h,
                    color: const Color(0xffdde2ea),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("A钥匙宽度(0.01mm):"),
                        SizedBox(
                            width: 200.w,
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: modeldata["locat"] == 0
                                      ? "550-900"
                                      : "550-1000"),
                              controller: TextEditingController(
                                text: modeldata["keywide"] == 0
                                    ? ""
                                    : modeldata["keywide"].toString(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(16),
                                FilteringTextInputFormatter(intRegExp,
                                    allow: true),
                              ],
                              onChanged: (value) {
                                if (value == "") {
                                  modeldata["keywide"] = 0;
                                } else {
                                  modeldata["keywide"] = int.parse(value);
                                }
                              },
                            ))
                      ],
                    )),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde2ea),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("B钥匙厚度(0.01mm):"),
                      SizedBox(
                          width: 200.w,
                          child: TextField(
                            controller: TextEditingController(
                                text: modeldata["keythickness"] == 0
                                    ? ""
                                    : modeldata["keythickness"].toString()),
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(hintText: "200-300"),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(18),
                              FilteringTextInputFormatter(intRegExp,
                                  allow: true),
                            ],
                            onChanged: (value) {
                              if (value == "") {
                                modeldata["keythickness"] = 0;
                              } else {
                                modeldata["keythickness"] = int.parse(value);
                              }
                            },
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              //如果对肩膀

              if (check2step()) {
                _nextpage();
                if (modeldata["keywide"] > 780) {
                  //如果厚度小于240 用T
                  if (modeldata["keythickness"] < 240) {
                    modeldata["modelwide"] = 1000;
                    modeldata["modelthickness"] = 220;
                  } else {
                    //如果厚度大于240用L
                    modeldata["modelwide"] = 1000;
                    modeldata["modelthickness"] = 300;
                  }
                } else {
                  //如果肩膀宽度小于780
                  modeldata["modelwide"] = 780;
                  modeldata["modelthickness"] = 300;
                }
              } else {
                Fluttertoast.showToast(msg: "请按照要求输入参数");
              }
              setState(() {});
            },
            child: Container(
              width: 150.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: const Color(0xff384c70),
                  borderRadius: BorderRadius.circular(13.r)),
              child: Center(
                child: Text(
                  S.of(context).nextstep,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]);
      case 3: //肩膀
        return Column(children: [
          Container(
            width: double.maxFinite,
            color: const Color(0xffdde1ea),
            height: 40.h,
            child: Center(
              child: Text(
                "肩膀数据",
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: Colors.white,
                  height: 175.h,
                  child: getStepPic(),
                ),
                Container(
                    height: 40.h,
                    color: const Color(0xffdde2ea),
                    child: Row(
                      children: [
                        const Text("A肩膀宽度： "),
                        SizedBox(
                            width: 200.w,
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText:
                                      "${modeldata["keywide"] + 100}-1000"),
                              controller: TextEditingController(
                                  text: modeldata["locatwide"] == 0
                                      ? ""
                                      : modeldata["locatwide"].toString()),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(18),
                                FilteringTextInputFormatter(intRegExp,
                                    allow: true),
                              ],
                              onChanged: (value) {
                                if (value == "") {
                                  modeldata["locatwide"] = 0;
                                } else {
                                  modeldata["locatwide"] = int.parse(value);
                                }
                              },
                            ))
                      ],
                    )),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                    height: 40.h,
                    color: const Color(0xffdde2ea),
                    child: Row(
                      children: [
                        const Text("B肩膀长度： "),
                        SizedBox(
                            width: 200.w,
                            child: TextField(
                              decoration:
                                  const InputDecoration(hintText: "500-4000"),
                              controller: TextEditingController(
                                  text: modeldata["locatlength"] == 0
                                      ? ""
                                      : modeldata["locatlength"].toString()),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(18),
                                FilteringTextInputFormatter(intRegExp,
                                    allow: true),
                              ],
                              onChanged: (value) {
                                if (value == "") {
                                  modeldata["locatlength"] = 0;
                                } else {
                                  modeldata["locatlength"] = int.parse(value);
                                }
                              },
                            ))
                      ],
                    )),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              //如果对肩膀
              if (check3step()) {
                _nextpage();
                //如果肩膀宽度大于780
                if (modeldata["locatwide"] > 780) {
                  //如果厚度小于240 用T
                  if (modeldata["keythickness"] < 240) {
                    modeldata["modelwide"] = 1000;
                    modeldata["modelthickness"] = 220;
                  } else {
                    //如果厚度大于240用L
                    modeldata["modelwide"] = 1000;
                    modeldata["modelthickness"] = 300;
                  }
                } else {
                  //如果肩膀宽度小于780
                  modeldata["modelwide"] = 780;
                  modeldata["modelthickness"] = 300;
                }
              } else {
                Fluttertoast.showToast(msg: "请按照要求输入参数");
              }

              setState(() {});
            },
            child: Container(
              width: 150.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: const Color(0xff384c70),
                  borderRadius: BorderRadius.circular(13.r)),
              child: Center(
                child: Text(
                  S.of(context).nextstep,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]);

      case 4: //上沟槽信息
        return Column(children: [
          Container(
            width: double.maxFinite,
            color: const Color(0xffdde1ea),
            height: 40.h,
            child: Center(
              child: Text(
                "上沟槽参数",
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          Expanded(
              child: ListView(
            children: ugroovedata(),
          )),
          TextButton(
            onPressed: () {
              if (check4step()) {
                _nextpage();
                setState(() {});
              } else {
                Fluttertoast.showToast(msg: "请按照要求输入参数");
              }
            },
            child: Container(
              width: 150.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: const Color(0xff384c70),
                  borderRadius: BorderRadius.circular(13.r)),
              child: Center(
                child: Text(
                  S.of(context).nextstep,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]);
      case 5: //下沟槽信息
        return Column(children: [
          Container(
            width: double.maxFinite,
            color: const Color(0xffdde1ea),
            height: 40.h,
            child: Center(
              child: Text(
                "下沟槽宽度",
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          Expanded(
              child: ListView(
            children: lgroovedata(),
          )),
          TextButton(
            onPressed: () {
              if (check5step()) {
                _nextpage();
                setState(() {});
              } else {
                Fluttertoast.showToast(msg: "请按照要求输入参数");
              }
            },
            child: Container(
              width: 150.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: const Color(0xff384c70),
                  borderRadius: BorderRadius.circular(13.r)),
              child: Center(
                child: Text(
                  S.of(context).nextstep,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]);
      case 6: //中间沟槽信息
        return Column(children: [
          Container(
            width: double.maxFinite,
            color: const Color(0xffdde1ea),
            height: 40.h,
            child: Center(
              child: Text(
                "中间沟槽",
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          Expanded(
              child: ListView(
            children: mgroovedata(),
          )),
          TextButton(
            onPressed: () {
              if (check6step()) {
                _nextpage();
                setState(() {});
              } else {
                Fluttertoast.showToast(msg: "请按照要求输入参数");
              }
            },
            child: Container(
              width: 150.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: const Color(0xff384c70),
                  borderRadius: BorderRadius.circular(13.r)),
              child: Center(
                child: Text(
                  S.of(context).nextstep,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]);

      case 7: //双中间沟槽的第二沟槽信息
        return Column(children: [
          Container(
            width: double.maxFinite,
            color: const Color(0xffdde1ea),
            height: 40.h,
            child: Center(
              child: Text(
                "第二沟槽",
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          Expanded(
              child: ListView(
            children: doublegroovedata(),
          )),
          TextButton(
            onPressed: () {
              _nextpage();
              setState(() {});
            },
            child: Container(
              width: 150.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: const Color(0xff384c70),
                  borderRadius: BorderRadius.circular(13.r)),
              child: Center(
                child: Text(
                  S.of(context).nextstep,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]);

      case 8: //V沟槽信息
        return Column(children: [
          Container(
            width: double.maxFinite,
            color: const Color(0xffdde1ea),
            height: 40.h,
            child: Center(
              child: Text(
                "V沟槽",
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          Expanded(
              child: ListView(
            children: vgroovedata(),
          )),
          TextButton(
            onPressed: () {
              _nextpage();
              setState(() {});
            },
            child: Container(
              width: 150.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: const Color(0xff384c70),
                  borderRadius: BorderRadius.circular(13.r)),
              child: Center(
                child: Text(
                  S.of(context).nextstep,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]);

      case 9: //头部特征
        return Column(
          children: [
            Container(
              width: double.maxFinite,
              color: const Color(0xffdde1ea),
              height: 40.h,
              child: Center(
                child: Text(
                  "头部特征",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 175.h,
                    color: Colors.white,
                    child: getStepPic(),
                  ),
                  Container(
                      height: 40.h,
                      color: const Color(0xffdde2ea),
                      margin: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("A头部长度:"),
                          SizedBox(
                              width: 200.w,
                              child: TextField(
                                decoration:
                                    const InputDecoration(hintText: "150-1000"),
                                controller: TextEditingController(
                                    text: modeldata["headlength"] == 0
                                        ? ""
                                        : modeldata["headlength"].toString()),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(18),
                                  FilteringTextInputFormatter(intRegExp,
                                      allow: true),
                                ],
                                onChanged: (value) {
                                  if (value == "") {
                                    modeldata["headlength"] = 0;
                                  } else {
                                    modeldata["headlength"] = int.parse(value);
                                  }
                                },
                              ))
                        ],
                      )),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                if (check9step()) {
                  _nextpage();
                  setState(() {});
                } else {
                  Fluttertoast.showToast(msg: "请按照要求输入参数");
                }
              },
              child: Container(
                width: 150.w,
                height: 30.h,
                decoration: BoxDecoration(
                    color: const Color(0xff384c70),
                    borderRadius: BorderRadius.circular(13.r)),
                child: Center(
                  child: Text(
                    S.of(context).nextstep,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      case 10: //保存
        return Column(
          children: [
            Container(
              width: double.maxFinite,
              color: const Color(0xffdde1ea),
              height: 40.h,
              child: Center(
                child: Text(
                  "保存信息",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 40.h,
                    color: const Color(0xffdde2ea),
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("模型名称: "),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(hintText: "必填"),
                            controller: TextEditingController(
                                text: modeldata["cnname"]),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(18),
                              //FilteringTextInputFormatter(intRegExp, allow: true),
                            ],
                            onChanged: (value) {
                              modeldata["cnname"] = value;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40.h,
                    color: const Color(0xffdde2ea),
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("品牌名称: "),
                        Expanded(
                          child: TextField(
                            controller:
                                TextEditingController(text: modeldata["brand"]),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(18),
                              //FilteringTextInputFormatter(intRegExp, allow: true),
                            ],
                            onChanged: (value) {
                              modeldata["brand"] = value;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40.h,
                    color: const Color(0xffdde2ea),
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("备注信息: "),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: modeldata["chnote"]),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(18),
                              //FilteringTextInputFormatter(intRegExp, allow: true),
                            ],
                            onChanged: (value) {
                              modeldata["chnote"] = value;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (c) {
                      return const MyTextDialog("是否立即加工此模型?");
                    }).then((value) async {
                  await addDiyModel();
                  if (value) {
                    // //print(modeldata);
                    Navigator.pushNamed(context, "/cutmodelready",
                        arguments: {"data": modeldata});
                  } else {
                    Navigator.pop(context);
                    //Navigator.pushNamed(context, "/diymodel");
                    //Navigator.pushNamedAndRemoveUntil(
                    //context, "/diymodel", (route) => false);
                  }
                });
              },
              child: Container(
                width: 150.w,
                height: 30.h,
                decoration: BoxDecoration(
                    color: const Color(0xff384c70),
                    borderRadius: BorderRadius.circular(13.r)),
                child: const Center(
                  child: Text(
                    "保存",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      default:
        return Column(children: const [
          Text("未知错误，请连接管理员"),
        ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (step == 0) {
            return true;
          } else {
            _uppage();
            setState(() {});
            return false;
          }
        },
        child: Scaffold(
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
                if (step == 0) {
                  Navigator.pop(context);
                } else {
                  _uppage();
                }
                setState(() {});
              },
              color: Colors.black,
              icon: Image.asset("image/share/Icon_back.png"),
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
                icon: Image.asset("image/share/Icon_home.png"),
              )
            ],
          ),
          // PreferredSize(
          //   preferredSize: Size(double.maxFinite, 60.h),
          //   child: Builder(
          //     builder: (context) {
          //       return Container(
          //         width: double.maxFinite,
          //         padding: EdgeInsets.only(top: 20.h),
          //         height: 60.h,
          //         //color: Colors.red,
          //         child: Stack(
          //           children: [
          //             Align(
          //               alignment: Alignment.centerLeft,
          //               child: TextButton(
          //                   onPressed: () {
          //                     if (step == 0) {
          //                       Navigator.pop(context);
          //                     } else {
          //                       _uppage();
          //                     }
          //                     setState(() {});
          //                   },
          //                   child: Image.asset("image/share/Icon_back.png")),
          //             ),
          //             Align(
          //               alignment: Alignment.center,
          //               child: Image.asset(
          //                 "image/tank/Icon_tankbar.png",
          //                 // fit: BoxFit.cover,
          //               ),
          //             ),
          //             Align(
          //                 alignment: Alignment.centerRight,
          //                 child: TextButton(
          //                     onPressed: () {
          //                       Navigator.of(context).pushAndRemoveUntil(
          //                           MaterialPageRoute(builder: (context) {
          //                         if (appData.isBLE) {
          //                           return const Tips4Page();
          //                         } else {
          //                           return const Tips2Page();
          //                         }
          //                       }), (route) => false);
          //                     },
          //                     child: Image.asset("image/share/Icon_home.png")))
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
          body: stempWidget(),
        ));
  }
}
