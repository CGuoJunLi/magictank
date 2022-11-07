import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/magicclone/updata/upgrade_page.dart';
import 'package:magictank/magicsmart/bluetooth/msclonebt_mananger.dart';

import '../../main.dart';

class SmartUpgradeListPage extends StatelessWidget {
  const SmartUpgradeListPage({Key? key}) : super(key: key);

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

            //fit: BoxFit.cover,
          ),
        ),
      ),
      body: const SmartUpgradeList(),
    );
  }
}

class SmartUpgradeList extends StatefulWidget {
  const SmartUpgradeList({Key? key}) : super(key: key);

  @override
  _SmartUpgradeListState createState() => _SmartUpgradeListState();
}

class _SmartUpgradeListState extends State<SmartUpgradeList> {
  List<Map> updatalist = [];
  final String _localPath = "";
  String url = host +
      "verMcList?language=" +
      (locales!.languageCode == "zh" ? "0" : "1");
  @override
  void initState() {
    //_prepareSaveDir();
    getSmartUpgradeList();
    super.initState();
  }

  Future<void> getSmartUpgradeList() async {
    Map<String, dynamic> headers = {"User-Agent": "Blade/1.0.0"};

    var dio = Dio();
    dio.options.headers = headers;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      return null;
    };
    // dio.options.headers = headers;
    //var data;
    debugPrint(url);
    final response = await dio.get(url);
    // data = response.data.toString();
    var data = json.decode(response.data);
    setState(() {
      debugPrint("服务器返回的数据");
      updatalist = List.from(data);
    });
  }

  Widget listItme(context, index) {
    return ListTile(
      title: Text("版本号:" + updatalist[index]["version"].toString()),
      subtitle: Text("版本说明:" + updatalist[index]["description"]),
      trailing: const Icon(Icons.upgrade),
      onTap: () {
        debugPrint(updatalist[index]["url"]);
        if (msbtmodel.state == false) {
          showDialog(
              context: context,
              builder: (c) {
                return const MyTextDialog("请先连接蓝牙");
              });
        } else {
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog(
                    "是否升级至" + updatalist[index]["version"].toString() + "版本.");
              }).then((value) {
            if (value) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (c) {
                    debugPrint(_localPath);
                    return Upgrade(updatalist[index]["url"]);
                  }).then((value) {
                if (value) {
                  Fluttertoast.showToast(msg: "升级成功");
                } else {
                  Fluttertoast.showToast(msg: "升级失败请重试!");
                }
              });
              debugPrint("确定升级");
            }
          });
        }

        //getUpgradeDat(updatalist[index]["upUrl"]);
      },
      // leading: Icon(Icons.upgrade),
    );
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
