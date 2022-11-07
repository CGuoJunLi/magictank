import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';

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

  @override
  void dispose() {
    mcbtmodel.flutterBlue.stopScan();
    btStateEvent.cancel();
    timer?.cancel();
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
            debugPrint(mcbtmodel.device!.id.toString());

            //   print(mcbtmodel.device.id);
            appData.upgradeAppData(
                {"mcbluetoothname": mcbtmodel.device!.id.toString()});
            btStateEvent.cancel();
            mcbtmodel.state = true;
            Navigator.pop(context);
          } else {
            mcbtmodel.disconnect();
            pd.close();

            /// Fluttertoast.showToast(msg: "设备连接失败,请稍后再试");
          }
        });
      },
    );

    if (mcbtmodel.blSwitch) {
      debugPrint("开始扫描蓝牙");
      btscanning();
    }
    //beginscanbt(); //监听蓝牙扫描状态
    //ConnectBL(); //获取连接到的蓝牙列表
    super.initState();
  }

  Future<void> btscanning() async {
    // btscanning();
    await mcbtmodel.flutterBlue.stopScan();
    scanstates = true;
    timer?.cancel();
    timer = Timer(const Duration(seconds: 10), () {
      timer?.cancel();
      scanstates = false;
      setState(() {});
    });
    mcbtmodel.flutterBlue.startScan(timeout: const Duration(seconds: 10));
    setState(() {});
  }

  bool selebttype(BluetoothDevice device) {
    appData.machineType = 2;
    if (device.name == "magic-cloud" || device.name.contains("MC-")) {
      return true;
    } else {
      return false;
    }
  }

  Widget bltitle(BluetoothDevice device) {
    return selebttype(device)
        //result.device.name.length == 16
        ? Card(
            child: StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) {
                VoidCallback? onPressed;
                String text;
                switch (snapshot.data) {
                  case BluetoothDeviceState.connected:
                    onPressed = () {
                      device.disconnect();
                      // disconnect();
                    };
                    text = '断开连接';
                    break;
                  case BluetoothDeviceState.disconnected:
                    onPressed = () {
                      pd.show(max: 100, msg: "连接中");

                      mcbtmodel.connection(device);
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
                        Text(device.name),
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
                mcbtmodel.connection(snapshot[i].device);
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
          const Divider(),
          mcbtmodel.connect > 0 ? bltitle(mcbtmodel.device!) : Container(),
          Expanded(
            child: mcbtmodel.blSwitch
                ? RefreshIndicator(
                    onRefresh: () {
                      debugPrint("下拉刷新");
                      return btscanning();
                    },
                    child: StreamBuilder<List<ScanResult>>(
                      stream: mcbtmodel.flutterBlue.scanResults,
                      initialData: const [],
                      builder: (c, snapshot) => ListView(
                        children: snapshot.data!
                            .map(
                              (r) => bltitle(
                                r.device,
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
