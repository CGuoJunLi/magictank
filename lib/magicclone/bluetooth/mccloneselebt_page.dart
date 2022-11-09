import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'dart:async';
//import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'mcclonebt_mananger.dart';

//import 'enable_bluetooth.dart';

class SeleMCPage extends StatefulWidget {
  const SeleMCPage({Key? key}) : super(key: key);
  @override
  _SeleMCPageState createState() => _SeleMCPageState();
}

class _SeleMCPageState extends State<SeleMCPage> {
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
    //  mcbtmodel.init();
    pd = ProgressDialog(context: context);
//  _streamSubscriptionState =
    btStateEvent = eventBus.on<MCConnectEvent>().listen(
      (MCConnectEvent event) {
        setState(() {
          if (event.state) {
            pd.close();
            debugPrint("返回");
            debugPrint("蓝牙ID");
            appData.upgradeAppData(
                {"mcbluetoothname": mcbtmodel.connetcedBtDriver!["id"]});
            btStateEvent.cancel();
            mcbtmodel.state = true;
            Navigator.pop(context);
          } else {
            if (pd.isOpen()) {
              pd.close();
            }
          }
        });
      },
    );

    if (mcbtmodel.blSwitch) {
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
    scanbtsubscription = mcbtmodel.flutterBlue.scanForDevices(
      withServices: [],
    ).listen((device) {
      print(device.name.contains("MC-"));
      if ((device.name == "magic-cloud") || device.name.contains("MC-")) {
        final knownDeviceIndex = btlist.indexWhere((d) => d.id == device.id);
        if (knownDeviceIndex >= 0) {
          btlist[knownDeviceIndex] = device;
        } else {
          print("添加");
          btlist.add(device);
          setState(() {});
        }
      }
    }, onError: (e) {
      scanbtsubscription?.cancel();
      print("出错了?$e");
      scanstates = false;
    }, onDone: () {
      scanstates = false;
    });
  }

  bool selebttype(DiscoveredDevice driver) {
    if (driver.name == "magic-cloud") {
      return true;
    }
    return false;
  }

  Widget bltitle(context, index) {
    return
        //result.device.name.length == 16
        Card(
      child: TextButton(
        onPressed: () async {
          if (mcbtmodel.connetcedBtDriver != null) {
            mcbtmodel.disconnect();
            await Future.delayed(Duration(seconds: 2));
          }
          pd.show(max: 100, msg: "连接中..");
          mcbtmodel.connection(btlist[index]);
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
                const Align(
                  child: Text("蓝牙开关"),
                  alignment: Alignment.centerLeft,
                ),
                Align(
                  child: Switch(
                    onChanged: (bool value) {
                      setState(() {});
                      debugPrint("$value");
                    },
                    value: mcbtmodel.blSwitch,
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
                const Align(
                  child: Text("自动连接"),
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
              Text("搜索到的设备"),
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
          mcbtmodel.connetcedBtDriver != null
              ? TextButton(
                  onPressed: () {
                    mcbtmodel.disconnect();
                    setState(() {});
                  },
                  child: SizedBox(
                    height: 50.h,
                    child: Row(
                      children: [
                        const Icon(Icons.computer),
                        const Expanded(child: SizedBox()),
                        Text(mcbtmodel.connetcedBtDriver!["name"]),
                        const Expanded(child: SizedBox()),
                        Text("断开连接"),
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
                  children: [Icon(Icons.search), Text("重新搜索")],
                )),
          )
        ],
      ),
    );
  }
}
