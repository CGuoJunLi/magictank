import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/cncpage/diykey/photokeycanvas.dart';
import 'package:magictank/cncpage/mycontainer.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/userappbar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:video_player/video_player.dart';

import '../../appdata.dart';

class PhotoDiyPage extends StatefulWidget {
  const PhotoDiyPage({Key? key}) : super(key: key);

  @override
  _PhotoDiyPageState createState() => _PhotoDiyPageState();
}

const double min = pi * -2;
const double max = pi * 2;

const double minScale = 0.03;
const double defScale = 0.1;
const double maxScale = 0.6;

class _PhotoDiyPageState extends State<PhotoDiyPage> {
  late ProgressDialog pd;
  String keytitle = "";
  int seleside = 0; //选择的边
  int atooth = 2; //A边齿数
  int toothnum = 2; //齿深数
  int btooth = 2; //B边齿数
  int diykeystep = 1; //步骤记录器
  //final ScrollController _scrollcontroller = ScrollController();
  late Map keydata;

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

  late Uint8List imagememory;
  late PhotoViewControllerBase controller;
  late PhotoViewScaleStateController scaleStateController;

  bool canbemove = false;
  String butstring = "固定";

  Offset touchoffect = const Offset(0, 0);
  double imagerotation = 0.0;
  double imagescale = 1.0;
  double imagepostx = 0.0;
  double imageposty = 0.0;
  //late Image _image;
  String filepath = "";
  //dynamic _pickImageError;
  bool isVideo = false;
  int seletooth = 0; //选择的齿号
  int seleahnum = 0; //选择的齿深
  int tooth = 2; //齿数
  List<int> changeDiff = [1, 5, 10]; //齿深齿位调整差值
  int seleDiff = 0;
  Timer? timer;
  int calls = 0;
  double currentscale = 0.0;
  VideoPlayerController? _controller;
  //VideoPlayerController? _toBeDisposed;

  final ImagePicker _picker = ImagePicker();

  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  @override
  void initState() {
    _initkeydata();
    diykeystep = 1;
    pd = ProgressDialog(context: context);

    controller = PhotoViewController(initialScale: 1)
      ..outputStateStream.listen(onController);

    scaleStateController = PhotoViewScaleStateController()
      ..outputScaleStateStream.listen(onScaleState);
    super.initState();
  }

  void onController(PhotoViewControllerValue value) {
    imagescale = value.scale!;
    imagerotation = value.rotation;
  }

  void onScaleState(PhotoViewScaleState scaleState) {}

  _initkeydata() {
    tooth = 2;
    atooth = 2;
    toothnum = 2;
    btooth = 2;
    keydata = {
      "smart": false,
      "hide": false,
      "nonconductive": false,
      "carname": "",
      "carmodel": "",
      "carmodeltime": "",
      "cnname": "",
      "enname": "",
      "Index": "",
      "picname": "",
      "Indexes": "",
      "id": 0,
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
      "toothDepth": [200, 100],
      "toothDepthName": ["1", "2"],
      "keynumbet": "",
      "chnote": "无",
      "ennote": "NULL",
      "moreside": [],
    };
  }

