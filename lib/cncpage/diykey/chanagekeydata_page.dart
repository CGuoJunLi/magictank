import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/userappbar.dart';

class ChangeKeyDataPage extends StatefulWidget {
  final Map needChanageData;
  const ChangeKeyDataPage(this.needChanageData, {Key? key}) : super(key: key);

  @override
  State<ChangeKeyDataPage> createState() => _ChangeKeyDataPageState();
}

class _ChangeKeyDataPageState extends State<ChangeKeyDataPage> {
  late Map needChanageData;
  late Map keydata;
  late int atooth;
  late int btooth;
  late int toothnum;
  RegExp onlynum = RegExp(r'[0-9]+'); //数字和和字母组成
  @override
  void initState() {
    needChanageData = Map.from(widget.needChanageData);
    keydata = json.decode(needChanageData["data"]);
    atooth = keydata["toothSA"].length;
    btooth = keydata["toothSB"].length;
    toothnum = keydata["toothDepth"].length;
    super.initState();
  }

  Future<void> delKeyData(keydata) async {
    try {
      var result = await Api.delUserKey(keydata);
      ////print(result);
      if (result["state"]) {
        await appData.deleUserKey(keydata["id"].toString());
      } else {
        await appData.updateUserKey(keydata["id"].toString(), 3);
      }
    } catch (e) {
      await appData.updateUserKey(keydata["id"].toString(), 3);
    }
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

//齿位A
  Widget toothsa() {
    List<Widget> temp = [];
    temp.add(
      SizedBox(
        width: double.maxFinite,
        height: 40.h,
        child: Row(
          children: [
            Text(
              S.of(context).keytoothnumA,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0XFF384C70))),
                onPressed: () {
                  if (keydata["locat"] == 0) {
                    if (keydata["toothSA"][0] > keydata["toothSA"][1]) {
                      Fluttertoast.showToast(msg: S.of(context).diykeytip3);
                    } else {
                      int diff = keydata["toothSA"][1] - keydata["toothSA"][0];
                      for (var i = 2; i < atooth; i++) {
                        keydata["toothSA"][i] =
                            keydata["toothSA"][i - 1] + diff;
                      }
                    }
                  } else {
                    if (keydata["toothSA"][0] < keydata["toothSA"][1]) {
                      Fluttertoast.showToast(msg: S.of(context).diykeytip3);
                    } else {
                      int diff = keydata["toothSA"][0] - keydata["toothSA"][1];
                      for (var i = 2; i < atooth; i++) {
                        keydata["toothSA"][i] =
                            keydata["toothSA"][i - 1] - diff;
                      }
                    }
                  }
                  setState(() {});
                },
                child: Text(S.of(context).autoinput)),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
    for (var i = 0;
        i < (((atooth) % 2 == 0) ? atooth ~/ 2 : atooth ~/ 2 + 1);
        i++) {
      temp.add(
        SizedBox(
          width: double.maxFinite,
          height: 40.h,
          child: Row(
            children: [
              Text(
                "${i * 2 + 1}:",
              ),
              SizedBox(
                width: 90.h,
                child: TextField(
                  controller: TextEditingController(
                      text: keydata["toothSA"][i * 2] == 0
                          ? ""
                          : "${keydata["toothSA"][i * 2]}"),
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(contentPadding: EdgeInsets.zero),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(16),
                    //Pattern x

                    FilteringTextInputFormatter(onlynum, allow: true),
                    // WhitelistingTextInputFormatter(accountRegExp),
                  ],
                  onChanged: (value) {
                    if (value == "") {
                      keydata["toothSA"][i * 2] = 0;
                    } else {
                      keydata["toothSA"][i * 2] = int.parse(value);
                    }
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              (i * 2 + 2 <= atooth)
                  ? Text(
                      "${i * 2 + 2}:",
                    )
                  : Container(),
              (i * 2 + 2 <= atooth)
                  ? SizedBox(
                      width: 90.h,
                      child: TextField(
                        controller: TextEditingController(
                            text: keydata["toothSA"][i * 2 + 1] == 0
                                ? ""
                                : "${keydata["toothSA"][i * 2 + 1]}"),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(16),
                          //Pattern x

                          FilteringTextInputFormatter.allow(
                              RegExp(r'([1-9][0-9]{0,3})')),
                          // WhitelistingTextInputFormatter(accountRegExp),
                        ],
                        onChanged: (value) {
                          if (value == "") {
                            keydata["toothSA"][i * 2 + 1] = 0;
                          } else {
                            keydata["toothSA"][i * 2 + 1] = int.parse(value);
                          }
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    }
    return Container(
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        color: const Color(0xffdde2ea),
        width: double.maxFinite,
        child: Column(
          children: temp,
        ));
  }

//齿位B
  Widget toothsb() {
    List<Widget> temp = [];
    temp.add(SizedBox(
        width: double.maxFinite,
        height: 40.h,
        child: Row(
          children: [
            Text(
              S.of(context).keytoothnumB,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0XFF384C70))),
                onPressed: () {
                  if (keydata["locat"] == 0) {
                    if (keydata["toothSB"][0] > keydata["toothSB"][1]) {
                      Fluttertoast.showToast(msg: S.of(context).diykeytip6);
                    } else {
                      int diff = keydata["toothSB"][1] - keydata["toothSB"][0];
                      for (var i = 2; i < btooth; i++) {
                        keydata["toothSB"][i] =
                            keydata["toothSB"][i - 1] + diff;
                      }
                    }
                  } else {
                    if (keydata["toothSB"][0] < keydata["toothSB"][1]) {
                      Fluttertoast.showToast(msg: S.of(context).diykeytip5);
                    } else {
                      int diff = keydata["toothSB"][0] - keydata["toothSB"][1];
                      for (var i = 2; i < btooth; i++) {
                        keydata["toothSB"][i] =
                            keydata["toothSB"][i - 1] - diff;
                      }
                    }
                  }
                  setState(() {});
                },
                child: Text(S.of(context).autoinput)),
          ],
        )));
    for (var i = 0;
        i < (((btooth) % 2 == 0) ? btooth ~/ 2 : btooth ~/ 2 + 1);
        i++) {
      temp.add(
        SizedBox(
          width: double.maxFinite,
          height: 40.h,
          child: Row(
            children: [
              Text(
                "${i * 2 + 1}:",
              ),
              SizedBox(
                width: 90.h,
                child: TextField(
                  controller: TextEditingController(
                      text: keydata["toothSB"][i * 2] == 0
                          ? ""
                          : "${keydata["toothSB"][i * 2]}"),
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(contentPadding: EdgeInsets.zero),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(16),
                    //Pattern x

                    FilteringTextInputFormatter(onlynum, allow: true),
                    // WhitelistingTextInputFormatter(accountRegExp),
                  ],
                  onChanged: (value) {
                    if (value == "") {
                      keydata["toothSB"][i * 2] = 0;
                    } else {
                      keydata["toothSB"][i * 2] = int.parse(value);
                    }
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              (i * 2 + 2 <= btooth)
                  ? Text(
                      "${i * 2 + 2}:",
                    )
                  : Container(),
              (i * 2 + 2 <= btooth)
                  ? SizedBox(
                      width: 90.h,
                      child: TextField(
                        controller: TextEditingController(
                            text: keydata["toothSB"][i * 2 + 1] == 0
                                ? ""
                                : "${keydata["toothSB"][i * 2 + 1]}"),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(16),
                          //Pattern x

                          FilteringTextInputFormatter.allow(
                              RegExp(r'([1-9][0-9]{0,3})')),
                          // WhitelistingTextInputFormatter(accountRegExp),
                        ],
                        onChanged: (value) {
                          if (value == "") {
                            keydata["toothSB"][i * 2 + 1] = 0;
                          } else {
                            keydata["toothSB"][i * 2 + 1] = int.parse(value);
                          }
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    }
    return Container(
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        color: const Color(0xffdde2ea),
        width: double.maxFinite,
        child: Column(
          children: temp,
        ));
  }

//齿宽A
  Widget toothwa() {
    List<Widget> temp = [];
    temp.add(
      SizedBox(
        width: double.maxFinite,
        height: 40.h,
        child: Row(
          children: [
            Text(
              S.of(context).keytoothwideA,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0XFF384C70))),
                onPressed: () {
                  if (keydata["toothWideA"][0] == 0) {
                    Fluttertoast.showToast(msg: S.of(context).diykeytip4);
                  } else {
                    for (var i = 1; i < atooth; i++) {
                      keydata["toothWideA"][i] = keydata["toothWideA"][0];
                    }
                  }

                  setState(() {});
                },
                child: Text(S.of(context).autoinput)),
          ],
        ),
      ),
    );
    for (var i = 0;
        i < (((atooth) % 2 == 0) ? atooth ~/ 2 : atooth ~/ 2 + 1);
        i++) {
      temp.add(
        SizedBox(
          width: double.maxFinite,
          height: 40.h,
          child: Row(
            children: [
              Text(
                "${i * 2 + 1}:",
              ),
              SizedBox(
                width: 90.h,
                child: TextField(
                  controller: TextEditingController(
                      text: keydata["toothWideA"][i * 2] == 0
                          ? ""
                          : "${keydata["toothWideA"][i * 2]}"),
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(contentPadding: EdgeInsets.zero),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(16),
                    //Pattern x

                    FilteringTextInputFormatter(onlynum, allow: true),
                    // WhitelistingTextInputFormatter(accountRegExp),
                  ],
                  onChanged: (value) {
                    if (value == "") {
                      keydata["toothWideA"][i * 2] = 0;
                    } else {
                      keydata["toothWideA"][i * 2] = int.parse(value);
                    }
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              (i * 2 + 2 <= atooth)
                  ? Text(
                      "${i * 2 + 2}:",
                    )
                  : Container(),
              (i * 2 + 2 <= atooth)
                  ? SizedBox(
                      width: 90.h,
                      child: TextField(
                        controller: TextEditingController(
                            text: keydata["toothWideA"][i * 2 + 1] == 0
                                ? ""
                                : "${keydata["toothWideA"][i * 2 + 1]}"),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(16),
                          //Pattern x

                          FilteringTextInputFormatter.allow(
                              RegExp(r'([1-9][0-9]{0,3})')),
                          // WhitelistingTextInputFormatter(accountRegExp),
                        ],
                        onChanged: (value) {
                          if (value == "") {
                            keydata["toothWideA"][i * 2 + 1] = 0;
                          } else {
                            keydata["toothWideA"][i * 2 + 1] = int.parse(value);
                          }
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    }
    return Container(
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        color: const Color(0xffdde2ea),
        width: double.maxFinite,
        child: Column(
          children: temp,
        ));
  }

//齿宽B
  Widget toothwb() {
    List<Widget> temp = [];
    temp.add(SizedBox(
        width: double.maxFinite,
        height: 40.h,
        child: Row(
          children: [
            Text(
              S.of(context).keytoothwideB,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0XFF384C70))),
                onPressed: () {
                  if (keydata["toothWideB"][0] == 0) {
                    Fluttertoast.showToast(msg: S.of(context).diykeytip4);
                  } else {
                    for (var i = 1; i < btooth; i++) {
                      keydata["toothWideB"][i] = keydata["toothWideB"][0];
                    }
                  }

                  setState(() {});
                },
                child: Text(S.of(context).autoinput)),
          ],
        )));
    for (var i = 0;
        i < (((btooth) % 2 == 0) ? btooth ~/ 2 : btooth ~/ 2 + 1);
        i++) {
      temp.add(
        SizedBox(
          width: double.maxFinite,
          height: 40.h,
          child: Row(
            children: [
              Text(
                "${i * 2 + 1}:",
              ),
              SizedBox(
                width: 90.h,
                child: TextField(
                  controller: TextEditingController(
                      text: keydata["toothWideB"][i * 2] == 0
                          ? ""
                          : "${keydata["toothWideB"][i * 2]}"),
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(contentPadding: EdgeInsets.zero),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(16),
                    //Pattern x

                    FilteringTextInputFormatter(onlynum, allow: true),
                    // WhitelistingTextInputFormatter(accountRegExp),
                  ],
                  onChanged: (value) {
                    if (value == "") {
                      keydata["toothWideB"][i * 2] = 0;
                    } else {
                      keydata["toothWideB"][i * 2] = int.parse(value);
                    }
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              (i * 2 + 2 <= btooth)
                  ? Text(
                      "${i * 2 + 2}:",
                    )
                  : Container(),
              (i * 2 + 2 <= btooth)
                  ? SizedBox(
                      width: 90.h,
                      child: TextField(
                        controller: TextEditingController(
                            text: keydata["toothWideB"][i * 2 + 1] == 0
                                ? ""
                                : "${keydata["toothWideB"][i * 2 + 1]}"),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(16),
                          //Pattern x

                          FilteringTextInputFormatter.allow(
                              RegExp(r'([1-9][0-9]{0,3})')),
                          // WhitelistingTextInputFormatter(accountRegExp),
                        ],
                        onChanged: (value) {
                          if (value == "") {
                            keydata["toothWideB"][i * 2 + 1] = 0;
                          } else {
                            keydata["toothWideB"][i * 2 + 1] = int.parse(value);
                          }
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    }
    return Container(
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        color: const Color(0xffdde2ea),
        width: double.maxFinite,
        child: Column(
          children: temp,
        ));
  }

//齿深
  Widget toothth() {
    List<Widget> temp = [];
    temp.add(
      SizedBox(
        width: double.maxFinite,
        height: 40.h,
        child: Row(
          children: [
            Text(
              S.of(context).keytoothdepth + ":",
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0XFF384C70))),
                onPressed: () {
                  if (keydata["toothDepth"][0] < keydata["toothDepth"][1]) {
                    Fluttertoast.showToast(msg: S.of(context).diykeytip8);
                  } else {
                    int diff =
                        keydata["toothDepth"][0] - keydata["toothDepth"][1];
                    for (var i = 2; i < toothnum; i++) {
                      keydata["toothDepth"][i] =
                          keydata["toothDepth"][i - 1] - diff;
                    }
                  }
                  setState(() {});
                },
                child: Text(S.of(context).autoinput)),
          ],
        ),
      ),
    );
    for (var i = 0;
        i < (((toothnum) % 2 == 0) ? toothnum ~/ 2 : toothnum ~/ 2 + 1);
        i++) {
      temp.add(
        SizedBox(
          width: double.maxFinite,
          height: 40.h,
          child: Row(
            children: [
              Text(
                "${i * 2 + 1}:",
              ),
              SizedBox(
                width: 90.h,
                child: TextField(
                  controller: TextEditingController(
                      text: keydata["toothDepth"][i * 2] == 0
                          ? ""
                          : "${keydata["toothDepth"][i * 2]}"),
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(contentPadding: EdgeInsets.zero),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(16),
                    //Pattern x

                    FilteringTextInputFormatter(onlynum, allow: true),
                    // WhitelistingTextInputFormatter(accountRegExp),
                  ],
                  onChanged: (value) {
                    if (value == "") {
                      keydata["toothDepth"][i * 2] = 0;
                    } else {
                      keydata["toothDepth"][i * 2] = int.parse(value);
                    }
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              (i * 2 + 2 <= toothnum)
                  ? Text(
                      "${i * 2 + 2}:",
                    )
                  : Container(),
              (i * 2 + 2 <= toothnum)
                  ? SizedBox(
                      width: 90.h,
                      child: TextField(
                        controller: TextEditingController(
                            text: keydata["toothDepth"][i * 2 + 1] == 0
                                ? ""
                                : "${keydata["toothDepth"][i * 2 + 1]}"),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(16),
                          //Pattern x

                          FilteringTextInputFormatter.allow(
                              RegExp(r'([1-9][0-9]{0,3})')),
                          // WhitelistingTextInputFormatter(accountRegExp),
                        ],
                        onChanged: (value) {
                          if (value == "") {
                            keydata["toothDepth"][i * 2 + 1] = 0;
                          } else {
                            keydata["toothDepth"][i * 2 + 1] = int.parse(value);
                          }
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    }
    return Container(
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        color: const Color(0xffdde2ea),
        width: double.maxFinite,
        child: Column(
          children: temp,
        ));
  }

  bool checkkeydata() {
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

    if (keydata["cnname"].replaceAll(" ", "") == "") {
      Fluttertoast.showToast(msg: S.of(context).inputkeyname);
      return false;
    }
    return true;
  }

  bool checktoothth() {
    for (var i = 0; i < toothnum - 1; i++) {
      if (keydata["toothDepth"][i] < keydata["toothDepth"][i + 1]) {
        Fluttertoast.showToast(msg: S.of(context).diykeytip8);
        return false;
      }
      if (keydata["toothDepth"][i] <= 0 || keydata["toothDepth"][i + 1] <= 0) {
        Fluttertoast.showToast(msg: S.of(context).diykeytip9);
        return false;
      }
    }
    return true;
  }

  bool checktoothsa() {
    ////头部定位
    if (keydata["locat"] == 1) {
      for (var i = 0; i < atooth - 1; i++) {
        if (keydata["toothSA"][i] < keydata["toothSA"][i + 1]) {
          Fluttertoast.showToast(msg: S.of(context).diykeytip3);
          return false;
        }
        if (keydata["toothSA"][i] <= 0 || keydata["toothSA"][i + 1] <= 0) {
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
          if (keydata["toothSB"][i] <= 0 || keydata["toothSB"][i + 1] <= 0) {
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
        if (keydata["toothSA"][i] <= 0 || keydata["toothSA"][i + 1] <= 0) {
          Fluttertoast.showToast(msg: S.of(context).diykeytip4);
          return false;
        }
        if (keydata["toothWideA"][i] <= 0 ||
            keydata["toothWideA"][i + 1] <= 0) {
          Fluttertoast.showToast(msg: S.of(context).diykeytip14);
          return false;
        }
      }
      if (keydata["side"] == 3) {
        for (var i = 0; i < btooth - 1; i++) {
          if (keydata["toothSB"][i] > keydata["toothSB"][i + 1]) {
            Fluttertoast.showToast(msg: S.of(context).diykeytip7);
            return false;
          }
          if (keydata["toothSB"][i] <= 0 || keydata["toothSB"][i + 1] <= 0) {
            Fluttertoast.showToast(msg: S.of(context).diykeytip4);
            return false;
          }
          if (keydata["toothWideB"][i] <= 0 ||
              keydata["toothWideB"][i + 1] <= 0) {
            Fluttertoast.showToast(msg: S.of(context).diykeytip14);
            return false;
          }
        }
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: userTankBar(context),
      body: Column(
        children: [
          SizedBox(
            height: 48.h,
            child: Center(
              child: Text(
                S.of(context).changekeydata,
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    Text(S.of(context).keyname + ":"),
                    Expanded(
                        child: TextField(
                      controller:
                          TextEditingController(text: keydata["cnname"]),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x
                        // FilteringTextInputFormatter.allow(
                        //     RegExp(r'([1-9][0-9]{0,3})')),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        keydata["cnname"] = value;
                      },
                    )),
                  ],
                ),
              ),
              //钥匙宽度
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    Text(S.of(context).keywide + ":"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text:
                              keydata["wide"] == 0 ? "" : "${keydata["wide"]}"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x

                        FilteringTextInputFormatter(onlynum, allow: true),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        if (value == "") {
                          keydata["wide"] = 0;
                        } else {
                          keydata["wide"] = int.parse(value);
                        }
                      },
                    )),
                  ],
                ),
              ),
              //钥匙厚度
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    Text(S.of(context).keythickness + ":"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: keydata["thickness"] == 0
                              ? ""
                              : "${keydata["thickness"]}"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x

                        FilteringTextInputFormatter(onlynum, allow: true),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        if (value == "") {
                          keydata["thickness"] = 0;
                        } else {
                          keydata["thickness"] = int.parse(value);
                        }
                      },
                    )),
                  ],
                ),
              ),
              //沟槽直径
              keydata["class"] == 5
                  ? Container(
                      height: 40.h,
                      margin: EdgeInsets.only(bottom: 6.h),
                      padding: EdgeInsets.only(left: 20.w, right: 20.h),
                      color: const Color(0xffdde2ea),
                      child: Row(
                        children: [
                          Text(S.of(context).keygroove),
                          Expanded(
                              child: TextField(
                            controller: TextEditingController(
                                text: keydata["groove"] == 0
                                    ? ""
                                    : "${keydata["groove"]}"),
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(16),
                              //Pattern x

                              FilteringTextInputFormatter(onlynum, allow: true),
                              // WhitelistingTextInputFormatter(accountRegExp),
                            ],
                            onChanged: (value) {
                              if (value == "") {
                                keydata["groove"] = 0;
                              } else {
                                keydata["groove"] = int.parse(value);
                              }
                            },
                          )),
                        ],
                      ),
                    )
                  : Container(),
              //切削深度
              keydata["class"] > 1
                  ? Container(
                      height: 40.h,
                      margin: EdgeInsets.only(bottom: 6.h),
                      padding: EdgeInsets.only(left: 20.w, right: 20.h),
                      color: const Color(0xffdde2ea),
                      child: Row(
                        children: [
                          Text(S.of(context).keydepth),
                          Expanded(
                              child: TextField(
                            controller: TextEditingController(
                                text: keydata["depth"] == 0
                                    ? ""
                                    : "${keydata["depth"]}"),
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(16),
                              //Pattern x

                              FilteringTextInputFormatter(onlynum, allow: true),
                              // WhitelistingTextInputFormatter(accountRegExp),
                            ],
                            onChanged: (value) {
                              if (value == "") {
                                keydata["depth"] = 0;
                              } else {
                                keydata["depth"] = int.parse(value);
                              }
                            },
                          )),
                        ],
                      ),
                    )
                  : Container(),
              //修改A齿数
              Container(
                width: double.maxFinite,
                height: 40.h,
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                margin: EdgeInsets.only(bottom: 6.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    Text(S.of(context).changeatooth),
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70)),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          atooth--;
                          if (atooth < 2) {
                            atooth = 2;
                          }
                          setState(() {});
                        },
                        child: const Text("-"),
                      ),
                    ),
                    SizedBox(
                        width: 35.w,
                        height: 20.h,
                        child: Center(
                          child: Text("$atooth"),
                        )),
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70)),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          atooth++;
                          if (atooth > 15) {
                            atooth = 15;
                          } else {
                            if (keydata["side"] == 3) {
                              keydata["toothSA"].add(0);

                              keydata["toothWideA"].add(100);
                            } else {
                              keydata["toothSA"].add(0);
                              keydata["toothSB"].add(0);
                              keydata["toothWideA"].add(100);
                              keydata["toothWideB"].add(100);
                            }
                          }

                          setState(() {});
                        },
                        child: const Text("+"),
                      ),
                    ),
                  ],
                ),
              ),
              toothsa(),
              toothwa(),
              //修改B齿数
              (keydata["class"] == 2 || keydata["class"] == 4)
                  ? Container(
                      width: double.maxFinite,
                      height: 40.h,
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      margin: EdgeInsets.only(bottom: 6.h),
                      color: const Color(0xffdde2ea),
                      child: Row(
                        children: [
                          Text(S.of(context).changebtooth),
                          SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xff384c70)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                btooth--;
                                if (btooth < 2) {
                                  btooth = 2;
                                }
                                setState(() {});
                              },
                              child: const Text("-"),
                            ),
                          ),
                          SizedBox(
                              width: 35.w,
                              height: 20.h,
                              child: Center(
                                child: Text("$btooth"),
                              )),
                          SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xff384c70)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                btooth++;
                                if (btooth > 15) {
                                  btooth = 15;
                                } else {
                                  keydata["toothSB"].add(0);
                                  keydata["toothWideB"].add(100);
                                }

                                setState(() {});
                              },
                              child: const Text("+"),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              (keydata["class"] == 2 || keydata["class"] == 4)
                  ? toothsb()
                  : Container(),

              (keydata["class"] == 2 || keydata["class"] == 4)
                  ? toothwb()
                  : Container(),
              Container(
                width: double.maxFinite,
                height: 40.h,
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                margin: EdgeInsets.only(bottom: 6.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    Text(S.of(context).changetoothnum),
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70)),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          toothnum--;
                          if (toothnum < 2) {
                            toothnum = 2;
                          }
                          setState(() {});
                        },
                        child: const Text("-"),
                      ),
                    ),
                    SizedBox(
                        width: 35.w,
                        height: 20.h,
                        child: Center(
                          child: Text("$toothnum"),
                        )),
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70)),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          toothnum++;

                          if (toothnum > 15) {
                            toothnum = 15;
                          } else {
                            keydata["toothDepth"].add(0);
                            keydata["toothDepthName"].add("$toothnum");
                          }
                          setState(() {});
                        },
                        child: const Text("+"),
                      ),
                    ),
                  ],
                ),
              ),
              toothth(),

              Container(
                height: 40.h,
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    Text(S.of(context).opendataa),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    const Text("AX:"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: keydata["headAx"] != null
                              ? (keydata["headAx"].toString())
                              : "0"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x
                        FilteringTextInputFormatter(onlynum, allow: true),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        if (value != "") {
                          keydata["headAx"] = int.parse(value);
                        } else {
                          keydata["headAx"] = 0;
                        }
                      },
                    )),
                    const Text("AY:"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: keydata["headAy"] != null
                              ? (keydata["headAy"].toString())
                              : "0"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x
                        FilteringTextInputFormatter(onlynum, allow: true),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        if (value != "") {
                          keydata["headAy"] = int.parse(value);
                        } else {
                          keydata["headAy"] = 0;
                        }
                      },
                    )),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    const Text("BX:"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: keydata["headBx"] != null
                              ? (keydata["headBx"].toString())
                              : "0"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x
                        FilteringTextInputFormatter(onlynum, allow: true),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        if (value != "") {
                          keydata["headBx"] = int.parse(value);
                        } else {
                          keydata["headBx"] = 0;
                        }
                      },
                    )),
                    const Text("BY:"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: keydata["headBy"] != null
                              ? (keydata["headBy"].toString())
                              : "0"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x
                        FilteringTextInputFormatter(onlynum, allow: true),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        if (value != "") {
                          keydata["headBy"] = int.parse(value);
                        } else {
                          keydata["headBy"] = 0;
                        }
                      },
                    )),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    Text(S.of(context).opendatab),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    const Text("AX:"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: keydata["headCx"] != null
                              ? (keydata["headCx"].toString())
                              : "0"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x
                        FilteringTextInputFormatter(onlynum, allow: true),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        if (value != "") {
                          keydata["headCx"] = int.parse(value);
                        } else {
                          keydata["headCx"] = 0;
                        }
                      },
                    )),
                    const Text("AY:"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: keydata["headCy"] != null
                              ? (keydata["headCy"].toString())
                              : "0"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x
                        FilteringTextInputFormatter(onlynum, allow: true),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        if (value != "") {
                          keydata["headCy"] = int.parse(value);
                        } else {
                          keydata["headCy"] = 0;
                        }
                      },
                    )),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    const Text("BX:"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: keydata["headDx"] != null
                              ? (keydata["headDx"].toString())
                              : "0"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x
                        FilteringTextInputFormatter(onlynum, allow: true),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        if (value != "") {
                          keydata["headDx"] = int.parse(value);
                        } else {
                          keydata["headDx"] = 0;
                        }
                      },
                    )),
                    const Text("BY:"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: keydata["headDy"] != null
                              ? (keydata["headDy"].toString())
                              : "0"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x
                        FilteringTextInputFormatter(onlynum, allow: true),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        if (value != "") {
                          keydata["headDy"] = int.parse(value);
                        } else {
                          keydata["headDy"] = 0;
                        }
                      },
                    )),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    Text(S.of(context).keynumber + ":"),
                    Expanded(
                        child: TextField(
                      controller:
                          TextEditingController(text: keydata["keynumbet"]),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x

                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        keydata["keynumbet"] = value;
                      },
                    )),
                  ],
                ),
              ),

              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    Text(S.of(context).note + ":"),
                    Expanded(
                        child: TextField(
                      controller:
                          TextEditingController(text: keydata["chnote"]),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x

                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        keydata["chnote"] = value;
                      },
                    )),
                  ],
                ),
              ),
            ],
          )),
          SizedBox(
            height: 50.h,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff384c70),
                        borderRadius: BorderRadius.circular(13.sp)),
                    width: 150.w,
                    height: 40.h,
                    child: Center(
                      child: Text(
                        S.of(context).cancel,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (checkkeydata() && checktoothsa() && checktoothth()) {
                      needChanageData["shared"] = false;
                      await delKeyData(needChanageData);

                      keydata["toothSA"] =
                          List.from(keydata["toothSA"].sublist(0, atooth));
                      keydata["toothWideA"] =
                          List.from(keydata["toothWideA"].sublist(0, atooth));
                      if (keydata["class"] == 2 || keydata["class"] == 4) {
                        keydata["toothSB"] =
                            List.from(keydata["toothSB"].sublist(0, btooth));
                        keydata["toothWideB"] =
                            List.from(keydata["toothWideB"].sublist(0, btooth));
                      } else {
                        keydata["toothSB"] =
                            List.from(keydata["toothSA"].sublist(0, atooth));
                        keydata["toothWideB"] =
                            List.from(keydata["toothWideA"].sublist(0, atooth));
                      }
                      keydata["toothDepthName"] = List.from(
                          keydata["toothDepthName"].sublist(0, toothnum));
                      keydata["toothDepth"] =
                          List.from(keydata["toothDepth"].sublist(0, toothnum));

                      await addDiyKey();
                      Fluttertoast.showToast(msg: S.of(context).changeok);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff384c70),
                        borderRadius: BorderRadius.circular(13.sp)),
                    width: 150.w,
                    height: 40.h,
                    child: Center(
                      child: Text(
                        S.of(context).okbt,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
