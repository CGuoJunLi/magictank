import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lpinyin/lpinyin.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:magictank/http/api.dart';
import '../../azlistview/src/az_common.dart';
import '../../azlistview/src/az_listview.dart';
import '../../azlistview/src/index_bar.dart';
import '../../main.dart';

class InstacodeCarModel extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;
  String? id;
  bool? selestate;
  InstacodeCarModel(
      {required this.name,
      this.tagIndex,
      this.namePinyin,
      this.id,
      this.selestate});
  InstacodeCarModel.fromJson(Map<String, dynamic> json) : name = json['name'];

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

class AllLostPage extends StatefulWidget {
  const AllLostPage({Key? key}) : super(key: key);

  @override
  _AllLostPageState createState() => _AllLostPageState();
}

class _AllLostPageState extends State<AllLostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: const CarSele(),
    );
  }
}

class CarSele extends StatefulWidget {
  const CarSele({Key? key}) : super(key: key);

  @override
  _CarSeleState createState() => _CarSeleState();
}

class _CarSeleState extends State<CarSele> {
  List<InstacodeCarModel> originList = []; //原列表
  List<InstacodeCarModel> dataList = []; //显示列表
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
  List<Map> carList = [];
  List<String> showlist = [];
  late ProgressDialog pd;
  late FocusNode _focusNode;

  //_carSelePageState() {}
  @override
  void initState() {
    _focusNode = FocusNode();
    pd = ProgressDialog(context: context);
    getCarList();
    super.initState();
  }

  void loaddata() //加载汽车列表
  {
    for (var i = 0; i < carList.length; i++) {
      if (locales!.languageCode == "zh") //中文
      {
        ////print(carList[i]);
        originList.add(InstacodeCarModel(
          name: carList[i]["name"],
          tagIndex: getstr(carList[i]["name"]),
          id: carList[i]["carid"].toString(),
          selestate: false,
        )
            //oftenkey: appData.carList[i]["often"],
            );
      } else {
        originList.add(InstacodeCarModel(
          name: carList[i]["name"],
          tagIndex: getstr(carList[i]["name"]),
          id: carList[i]["carid"].toString(),
          selestate: false,
        )
            // oftenkey: appData.carList[i]["often"],
            );
      }
    }
    _handleList(originList);
  }

  void _handleList(List<InstacodeCarModel> list) {
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

  Future<void> getCarList() async {
    var result = await Api.getCarList(
        "language=${(locales!.languageCode == "zh" ? "0" : "1")}");
//printresult);

    carList = List.from(result);
    ////print(carList);

    loaddata();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _search(String text) {
    if (text.isEmpty) {
      debugPrint("空");
      _handleList(originList);
    } else {
      List<InstacodeCarModel> list = originList.where((v) {
        return v.name.toLowerCase().contains(text.toLowerCase());
      }).toList();
      _handleList(list);
    }
  }

  _clearSeleState(List<InstacodeCarModel> dataList) {
    for (var i = 0; i < dataList.length; i++) {
      dataList[i].selestate = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.only(left: 10.w, right: 10.w),
        width: double.maxFinite,
        height: 20.h,
        child: Row(
          children: [
            Text(
              S.of(context).alllost,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Expanded(child: SizedBox()),
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
        child: dataList.isEmpty
            ? Center(child: Text(S.of(context).loadingdata))
            : AzListView(
                data: dataList,
                itemCount: dataList.length,
                indexBarOptions: IndexBarOptions(
                  textStyle: TextStyle(
                      fontSize: 14.sp, color: const Color(0xFF666666)),
                ),
                itemBuilder: (BuildContext context, int index) {
                  InstacodeCarModel model = dataList[index];
                  return GestureDetector(
                    child: Container(
                      color: model.selestate!
                          ? const Color(0xff384c70)
                          : const Color(0xffeeeeee),
                      height: 43.h,
                      width: double.maxFinite,
                      child: Center(
                        child: Text(
                          model.name,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    onTapDown: (s) {
                      _clearSeleState(dataList);
                      dataList[index].selestate = true;
                      _focusNode.unfocus();
                      Navigator.pushNamed(context, '/inputcode', arguments: {
                        "carname": model.name,
                        "carid": model.id
                      });
                      setState(() {});
                    },
                  );
                },
                //       padding: const EdgeInsets.all(20),
                susItemBuilder: (BuildContext context, int index) {
                  InstacodeCarModel model = dataList[index];
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
    ]);
  }
}
