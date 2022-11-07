import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';

import 'package:magictank/main.dart';
import 'package:magictank/userappbar.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../azlistview/src/az_common.dart';
import '../../azlistview/src/az_listview.dart';
import '../../azlistview/src/index_bar.dart';

class CarModel extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;
  Map? data;
  List? oftenkey;
  List? carmodel;
  int? modelindex;
  String? searchIndex;
  bool? selestate;

  CarModel({
    required this.name,
    this.tagIndex,
    this.searchIndex,
    this.namePinyin,
    this.data,
    this.oftenkey,
    this.carmodel,
    this.modelindex,
    this.selestate,
  });
  CarModel.fromJson(Map<String, dynamic> json) : name = json['name'];

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

class CarDataPage extends StatefulWidget {
  final Map arguments;
  const CarDataPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  _CarDataPageState createState() => _CarDataPageState();
}

class _CarDataPageState extends State<CarDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XffEEEEEE),
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: CarDataList(widget.arguments),
    );
  }
}

class CarDataList extends StatefulWidget {
  final Map arguments;
  const CarDataList(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  _CarDataListState createState() => _CarDataListState();
}

class _CarDataListState extends State<CarDataList> {
  List<Map> oftenkey = [];

  int currentsele = -1;
  List<CarModel> originList = []; //原列表
  List<CarModel> dataList = []; //显示列表
  List<String> moellist = [];
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
//{[\d]:[0-9]*:[\u4E00-\u9FA5A-Za-z0-9]+:[A-Za-z0-9]+:[A-Za-z0-9]+:[\w]+:[A-Za-z0-9]+:[0-9]*,[0-9]*}");

