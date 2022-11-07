import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'dart:async';
//import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'msclonebt_mananger.dart';

//import 'enable_bluetooth.dart';

class SeleMSPage extends StatefulWidget {
  const SeleMSPage({Key? key}) : super(key: key);
  @override
  _SeleBL4PageState createState() => _SeleBL4PageState();
}

class _SeleBL4PageState extends State<SeleMSPage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<Map> allBleNameAry = [];
  bool scanstates = false;
  late ProgressDialog pd;
  Timer? timer;
  //bool btstate = false;
  late StreamSubscription btStateEvent;

  @override
  void dispose() {
    super.dispose();
    btStateEvent.cancel();
  }

  @override
  void initState() {
    //listenbtstate();
    pd = ProgressDialog(context: context);
//  _streamSubscriptionState =
    btStateEvent = eventBus.on<MSConnectEvent>().listen(
      (MSConnectEvent event) {
        setState(() {
          if (event.state) {
            pd.close();
            debugPrint("返回");
            debugPrint("蓝牙ID");
            debugPrint(msbtmodel.device.id.toString());

            appData.upgradeAppData(
                {"smartbluetoothname": msbtmodel.device.id.toString()});

            btStateEvent.cancel();
            msbtmodel.state = true;
            Navigator.pop(context);
          } else {
            msdisconnect();
            pd.close();
            Fluttertoast.showToast(msg: "设备连接失败,请稍后再试");
          }
        });
      },
    );

    if (msbtmodel.blSwitch) {
      debugPrint("开始扫描蓝牙");
      beginscanbt();
    }
    //beginscanbt(); //监听蓝牙扫描状态
    //ConnectBL(); //获取连接到的蓝牙列表
    super.initState();
  }

  Future<void> btscanning() async {
    flutterBlue.isScanning.listen((state) {
      scanstates = state;
    });
    debugPrint("蓝牙状态" + scanstates.toString());
    // return states;
  }

  Future<void> beginscanbt() async {
    btscanning();
    if (scanstates == false) {
      flutterBlue.startScan(timeout: const Duration(seconds: 4));
      // // 监听扫描结果
      List temp;
      List<Map> temp2 = [];
      temp = await flutterBlue.connectedDevices;
      for (var i = 0; i < temp.length; i++) {
        temp2.add({
          "name":
              temp[i].name.length > 0 ? temp[i].name : temp[i].id.toString(),
          "drive": temp[i],
          "state": "断开连接"
        });
      }
      setState(() {
        allBleNameAry = List.from(temp2);
      });
    }
  }

  bool selebttype(ScanResult result) {
    appData.machineType = 1;
    if (result.device.name == "magic-xxx") {
      return true;
    } else {
      return false;
    }
  }

  Widget bltitle(ScanResult result) {
    return selebttype(result)
        //result.device.name.length == 16
        ? Card(
            child: StreamBuilder<BluetoothDeviceState>(
              stream: result.device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) {
                VoidCallback? onPressed;
                String text;
                switch (snapshot.data) {
                  case BluetoothDeviceState.connected:
                    onPressed = () {
                      result.device.disconnect();
                      // disconnect();
                    };
                    text = '断开连接';
                    break;
                  case BluetoothDeviceState.disconnected:
                    onPressed = () {
                      pd.show(max: 100, msg: "连接中");
                      msconnectionBle(result.device);
                      // result.device.
                      // result.device.connect(timeout: Duration(S))
                    };
                    text = '连接';
                    break;
                  default:
                    onPressed = null;
                    text = snapshot.data.toString().substring(21).toUpperCase();
                    break;
                }
                return TextButton(
                  onPressed: onPressed,
                  child: SizedBox(
                    height: 50.h,
                    child: Row(
                      children: [
                        const Icon(Icons.computer),
                        const Expanded(child: SizedBox()),
                        Column(
                          children: [
                            Text(result.device.name.isNotEmpty
                                ? result.device.name
                                : result.device.id.toString()),
                            Text(result.device.id.toString()),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        Text(text),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Container();
  }

  List<Widget> bllist(List<ScanResult> snapshot) {
    List<Widget> temp = [];

    //snapshot[i].device.name == "magiclcone" ||
    for (var i = 0; i < snapshot.length; i++) {
      if (snapshot[i].device.name.length > 1) {
        temp.add(Card(
          child: TextButton(
            child: Stack(
              children: [
                Align(
                  child: Text(snapshot[i].device.name),
                  alignment: Alignment.centerLeft,
                ),
                const Align(
                  child: Text("连接设备"),
                  //child: Text("连接"),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                msconnectionBle(snapshot[i].device);
              });
            },
          ),
        ));
      }
    }

    return temp;
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
          Expanded(
            child: msbtmodel.blSwitch
                ? RefreshIndicator(
                    onRefresh: () {
                      debugPrint("下拉刷新");
                      allBleNameAry.clear();
                      return beginscanbt();
                    },
                    child: StreamBuilder<List<ScanResult>>(
                      stream: FlutterBlue.instance.scanResults,
                      initialData: const [],
                      builder: (c, snapshot) => ListView(
                        children: snapshot.data!
                            .map(
                              (r) => bltitle(
                                r,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                : const Text("请先打开蓝牙"),
          ),
          const Text(
            "下滑即可刷新列表",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
