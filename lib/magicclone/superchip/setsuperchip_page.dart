import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';
import 'package:magictank/magicclone/chipclass/progresschip.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class SetSuperChipPage extends StatefulWidget {
  const SetSuperChipPage({Key? key}) : super(key: key);

  @override
  State<SetSuperChipPage> createState() => _SetSuperChipPageState();
}

class _SetSuperChipPageState extends State<SetSuperChipPage> {
  List<Map<String, dynamic>> chipMpdel = [
    {"model": 0X00, "name": "PCF7936(ID46)"},
    {"model": 0X01, "name": "PCF7937"},
    {"model": 0X02, "name": "PCF7938(ID47)"},
    {"model": 0X03, "name": "EM4170(ID48)"},
    {"model": 0X04, "name": "11"},
    {"model": 0X05, "name": "12"},
    {"model": 0X06, "name": "13"},
    {"model": 0X07, "name": "33"},
    {"model": 0X08, "name": "7935"},
  ];
  Timer? timer;
  Duration timeout = const Duration(seconds: 10);
  late ProgressDialog pd;
  late StreamSubscription eventBusFn;
  late StreamSubscription btStateEvent;
  @override
  void initState() {
    pd = ProgressDialog(context: context);
    eventBusFn = eventBus.on<ChipReadEvent>().listen((ChipReadEvent event) {
      pd.close();
      if (event.state == false) {
        Fluttertoast.showToast(msg: "设置失败");
      } else {
        Fluttertoast.showToast(msg: "设置成功");
        pd.close();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    eventBusFn.cancel();
    super.dispose();
  }

  void progressTimeout(String showmessage) {
    if (timer != null) {
      timer!.cancel();
    }

    timeout = const Duration(seconds: 30);

    timer = Timer(timeout, () {
      pd.close();
      showDialog(
          context: context,
          builder: (c) {
            return MyTextDialog(showmessage);
          });
    });
  }

  _autoConnectBT() {
    if (appData.autoconnect &&
        mcbtmodel.blSwitch &&
        appData.mcbluetoothname != "") {
      pd.show(max: 100, msg: S.of(context).autoconnectbt);
      btStateEvent = eventBus.on<MCConnectEvent>().listen(
        (MCConnectEvent event) async {
          if (event.state) {
            //  progressChip.getver();
            btStateEvent.cancel();
            //   await Future.delayed(const Duration(seconds: 2));
            pd.close();
          } else {
            pd.close();
            btStateEvent.cancel();
            Navigator.pushNamed(context, "/selemc");
          }
        },
      );
      mcbtmodel.autoConnect();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const MyTextDialog("请先连接蓝牙");
          }).then((value) {
        if (value) {
          Navigator.pushNamed(context, '/selemc');
        }
      });
    }
  }

  List<Widget> chipList() {
    List<Widget> temp = [];

    for (var i = 0; i < chipMpdel.length; i++) {
      temp.add(
        Container(
          height: 43.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xffeeeeee))),
          ),
          child: TextButton(
            onPressed: () {
              if (mcbtmodel.getMcBtState()) {
                pd.show(max: 100, msg: "设置中...");
                //progressTimeout("超时,设置失败");

                progressChip.setSuperChip(chipMpdel[i]["model"]);
              } else {
                _autoConnectBT();
              }
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.only(left: 19.r),
                child: Text(
                  chipMpdel[i]["name"],
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userCloneBar(context),
      body: Column(children: [
        SizedBox(
          width: double.maxFinite,
          height: 35.r,
          child: Padding(
            padding: EdgeInsets.only(left: 21.r, top: 10),
            child: Text(
              "超模芯片设置",
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Divider(
          color: const Color(0xffdde2ea),
          thickness: 8.r,
          height: 8.r,
        ),
        Expanded(
            child: ListView(
          children: chipList(),
        ))
      ]),
    );
  }
}