  Future<void> addDiyKey() async {
    var data = {
      "userid": appData.id,
      "timer": DateTime.now().toString().substring(0, 19),
      "data": json.encode(keydata),
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

  bool step4check() {
    switch (keydata["class"]) {
      case 2:
      case 3:
      case 4:
      case 5:
        if ((keydata["depth"] > keydata["thickness"])) {
          Fluttertoast.showToast(msg: "切削深度需要小于钥匙厚度");
          return false;
        }
        if (keydata["class"] == 5) {
          if ((keydata["groove"] > keydata["wide"])) {
            Fluttertoast.showToast(msg: "内沟槽宽度需要小于钥匙宽");
            return false;
          }
        }
        break;

      default:
        if (keydata["wide"] < 400 || keydata["wide"] > 1100) {
          Fluttertoast.showToast(msg: "钥匙宽度范围400-1100");
          return false;
        }
        if ((keydata["thickness"] < 180 || keydata["thickness"] > 500) &&
            (keydata["class"] != 0 && keydata["class"] != 1)) {
          Fluttertoast.showToast(msg: "钥匙厚度范围180-500");
          return false;
        }
        break;
    }
    if ((keydata["depth"] == 0 || keydata["depth"] > 110) &&
        (keydata["class"] != 0 && keydata["class"] != 1)) {
      Fluttertoast.showToast(msg: "切削深度不能为0且最大值为110");
      return false;
    }
    return true;
  }

  bool step5check() {
    if (keydata["locat"] == 1) {
      for (var i = 0; i < atooth - 1; i++) {
        if (keydata["toothSA"][i] < keydata["toothSA"][i + 1]) {
          Fluttertoast.showToast(msg: "齿位必须从大到小排列");
          return false;
        }
        if (keydata["toothSA"][i] <= 0) {
          Fluttertoast.showToast(msg: "齿位必须大于0");
          return false;
        }
      }
      if (keydata["side"] == 3) {
        for (var i = 0; i < btooth - 1; i++) {
          if (keydata["toothSB"][i] < keydata["toothSB"][i + 1]) {
            Fluttertoast.showToast(msg: "B齿位必须从大到小排列");
            return false;
          }
          if (keydata["toothSB"][i] <= 0) {
            Fluttertoast.showToast(msg: "齿位必须大于0");
            return false;
          }
        }
      }
    } else {
      for (var i = 0; i < atooth - 1; i++) {
        if (keydata["toothSA"][i] > keydata["toothSA"][i + 1]) {
          Fluttertoast.showToast(msg: "齿位必须从小到大排列");
          return false;
        }
        if (keydata["toothSA"][i] <= 0) {
          Fluttertoast.showToast(msg: "齿位必须大于0");
          return false;
        }
      }
      if (keydata["side"] == 3) {
        for (var i = 0; i < btooth - 1; i++) {
          if (keydata["toothSB"][i] > keydata["toothSB"][i + 1]) {
            Fluttertoast.showToast(msg: "B齿位必须从小到大排列");
            return false;
          }
          if (keydata["toothSB"][i] <= 0) {
            Fluttertoast.showToast(msg: "齿位必须大于0");
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
        Fluttertoast.showToast(msg: "齿深必须从大到小排列");
        return false;
      }
      if (keydata["toothDepth"][i] <= 0) {
        Fluttertoast.showToast(msg: "齿深必须大于0");
        return false;
      }
    }
    return true;
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
          Container(
            width: 340.w,
            height: 193.h,
            margin: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Color(0xff384c70),
              borderRadius: BorderRadius.all(Radius.circular(13.0)),
            ),
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              onPressed: () {
                setState(() {
                  diykeystep = 4;
                });
              },
              child: Column(
                children: [
                  SizedBox(
                      width: 340.w,
                      height: 23.h,
                      child: const Text(
                        "侧夹",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      child: Container(
                    width: 340.w,
                    color: Colors.white,
                    child: Image.file(File(getfixturepic(1, 0))),
                  )),
                ],
              ),
            ),
          ),
        );
      } else {
        for (var i = 0; i < keyfixturelist3.length; i++) {
          temp.add(
            Container(
              width: 340.w,
              height: 193.h,
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Color(0xff384c70),
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
              ),
              child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: () {
                  setState(() {
                    switch (i) {
                      case 0:
                        keydata["side"] = 0;
                        keydata["fixture"] = [3];
                        break;
                      case 1:
                        keydata["side"] = 1;
                        keydata["fixture"] = [4];
                        break;
                      case 2: //薄
                        keydata["side"] = 0;
                        keydata["fixture"] = [5];
                        break;

                      case 3: //薄
                        keydata["side"] = 1;
                        keydata["fixture"] = [5];
                        break;
                    }
                    diykeystep = 4;
                    //state = 0;
                  });
                },
                child: Column(
                  children: [
                    SizedBox(
                        width: 340.w,
                        height: 23.h,
                        child: Text(
                          keyfixturelist3[i],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        )),
                    Expanded(
                        child: Container(
                      width: 340.w,
                      color: Colors.white,
                      child:
                          Image.file(File(getfixturepic(i > 1 ? 5 : 0, i % 2))),
                    )),
                  ],
                ),
              ),
            ),
          );
        }
      }
    } else {
      if (keydata["class"] != 0 && keydata["class"] != 1) {
        for (var i = 0; i < keyfixturelist.length; i++) {
          temp.add(
            Container(
              width: 340.w,
              height: 193.h,
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Color(0xff384c70),
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
              ),
              child: TextButton(
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
                child: Column(
                  children: [
                    SizedBox(
                        width: 340.w,
                        height: 23.h,
                        child: Text(
                          keyfixturelist[i],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        )),
                    Expanded(
                        child: Container(
                      width: 340.w,
                      color: Colors.white,
                      child: Image.file(File(getfixturepic(i == 0 ? 0 : 5, 2))),
                    )),
                  ],
                ),
              ),
            ),
          );
        }
      } else {
        //平铣类型
        temp.add(
          Container(
            width: 340.w,
            height: 193.h,
            margin: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Color(0xff384c70),
              borderRadius: BorderRadius.all(Radius.circular(13.0)),
            ),
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              onPressed: () {
                setState(() {
                  diykeystep = 4;
                });
              },
              child: Column(
                children: [
                  SizedBox(
                      width: 340.w,
                      height: 23.h,
                      child: Text(
                        keydata["fixture"][0] == 1 ? "侧夹" : keyfixturelis5[0],
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      child: Container(
                    width: 340.w,
                    color: Colors.white,
                    child: Image.file(File(getfixturepic(
                        keydata["fixture"][0], keydata["class"] == 0 ? 2 : 0))),
                  )),
                ],
              ),
            ),
          ),
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
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            keytitle = keytitle + "-" + keylocatelist[i]["name"];
            switch (i) {
              case 0:
                debugPrint("对头");
                keydata["locat"] = 1;
                keydata["toothSA"][0] = 400;
                keydata["toothSA"][1] = 200;
                if (keydata["class"] == 0 || keydata["class"] == 1) {
                  keydata["picname"] = "GPT.png";
                } else {
                  keydata["picname"] = "GLT.png";
                }
                break;
              case 1:
                debugPrint("对肩");
                keydata["locat"] = 0;
                keydata["toothSA"][0] = 200;
                keydata["toothSA"][1] = 400;
                if (keydata["class"] == 0 || keydata["class"] == 1) {
                  keydata["picname"] = "GPJ.png";
                } else {
                  keydata["picname"] = "GLJ.png";
                }
                break;
              default:
            }

            diykeystep = 3;
            setState(() {});
          },
          child: Container(
            width: 340.w,
            height: 126.h,
            margin: EdgeInsets.only(
                left: 10.w, right: 10.w, top: 20.h, bottom: 20.h),
            decoration: BoxDecoration(
                color: const Color(0xff384c70),
                borderRadius: BorderRadius.circular(13)),
            child: Column(
              children: [
                SizedBox(
                  height: 23.h,
                  child: Text(
                    keylocatelist[i]["name"],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: 340.w,
                  height: 103.h,
                  color: Colors.white,
                  child: Image.file(
                    File(keylocatelist[i]["pic"]),
                  ),
                ))
              ],
            ),
          ),
        ),
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
            Text("齿位:${index + 1}:"),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          onetoothshow(index * 2),
          (atooth % 2 == 1 && index * 2 + 1 == atooth)
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
            Text("齿宽:${index + 1}"),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          onetoothwideshow(index * 2),
          (atooth % 2 == 1 && index * 2 + 1 == atooth)
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
            Text("齿深:${index + 1}"),
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

