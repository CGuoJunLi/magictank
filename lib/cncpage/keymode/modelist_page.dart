//立铣胚模型界面
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

//import '../../fileimageex.dart';
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

class ModelListPage extends StatelessWidget {
  final Map arguments;
  const ModelListPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: ModelList(arguments),
    );
  }
}

class ModelList extends StatefulWidget {
  final Map arguments;
  const ModelList(this.arguments, {Key? key}) : super(key: key);

  @override
  State<ModelList> createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> {
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
  late FocusNode _focusNode;
  @override
  void initState() {
    _focusNode = FocusNode();
    loaddata(widget.arguments["type"]);

    super.initState();
    //showlist = List.from();
  }

  void loaddata(int type) //加载汽车列表
  {
    List<dynamic> temp = [];
    switch (type) {
      case 1:
        //print(appData.pmodelList[0]);
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

  String getkeynumbet(Map keydata) {
    if (keydata["modelwide"] == 1000) {
      if (keydata["modelthickness"] == 220) {
        return "使用:T胚";
      } else {
        return "使用:L胚";
      }
    } else {
      return "使用:S胚";
    }
  }

  int getFirstClamp(Map keymodel) {
    if (keymodel["alltype"] == 1 ||
        keymodel["alltype"] == 2 ||
        keymodel["alltype"] == 5 ||
        keymodel["alltype"] == 8 ||
        keymodel["headtype"] != 0) {
      return 13;
    } else {
      if (keymodel["modelthickness"] > keymodel["keythickness"]) {
        return 13;
      } else {
        return 15;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48.h,
          child: Center(
            child: Text(
              widget.arguments["type"] == 1 ? "平铣模型" : "立铣模型",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
              ),
            ),
          ),
        ),
        Container(
          height: 13.h,
          color: const Color(0xffdde2ea),
        ),
        Container(
          width: double.maxFinite,
          height: 28.h,
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  onChanged: (instring) {
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
                    hintText: S.of(context).inputkeyname,
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
                width: 10.w,
              ),
            ],
          ),
        ),
        Expanded(
          child: AzListView(
            data: dataList,
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              ModelModel model = dataList[index];
              return TextButton(
                onPressed: () {
                  _focusNode.unfocus();
                  Navigator.pushNamed(context, "/cutmodelready",
                      arguments: {"data": model.data!});
                },
                child: Container(
                  height: 126.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                      color: const Color(0XFF384C70),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 23.h,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              model.name,
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.white),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              getkeynumbet(model.data!),
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.white),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Image.file(
                            File(appData.keyImagePath +
                                "/model/" +
                                model.picname!),
                            fit: BoxFit.fill,
                            errorBuilder: (context, objeck, e) {
                          return Image.asset("image/null.png");
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
            susItemBuilder: (BuildContext context, int index) {
              ModelModel model = dataList[index];
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
          flex: 5,
        ),
      ],
    );
  }
}
