/*
使用方法
配置好环境： 
Android/iOS 权限设置完毕
导入库 flutter_blue 
1.初始化
initBle();
2.开始搜索蓝牙设备
startBle();
3.得到搜索到所有蓝牙设备名字数组(含名称过滤/空名、错误名)
getBleScanNameAry
4.从名字数组里面选择对应的蓝牙设备进行连接，传入需要连接的设备名在数组的位置
(其实是假连接，停止扫描，准备好需要连接的蓝牙设备参数)
connectionBle(int chooseBle)
5.正式连接蓝牙，并且开始检索特征描述符，并匹配需要用到的特征描述符等
discoverServicesBle()
6.断开蓝牙连接
endBle()
*写入数据  例子：dataCallsendBle([0x00, 0x00, 0x00, 0x00])
dataCallsendBle(List<int> value)
*收到数据
dataCallbackBle()  
更多帮助博客：https://www.jianshu.com/p/bab40d5ecdee
*/

//import 'package:archive/archive.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'dart:async';

import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/cncpage/bluecmd/cmd.dart';

import 'package:magictank/magicclone/chipclass/progresschip.dart';
import 'package:magictank/magicsmart/bluetooth/receive.dart';

// import 'package:magicclone/magicclone/chipclass/progresschip.dart';
// import 'package:provider/provider.dart';
// import '/convers/convers.dart';

MsBlutoothServer msbtmodel = MsBlutoothServer();

class MsBlutoothServer {
  bool state = false;
  bool blSwitch = false;
  String btaddr = "";
  FlutterBlue flutterBlue = FlutterBlue.instance;
  late BluetoothDevice device;
  BluetoothCharacteristic? sendmCharacteristic;
  BluetoothCharacteristic? receivemCharacteristic;
  BluetoothCharacteristic? oSendmCharacteristic;
  BluetoothCharacteristic? oReceivemCharacteristic;
}

class AllBluSatae with ChangeNotifier, DiagnosticableTreeMixin {
  bool _switchstate = false;
  bool connectstate = false;
  bool get switchState => _switchstate;
  void setSwitchSatae(bool state) {
    // debugPrint(state);
    _switchstate = state;
    notifyListeners();
  }

  void setConnectSatae(bool state) {
    // debugPrint(state);
    connectstate = state;
    notifyListeners();
  }
}

//蓝牙数据模型
//BleDataModel btmodel = BleDataModel();
StreamSubscription? _streamSubscriptionData;

void msinitBle() {
  msbtmodel.flutterBlue = FlutterBlue.instance;
  msbtmodel.state = false; //未连接
  msbtmodel.sendmCharacteristic = null;
  msbtmodel.receivemCharacteristic = null;
}

void msconnectionBle(BluetoothDevice connectDevice) async {
  msbtmodel.flutterBlue.stopScan();
  try {
    msdisconnect();
  } catch (e) {
    debugPrint("$e");
  }
  debugPrint("准备连接");
  msinitBle();
  msbtmodel.device = connectDevice;

  discoverServicesBle();
}

