import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';
import 'package:magictank/magicclone/updata/upgrade_page.dart';
import 'package:magictank/userappbar.dart';

import '../../main.dart';

class McUpgradeListPage extends StatelessWidget {
  const McUpgradeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userCloneBar(context),
      body: const McUpgradeList(),
    );
  }
}

class McUpgradeList extends StatefulWidget {
  const McUpgradeList({Key? key}) : super(key: key);

  @override
  _McUpgradeListState createState() => _McUpgradeListState();
}

class _McUpgradeListState extends State<McUpgradeList> {
  List<Map> updatalist = [];
  final String _localPath = "";
  String url = host +
      "verMcList?language=" +
      (locales!.languageCode == "zh" ? "0" : "1");
  @override
  void initState() {
    //_prepareSaveDir();
    getMcUpgradeList();
    super.initState();
  }

  Future<void> getMcUpgradeList() async {
    var result = await Api.mcvarList(locales!.languageCode == "zh" ? "0" : "1");
    // data = response.data.toString();
    setState(() {
      debugPrint("服务器返回的数据");
      List temp = [];

      updatalist = List.from(result.reversed);
    });
  }

  Widget listItme(context, index) {
    return ListTile(
      title: Text(S.of(context).ver + updatalist[index]["version"].toString()),
      subtitle:
          Text(S.of(context).direction + updatalist[index]["description"]),
      trailing: const Icon(Icons.upgrade),
      onTap: () {
        debugPrint(updatalist[index]["url"]);
        if (!mcbtmodel.getMcBtState()) {
          showDialog(
              context: context,
              builder: (c) {
                return const MyTextDialog("请先连接蓝牙");
              });
        } else {
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog(S.of(context).askupgrade +
                    updatalist[index]["version"].toString());
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
                  Fluttertoast.showToast(
                    msg: S.of(context).upgradeok,
                  );
                } else {
                  Fluttertoast.showToast(msg: S.of(context).upgradeerror);
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
