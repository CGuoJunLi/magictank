//立铣胚模型界面
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../azlistview/src/az_common.dart';
import '../../azlistview/src/az_listview.dart';
import '../../main.dart';

class ModelModel extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;
  Map? data;
  List? oftenkey;
  List? carmodel;
  String? picname;
  ModelModel({
    required this.name,
    this.tagIndex,
    this.namePinyin,
    this.picname,
    this.data,
  });
  ModelModel.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}

class TestKeyListPage extends StatelessWidget {
  final Map arguments;
  const TestKeyListPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0XFF6E66AA),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Image.asset(
          "image/tank/tank.png",
          scale: 2.0,
        ),
      ),
      body: TestKeyList(arguments),
    );
  }
}

class TestKeyList extends StatefulWidget {
  final Map arguments;
  const TestKeyList(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  State<TestKeyList> createState() => _TestKeyListState();
}

class _TestKeyListState extends State<TestKeyList> {
  List<ModelModel> originList = []; //原列表
  List<ModelModel> dataList = []; //显示列表
  ItemScrollController itemScrollController = ItemScrollController();
  late TextEditingController textEditingController;
  List<String> kIndexBarData = const [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '#'
  ];
  RegExp exp = RegExp(
      r'{[\d]:[0-9]*:[\u4E00-\u9FA5A-Za-z0-9]+:[A-Za-z0-9]+:[A-Za-z0-9]+:[\w]+:[A-Za-z0-9]+:[0-9]*,[0-9]*}');
  RegExp expcn = RegExp(//匹配中文,
      r'[\u4e00-\u9fa5]+');
  RegExp expen = RegExp(//匹配英文 和数字
      r'[A-Za-z0-9]+');

  @override
  void initState() {
    loaddata(widget.arguments["type"]);

    super.initState();
    //showlist = List.from();
  }

  void loaddata(int type) //加载汽车列表
  {
    List<dynamic> temp = [];
    switch (type) {
      case 1:
        temp = List.from(appData.pmodelList);

        break;
      case 2:
        temp = List.from(appData.lmodelList);

        break;
    }
    for (var i = 0; i < temp.length; i++) {
      if (locales!.languageCode == "zh") //中文
      {
        originList.add(
          ModelModel(
              name: temp[i]["cnname"],
              tagIndex: getstr(temp[i]["cnname"]),
              picname: temp[i]["picname"],
              data: temp[i]),
        );
      } else {
        originList.add(
          ModelModel(
              name: temp[i]["enname"],
              tagIndex: getstr(temp[i]["enbrand"]),
              picname: temp[i]["picname"],
              data: temp[i]),
        );
      }
    }
    _handleList(originList);
  }

  String getstr(String getc) {
    RegExp expcn = RegExp(r'[\u4e00-\u9fa5]+'); //数字和和字母组成
    RegExp expen = RegExp(r'[A-Za-z]+'); //数字和和字母组成

    if (expcn.firstMatch(getc[0]) != null) //中文
    {
      return PinyinHelper.getPinyinE(getc[0],
              defPinyin: "#", format: PinyinFormat.WITHOUT_TONE)[0]
          .toUpperCase();
    } else {
      if (expen.firstMatch(getc[0]) != null) //英文
      {
        return getc[0].toUpperCase();
      } else //数字
      {
        return "#";
      }
    }
  }

  void _search(String text) {
    if (text.isEmpty) {
      debugPrint("空");
      _handleList(originList);
    } else {
      List<ModelModel> list = originList.where((v) {
        return v.name.toLowerCase().contains(text.toLowerCase());
      }).toList();
      _handleList(list);
    }
  }

  void _handleList(List<ModelModel> list) {
    dataList.clear();
    if (list.isEmpty) {
      setState(() {});
      return;
    }
    dataList.addAll(list);

    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(dataList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(dataList);

    setState(() {});

    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.arguments["type"] == 1 ? "平铣模型" : "立铣模型",
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (instring) {
                  _search(instring);
                },
                decoration: const InputDecoration(
                  hintText: "请输入钥匙名称",
                ),
              ),
              flex: 5,
            ),
            const Expanded(
              child: Icon(
                Icons.search,
                size: 30,
              ),
              flex: 1,
            ),
          ],
        ),
        Expanded(
          child: AzListView(
            data: dataList,
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              ModelModel model = dataList[index];
              return TextButton(
                onPressed: () {
                  baseKey.initdata(model.data!, isKeyModel: true);
                  List<int> temp = [];
                  temp.add(cncBtSmd.cutKeyModel);
                  temp.add(0);
                  temp.addAll(baseKey.creatkeydata(0));
                  Navigator.pushNamed(context, "/clampmodel", arguments: {
                    "type": 3,
                    "no": 0,
                    "message": 13,
                    "first": true,
                  });
                },
                child: SizedBox(
                  height: 200,
                  width: double.maxFinite,
                  child:
                      // Stack(
                      //   children: [
                      //     Align(
                      //       child: Image.file(
                      //         File(appData.keyimagepath + "/" + model.picname!),
                      //         fit: BoxFit.cover,
                      //         alignment: Alignment.center,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            model.name,
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      Expanded(
                        child: Image.file(
                          File(appData.keyImagePath +
                              "/model/" +
                              model.picname!),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Stack(
                        children: [
                          Align(
                            child: Text(
                              "使用:" + model.data!["keynumbet"] + "胚",
                              style: const TextStyle(fontSize: 15),
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            padding: const EdgeInsets.all(20),
            susItemBuilder: (BuildContext context, int index) {
              ModelModel model = dataList[index];
              String tag = model.getSuspensionTag();
              return Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 16.0),
                color: const Color(0xFFF3F4F5),
                alignment: Alignment.centerLeft,
                child: Text(
                  tag,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF666666),
                  ),
                ),
              );
            },
            indexBarData: [...kIndexBarData],
          ),
          flex: 5,
        ),
      ],
    );
  }
}