void discoverServicesBle() {
  bool uuidswitch = true;
  try {
    if (_streamSubscriptionData != null) {
      _streamSubscriptionData!.cancel();
    }
  } catch (e) {
    debugPrint("取消失败");
  }
  runZonedGuarded(() async {
    await msbtmodel.device
        .connect(autoConnect: false, timeout: const Duration(seconds: 10));

    //timer!.cancel();
    //等待设置mtu
    if (!Platform.isIOS) {
      //ios不需要协商MTU
      await msbtmodel.device.requestMtu(512);
      await Future.delayed(const Duration(seconds: 1));
    }

    debugPrint("连接成功");

    List<BluetoothService> services = await msbtmodel.device.discoverServices();
    if (uuidswitch) {
      uuidswitch = false;

      debugPrint("执行 UUID");
      switch (appData.machineType) {
        case 1:
        case 2:
          for (var service in services) {
            if (service.uuid.toString() ==
                    "0000fff0-0000-1000-8000-00805f9b34fb"
                //"49535343-fe7d-4ae5-8fa9-9fafd205e455"
                ) {
              List<BluetoothCharacteristic> characteristics =
                  service.characteristics;
              for (var characteristic in characteristics) {
                if (characteristic.uuid.toString() ==
                        "0000fff4-0000-1000-8000-00805f9b34fb"
                    //"49535343-1e4d-4bd9-ba61-23c647249616"
                    ) {
                  debugPrint("匹配到正确的接收特征值");
                  // if (msbtmodel.receivemCharacteristic != null) {
                  msbtmodel.receivemCharacteristic = null;
                  // } else {
                  msbtmodel.receivemCharacteristic = characteristic;
                  // const timeout = const Duration(seconds: 3);
                  // Timer(timeout, () {
                  //   dataCallbackBle();
                  // });
                }
                if (characteristic.uuid.toString() ==
                        "0000fff6-0000-1000-8000-00805f9b34fb"
                    //"49535343-8841-43f4-a8d4-ecbe34729bb3"
                    ) {
                  debugPrint("匹配到正确的发送特征值");
                  // if (msbtmodel.sendmCharacteristic != null) {
                  //   debugPrint("存在发送特征值");
                  msbtmodel.sendmCharacteristic = null;
                  // } else {
                  msbtmodel.sendmCharacteristic = characteristic;
                  // }
                }
              }
            }
          }
          break;

        case 0:
        case 3:
          for (var service in services) {
            if (service.uuid.toString() ==
                    "0000ffe0-0000-1000-8000-00805f9b34fb"
                //"49535343-fe7d-4ae5-8fa9-9fafd205e455"
                ) {
              debugPrint("执行 UUID2");
              List<BluetoothCharacteristic> characteristics =
                  service.characteristics;
              for (var characteristic in characteristics) {
                if (characteristic.uuid.toString() ==
                        "0000ffe1-0000-1000-8000-00805f9b34fb"
                    //"49535343-1e4d-4bd9-ba61-23c647249616"
                    ) {
                  debugPrint("匹配到正确的接收特征值");
                  // if (msbtmodel.receivemCharacteristic != null) {
                  msbtmodel.receivemCharacteristic = null;
                  // } else {
                  msbtmodel.receivemCharacteristic = characteristic;
                  // const timeout = const Duration(seconds: 3);
                  // Timer(timeout, () {
                  //   dataCallbackBle();
                  // });
                }
                if (characteristic.uuid.toString() ==
                        "0000ffe1-0000-1000-8000-00805f9b34fb"
                    //"49535343-8841-43f4-a8d4-ecbe34729bb3"
                    ) {
                  debugPrint("匹配到正确的发送特征值");
                  // if (msbtmodel.sendmCharacteristic != null) {
                  //   debugPrint("存在发送特征值");
                  msbtmodel.sendmCharacteristic = null;
                  // } else {
                  msbtmodel.sendmCharacteristic = characteristic;
                  // }
                }
              }
            }
          }
          break;
        default:
      }
    }
    if (!msbtmodel.receivemCharacteristic!.isNotifying) {
      debugPrint("准备接收数据");
      await msbtmodel.receivemCharacteristic!.setNotifyValue(true);
      _streamSubscriptionData =
          msbtmodel.receivemCharacteristic!.value.listen((value) {
        debugPrint("收到数据");
        debugPrint("$value");
        if (value.isNotEmpty) {
          processingSmartData(value);
        }
      });
    }
    msbtmodel.oReceivemCharacteristic = msbtmodel.receivemCharacteristic;
    msbtmodel.oSendmCharacteristic = msbtmodel.sendmCharacteristic;

    // switch (msbtmodel.device.name) {
    //   case "magic-cloud":
    //     appData.machineType = 0;
    //     break;
    //   case "magic-smart":
    //     appData.machineType = 1;
    //     break;
    // }
    msbtmodel.state = true;

    switch (appData.machineType) {
      case 1:
      case 2:
        progressChip.getver();
        break;
      case 3:
        getver();
        break;
      default:
    }

    // progressChip.getver();
  }, (Object error, StackTrace stack) async {
    debugPrint("蓝牙出错了");
    debugPrint("$error");
    msdisconnect();
    eventBus.fire(MCConnectEvent(false));
  });
}

Future<void> mssendMessage(List<int> value) async {
  debugPrint("发送数据");
  await msbtmodel.sendmCharacteristic!.write(value);
}

// Future<void> dataCallbackBle() async {
//   await msbtmodel.receivemCharacteristic!.setNotifyValue(true);
//   msbtmodel.receivemCharacteristic!.value.listen((value) {
//     debugPrint("收到数据");
//     debugPrint("$value");
//     if (value.isNotEmpty) {

//       processingData(value);
//     }
//   });

// debugPrint("我是蓝牙返回数据2 - " + receivedata.toString());
// debugPrint(receivedata.length);
// dataCallsendBle(receivedata);
//}

bool getMsBtState() {
  return msbtmodel.state;
}

void msdisconnect() async {
  msbtmodel.state = false;
  try {
    await msbtmodel.device.disconnect();
  } catch (e) {
    debugPrint("$e");
  }
  // eventBus.fire(BTStateEvent(false));
}

/*!
  @brief 自动连接
*/
Future<void> msautoConnectBT() async {
  msinitBle();
  late StreamSubscription _streamSubscriptionDrive;
  //如果蓝牙已打
  await msbtmodel.flutterBlue.stopScan();
  await msbtmodel.flutterBlue.startScan(timeout: const Duration(seconds: 4));
  // 监听扫描结果
  Timer? timer;
  Duration timeout = const Duration(seconds: 10);
  timer = Timer(timeout, () {
    if (!getMsBtState()) {
      // print("超时?");
      _streamSubscriptionDrive.cancel();
      msdisconnect();

      eventBus.fire(MCConnectEvent(false));
    }
  });
  _streamSubscriptionDrive =
      msbtmodel.flutterBlue.scanResults.listen((results) {
    // 扫描结果 可扫描到的所有蓝牙设备
    for (ScanResult r in results) {
      debugPrint(r.device.id.toString());

      if (r.device.id.toString().toUpperCase() ==
          appData.mcbluetoothname.toUpperCase()) {
        msbtmodel.flutterBlue.stopScan();
        _streamSubscriptionDrive.cancel();
        timer!.cancel();
        //  print("取消超时");
        msconnectionBle(r.device);
      }
    }
  });
}