//更改齿数
  _changeToooth() {
    List<int> temp = [];
    int oldtooth;
    print(keydata["toothSA"]);
    print(keydata["toothSB"]);

    temp = List.from(keydata["toothSA"]);
    keydata["toothSA"] = [];
    oldtooth = temp.length;
    //  //print("object:$tooth");
    int diff = (temp[0] - temp[oldtooth - 1]) ~/ (tooth - 1);
    for (var i = 0; i < tooth; i++) {
      keydata["toothSA"].add(diff * (tooth - 1 - i) + temp[oldtooth - 1]);
    }
    keydata["toothSA"][0] = temp[0];
    keydata["toothSA"][tooth - 1] = temp[oldtooth - 1];
    keydata["toothWideA"] = [];

    for (var i = 0; i < tooth; i++) {
      keydata["toothWideA"].add(100);
    }

    if (keydata["side"] == 3) {
      temp = List.from(keydata["toothSB"]);
      // //print(keydata["toothSA"]);
      keydata["toothSB"] = [];
      oldtooth = temp.length;
      //  //print("object:$tooth");
      int difft = (temp[0] - temp[oldtooth - 1]) ~/ (tooth - 1);

      for (var i = 0; i < tooth; i++) {
        keydata["toothSB"].add(difft * (tooth - 1 - i) + temp[oldtooth - 1]);
      }
      keydata["toothSB"][0] = temp[0];
      keydata["toothSB"][tooth - 1] = temp[oldtooth - 1];
      keydata["toothWideB"] = [];

      for (var i = 0; i < tooth; i++) {
        keydata["toothWideB"].add(100);
      }
      if (keydata["side"] != 3) {
        keydata["toothWideA"] = [];
        for (var i = 0; i < tooth; i++) {
          keydata["toothWideA"].add(100);
        }
        keydata["toothSA"] = List.from(keydata["toothSB"]);
      }
      //print(keydata["toothSA"]);
    } else {
      keydata["toothWideB"] = [];
      for (var i = 0; i < tooth; i++) {
        keydata["toothWideB"].add(100);
      }
      keydata["toothSB"] = List.from(keydata["toothSA"]);
    }

    ////print(keydata["toothSA"]);
    // _asyncTooth();
    setState(() {});
  }

  _changeTooothDepth() {
    List<int> temp = [];
    int oldtooth;
    ////print("keydata[\"side\"]:${keydata["side"]}");

    temp = List.from(keydata["toothDepth"]);
    keydata["toothDepth"] = [];
    oldtooth = temp.length;
    //  //print("object:$tooth");
    int diff = (temp[0] - temp[oldtooth - 1]) ~/ (toothnum - 1);
    for (var i = 0; i < toothnum; i++) {
      keydata["toothDepth"].add(diff * (toothnum - 1 - i) + temp[oldtooth - 1]);
    }
    keydata["toothDepth"][0] = temp[0];
    keydata["toothDepth"][toothnum - 1] = temp[oldtooth - 1];
    keydata["toothDepthName"] = [];
    for (var i = 0; i < toothnum; i++) {
      keydata["toothDepthName"].add("${i + 1}");
    }
    //print(keydata["toothSA"]);

    ////print(keydata["toothSA"]);
    // _asyncTooth();
    setState(() {});
  }

  void _longPress(int model) {
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 100), (v) {
      switch (model) {
        case 0: //放大长按
          imagescale = imagescale + 0.01;
          controller.scale = imagescale;
          setState(() {});
          break;
        case 1: //缩小长按
          imagescale = imagescale - 0.01;
          controller.scale = imagescale;
          setState(() {});
          break;
        case 2: //左转长按
          imagerotation = imagerotation + 0.01;
          controller.rotation = imagerotation;
          setState(() {});
          break;
        case 3: //右转长按
          imagerotation = imagerotation - 0.01;
          controller.rotation = imagerotation;
          setState(() {});
          break;
        case 4:
          imageposty = imageposty - 2;
          controller.position = Offset(imagepostx, imageposty);
          setState(() {});
          break;
        case 5:
          imageposty = imageposty + 2;
          controller.position = Offset(imagepostx, imageposty);
          setState(() {});
          break;
        case 6:
          imagepostx = imagepostx - 2;
          controller.position = Offset(imagepostx, imageposty);
          setState(() {});
          break;
        case 7:
          imagepostx = imagepostx + 2;
          controller.position = Offset(imagepostx, imageposty);
          setState(() {});
          break;
      }
    });
  }

