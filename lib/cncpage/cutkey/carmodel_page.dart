import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

import '../../appdata.dart';
import 'cardata_page.dart';

class CarModelPage extends StatefulWidget {
  final Map arguments;
  const CarModelPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  _CarModelPageState createState() => _CarModelPageState();
}

class _CarModelPageState extends State<CarModelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffeeeeee),
      appBar: userTankBar(context),
      body: CarModelList(widget.arguments),
    );
  }
}

class CarModelList extends StatefulWidget {
  final Map arguments;
  const CarModelList(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  _CarModelListState createState() => _CarModelListState();
}

class _CarModelListState extends State<CarModelList> {
  late List<Map> carmodel = [];
  late List<Map> showlist = [];
  late CarModel modeldata;
  List keydatalist = [];
  Color selecolor = Colors.white;
  //bool listmodel = false;
  String selename = "";
  int currentsele = 0;
  @override
  void initState() {
    super.initState();
    modeldata = widget.arguments["carmodel"];

    showlist = List.from(modeldata.carmodel!);
    if (appData.carDataListview) {
      getkeylist(showlist[0]["time"]);
    }
    for (var i = 0; i < showlist.length; i++) {
      showlist[i]["sele"] = false;
    }

    selename = showlist[0]["chname"];
  }

  Widget showcarmodel(context, index) {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              currentsele == index
                  ? const Color(0xff384c70)
                  : const Color(0XFFEEEEEE),
            ),
            padding: MaterialStateProperty.all(EdgeInsets.zero)),
        onPressed: () {
          currentsele = index;

          showlist[index]["sele"] = true;

          getkeylist(showlist[index]["time"]);
          setState(() {});

          Navigator.pushNamed(
            context,
            '/keydata',
            arguments: {
              "modellist": showlist[index]["time"],
              "modelname": showlist[index]["chname"],
              "carname": modeldata.name,
              "type": widget.arguments["type"]
            },
          );
        },
        child: SizedBox(
            height: 43.h,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        showlist[index]["chname"],
                        style: TextStyle(fontSize: 15.sp, color: Colors.black),
                      ),
                      const Expanded(child: SizedBox()),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xff707070),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1.h,
                  thickness: 1.h,
                ),
              ],
            )));
  }

  void getkeylist(data) {
    List<Map> temp = [];
    keydatalist = [];
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

    List keyid = [];
    for (var i = 0; i < data.length; i++) {
      keyid.addAll(data[i]["id"]);
    }
    keyid = keyid.toSet().toList();
    for (var j = 0; j < keyid.length; j++) {
      for (var i = 0; i < temp.length; i++) {
        if (keyid[j] == temp[i]["id"]) {
          //如果存在id 则将ID转换为钥匙数据
          temp[i]["sele"] = false;
          keydatalist.add(temp[i]);
        }
      }
    }
  }

  Widget showcarmodel2(context, index) {
    return SizedBox(
      height: 43.h,
      width: 114.w,
      child: TextButton(
        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        onPressed: () {
          currentsele = index;
          getkeylist(showlist[index]["time"]);
          setState(() {});
        },
        child: Text(
          showlist[index]["chname"],
          style: TextStyle(
            fontSize: 14.sp,
            color:
                currentsele == index ? const Color(0xff384c70) : Colors.black,
          ),
        ),
      ),
    );
  }

  String _gettooth(Map keydata) {
    if (keydata["side"] == 3 && keydata["class"] != 0) {
      if (keydata["toothSA"][keydata["toothSA"].length - 1] ==
          keydata["toothSA"][keydata["toothSA"].length - 2]) {
        return (keydata["toothSA"].length - 1).toString() +
            "-" +
            keydata["toothSA"].length.toString();
      } else if (keydata["toothSB"][keydata["toothSB"].length - 1] ==
          keydata["toothSB"][keydata["toothSB"].length - 2]) {
        return (keydata["toothSA"].length).toString() +
            "-" +
            (keydata["toothSA"].length - 1).toString();
      } else {
        return keydata["toothSA"].length.toString() +
            "-" +
            keydata["toothSA"].length.toString();
      }
    } else {
      return keydata["toothSA"].length.toString();
    }
  }

  String getkeylength(Map keydata) {
    if (keydata["locat"] == 0) {
      return keydata["wide"].toString() +
          "*" +
          (keydata["toothSA"][keydata["toothSA"].length - 1] + 210).toString();
    } else {
      return keydata["wide"].toString() +
          "*" +
          keydata["toothSA"][0].toString();
    }
  }

  Widget showkeydata(context, index) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      child: SizedBox(
        height: 130.h,
        child: Card(
          child: Column(
            children: [
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                height: 16.h,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      keydatalist[index]["cnname"],
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.h,
                      child: Text(
                        keydatalist[index]["keynumbet"] == ""
                            ? ""
                            : "（" + keydatalist[index]["keynumbet"] + "）",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10.sp, color: Colors.red),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              SizedBox(
                height: 13.h,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      _gettooth(keydatalist[index]) + S.of(context).keycuts,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(
                      width: 13.w,
                    ),
                    SizedBox(
                      height: 10.h,
                      child: Text(
                        getkeylength(keydatalist[index]),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      keydatalist[index]["locat"].toString() == "0"
                          ? (S.of(context).keyloact +
                              ":" +
                              S.of(context).keylocat0)
                          : (S.of(context).keyloact +
                              ":" +
                              S.of(context).keylocat1),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  // color: Colors.red,
                  height: 38.h,
                  width: 136.w,
                  child: Image.file(
                    File(appData.keyImagePath +
                        "/key/" +
                        keydatalist[index]["picname"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ]),
              const Expanded(child: SizedBox()),
              SizedBox(
                width: 226.w,
                height: 22.h,
                child: Text(
                  (keydatalist[index]["chnote"] != "无" &&
                          keydatalist[index]["chnote"] != "null")
                      ? S.of(context).note + keydatalist[index]["chnote"]
                      : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 10.sp,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        ////print(keydatalist[index]);
        //传入钥匙数据即可
        //先显示操作说明
        baseKey.initdata(keydatalist[index]);
        Navigator.pushNamed(context, '/openclamp',
            arguments: {"keydata": keydatalist[index], "state": 0});

        // Navigator.pushNamed(context, '/keyshow',
        // arguments: {"keydata": showlist[index]["keydata"][i]});
      },
      onLongPress: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 44.h,
          child: Row(
            children: [
              SizedBox(
                width: 10.h,
              ),
              Text(
                modeldata.name,
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: SizedBox(
                width: 10.h,
              )),
              TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Container(
                    width: 90.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xff384c70), width: 1.0),
                        borderRadius: BorderRadius.circular(11.h)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(appData.carDataListview
                            ? "image/tank/Icon_listmodel1.png"
                            : "image/tank/Icon_listmodel2.png"),
                        Text(
                          S.of(context).carlistmodel,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    )),
                onPressed: () {
                  appData.carDataListview = !appData.carDataListview;
                  appData.upgradeAppData(
                      {"carDataListview": appData.carDataListview});
                  //   bool carDataListview = false;
                  if (keydatalist.isEmpty) {
                    getkeylist(showlist[0]["time"]);
                  }
                  setState(() {});
                },
              ),
              SizedBox(
                width: 10.h,
              ),
            ],
          ),
        ),
        Container(
          height: 8.h,
          color: const Color(0xffDDE2EA),
        ),
        appData.carDataListview
            ? Expanded(
                child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: showlist.length,
                      itemBuilder: (context, index) {
                        return showcarmodel2(context, index);
                      },
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: keydatalist.length,
                      itemBuilder: (context, index) {
                        return showkeydata(context, index);
                      },
                    ),
                    flex: 2,
                  ),
                ],
              ))
            : Expanded(
                child: ListView.builder(
                  itemCount: showlist.length,
                  itemBuilder: (context, index) {
                    return showcarmodel(context, index);
                  },
                ),
              ),
      ],
    );
  }
}