  late FocusNode _focusNode;
  @override
  void initState() {
    _focusNode = FocusNode();
    if (Platform.isAndroid) {
      //设置状态栏透明
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          //statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark));
    }

    loaddata(widget.arguments["type"]);

    super.initState();
    //showlist = List.from();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loaddata(int type) //加载汽车列表
  {
    List<dynamic> temp = [];

    switch (type) {
      case 1:
        temp = List.from(appData.carList);
        break;
      case 2:
        temp = List.from(appData.civilList);

        break;
      case 3:
        temp = List.from(appData.motorList);
        break;
    }
    // if (locales!.languageCode == "zh") {
    //   for (var j = 0; j < kIndexBarData.length; j++) {
    //     for (var i = 0; i < temp.length; i++) {
    //       if (getstr(temp[i]["chbrand"]) == kIndexBarData[j]) {
    //         temp2.add(temp[i]);
    //       }
    //     }
    //   }
    //   temp = List.from(temp2);
    //   temp2 = [];
    // } else {
    //   for (var j = 0; j < kIndexBarData.length; j++) {
    //     for (var i = 0; i < temp.length; i++) {
    //       if (getstr(temp[i]["enbrand"]) == kIndexBarData[j]) {
    //         temp2.add(temp[i]);
    //       }
    //     }
    //   }
    //   temp = List.from(temp2);
    //   temp2 = [];
    // }
    // print(temp);
    for (var i = 0; i < temp.length; i++) {
      if (locales!.languageCode == "zh") //中文
      {
        //(getstr(temp[i]["chbrand"]));
        // print(temp[i]);
        originList.add(
          CarModel(
            name: temp[i]["chbrand"],
            searchIndex: getIndex(temp[i]["chbrand"]) + temp[i]["enbrand"],
            tagIndex: getstr(temp[i]["chbrand"]),
            //oftenkey: temp[i]["often"],
            //oftenkey: getoftenkeydatalsit(temp[i]["often"]),
            carmodel: temp[i]["model"],
            selestate: false,
          ),
        );
      } else {
        originList.add(
          CarModel(
            name: temp[i]["enbrand"],
            searchIndex: getIndex(temp[i]["chbrand"]) + temp[i]["enbrand"],
            tagIndex: getstr(temp[i]["enbrand"]),
            //oftenkey: temp[i]["often"],
            //oftenkey: getoftenkeydatalsit(temp[i]["often"]),
            carmodel: temp[i]["model"], selestate: false,
          ),
        );
      }
    }

    _handleList(originList);
  }

  String getBaseTitle() {
    switch (widget.arguments["type"]) {
      case 1:
        return S.of(context).cardatabase;
      case 2:
        return S.of(context).civildatabase;
      case 3:
        return S.of(context).motordatabase;
      default:
        return "";
    }
  }

  void _handleList(List<CarModel> list) {
    dataList.clear();
    if (list.isEmpty) {
      setState(() {});
      return;
    }
    dataList.addAll(list);

    // // A-Z sort.

    SuspensionUtil.sortListBySuspensionTag(dataList, model: 1);
    // dataList = List.from(SuspensionUtil.result);

    // // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(dataList);

    setState(() {});

    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
  }

  String getIndex(String getc) {
    RegExp expcn = RegExp(r'[\u4e00-\u9fa5]+'); //数字和和字母组成
    RegExp expen = RegExp(r'[A-Za-z]+'); //数字和和字母组成
    if (expcn.firstMatch(getc[0]) != null) //中文
    {
      // print(PinyinHelper.getPinyinE(getc,
      //             defPinyin: "#",
      //             separator: "",
      //             format: PinyinFormat.WITHOUT_TONE)
      //         .toUpperCase() +
      //     PinyinHelper.getShortPinyin(getc).toUpperCase());
      return getc +
          PinyinHelper.getPinyinE(getc,
                  defPinyin: "#",
                  separator: "",
                  format: PinyinFormat.WITHOUT_TONE)
              .toUpperCase() +
          PinyinHelper.getShortPinyin(getc).toUpperCase();
    } else {
      if (expen.firstMatch(getc) != null) //英文
      {
        return getc.toUpperCase();
      } else //数字
      {
        return "#";
      }
    }
  }

  //获取首字母,中文获取 拼音 英文获取首字母
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
      //只查找品牌
      // List<CarModel> list = originList.where((v) {
      //   return v.name.toLowerCase().contains(text.toLowerCase());
      // }).toList();
      //如果品牌为空 那么就查找车型
      List<CarModel> list2 = [];
      for (var i = 0; i < originList.length; i++) {
        //var temp=originList[i].carmodel

        if (originList[i]
            .searchIndex!
            .toUpperCase()
            .contains(text.toUpperCase())) {
          list2.add(originList[i]);
        } else {
          for (var j = 0; j < originList[i].carmodel!.length; j++) {
            // print(originList[i].carmodel![j]["chname"]);
            if (originList[i]
                .carmodel![j]["chname"]
                .toUpperCase()
                .contains(text.toUpperCase())) {
              CarModel tempmodel = CarModel(
                name: originList[i].name +
                    "--" +
                    originList[i].carmodel![j]["chname"],
                tagIndex: originList[i].tagIndex,
                namePinyin: originList[i].namePinyin,
                data: originList[i].data,
                oftenkey: originList[i].oftenkey,
                carmodel: originList[i].carmodel,
                modelindex: j,
                selestate: false,
              );

              //print(tempmodel.name);
              list2.add(tempmodel);
            }
          }
        }
      }
      _handleList(list2);
    }
  }

  // Map getoftenkeydata(int id, int num) {
  //   int i = 0;
  //   Map data = {};
  //   for (i = 0; i < temp.length; i++) {
  //     if (temp[i]["id"] == id) {
  //       return (temp[i]);
  //     }
  //   }
  //   return {};
  // }