//齿深齿距标题
  Widget keySASHTitle() {
    switch (diykeystep) {
      case 5:
        return Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 40.h,
              width: double.maxFinite,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/8)位置确定",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ));
      case 6:
        return Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 40.h,
              width: double.maxFinite,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/8)位置确定",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ));
      case 7:
        return Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 40.h,
              width: double.maxFinite,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/8)位置确定",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ));
      default:
        return Container();
    }
  }

//齿深齿距右边控制栏
  Widget keySASHRightControl() {
    switch (diykeystep) {
      case 5:
        return Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 50.r,
                height: 50.r,
                child: GestureDetector(
                  onPanDown: (details) {
                    imagescale = imagescale + 0.001;
                    controller.scale = imagescale;
                    setState(() {});
                  },
                  onLongPressStart: (details) {
                    _longPress(0);
                  },
                  onLongPressEnd: (details) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                  },
                  child: Image.asset("image/tank/Icon_enlarge.png"),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                width: 50.r,
                height: 50.r,
                child: GestureDetector(
                    onPanDown: (details) {
                      imagescale = imagescale - 0.001;
                      controller.scale = imagescale;
                      setState(() {});
                    },
                    onLongPressStart: (details) {
                      // sendmotor(0);
                      _longPress(1);
                    },
                    onLongPressEnd: (details) {
                      //   timer!.cancel();
                      if (timer != null) {
                        timer!.cancel();
                      }
                    },
                    child: Image.asset("image/tank/Icon_narrow.png")),
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                width: 50.r,
                height: 50.r,
                child: GestureDetector(
                    onPanDown: (details) {
                      imagerotation = imagerotation + 0.01;
                      controller.rotation = imagerotation;
                      setState(() {});
                    },
                    onLongPressStart: (details) {
                      // sendmotor(0);

                      _longPress(2);
                    },
                    onLongPressEnd: (details) {
                      //   timer!.cancel();
                      if (timer != null) {
                        timer!.cancel();
                      }
                    },
                    child: Image.asset("image/tank/Icon_turnleft.png")),
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                width: 50.r,
                height: 50.r,
                child: GestureDetector(
                    onPanDown: (details) {
                      imagerotation = imagerotation - 0.01;
                      controller.rotation = imagerotation;
                      setState(() {});
                    },
                    onLongPressStart: (details) {
                      // sendmotor(0);
                      _longPress(3);
                    },
                    onLongPressEnd: (details) {
                      //   timer!.cancel();
                      if (timer != null) {
                        timer!.cancel();
                      }
                    },
                    child: Image.asset("image/tank/Icon_turnright.png")),
              ),
            ],
          ),
        );
      case 7:
        return Container();
      default:
        return Container();
    }
  }

