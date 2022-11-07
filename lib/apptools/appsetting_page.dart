import 'package:flutter/material.dart';

import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';

import 'package:magictank/generated/l10n.dart';

import 'package:magictank/home4_page.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';

import 'package:magictank/userappbar.dart';

import '../appdata.dart';

class AppSettingPage extends StatefulWidget {
  const AppSettingPage({Key? key}) : super(key: key);

  @override
  State<AppSettingPage> createState() => _AppSettingPageState();
}

class _AppSettingPageState extends State<AppSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userAppBar(context),
      body: const AppSetting(),
    );
  }
}

class AppSetting extends StatefulWidget {
  const AppSetting({Key? key}) : super(key: key);

  @override
  State<AppSetting> createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
            title: Text(S.of(context).appwelcomepage),
            value: appData.welcomepage,
            onChanged: (value) {
              appData.upgradeAppData({"welcomepage": value});
              setState(() {});
            }),
        SwitchListTile(
            title: Text(S.of(context).usenewver),
            value: appData.isBLE,
            onChanged: (value) {
              appData.isBLE = value;

              cncbt4model.disconnect();
              if (mcbtmodel.getMcBtState()) {
                mcbtmodel.disconnect();
                if (value) {
                  mcbtmodel.init();
                }
              }
              // if (getMsBtState()) {
              //   msdisconnect();
              // }
              appData.upgradeAppData({"isble": value});
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return const Tips4Page();
              }), (route) => false);

              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(builder: (context) {
              //     if (appData.isBLE) {
              //       return const Tips4Page();
              //     } else {
              //       return const Tips2Page();
              //     }
              //   }),
              //   ModalRoute.withName('/'),
              // );
              setState(() {});
            }),
        SwitchListTile(
            title: const Text("新读码方式"),
            value: appData.readmodel,
            onChanged: (value) {
              appData.readmodel = value;
              appData.upgradeAppData({"readmodel": value});
              setState(() {});
            }),
        SwitchListTile(
            title: const Text("启动APP后自动连接设备"),
            value: appData.beginautobt,
            onChanged: (value) {
              appData.beginautobt = value;
              appData.upgradeAppData({"beginautobt": value});
              setState(() {});
            }),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xff384c70)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/selelanguage");
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Text(S.of(context).selelanuage),
            )),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xff384c70)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/speek");
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Text(S.of(context).voicesetting),
            )),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xff384c70)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/hidepage");
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Text(S.of(context).mainpage),
            )),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xff384c70)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/getzip");
            },
            child: const SizedBox(
              width: double.maxFinite,
              child: Text("解压本地文件"),
            )),
        appData.limit == 10
            ? ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff384c70)),
                ),
                onPressed: () {
                  if (cncVersion.fixtureType == 21) {
                    cncVersion.fixtureType = 11;
                  } else {
                    cncVersion.fixtureType = 21;
                  }
                  setState(() {});
                },
                child: SizedBox(
                  width: double.maxFinite,
                  child: Text("当前默认夹具:" +
                      (cncVersion.fixtureType == 21 ? "新夹具" : "旧夹具")),
                ))
            : const SizedBox(),
        const Text("内部版本号:219_4")
      ],
    );
  }
}
