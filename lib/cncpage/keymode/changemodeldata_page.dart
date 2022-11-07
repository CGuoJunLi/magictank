import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/userappbar.dart';

class ChangeModelDataPage extends StatefulWidget {
  final Map argument;
  const ChangeModelDataPage(this.argument, {Key? key}) : super(key: key);

  @override
  State<ChangeModelDataPage> createState() => _ChangeModelDataPageState();
}

class _ChangeModelDataPageState extends State<ChangeModelDataPage> {
  late Map<String, dynamic> needChanageData;
  late Map<String, dynamic> keydata;
  @override
  void initState() {
    needChanageData = Map.from(widget.argument);
    keydata = json.decode(needChanageData["data"]);

    super.initState();
  }

  List<Widget> _getlistwidget() {
    List<Widget> temp = [];
    temp.add(Container(
        height: 40.h,
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.h),
        color: const Color(0xffdde2ea),
        child: Center(
          child: Text(
            "修改基本参数:",
            style: TextStyle(color: Colors.red, fontSize: 17.sp),
          ),
        )));
    //宽度
    temp.add(Container(
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
                text: keydata["keywide"] == 0 ? "" : "${keydata["keywide"]}"),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(contentPadding: EdgeInsets.zero),
            inputFormatters: [
              LengthLimitingTextInputFormatter(16),
              //Pattern x

              FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
              // WhitelistingTextInputFormatter(accountRegExp),
            ],
            onChanged: (value) {
              if (value == "") {
                keydata["keywide"] = 0;
              } else {
                keydata["keywide"] = int.parse(value);
              }
            },
          )),
        ],
      ),
    ));
    //厚度
    temp.add(
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
                  text: keydata["keythickness"] == 0
                      ? ""
                      : "${keydata["keythickness"]}"),
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(contentPadding: EdgeInsets.zero),
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
                //Pattern x

                FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                // WhitelistingTextInputFormatter(accountRegExp),
              ],
              onChanged: (value) {
                if (value == "") {
                  keydata["keythickness"] = 0;
                } else {
                  keydata["keythickness"] = int.parse(value);
                }
              },
            )),
          ],
        ),
      ),
    );
    //是否有肩膀
    if (keydata["locat"] == 0) {
      temp.add(Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Center(
            child: Text(
              "修改肩膀:",
              style: TextStyle(color: Colors.red, fontSize: 17.sp),
            ),
          )));
      temp.add(
        Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Row(
            children: [
              Text(S.of(context).keylocatwide + ":"),
              Expanded(
                  child: TextField(
                controller: TextEditingController(
                    text: keydata["locatwide"] == 0
                        ? ""
                        : "${keydata["locatwide"]}"),
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(contentPadding: EdgeInsets.zero),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  //Pattern x

                  FilteringTextInputFormatter.allow(
                      RegExp(r'([1-9][0-9]{0,3})')),
                  // WhitelistingTextInputFormatter(accountRegExp),
                ],
                onChanged: (value) {
                  if (value == "") {
                    keydata["locatwide"] = 0;
                  } else {
                    keydata["locatwide"] = int.parse(value);
                  }
                },
              )),
            ],
          ),
        ),
      );
      temp.add(
        Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Row(
            children: [
              Text(S.of(context).keylocatlen + ":"),
              Expanded(
                  child: TextField(
                controller: TextEditingController(
                    text: keydata["locatlength"] == 0
                        ? ""
                        : "${keydata["locatlength"]}"),
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(contentPadding: EdgeInsets.zero),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  //Pattern x

                  FilteringTextInputFormatter.allow(
                      RegExp(r'([1-9][0-9]{0,3})')),
                  // WhitelistingTextInputFormatter(accountRegExp),
                ],
                onChanged: (value) {
                  if (value == "") {
                    keydata["locatlength"] = 0;
                  } else {
                    keydata["locatlength"] = int.parse(value);
                  }
                },
              )),
            ],
          ),
        ),
      );
    }
    //中间沟槽
    if (keydata["alltype"] == 1 || keydata["alltype"] == 2) {
      temp.add(Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Center(
            child: Text(
              "修改中间沟槽:",
              style: TextStyle(color: Colors.red, fontSize: 17.sp),
            ),
          )));
      temp.add(
          //宽度
          Container(
        height: 40.h,
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.h),
        color: const Color(0xffdde2ea),
        child: Row(
          children: [
            Text(S.of(context).mgroovewide + ":"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: keydata["mgroovewide"] == 0
                      ? ""
                      : "${keydata["mgroovewide"]}"),
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(contentPadding: EdgeInsets.zero),
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
                //Pattern x

                FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                // WhitelistingTextInputFormatter(accountRegExp),
              ],
              onChanged: (value) {
                if (value == "") {
                  keydata["mgroovewide"] = 0;
                } else {
                  keydata["mgroovewide"] = int.parse(value);
                }
              },
            )),
          ],
        ),
      ));
      temp.add(
        //宽度
        Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Row(
            children: [
              Text(S.of(context).mgroovedistance + ":"),
              Expanded(
                  child: TextField(
                controller: TextEditingController(
                    text: keydata["mgroovedistance"] == 0
                        ? ""
                        : "${keydata["mgroovedistance"]}"),
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(contentPadding: EdgeInsets.zero),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  //Pattern x

                  FilteringTextInputFormatter.allow(
                      RegExp(r'([1-9][0-9]{0,3})')),
                  // WhitelistingTextInputFormatter(accountRegExp),
                ],
                onChanged: (value) {
                  if (value == "") {
                    keydata["mgroovedistance"] = 0;
                  } else {
                    keydata["mgroovedistance"] = int.parse(value);
                  }
                },
              )),
            ],
          ),
        ),
      );
      temp.add(Container(
        height: 40.h,
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.h),
        color: const Color(0xffdde2ea),
        child: Row(
          children: [
            Text(S.of(context).mgroovedepth + ":"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: keydata["mgroovedepth"] == 0
                      ? ""
                      : "${keydata["mgroovedepth"]}"),
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(contentPadding: EdgeInsets.zero),
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
                //Pattern x

                FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                // WhitelistingTextInputFormatter(accountRegExp),
              ],
              onChanged: (value) {
                if (value == "") {
                  keydata["mgroovedepth"] = 0;
                } else {
                  keydata["mgroovedepth"] = int.parse(value);
                }
              },
            )),
          ],
        ),
      ));
      temp.add(Container(
        height: 40.h,
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.h),
        color: const Color(0xffdde2ea),
        child: Row(
          children: [
            Text(S.of(context).mgroovelen + ":"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: keydata["mgroovelength"] == 0
                      ? ""
                      : "${keydata["mgroovelength"]}"),
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(contentPadding: EdgeInsets.zero),
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
                //Pattern x

                FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                // WhitelistingTextInputFormatter(accountRegExp),
              ],
              onChanged: (value) {
                if (value == "") {
                  keydata["mgroovelength"] = 0;
                } else {
                  keydata["mgroovelength"] = int.parse(value);
                }
              },
            )),
          ],
        ),
      ));
    }

    if ((keydata["alltype"] == 2 || keydata["alltype"] == 3) &&
        keydata["ugroovelength"] > 0) {
      temp.add(Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Center(
            child: Text(
              "修改上沟槽:",
              style: TextStyle(color: Colors.red, fontSize: 17.sp),
            ),
          )));
      temp.add(
          //宽度
          Container(
        height: 40.h,
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.h),
        color: const Color(0xffdde2ea),
        child: Row(
          children: [
            Text(S.of(context).ugroovedepth + ":"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: keydata["ugroovedepth"] == 0
                      ? ""
                      : "${keydata["ugroovedepth"]}"),
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(contentPadding: EdgeInsets.zero),
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
                //Pattern x

                FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                // WhitelistingTextInputFormatter(accountRegExp),
              ],
              onChanged: (value) {
                if (value == "") {
                  keydata["ugroovedepth"] = 0;
                } else {
                  keydata["ugroovedepth"] = int.parse(value);
                }
              },
            )),
          ],
        ),
      ));
      temp.add(
        //宽度
        Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Row(
            children: [
              Text(S.of(context).ugroovewide + ":"),
              Expanded(
                  child: TextField(
                controller: TextEditingController(
                    text: keydata["ugroovewide"] == 0
                        ? ""
                        : "${keydata["ugroovewide"]}"),
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(contentPadding: EdgeInsets.zero),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  //Pattern x

                  FilteringTextInputFormatter.allow(
                      RegExp(r'([1-9][0-9]{0,3})')),
                  // WhitelistingTextInputFormatter(accountRegExp),
                ],
                onChanged: (value) {
                  if (value == "") {
                    keydata["ugroovewide"] = 0;
                  } else {
                    keydata["ugroovewide"] = int.parse(value);
                  }
                },
              )),
            ],
          ),
        ),
      );
      temp.add(
        //宽度
        Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Row(
            children: [
              Text(S.of(context).ugroovelen + ":"),
              Expanded(
                  child: TextField(
                controller: TextEditingController(
                    text: keydata["ugroovelength"] == 0
                        ? ""
                        : "${keydata["ugroovelength"]}"),
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(contentPadding: EdgeInsets.zero),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  //Pattern x

                  FilteringTextInputFormatter.allow(
                      RegExp(r'([1-9][0-9]{0,3})')),
                  // WhitelistingTextInputFormatter(accountRegExp),
                ],
                onChanged: (value) {
                  if (value == "") {
                    keydata["ugroovelength"] = 0;
                  } else {
                    keydata["ugroovelength"] = int.parse(value);
                  }
                },
              )),
            ],
          ),
        ),
      );
    }

    if ((keydata["alltype"] == 2 || keydata["alltype"] == 3) &&
        keydata["lgroovelength"] > 0) {
      temp.add(Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Center(
            child: Text(
              "修改下沟槽:",
              style: TextStyle(color: Colors.red, fontSize: 17.sp),
            ),
          )));
      temp.add(
          //宽度
          Container(
        height: 40.h,
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.h),
        color: const Color(0xffdde2ea),
        child: Row(
          children: [
            Text(S.of(context).lgroovedepth + ":"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: keydata["lgroovedepth"] == 0
                      ? ""
                      : "${keydata["lgroovedepth"]}"),
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(contentPadding: EdgeInsets.zero),
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
                //Pattern x

                FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                // WhitelistingTextInputFormatter(accountRegExp),
              ],
              onChanged: (value) {
                if (value == "") {
                  keydata["lgroovedepth"] = 0;
                } else {
                  keydata["lgroovedepth"] = int.parse(value);
                }
              },
            )),
          ],
        ),
      ));
      temp.add(
        //宽度
        Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Row(
            children: [
              Text(S.of(context).lgroovewide + ":"),
              Expanded(
                  child: TextField(
                controller: TextEditingController(
                    text: keydata["lgroovewide"] == 0
                        ? ""
                        : "${keydata["lgroovewide"]}"),
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(contentPadding: EdgeInsets.zero),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  //Pattern x

                  FilteringTextInputFormatter.allow(
                      RegExp(r'([1-9][0-9]{0,3})')),
                  // WhitelistingTextInputFormatter(accountRegExp),
                ],
                onChanged: (value) {
                  if (value == "") {
                    keydata["lgroovewide"] = 0;
                  } else {
                    keydata["lgroovewide"] = int.parse(value);
                  }
                },
              )),
            ],
          ),
        ),
      );
      temp.add(
        //宽度
        Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Row(
            children: [
              Text(S.of(context).lgroovelen + ":"),
              Expanded(
                  child: TextField(
                controller: TextEditingController(
                    text: keydata["lgroovedepth"] == 0
                        ? ""
                        : "${keydata["lgroovedepth"]}"),
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(contentPadding: EdgeInsets.zero),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  //Pattern x

                  FilteringTextInputFormatter.allow(
                      RegExp(r'([1-9][0-9]{0,3})')),
                  // WhitelistingTextInputFormatter(accountRegExp),
                ],
                onChanged: (value) {
                  if (value == "") {
                    keydata["lgroovedepth"] = 0;
                  } else {
                    keydata["lgroovedepth"] = int.parse(value);
                  }
                },
              )),
            ],
          ),
        ),
      );
    }

    if (keydata["headtype"] > 0) {
      temp.add(Container(
          height: 40.h,
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.h),
          color: const Color(0xffdde2ea),
          child: Center(
            child: Text(
              "修改头部:",
              style: TextStyle(color: Colors.red, fontSize: 17.sp),
            ),
          )));
      temp.add(
          //宽度
          Container(
        height: 40.h,
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.only(left: 20.w, right: 20.h),
        color: const Color(0xffdde2ea),
        child: Row(
          children: [
            const Text("头部长度:"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: keydata["headlength"] == 0
                      ? ""
                      : "${keydata["headlength"]}"),
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(contentPadding: EdgeInsets.zero),
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
                //Pattern x

                FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                // WhitelistingTextInputFormatter(accountRegExp),
              ],
              onChanged: (value) {
                if (value == "") {
                  keydata["headlength"] = 0;
                } else {
                  keydata["headlength"] = int.parse(value);
                }
              },
            )),
          ],
        ),
      ));
    }
    return temp;
  }

  Future<void> savedata() async {
    await delModelData();
    await addDiyModel();
  }

  Future<void> delModelData() async {
    try {
      var result = await Api.delUserModel(needChanageData);

      if (result["state"]) {
        await appData.deleUserModel(needChanageData["id"].toString());
      } else {
        await appData.updateUserModel(needChanageData["id"].toString(), 3);
      }
    } catch (e) {
      await appData.updateUserModel(needChanageData["id"].toString(), 3);
    }
  }

  Future<void> addDiyModel() async {
    var data = {
      "userid": appData.id,
      "timer": DateTime.now().toString().substring(0, 19),
      "data": json.encode(keydata),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            children: _getlistwidget(),
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
                    await savedata();
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
