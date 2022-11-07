import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magictank/dialogshow/dialogpage.dart';

import '../../appdata.dart';
import 'package:magictank/http/api.dart';

class SmartDiyModelStepPage extends StatefulWidget {
  const SmartDiyModelStepPage({Key? key}) : super(key: key);

  @override
  State<SmartDiyModelStepPage> createState() => _SmartDiyModelStepPageState();
}

class _SmartDiyModelStepPageState extends State<SmartDiyModelStepPage> {
  int step = 0;
  bool mg = false; //中间沟槽
  bool ug = false; //上沟槽
  bool lg = false; //下沟槽
  bool lineg = false; //直槽
  bool vg = false; //V形槽
  bool doubleg = false; //双直槽
  bool headtype = true; //头部类型 true 宽头 false窄头
  RegExp intRegExp = RegExp(r'[A-Za-z0-9]+'); //参数 必须使用int
  List modelclassname = [
    "立铣-头部定位",
    "立铣-肩部定位",
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
      temp.add(const SizedBox(
        height: 10,
      ));
      temp.add(
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(
              width: 3,
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: TextButton(
            onPressed: () {
              switch (i) {
                case 0:
                  modeldata["class"] = 9;
                  modeldata["locat"] = 0;
                  break;
                case 1:
                  modeldata["class"] = 9;
                  modeldata["locat"] = 1;
                  break;
                case 2:
                  modeldata["class"] = 10;
                  modeldata["locat"] = 0;
                  break;
                case 3:
                  modeldata["class"] = 10;
                  modeldata["locat"] = 1;
                  break;
              }
              step = 1;
              setState(() {});
            },
            child: Row(
              children: [
                const Expanded(
                  child: Text("图片"),
                  flex: 3,
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    modelclassname[i],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return temp;
  }

  Widget groovimage() {
    return Container(
      height: 100,
      color: Colors.red,
    );
  }

  List<Widget> groovedata() {
    List<Widget> temp = [];
    if (mg && lineg) {
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("中间沟槽长度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["mgroovelength"].toString()),
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
        ),
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("中间沟槽宽度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["mgroovewide"].toString()),
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
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("中间沟槽边到边的距离"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["mgroovedistance"].toString()),
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
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("中间沟槽深度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["mgroovedepth"].toString()),
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
      );
    }
    if (ug) {
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("上沟槽长度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["ugroovelength"].toString()),
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
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("上沟槽宽度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["lgroovewide"].toString()),
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
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("上沟槽深度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["ugroovedepth"].toString()),
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
      );
    }
    if (lg && !vg && !doubleg) {
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("下沟槽长度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["lgroovelength"].toString()),
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
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("下沟槽宽度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["lgroovewide"].toString()),
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
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("下沟槽深度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["lgroovedepth"].toString()),
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
      );
    }
    if (!lg && vg && !doubleg) {
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("V槽长度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["v2groovelength"].toString()),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
                FilteringTextInputFormatter(intRegExp, allow: true),
              ],
              onChanged: (value) {
                if (value == "") {
                  modeldata["v2groovelength"] = 0;
                } else {
                  modeldata["v2groovelength"] = int.parse(value);
                }
              },
            ))
          ],
        ),
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("V槽宽度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["v2groovewide"].toString()),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
                FilteringTextInputFormatter(intRegExp, allow: true),
              ],
              onChanged: (value) {
                if (value == "") {
                  modeldata["v2groovewide"] = 0;
                } else {
                  modeldata["v2groovewide"] = int.parse(value);
                }
              },
            ))
          ],
        ),
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("V槽边到边的距离"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["v2groovedistance"].toString()),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
                FilteringTextInputFormatter(intRegExp, allow: true),
              ],
              onChanged: (value) {
                if (value == "") {
                  modeldata["v2groovedistance"] = 0;
                } else {
                  modeldata["v2groovedistance"] = int.parse(value);
                }
              },
            ))
          ],
        ),
      );
    }
    if (doubleg) {
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("第二中间槽长度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["v2groovelength"].toString()),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
                FilteringTextInputFormatter(intRegExp, allow: true),
              ],
              onChanged: (value) {
                if (value == "") {
                  modeldata["v2groovelength"] = 0;
                } else {
                  modeldata["v2groovelength"] = int.parse(value);
                }
              },
            ))
          ],
        ),
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("第二中间槽宽度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["v2groovewide"].toString()),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
                FilteringTextInputFormatter(intRegExp, allow: true),
              ],
              onChanged: (value) {
                if (value == "") {
                  modeldata["v2groovewide"] = 0;
                } else {
                  modeldata["v2groovewide"] = int.parse(value);
                }
              },
            ))
          ],
        ),
      );
      temp.add(Container(
        height: 100,
        color: Colors.red,
      ));
      temp.add(
        Row(
          children: [
            const Text("第二中间槽深度"),
            Expanded(
                child: TextField(
              controller: TextEditingController(
                  text: modeldata["v2groovedepth"].toString()),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
                FilteringTextInputFormatter(intRegExp, allow: true),
              ],
              onChanged: (value) {
                if (value == "") {
                  modeldata["v2groovedepth"] = 0;
                } else {
                  modeldata["v2groovedepth"] = int.parse(value);
                }
              },
            ))
          ],
        ),
      );
    }
    temp.add(ElevatedButton(
        onPressed: () {
          if (modeldata["headtype"] > 0) {
            step = 4;
          } else {
            step = 5;
          }
          setState(() {});
        },
        child: const Text("下一步")));
    return temp;
  }

  Widget stempWidget() {
    switch (step) {
      case 0:
        return Column(
          children: [
            const Text(
              "选择类型",
              style: TextStyle(fontSize: 30),
            ),
            Expanded(
              child: ListView(
                children: modelclass(),
              ),
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            const Text(
              "选择特征",
              style: TextStyle(fontSize: 30),
            ),
            Expanded(
              child: ListView(
                children: [
                  CheckboxListTile(
                      title: const Text("中间沟槽"),
                      value: mg,
                      onChanged: (value) {
                        mg = !mg;
                        lineg = true;
                        setState(() {});
                      }),
                  mg
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
                      : Container(),
                  mg
                      ? Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                  title: const Text("直槽"),
                                  value: lineg,
                                  onChanged: (value) {
                                    if (!doubleg) {
                                      lineg = !lineg;
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
                                      if (lineg) {
                                        ug = false;
                                        lg = false;
                                      }
                                    }
                                    setState(() {});
                                  }),
                            ),
                          ],
                        )
                      : Container(),
                  CheckboxListTile(
                      title: const Text("上边沟槽"),
                      value: ug,
                      onChanged: (value) {
                        if (!doubleg && !(lineg && vg)) {
                          ug = !ug;
                        }
                        setState(() {});
                      }),
                  CheckboxListTile(
                      title: const Text("下边沟槽"),
                      value: lg,
                      onChanged: (value) {
                        if (!doubleg && !(lineg && vg)) {
                          lg = !lg;
                        }
                        setState(() {});
                      }),
                  groovimage(),
                  CheckboxListTile(
                      title: const Text("头部处理"),
                      value: modeldata["headtype"] > 0 ? true : false,
                      onChanged: (value) {
                        if (value!) {
                          modeldata["headtype"] = 1;
                        } else {
                          modeldata["headtype"] = 0;
                        }
                        setState(() {});
                      }),
                  modeldata["headtype"] > 0
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                color: Colors.green,
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
                      : Container(),
                  modeldata["headtype"] > 0
                      ? Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text("宽头"),
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
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text("窄头"),
                                value: !headtype,
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
                            ),
                          ],
                        )
                      : Container(),
                  modeldata["headtype"] > 0
                      ? Container(
                          height: 100,
                          color: Colors.red,
                        )
                      : Container(),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  step = 2;
                  setState(() {});
                },
                child: const Text("下一步"))
          ],
        );
      case 2:
        return Column(children: [
          const Text(
            "基本特征",
            style: TextStyle(fontSize: 30),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: Colors.red,
                  height: 50,
                ),
                Row(
                  children: [
                    const Text("钥匙厚度(0.01mm):"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: modeldata["keythickness"].toString()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(18),
                        FilteringTextInputFormatter(intRegExp, allow: true),
                      ],
                      onChanged: (value) {},
                    ))
                  ],
                ),
                Container(
                  color: Colors.red,
                  height: 50,
                ),
                Row(
                  children: [
                    const Text("钥匙宽度(0.01mm):"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(
                          text: modeldata["keywide"].toString()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(18),
                        FilteringTextInputFormatter(intRegExp, allow: true),
                      ],
                      onChanged: (value) {},
                    ))
                  ],
                ),
                modeldata["locat"] > 0
                    ? Container(
                        color: Colors.red,
                        height: 50,
                      )
                    : Container(),
                modeldata["locat"] > 0
                    ? Row(
                        children: [
                          const Text("肩膀长度： "),
                          Expanded(
                              child: TextField(
                            controller: TextEditingController(
                                text: modeldata["keywide"].toString()),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(18),
                              FilteringTextInputFormatter(intRegExp,
                                  allow: true),
                            ],
                            onChanged: (value) {},
                          ))
                        ],
                      )
                    : Container(),
                modeldata["locat"] > 0
                    ? Container(
                        color: Colors.red,
                        height: 50,
                      )
                    : Container(),
                modeldata["locat"] > 0
                    ? Row(
                        children: [
                          const Text("肩膀宽度： "),
                          Expanded(
                              child: TextField(
                            controller: TextEditingController(
                                text: modeldata["keywide"].toString()),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(18),
                              FilteringTextInputFormatter(intRegExp,
                                  allow: true),
                            ],
                            onChanged: (value) {},
                          ))
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (!mg && !ug && !lg) {
                step = 5;
              } else {
                step = 3;
              }
              setState(() {});
            },
            child: const Text("下一步"),
          ),
        ]);
      case 3: //沟槽信息
        return Column(children: [
          const Text(
            " 沟槽特征",
            style: TextStyle(fontSize: 30),
          ),
          Expanded(
              child: ListView(
            children: groovedata(),
          ))
        ]);
      case 4:
        return Column(
          children: [
            const Text("头部特征"),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 100,
                    color: Colors.red,
                  ),
                  Row(
                    children: [
                      const Text("头部长度"),
                      Expanded(
                          child: TextField(
                        controller: TextEditingController(
                            text: modeldata["headlength"].toString()),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(18),
                          FilteringTextInputFormatter(intRegExp, allow: true),
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
                  ),
                  ElevatedButton(
                      onPressed: () {
                        step = 5;
                        setState(() {});
                      },
                      child: const Text("下一步"))
                ],
              ),
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            const Text(
              "保存信息",
              style: TextStyle(fontSize: 30),
            ),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      const Text("模型名称: "),
                      Expanded(
                        child: TextField(
                          controller:
                              TextEditingController(text: modeldata["cnname"]),
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
                  Row(
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
                  Row(
                    children: [
                      const Text("备注信息: "),
                      Expanded(
                        child: TextField(
                          controller:
                              TextEditingController(text: modeldata["chnote"]),
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
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("是否立即加工此模型?");
                            }).then((value) async {
                          if (value) {
                            debugPrint("立即加工");
                          } else {
                            await addDiyModel();
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: const Text("保存"))
                ],
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
            setState(() {
              step--;
              if (step == 4 && modeldata["headtype"] == 0) {
                if (!mg && !ug && !lg) {
                  step = 2;
                } else {
                  step = 3;
                }
              }
            });
            return false;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0XFF6E66AA),
            leading: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                if (step == 0) {
                  Navigator.pop(context);
                } else {
                  step--;
                }
                setState(() {});
              },
            ),
            centerTitle: true,
            title: Image.asset(
              "image/tank/tank.png",
              scale: 2.0,
            ),
          ),
          body: stempWidget(),
        ));
  }
}