//齿深齿距左边边控制栏
  Widget keySASHLeftControl() {
    switch (diykeystep) {
      case 5:
        return Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 50.r,
                height: 50.r,
                child: GestureDetector(
                  onPanDown: (details) {
                    imageposty = imageposty - 1;
                    controller.position = Offset(imagepostx, imageposty);
                    setState(() {});
                  },
                  onLongPressStart: (details) {
                    _longPress(4);
                  },
                  onLongPressEnd: (details) {
                    if (timer != null) {
                      timer!.cancel();
                    }
                  },
                  child: Image.asset("image/tank/Icon_moveup.png"),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                width: 50.r,
                height: 50.r,
                child: GestureDetector(
                    onPanDown: (details) {
                      imageposty = imageposty + 1;
                      controller.position = Offset(imagepostx, imageposty);
                      setState(() {});
                    },
                    onLongPressStart: (details) {
                      // sendmotor(0);
                      _longPress(5);
                    },
                    onLongPressEnd: (details) {
                      //   timer!.cancel();
                      if (timer != null) {
                        timer!.cancel();
                      }
                    },
                    child: Image.asset("image/tank/Icon_movedown.png")),
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                width: 50.r,
                height: 50.r,
                child: GestureDetector(
                    onPanDown: (details) {
                      imagepostx = imagepostx - 1;
                      controller.position = Offset(imagepostx, imageposty);
                      setState(() {});
                    },
                    onLongPressStart: (details) {
                      // sendmotor(0);

                      _longPress(6);
                    },
                    onLongPressEnd: (details) {
                      //   timer!.cancel();
                      if (timer != null) {
                        timer!.cancel();
                      }
                    },
                    child: Image.asset("image/tank/Icon_moveleft.png")),
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                width: 50.r,
                height: 50.r,
                child: GestureDetector(
                    onPanDown: (details) {
                      imagepostx = imagepostx + 1;
                      controller.position = Offset(imagepostx, imageposty);
                      setState(() {});
                    },
                    onLongPressStart: (details) {
                      // sendmotor(0);
                      _longPress(7);
                    },
                    onLongPressEnd: (details) {
                      //   timer!.cancel();
                      if (timer != null) {
                        timer!.cancel();
                      }
                    },
                    child: Image.asset("image/tank/Icon_moveright.png")),
              ),
            ],
          ),
        );
      case 6:
      case 7:
        return Container();
      default:
        return Container();
    }
  }

