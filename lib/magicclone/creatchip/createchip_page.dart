import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../azlistview/azlistview.dart';

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

class CityModel extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;
  Map? data;
  CityModel({
    required this.name,
    this.tagIndex,
    this.namePinyin,
    this.data,
  });

  CityModel.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
//'tagIndex': tagIndex,
//'namePinyin': namePinyin,
//'isShowSuspension': isShowSuspension
      };
  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}

class CreateChipPage extends StatelessWidget {
  const CreateChipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffeeeeee),
      appBar: userCloneBar(context),
      body: const CreateChip(),
    );
  }
}

class CreateChip extends StatefulWidget {
  const CreateChip({Key? key}) : super(key: key);

  @override
  State<CreateChip> createState() => _CreateChipState();
}

class _CreateChipState extends State<CreateChip> {
  List<CityModel> originList = [];
  // List<CityModel> originListChip = [];
  List<CityModel> dataList = [];
  bool listmodel = false; //列表显示方式 true 按芯片名称排序 false 按照汽车排序
  ItemScrollController itemScrollController = ItemScrollController();
  late TextEditingController textEditingController;
  int currentsele = -1;
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

    loaddata(listmodel);
    super.initState();
  }

  void loaddata(model) {
    originList.clear();
    // originList
    //     .add(CityModel(name: listmodel ? "*按照车型检索" : "*按照芯片检索", tagIndex: "0"));
    if (listmodel) {
      for (var i = 0; i < appData.chipIDList.length; i++) {
        originList.add(CityModel(
            name: appData.chipIDList[i]["master"],
            tagIndex: getstr(appData.chipIDList[i]["master"]),
            data: appData.chipIDList[i]));
      }
    } else {
      for (var i = 0; i < appData.chipCarList.length; i++) {
        originList.add(CityModel(
            name: appData.chipCarList[i]["master"],
            tagIndex: getstr(appData.chipCarList[i]["master"]),
            data: appData.chipCarList[i]));
      }
    }
    // SuspensionUtil.sortListBySuspensionTag(originList);
    // SuspensionUtil.setShowSuspensionStatus(originList);
    _handleList(originList);
  }

  void _handleList(List<CityModel> list) {
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
      List<CityModel> list = originList.where((v) {
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
    return SizedBox(
      height: 28.h,
      width: 340.w,
      child: TextField(
        autofocus: false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.r)),
            borderSide: const BorderSide(color: Color(0xff50c5c4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.r)),
            borderSide: const BorderSide(color: Color(0xff50c5c4)),
          ),
          contentPadding: EdgeInsets.only(left: 10.r, right: 10.r),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.r)),
            borderSide: BorderSide(color: const Color(0XFF50c5c4), width: 10.r),
          ),
          hintText:
              listmodel ? S.of(context).inchipname : S.of(context).incarname,
          hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFFCCCCCC)),
        ),
        onChanged: (instring) {
          _search(instring);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        header(),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          width: 320.w,
          height: 31.h,
          child: Row(
            children: [
              Expanded(
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          backgroundColor: MaterialStateProperty.all(!listmodel
                              ? const Color(0xff50c5c4)
                              : Colors.white)),
                      onPressed: () {
                        listmodel = false;
                        loaddata(0);
                        setState(() {});
                      },
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).carlist,
                              style: TextStyle(
                                  color:
                                      !listmodel ? Colors.white : Colors.black),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 12.w,
                              height: 16.h,
                              child: Image.asset(
                                "image/mcclone/Icon_hand.png",
                                fit: BoxFit.cover,
                                color: !listmodel
                                    ? Colors.white
                                    : const Color(0xff50c5c4),
                              ),
                            ),
                          ],
                        ),
                      ))),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor: MaterialStateProperty.all(
                          listmodel ? const Color(0xff50c5c4) : Colors.white)),
                  onPressed: () {
                    listmodel = true;
                    loaddata(0);
                    setState(() {});
                  },
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).chiplist,
                          style: TextStyle(
                              color: listmodel ? Colors.white : Colors.black),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        SizedBox(
                          width: 12.w,
                          height: 16.h,
                          child: Image.asset(
                            "image/mcclone/Icon_hand.png",
                            fit: BoxFit.cover,
                            color: listmodel
                                ? Colors.white
                                : const Color(0xff50c5c4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Expanded(
          child: AzListView(
            data: dataList,
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              CityModel model = dataList[index];
              return TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Container(
                  color: currentsele == index
                      ? const Color(0xff50c5c4)
                      : const Color(0xffeeeeee),
                  height: 43.h,
                  width: double.maxFinite,
                  child: Center(
                    child: Text(
                      model.name,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onPressed: () {
                  currentsele = index;
                  //   _focusNode.unfocus();
                  Navigator.pushNamed(context, "/createchiplist",
                      arguments: model.data);
                  setState(() {});
                },
              );
            },
            susItemBuilder: (BuildContext context, int index) {
              CityModel model = dataList[index];
              String tag = model.getSuspensionTag();
              return Container(
                height: 30.h,
                width: double.maxFinite,
                color: const Color(0X8cdce7e7),
                alignment: Alignment.centerLeft,
                child: Center(
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF384c70),
                    ),
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
