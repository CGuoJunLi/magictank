import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/http/api.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';

import 'package:magictank/cncpage/upgrade/upgradeserver.dart';
import 'package:magictank/convers/convers.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/main.dart';
import 'package:magictank/userappbar.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';

import 'upgrading_page.dart';

class UpgradeLcdListPage extends StatefulWidget {
  const UpgradeLcdListPage({Key? key}) : super(key: key);

  @override
  _UpgradeLcdListPageState createState() => _UpgradeLcdListPageState();
}

class _UpgradeLcdListPageState extends State<UpgradeLcdListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const UpgradeList(),
    );
  }
}

class UpgradeList extends StatefulWidget {
  const UpgradeList({Key? key}) : super(key: key);

  @override
  _UpgradeListState createState() => _UpgradeListState();
}

class _UpgradeListState extends State<UpgradeList> {
  UpgradeServer upgradeServer = UpgradeServer();
  List<Map> updatalist = [];
  late ProgressDialog pd;
  String url = host +
      "/varList?JQ=" +
      cncVersion.verJG.toString() +
      "&PCB=" +
      cncVersion.verJG.toString() +
      "&sn=" +
      intToFormatStringHex(cncVersion.sn) +
      "&language=" +
      (locales!.languageCode == "zh" ? "0" : "1");
  @override
  void initState() {
    pd = ProgressDialog(context: context);
    getUpgradeList();
    super.initState();
  }

  Future<void> getUpgradeList() async {
    List result = await Api.lcdvarList(
      (locales!.languageCode == "zh" ? "0" : "1"),
      cncVersion.lcdJG,
      cncVersion.lcdPCB,
    );

    ////print(result);
    updatalist = List.from(result.reversed);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getUpgradeDat(String upurl, int ver) async {
    var data = await Api.encryptLcdBin(upurl.split("?")[1]);

    setState(() {
      // updatalist = List.from(data);
      showDialog(
          context: context,
          builder: (context) {
            return const MyTextDialog("是否确认升级此版本?");
          }).then((value) {
        if (value) {
          // pd.show(max: 100, msg: "升级中,请稍等");

          // cncVersion.ran = data["ran"];
          // cncVersion.binbase64 = data["bin-base64"];
          // cncVersion.w = data["w"];
          // cncVersion.ranbase64 = data["ran-base64"];
          // debugPrint("数据长度");

          ////print(cncVersion.binbase64.codeUnits.length);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (c) {
                return UpgradingPage(
                  {
                    "data": base64Decode(data["data"]),
                    "version": ver,
                    "model": 2
                  },
                );
              });
        } else {
          debugPrint("取消升级");
        }
      });
    });
  }

  Widget listItme(context, index) {
    // print(updatalist[index]);
    if (appData.limit > 0) {
      return ListTile(
        title: Text("版本号:" + updatalist[index]["ver"].toString()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("版本类型:" + updatalist[index]["release"]),
            Text("版本说明:" + updatalist[index]["description"]),
          ],
        ),
        trailing: const Icon(Icons.upgrade),
        onTap: () {
          ////print(updatalist[index]["upUrl"]);
          getUpgradeDat(updatalist[index]["upUrl"], updatalist[index]["ver"]);
        },
        // leading: Icon(Icons.upgrade),
      );
    } else {
      if (updatalist[index]["release"] == "Debug") {
        return const SizedBox();
      } else {
        return ListTile(
          title: Text("版本号:" + updatalist[index]["ver"].toString()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("版本类型:" + updatalist[index]["release"]),
              Text("版本说明:" + updatalist[index]["description"]),
            ],
          ),
          trailing: const Icon(Icons.upgrade),
          onTap: () {
            ////print(updatalist[index]["upUrl"]);
            getUpgradeDat(updatalist[index]["upUrl"], updatalist[index]["ver"]);
          },
          // leading: Icon(Icons.upgrade),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: updatalist.length,
        itemBuilder: (context, index) {
          return listItme(context, index);
        });
  }
}