//齿深齿距底部控制栏
  Widget keySASHBottomControl() {
    switch (diykeystep) {
      case 5:
        return Align(
          child: SizedBox(
            width: 100.w,
            height: 30.h,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff384c70))),
                onPressed: () {
                  diykeystep++;
                  setState(() {});
                },
                child: Text("下一步")),
          ),
          alignment: Alignment.bottomCenter,
        );
      case 6:
      case 7:
        return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50.w,
                    height: 30.h,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        onPressed: () {
                          if (diykeystep == 6) {
                            if (baseKey.seleindex == 1) {
                              keydata["toothSA"][0] =
                                  keydata["toothSA"][0] + changeDiff[seleDiff];
                            } else {
                              keydata["toothSA"][tooth - 1] = keydata["toothSA"]
                                      [tooth - 1] +
                                  changeDiff[seleDiff];
                            }
                          }
                          if (diykeystep == 7) {
                            if (baseKey.seleindex == 1) {
                              keydata["toothDepth"][0] = keydata["toothDepth"]
                                      [0] +
                                  changeDiff[seleDiff];
                            } else {
                              keydata["toothDepth"][toothnum - 1] =
                                  keydata["toothDepth"][toothnum - 1] +
                                      changeDiff[seleDiff];
                            }
                          }
                          setState(() {});
                        },
                        child: Text("+")),
                  ),
                  SizedBox(
                    width: 50.w,
                    height: 30.h,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        onPressed: () {
                          seleDiff++;
                          if (seleDiff > 2) {
                            seleDiff = 0;
                          }
                          setState(() {});
                        },
                        child: Text(
                          "${changeDiff[seleDiff] / 100}",
                        )),
                  ),
                  SizedBox(
                    width: 50.w,
                    height: 30.h,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        onPressed: () {
                          if (diykeystep == 6) {
                            if (baseKey.seleindex == 1) {
                              keydata["toothSA"][0] =
                                  keydata["toothSA"][0] - changeDiff[seleDiff];
                            } else {
                              keydata["toothSA"][tooth - 1] = keydata["toothSA"]
                                      [tooth - 1] -
                                  changeDiff[seleDiff];
                            }
                          }
                          if (diykeystep == 7) {
                            if (baseKey.seleindex == 1) {
                              keydata["toothDepth"][0] = keydata["toothDepth"]
                                      [0] -
                                  changeDiff[seleDiff];
                            } else {
                              keydata["toothDepth"][toothnum - 1] =
                                  keydata["toothDepth"][toothnum - 1] -
                                      changeDiff[seleDiff];
                            }
                          }
                          setState(() {});
                        },
                        child: Text("-")),
                  ),
                  SizedBox(
                    width: 50.w,
                    height: 30.h,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        onPressed: () {
                          if (diykeystep == 6) {
                            tooth++;
                            atooth++;
                            btooth++;
                            if (tooth > 12) {
                              tooth = 12;
                              atooth = 12;
                              btooth = 12;
                            }
                            _changeToooth();
                          }
                          if (diykeystep == 7) {
                            toothnum++;
                            if (toothnum > 8) {
                              toothnum = 8;
                            }
                            _changeTooothDepth();
                          }
                        },
                        child: Text("+")),
                  ),
                  SizedBox(
                    width: 50.w,
                    height: 30.h,
                    child: Center(
                      child: Text(
                        diykeystep == 6
                            ? (tooth.toString())
                            : (toothnum.toString()),
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.w,
                    height: 30.h,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        onPressed: () {
                          if (diykeystep == 6) {
                            tooth--;
                            atooth--;
                            btooth--;
                            if (tooth < 2) {
                              tooth = 2;
                              atooth = 2;
                              btooth = 2;
                            }
                            _changeToooth();
                          }
                          if (diykeystep == 7) {
                            toothnum--;
                            if (toothnum < 2) {
                              toothnum = 2;
                            }
                            _changeTooothDepth();
                          }
                        },
                        child: Text("-")),
                  ),
                ],
              ),
              SizedBox(
                height: 10.r,
              ),
              SizedBox(
                width: 100.w,
                height: 30.h,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff384c70))),
                    onPressed: () {
                      diykeystep++;
                      setState(() {});
                    },
                    child: Text("下一步")),
              ),
            ],
          ),
        );

      default:
        return Align(
          child: SizedBox(
            width: 100.w,
            height: 30.h,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff384c70))),
                onPressed: () {
                  diykeystep++;
                  setState(() {});
                },
                child: Text("下一步")),
          ),
          alignment: Alignment.bottomCenter,
        );
    }
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
                  "($diykeystep/8)钥匙类型",
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
                  "($diykeystep/8)" + S.of(context).keyloact,
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
                  "($diykeystep/8)夹具类型",
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
                  "($diykeystep/8)钥匙形状",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              width: 320.w,
              height: 150,
              child: const Center(child: Text("钥匙示意图")),
            ),
            Expanded(
              child: ListView(children: [
                Container(
                  height: 40.h,
                  color: const Color(0xffdde2ea),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "A:钥匙宽度:",
                      ),
                      SizedBox(
                        width: 200.w,
                        child: TextField(
                          controller: TextEditingController(
                              text: keydata["wide"] == 0
                                  ? ""
                                  : "${keydata["wide"]}"),
                          keyboardType: TextInputType.phone,
                          decoration:
                              const InputDecoration(hintText: "请输入范围400-1100"),
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
                      const Text(
                        "B:钥匙厚度:",
                      ),
                      SizedBox(
                        width: 200.w,
                        child: TextField(
                          controller: TextEditingController(
                              text: keydata["thickness"] == 0
                                  ? ""
                                  : "${keydata["thickness"]}"),
                          keyboardType: TextInputType.phone,
                          decoration:
                              const InputDecoration(hintText: "请输入范围180-500"),
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
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                (keydata["class"] != 0 && keydata["class"] != 1)
                    ? Container(
                        height: 40.h,
                        color: const Color(0xffdde2ea),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("E:切割深度:"),
                            SizedBox(
                              width: 200.w,
                              child: TextField(
                                controller: TextEditingController(
                                    text: keydata["depth"] == 0
                                        ? ""
                                        : "${keydata["depth"]}"),
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: "切割深度(最大110)",
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
                            const Text("F:沟槽宽度:"),
                            SizedBox(
                              width: 200.w,
                              child: TextField(
                                controller: TextEditingController(
                                    text: keydata["groove"] == 0
                                        ? ""
                                        : "${keydata["groove"]}"),
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: "请输入沟槽宽度",
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
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                const Text(
                  "请输入相应参数(单位0.01mm)",
                  style: TextStyle(color: Colors.red),
                ),
              ]),
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
                    child: const Text(
                      "下一步",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      switch (diykeystep) {
                        case 4:
                          if (step4check()) {
                            // setState(() {
                            //   diykeystep = 5;
                            // });
                            if (keydata["locat"] == 0) {
                              keydata["toothSA"][0] = 450;
                              keydata["toothSA"][1] = 2000;
                              keydata["toothSB"][0] = 450;
                              keydata["toothSB"][1] = 2000;
                            } else {
                              keydata["toothSA"][0] = 2000;
                              keydata["toothSA"][1] = 450;
                              keydata["toothSB"][0] = 2000;
                              keydata["toothSB"][1] = 450;
                            }
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return const MySeleDialog(["相册", "相机"]);
                                }).then((value) {
                              switch (value) {
                                case 1:
                                  debugPrint("选择相册");

                                  _onImageButtonPressed(ImageSource.gallery,
                                      context: context);
                                  break;
                                case 2:
                                  debugPrint("选择相机");
                                  _onImageButtonPressed(ImageSource.camera,
                                      context: context);
                                  break;
                                default:
                                  break;
                              }
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

      case 5: //确定位置
      case 6: //确定齿距
      case 7: //确定齿深
        return SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: GestureDetector(
            onPanDown: (details) {
              if (diykeystep == 6) {
                touchoffect = details.localPosition;
                _changeToooth();
                setState(() {});
              }
              if (diykeystep == 7) {
                touchoffect = details.localPosition;
                _changeTooothDepth();
                setState(() {});
              }
            },
            onPanUpdate: (details) {
              if (diykeystep == 6) {
                touchoffect = details.localPosition;
                _changeToooth();
                setState(() {});
              }
              if (diykeystep == 7) {
                touchoffect = details.localPosition;
                _changeTooothDepth();
                setState(() {});
              }
            },
            child: Stack(
              children: [
                keySASHTitle(),
                Align(
                  child: CustomPaint(
                    size:
                        const Size(double.maxFinite / 2, double.maxFinite / 2),
                    foregroundPainter: PhotoPainter(
                      touchoffect,
                      diykeystep,
                      keydata,
                      seletooth,
                    ),
                    child: PhotoView(
                      imageProvider: FileImage(File(filepath)),
                      enableRotation: false,
                      controller: controller,
                      enablePanAlways: true,
                      disableGestures: diykeystep > 5 ? true : false, //关闭手势操作
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                //左边边控制栏目
                keySASHLeftControl(),
                //右边控制栏目
                keySASHRightControl(),
                //底部控制栏
                keySASHBottomControl(),
              ],
            ),
          ),
        );

      // case 6: //齿距确定
      //   return Column(children: [
      //     Container(
      //       height: 40.h,
      //       color: const Color(0xffdde1ea),
      //       child: Center(
      //         child: Text(
      //           "($diykeystep/8)齿距确定",
      //           style:
      //               TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //         child: SizedBox(
      //       width: double.maxFinite,
      //       child: Stack(
      //         children: [
      //           Align(
      //               alignment: Alignment.center,
      //               child: GestureDetector(
      //                 onPanDown: (details) {
      //                   touchoffect = details.localPosition;
      //                   _changeToooth();
      //                   setState(() {});
      //                 },
      //                 onPanUpdate: (details) {
      //                   touchoffect = details.localPosition;
      //                   _changeToooth();
      //                   setState(() {});
      //                 },
      //                 child: CustomPaint(
      //                   size: const Size(
      //                       double.maxFinite / 2, double.maxFinite / 2),
      //                   foregroundPainter:
      //                       PhotoPainter(touchoffect, 6, keydata, seletooth),
      //                   child: PhotoView(
      //                       imageProvider: FileImage(File(filepath)),
      //                       enableRotation: false,
      //                       initialScale: currentscale,
      //                       controller: controller,
      //                       enablePanAlways: false,
      //                       disableGestures: true //关闭手势操作
      //                       ),
      //                 ),
      //               )),
      //           Align(
      //             alignment: Alignment.centerLeft,
      //             child: Column(
      //               children: const [],
      //             ),
      //           ),
      //         ],
      //       ),
      //     )),
      //     SizedBox(
      //       width: 160.w,
      //       height: 30.h,
      //       child: Row(
      //         children: [
      //           SizedBox(
      //               width: 30.w,
      //               child: TextButton(
      //                   style: ButtonStyle(
      //                       padding:
      //                           MaterialStateProperty.all(EdgeInsets.zero)),
      //                   onPressed: () {
      //                     if (tooth > 2) {
      //                       tooth--;
      //                     }
      //                     _changeToooth();
      //                     setState(() {});
      //                   },
      //                   child: Image.asset("image/tank/Icon_rounddec.png"))),
      //           Expanded(
      //             child: Text(
      //               "$tooth齿",
      //               textAlign: TextAlign.center,
      //             ),
      //           ),
      //           SizedBox(
      //               width: 30.w,
      //               child: TextButton(
      //                   style: ButtonStyle(
      //                       padding:
      //                           MaterialStateProperty.all(EdgeInsets.zero)),
      //                   onPressed: () {
      //                     if (tooth < 12) {
      //                       tooth++;
      //                     }
      //                     _changeToooth();
      //                     setState(() {});
      //                   },
      //                   child: Image.asset("image/tank/Icon_roundadd.png"))),
      //         ],
      //       ),
      //     ),
      //     const Text("请确认齿位", style: TextStyle(color: Colors.red)),
      //     ElevatedButton(
      //       onPressed: () {
      //         diykeystep = 7;
      //         setState(() {});
      //       },
      //       child: const Text(
      //         "下一步",
      //       ),
      //     ),
      //   ]);
      // case 7: //钥匙齿深
      //   return Column(children: [
      //     Container(
      //       height: 40.h,
      //       color: const Color(0xffdde1ea),
      //       child: Center(
      //         child: Text(
      //           "($diykeystep/8)齿深确定",
      //           style:
      //               TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //         child: SizedBox(
      //       width: double.maxFinite,
      //       child: Stack(
      //         children: [
      //           Align(
      //               alignment: Alignment.center,
      //               child: GestureDetector(
      //                 onPanDown: (details) {
      //                   ////print(ahNum);
      //                   ////print(details.localPosition);

      //                   touchoffect = details.localPosition;
      //                   _changeTooothDepth();
      //                   setState(() {});
      //                 },
      //                 onPanUpdate: (details) {
      //                   touchoffect = details.localPosition;
      //                   _changeTooothDepth();
      //                   setState(() {});
      //                 },
      //                 child: CustomPaint(
      //                   size: const Size(
      //                       double.maxFinite / 2, double.maxFinite / 2),
      //                   foregroundPainter:
      //                       PhotoPainter(touchoffect, 7, keydata, seletooth),
      //                   child: PhotoView(
      //                       imageProvider: FileImage(File(filepath)),
      //                       enableRotation: false,
      //                       initialScale: currentscale,
      //                       controller: controller,
      //                       enablePanAlways: false,
      //                       disableGestures: true //关闭手势操作
      //                       ),
      //                 ),
      //               )),
      //           Align(
      //             alignment: Alignment.centerLeft,
      //             child: Column(
      //               children: const [],
      //             ),
      //           ),
      //         ],
      //       ),
      //     )),
      //     SizedBox(
      //       width: 160.w,
      //       height: 30.h,
      //       child: Row(
      //         children: [
      //           SizedBox(
      //               width: 30.w,
      //               child: TextButton(
      //                   style: ButtonStyle(
      //                       padding:
      //                           MaterialStateProperty.all(EdgeInsets.zero)),
      //                   onPressed: () {
      //                     if (toothnum > 2) {
      //                       toothnum--;
      //                     }
      //                     _changeTooothDepth();
      //                     setState(() {});
      //                   },
      //                   child: Image.asset("image/tank/Icon_rounddec.png"))),
      //           Expanded(
      //             child: Text(
      //               "$toothnum",
      //               textAlign: TextAlign.center,
      //             ),
      //           ),
      //           SizedBox(
      //               width: 30.w,
      //               child: TextButton(
      //                   style: ButtonStyle(
      //                       padding:
      //                           MaterialStateProperty.all(EdgeInsets.zero)),
      //                   onPressed: () {
      //                     if (toothnum < 12) {
      //                       toothnum++;
      //                     }
      //                     _changeTooothDepth();
      //                     setState(() {});
      //                   },
      //                   child: Image.asset("image/tank/Icon_roundadd.png"))),
      //         ],
      //       ),
      //     ),
      //     const Text("请确认齿深", style: TextStyle(color: Colors.red)),
      //     ElevatedButton(
      //       onPressed: () {
      //         diykeystep = 8;
      //         setState(() {});
      //       },
      //       child: const Text(
      //         "下一步",
      //       ),
      //     ),
      //   ]);

      case 8:
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/8)钥匙名称",
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
                  child: const Center(
                    child: Text("图片显示区域"),
                  ),
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
                      const Text("品牌名称: "),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            // WhitelistingTextInputFormatter(accountRegExp),
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
                      const Text("品牌车型: "),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
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
                // Container(
                //   height: 40.h,
                //   color: const Color(0xffdde1ea),
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         width: 22.w,
                //       ),
                //       const Text("品牌年份: "),
                //       SizedBox(
                //         width: 22.w,
                //       ),
                //       Expanded(
                //         child: TextField(
                //           keyboardType: TextInputType.phone,
                //           inputFormatters: [
                //             LengthLimitingTextInputFormatter(16),
                //             //Pattern x
                //             //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                //             // WhitelistingTextInputFormatter(accountRegExp),
                //           ],
                //           onChanged: (value) {
                //             keydata["carmodeltime"] = value;
                //           },
                //         ),
                //       ),
                //       SizedBox(
                //         width: 22.w,
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      const Text("钥匙名称: "),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            // WhitelistingTextInputFormatter(accountRegExp),
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
                      const Text("备注信息: "),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
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
                    child: const Text(
                      "完成",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (keydata["carname"] == "") {
                        Fluttertoast.showToast(msg: "请输入品牌名称");
                      } else if (keydata["cnname"] == "") {
                        Fluttertoast.showToast(msg: "请输入钥匙名称");
                      } else {
                        await addDiyKey();
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("是否立即使用?");
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

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        // maxWidth: 100.0,
        // maxHeight: 100.0,
        // imageQuality: quality,
      );
      setState(() {
        filepath = pickedFile!.path;
        diykeystep = 5;
      });
    } catch (e) {
      debugPrint("$e");
      //setState(() {
      // _pickImageError = e;
      //});
    }
  }
}
