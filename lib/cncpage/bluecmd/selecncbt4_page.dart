import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/convers/convers.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'dart:async';

//import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'cncbt4_manganger.dart';

//import 'enable_bluetooth.dart';

class SeleCncBT4Page extends StatefulWidget {
  final int machineType;
  const SeleCncBT4Page(this.machineType, {Key? key}) : super(key: key);
  @override
  _SeleCncPageState createState() => _SeleCncPageState();
}

class _SeleCncPageState extends State<SeleCncBT4Page> {
  bool scanstates = false;
  late ProgressDialog pd;
  Timer? timer;
  //bool btstate = false;
  late StreamSubscription btStateEvent;
  List<DiscoveredDevice> btlist = [];
  StreamSubscription? scanbtsubscription;

  @override
  void dispose() {
    timer?.cancel();
    scanbtsubscription?.cancel();
    btStateEvent.cancel();
    super.dispose();
  }

  @override
  void initState() {
    //listenbtstate();
    //  cncbt4model.init();
    pd = ProgressDialog(context: context);
//  _streamSubscriptionState =
    btStateEvent = eventBus.on<CNCConnectEvent>().listen(
      (CNCConnectEvent event) {
        setState(() {
          if (event.state) {
            pd.close();
            debugPrint("返回");
            debugPrint("蓝牙ID");
            int have = appData.isactivation
                .indexWhere((d) => d == cncbt4model.connetcedBtDriver!["name"]);
            if (have > 0) {
              print("连接存在");
              appData.upgradeAppData({
                "cncbluetoothname": json.encode(cncbt4model.connetcedBtDriver),
              });
            } else {
              print("连接不存在");
              appData.upgradeAppData({
                "cncbluetoothname": json.encode(cncbt4model.connetcedBtDriver),
                "isactivation": cncbt4model.connetcedBtDriver!["name"],
              });
            }
            btStateEvent.cancel();
            cncbtmodel.state = true;
            Navigator.pop(context);
          } else {
            if (pd.isOpen()) {
              pd.close();
            }
          }
        });
      },
    );

    if (cncbtmodel.blSwitch) {
      debugPrint("开始扫描蓝牙");
      btscanning();
    }

    super.initState();
  }

  Future<void> btscanning() async {
    btlist = [];
    scanbtsubscription?.cancel();
    scanstates = true;
    timer?.cancel();
    timer = Timer(const Duration(seconds: 10), () {
      timer?.cancel();
      scanbtsubscription?.cancel();
      scanstates = false;

      setState(() {});
    });
    scanbtsubscription = cncbt4model.flutterBlue.scanForDevices(
      withServices: [],
    ).listen((device) {
      if (selebttype(device)) {
        final knownDeviceIndex = btlist.indexWhere((d) => d.id == device.id);
        if (knownDeviceIndex >= 0) {
          btlist[knownDeviceIndex] = device;
        } else {
          btlist.add(device);
          setState(() {});
        }
      } else {
        if (device.name != "") {}
      }
    }, onError: (e) {
      print("出错了?$e");
    });
  }

  bool selebttype(DiscoveredDevice driver) {
    appData.machineType = 3;
    String btnamemd5 = "MAGIC TANK" + driver.id.toString();
    Uint8List content = const Utf8Encoder().convert(btnamemd5);
    Digest digest = md5.convert(content);
    btnamemd5 = base64.encode(digest.bytes);
    // print("$btnamemd5,${result.device.name}");
    if (driver.name.length > 15 || (driver.name.contains("MT-"))) {
      return true;
    } else {
      if (appData.limit == 10) {
        if (driver.name.contains("MAGICTK")) {
          //  print(device.name);
          return true;
        } else {
          return false;
        }
      }
      return false;
    }
  }

  Widget bltitle(context, index) {
    return Card(
      child: TextButton(
        onPressed: () async {
          if (cncbt4model.connetcedBtDriver != null) {
            cncbt4model.disconnect();
            await Future.delayed(Duration(seconds: 2));
          }
          pd.show(max: 100, msg: "连接中..");
          cncbt4model.connection(btlist[index]);
          // try {
          //   int have = appData.isactivation
          //       .indexWhere((d) => d == btlist[index].name);
          //   if (have > 0) {
          //     print("扫描存在");
          //     cncbt4model.connection(btlist[index]);
          //   } else {
          //     print("扫描不存在");
          //     var res = await Api.isactivation(
          //         btlist[index].name.substring(3, 11));
          //     if (res["state"]) {
          //       cncbt4model.connection(btlist[index]);
          //     } else {
          //       pd.close();
          //       Fluttertoast.showToast(msg: "请连接网路");
          //     }
          //   }
          // } catch (e) {}
        },
        child: SizedBox(
          height: 50.h,
          child: Row(
            children: [
              const Icon(Icons.computer),
              const Expanded(child: SizedBox()),
              Text(btlist[index].name),
              const Expanded(child: SizedBox()),
              Text(S.of(context).connect),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userAppBar(context),
      body: Column(
        children: [
          const Divider(),
          SizedBox(
            height: 20.h,
            child: Stack(
              children: [
                Align(
                  child: Text(S.of(context).btswicth),
                  alignment: Alignment.centerLeft,
                ),
                Align(
                  child: Switch(
                    onChanged: (bool value) {
                      setState(() {});

                      debugPrint("$value");
                    },
                    value: cncbtmodel.blSwitch,
                  ),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 20.h,
            child: Stack(
              children: [
                Align(
                  child: Text(S.of(context).autoconnectbt),
                  alignment: Alignment.centerLeft,
                ),
                Align(
                  child: Switch(
                    onChanged: (bool value) {
                      debugPrint("$value");
                      appData.autoconnect = value;
                      appData.upgradeAppData({"autoconnect": value});
                      setState(() {});
                    },
                    value: appData.autoconnect,
                  ),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              Text(S.of(context).canuse),
              SizedBox(
                width: 10.r,
              ),
              scanstates
                  ? SizedBox(
                      width: 10.r,
                      height: 10.r,
                      child: const CircularProgressIndicator(strokeWidth: 2.0),
                    )
                  : SizedBox(),
            ],
          ),
          cncbt4model.connetcedBtDriver != null
              ? TextButton(
                  onPressed: () {
                    cncbt4model.disconnect();
                    setState(() {});
                  },
                  child: SizedBox(
                    height: 50.h,
                    child: Row(
                      children: [
                        const Icon(Icons.computer),
                        const Expanded(child: SizedBox()),
                        Text(cncbt4model.connetcedBtDriver!["name"]),
                        const Expanded(child: SizedBox()),
                        Text(S.of(context).disconnect),
                      ],
                    ),
                  ),
                )
              : Container(),
          Expanded(
              child: ListView.builder(
                  itemCount: btlist.length,
                  itemBuilder: ((context, index) {
                    return bltitle(context, index);
                  }))),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  // backgroundColor:
                  //     MaterialStateProperty.all(const Color(0xff50c5c4)),
                ),
                onPressed: () {
                  btscanning();
                  setState(() {});
                },
                child: Column(
                  children: [
                    const Icon(Icons.search),
                    Text(S.of(context).searchbtagain)
                  ],
                )),
          )
        ],
      ),
    );
  }
}