  List<Map> getoftenkeydatalsit(List id) {
    int i = 0;
    int times = 0;
    debugPrint("id:$id");
    List temp = [];
    switch (widget.arguments["type"]) {
      case 1:
        temp = List.from(appData.carkeyList);
        break;
      case 2:
        temp = List.from(appData.civilkeyList);
        break;
      case 3:
        temp = List.from(appData.motorkeyList);
        break;
    }
    List<Map> data = List.filled(2, {});
    for (i = 0; i < temp.length; i++) {
      if (id[0] == temp[i]["id"]) {
        times++;
        data[0] = Map.from(temp[i]);
      }
      if (id[1] == temp[i]["id"]) {
        times++;
        data[1] = Map.from(temp[i]);
      }
      if (times == 2) {
        return data;
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          width: double.maxFinite,
          height: 20.h,
          child: Row(
            children: [
              Text(
                getBaseTitle(),
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Expanded(child: SizedBox()),
              TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Container(
                  width: 97.w,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 1.0, color: const Color(0xff384c70)),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset("image/share/Icon_mystar.png"),
                      Text(
                        S.of(context).userstar,
                        style: TextStyle(fontSize: 12.sp),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  if (appData.loginstate) {
                    Navigator.pushNamed(context, '/mycollection');
                  } else {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return MyTextDialog(S.of(context).needlogin,
                              button2: S.of(context).login);
                        }).then((value) {
                      if (value) {
                        Navigator.pushNamed(context, '/login');
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Container(
          width: double.maxFinite,
          height: 28.h,
          margin: EdgeInsets.only(left: 10.w, right: 10.h),
          child: TextField(
            focusNode: _focusNode,
            onChanged: (instring) {
              currentsele = -1;
              _search(instring);
            },
            style: TextStyle(fontSize: 12.sp),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              suffixIcon: const Icon(
                Icons.search,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
                borderSide: BorderSide(color: Color(0xff384c70)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
                borderSide: BorderSide(color: Color(0xff384c70)),
              ),
              hintText: S.of(context).searchcartip,
              contentPadding: const EdgeInsets.only(bottom: 0),
              hintStyle: TextStyle(fontSize: 12.sp),
              // border: OutlineInputBorder(
              //   borderRadius: const BorderRadius.all(
              //     Radius.circular(4.0),
              //   ),
              // ),
            ),
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        Expanded(
          child: AzListView(
            data: dataList,
            itemCount: dataList.length,
            indexBarOptions: IndexBarOptions(
              textStyle:
                  TextStyle(fontSize: 14.sp, color: const Color(0xFF666666)),
            ),
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              CarModel model = dataList[index];
              return TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      currentsele == index
                          ? const Color(0xff384c70)
                          : const Color(0XFFEEEEEE),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: SizedBox(
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
                  _focusNode.unfocus();

                  if (model.name.contains("--")) {
                    baseKey.setcarname(model.name.split("--")[0]);

                    //print(baseKey.carname);
                    Navigator.pushNamed(
                      context,
                      '/keydata',
                      arguments: {
                        "modellist": model.carmodel![model.modelindex!]["time"],
                        "modelname": model.carmodel![model.modelindex!]
                            ["chname"],
                        "carname": baseKey.getcarname,
                        "type": widget.arguments["type"]
                      },
                    );
                  } else if (model.carmodel!.length == 1) {
                    baseKey.setcarname(model.name);
                    Navigator.pushNamed(
                      context,
                      '/keydata',
                      arguments: {
                        "modellist": model.carmodel![0]["time"],
                        "modelname": model.carmodel![0]["chname"],
                        "carname": model.name,
                        "type": widget.arguments["type"]
                      },
                    );
                  } else {
                    baseKey.setcarname(model.name);

                    Navigator.pushNamed(context, '/carmodel', arguments: {
                      "carmodel": model,
                      "type": widget.arguments["type"]
                    });
                  }
                  setState(() {});
                },
              );
            },
            susItemBuilder: (BuildContext context, int index) {
              CarModel model = dataList[index];
              String tag = model.getSuspensionTag();
              return Container(
                height: 30.h,
                width: double.maxFinite,
                color: const Color(0XFFDDE2EA),
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
