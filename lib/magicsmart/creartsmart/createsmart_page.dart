import 'dart:convert';

import '../../azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:magictank/appdata.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ContactInfo extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;

  Color? bgColor;
  IconData? iconData;

  String? img;
  String? id;
  String? firstletter;

  ContactInfo({
    required this.name,
    this.tagIndex,
    this.namePinyin,
    this.bgColor,
    this.iconData,
    this.img,
    this.id,
    this.firstletter,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        img = json['img'],
        id = json['id']?.toString(),
        firstletter = json['firstletter'];

  Map<String, dynamic> toJson() => {
//        'id': id,
        'name': name,
        'img': img,
//        'firstletter': firstletter,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}

class SmartModel extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;
  Map? data;
  SmartModel({
    required this.name,
    this.tagIndex,
    this.namePinyin,
    this.data,
  });

  SmartModel.fromJson(Map<String, dynamic> json) : name = json['name'];

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

class CreateSmartPage extends StatelessWidget {
  const CreateSmartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          //  elevation: 0,

          backgroundColor: const Color(0XFF6E66AA),
          centerTitle: true,
          title: SizedBox(
            width: 97.r,
            height: 18.r,
            child: Image.asset(
              "image/mcclone/mcbar.png",
              scale: 2.0,
              //fit: BoxFit.cover,
            ),
          )),
      body: const CreateSmart(),
    );
  }
}

class CreateSmart extends StatefulWidget {
  const CreateSmart({Key? key}) : super(key: key);

  @override
  State<CreateSmart> createState() => _CreateSmartState();
}

class _CreateSmartState extends State<CreateSmart> {
  List<SmartModel> originList = [];
  // List<SmartModel> originListChip = [];
  List<SmartModel> dataList = [];
  bool listmodel = false; //列表显示方式 true 按芯片名称排序 false 按照汽车排序
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
  @override
  void initState() {
    //SuspensionUtil.setShowSuspensionStatus(test);

    loaddata();
    super.initState();
  }

  void loaddata() {
    originList.clear();

    for (var i = 0; i < appData.smartCarList.length; i++) {
      /// print(appData.smartCarList[i]);
      originList.add(SmartModel(
          name: appData.smartCarList[i]["brandCN"],
          tagIndex: getstr(appData.smartCarList[i]["brandCN"]),
          data: appData.smartCarList[i]));
    }

    // SuspensionUtil.sortListBySuspensionTag(originList);
    // SuspensionUtil.setShowSuspensionStatus(originList);
    _handleList(originList);
  }

  void _handleList(List<SmartModel> list) {
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

  void _search(String text) {
    if (text.isEmpty) {
      //   debugPrint("空");
      _handleList(originList);
    } else {
      List<SmartModel> list = originList.where((v) {
        return v.name.toLowerCase().contains(text.toLowerCase());
      }).toList();
      _handleList(list);
    }
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

  Widget header() {
    return Container(
      color: Colors.white,
      height: 50.h,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: false,
                decoration: const InputDecoration(
                  focusColor: Color(0XFF6E66AA),
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide:
                        BorderSide(color: Color(0XFF6E66AA), width: 10.0),
                  ),
                  hintText: '汽车中文名或拼音',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
                ),
                onChanged: (instring) {
                  _search(instring);
                },
              ),
            ),
          ),
          // Container(
          //   width: 0.33,
          //   height: 14.0,
          //   color: Color(0xFFEFEFEF),
          // ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "取消",
                style: TextStyle(color: Color(0xFF999999), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header(),
        Expanded(
          child: AzListView(
            data: dataList,
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              SmartModel model = dataList[index];
              return ListTile(
                title: Text(model.name),
                onTap: () {
                  setState(() {
                    debugPrint("${model.data}");
                    Navigator.pushNamed(context, "/createsmartlist",
                        arguments: model.data);
                  });
                },
              );
            },
            padding: const EdgeInsets.all(20),
            susItemBuilder: (BuildContext context, int index) {
              SmartModel model = dataList[index];
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
        ),
      ],
    );
  }
}
