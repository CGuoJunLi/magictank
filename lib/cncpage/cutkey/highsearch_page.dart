import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class HighSearchPage extends StatefulWidget {
  const HighSearchPage({Key? key}) : super(key: key);
  @override
  State<HighSearchPage> createState() => _HighSearchPageState();
}

class _HighSearchPageState extends State<HighSearchPage> {
  int keyclassindex = 0;
  int keysideindex = 0;
  int keylocationindex = 0;
  bool smartkey = false;
  bool nonconductive = false;
  String inputwide = "";
  String inputtooth = "";
  RegExp pwRegExp = RegExp(r'[0-9]+'); //数字和和字母组成
  List<Map> keyclass = [
    {
      "name": S.current.keyclass1,
      "id": 1,
    },
    {
      "name": S.current.keyclass0,
      "id": 0,
    },
    {
      "name": S.current.keyclass3,
      "id": 3,
    },
    {
      "name": S.current.keyclass4,
      "id": 4,
    },
    {
      "name": S.current.keyclass5,
      "id": 5,
    },
    {
      "name": S.current.keyclass2,
      "id": 2,
    },
  ];
  List<Map> keyside = [
    {
      "name": S.current.keyside7,
      "id": 1,
    },
    {
      "name": S.current.keyside8,
      "id": 0,
    },
    {
      "name": S.current.keyside9,
      "id": 3,
    },
  ];
  List<Map> keylocation = [
    {
      "name": S.current.keylocat0,
      "id": 0,
    },
    {
      "name": S.current.keylocat1,
      "id": 1,
    },
  ];
  List<DropdownMenuItem<int>> selekeyclass() {
    List<DropdownMenuItem<int>> temp = [];
    for (var i = 0; i < keyclass.length; i++) {
      temp.add(DropdownMenuItem(
        value: i,
        child: Text(keyclass[i]["name"]),
      ));
    }
    return temp;
  }

  List<DropdownMenuItem<int>> selekeyside() {
    List<DropdownMenuItem<int>> temp = [];
    for (var i = 0; i < keyside.length; i++) {
      temp.add(DropdownMenuItem(
        value: i,
        child: Text(keyside[i]["name"]),
      ));
    }
    return temp;
  }

  List<DropdownMenuItem<int>> selekeylocation() {
    List<DropdownMenuItem<int>> temp = [];
    for (var i = 0; i < keylocation.length; i++) {
      temp.add(DropdownMenuItem(
        value: i,
        child: Text(keylocation[i]["name"]),
      ));
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: Column(children: [
        Expanded(
          child: ListView(
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: CheckboxListTile(
              //         title: const Text("智能卡"),
              //         value: smartkey,
              //         onChanged: (value) {
              //           smartkey = !smartkey;
              //           if (smartkey) {
              //             nonconductive = false;
              //           }
              //           setState(() {});
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: CheckboxListTile(
              //         title: const Text("非导电"),
              //         value: nonconductive,
              //         onChanged: (value) {
              //           nonconductive = !nonconductive;
              //           if (nonconductive) {
              //             smartkey = false;
              //           }
              //           setState(() {});
              //         },
              //       ),
              //     ),
              //   ],
              // ),

              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 10.h),
                color: const Color(0xffdde2ea),
                child: Row(children: [
                  SizedBox(
                    width: 23.w,
                  ),
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      S.of(context).keyclass,
                    ),
                  ),
                  DropdownButton(
                      value: keyclassindex,
                      items: selekeyclass(),
                      onChanged: (value) {
                        keyclassindex = value as int;
                        switch (keyclass[keyclassindex]["id"]) {
                          case 2: //立铣内沟双边
                          case 4: //立铣外沟双边
                          case 0: //平铣双边
                            keysideindex = 2;
                            break;
                          case 1: //平铣单边
                            keysideindex = 1;
                            break;
                          case 3: //立铣外沟单边
                          case 5: //立铣内沟单边

                            keysideindex = 0;

                            break;
                        }
                        setState(() {});
                      })
                ]),
              ),
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 10.h),
                color: const Color(0xffdde2ea),
                child: Row(children: [
                  SizedBox(
                    width: 23.w,
                  ),
                  SizedBox(
                    width: 120.w,
                    child: Text(S.of(context).keyloact),
                  ),
                  DropdownButton(
                      value: keylocationindex,
                      items: selekeylocation(),
                      onChanged: (value) {
                        keylocationindex = value as int;
                        setState(() {});
                      })
                ]),
              ),
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 10.h),
                color: const Color(0xffdde2ea),
                child: Row(children: [
                  SizedBox(
                    width: 23.w,
                  ),
                  SizedBox(
                    width: 120.w,
                    child: Text(S.of(context).keyside),
                  ),
                  DropdownButton(
                      value: keysideindex,
                      items: selekeyside(),
                      onChanged: (value) {
                        switch (keyclass[keyclassindex]["id"]) {
                          case 2: //立铣内沟双边
                          case 4: //立铣外沟双边
                          case 0: //平铣双边
                            keysideindex = 2;
                            break;
                          case 1: //平铣单边
                            keysideindex = 1;
                            break;
                          case 3: //立铣外沟单边
                          case 5: //立铣内沟单边
                            if (value as int == 2) {
                              keysideindex = 1;
                            } else {
                              keysideindex = value;
                            }
                            break;
                          default:
                            keysideindex = value as int;
                            break;
                        }
                        setState(() {});
                      })
                ]),
              ),
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 10.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    SizedBox(
                      width: 23.w,
                    ),
                    SizedBox(
                      width: 120.w,
                      child: Text(S.of(context).keywide),
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                          FilteringTextInputFormatter(pwRegExp, allow: true),
                        ],
                        onChanged: (value) {
                          inputwide = value;
                          // print(inputwide);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 10.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    SizedBox(
                      width: 23.w,
                    ),
                    SizedBox(
                      width: 120.w,
                      child: Text(S.of(context).keytooth),
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(2),
                          //WhitelistingTextInputFormatter(pwRegExp),
                          FilteringTextInputFormatter(pwRegExp, allow: true),
                        ],
                        onChanged: (value) {
                          inputtooth = value;
                          // print(inputtooth);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 23.w,
                  ),
                  Text(
                    S.of(context).highmodeltip,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                width: 150.w,
                height: 40.w,
                child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0))),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff384c70))),
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Text(
                      S.of(context).cancel,
                      style: const TextStyle(color: Colors.white),
                    ))),
            SizedBox(
                width: 150.w,
                height: 40.w,
                child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0))),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff384c70))),
                    onPressed: () {
                      if (inputwide == "") {
                        inputwide = "0";
                      }
                      if (inputtooth == "") {
                        inputtooth = "0";
                      }
                      Navigator.pop(context, {
                        "class": keyclass[keyclassindex]["id"],
                        "side": keyside[keysideindex]["id"],
                        "location": keylocation[keylocationindex]["id"],
                        "wide": int.parse(inputwide),
                        "tooth": int.parse(inputtooth),
                        "smart": smartkey,
                        "non": nonconductive,
                      });
                    },
                    child: Text(
                      S.of(context).search,
                      style: const TextStyle(color: Colors.white),
                    ))),
          ],
        )
      ]),
    );
  }
}
