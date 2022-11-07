import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/dialogshow/dialogpage.dart';

import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';

import 'package:magictank/convers/convers.dart';
import 'package:magictank/userappbar.dart';

class AchivePage extends StatefulWidget {
  const AchivePage({Key? key}) : super(key: key);

  @override
  State<AchivePage> createState() => _AchivePageState();
}

class _AchivePageState extends State<AchivePage> {
  late StreamSubscription activtbus;
  String activtState = "点击按钮开始激活";
  bool begin = false;
  String btname = "";
  String crcname = "";
  @override
  void initState() {
    activtbus = eventBus.on<ActivtEvent>().listen((ActivtEvent event) async {
      switch (event.state) {
        case 0x13:
          await Future.delayed(const Duration(milliseconds: 1000));
          getServerUID();
          break;
        case 0x14:
          await Future.delayed(const Duration(milliseconds: 1000));
          List<int> writebtnem = [0x40];

          writebtnem.addAll(asciiStringToint(btname));

          updatacmd(writebtnem, false);
          break;
        case 0x40:
          Fluttertoast.showToast(msg: S.of(context).complete);
          break;
        default:
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    activtbus.cancel();

    super.dispose();
  }

  Future<void> getServerUID() async {
    //print(cncVersion.iapSn);
    if (cncVersion.iapSn.length != 24) {
      Fluttertoast.showToast(msg: "设备已经是激活状态");
      return;
    }
    var result = await Api.adduid(cncVersion.iapSn);

    String btnamemd5 = crcname + cncbt4model.connetcedBtDriver!["id"];
    Uint8List content = const Utf8Encoder().convert(btnamemd5);
    Digest digest = md5.convert(content);
    btnamemd5 = base64.encode(digest.bytes);
    //btname = result["sn"] + "_" + btnamemd5.substring(0, 7);
    print(result["sn"]);
    btname = "AT+BNAME=MT-" + result["sn"];
    print(btname);
    List<int> writesn = [
      0X14,
    ];
    List<int> basesn = base64.decode(result["raw-base64"]);
    writesn.addAll(basesn);
    updatacmd(writesn, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userTankBar(context),
        body: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(activtState),
              ElevatedButton(
                  onPressed: () {
                    //print("开始激活设备");
                    if (cncbtmodel.state) {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return MySeleDialog(["旧蓝牙", "新蓝牙"]);
                          }).then((value) {
                        switch (value) {
                          case 1:
                            crcname = "MAGIC STAR";
                            updatacmd([0x13, 0, 0], false);
                            break;
                          case 2:
                            crcname = "MAGIC TANK";
                            updatacmd([0x13, 0, 0], false);
                            break;
                        }
                      });
                    } else {
                      Fluttertoast.showToast(msg: "请先连接蓝牙");
                      Navigator.pushNamed(context, "/selecnc", arguments: 3);
                    }
                  },
                  child: const Text("激活")),
              // ElevatedButton(
              //     onPressed: () {
              //       getServerUID();
              //     },
              //     child: const Text("获取服务器的数据")),
              // ElevatedButton(onPressed: () {}, child: const Text("写入sn数据")),
              // ElevatedButton(
              //     onPressed: () {
              //       List<int> writebtnem = [0x40];
              //       btname = "061FDA38_fze7t+6";
              //       writebtnem.addAll(asciiStringToint(btname));
              //       //print("写入蓝牙");
              //       updatacmd(writebtnem, false);
              //     },
              //     child: const Text("写入蓝牙名称")),
            ],
          ),
        ));
  }
}
