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

import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/magicclone/chipclass/progresschip.dart';
import 'package:magictank/magicsmart/bluetooth/receive.dart';

// import 'package:magicclone/magicclone/chipclass/progresschip.dart';
// import 'package:provider/provider.dart';
// import '/convers/convers.dart';

McBlutoothServer mcbtmodel = McBlutoothServer();

class McBlutoothServer {
  ///连接状态
  bool state = false;

  ///第一次连接标志位
  bool firststate = false;

  ///蓝牙开关
  bool blSwitch = false;
  String btaddr = "";
  FlutterBlue flutterBlue = FlutterBlue.instance;

  ///已连接的设备
  BluetoothDevice? device;
  int connect = 0;
  BluetoothCharacteristic? sendmCharacteristic;
  BluetoothCharacteristic? receivemCharacteristic;
  StreamSubscription? _streamSubscriptionData;
  StreamSubscription? _streamSubscriptionState;
  StreamSubscription? _stateSubscription;
  StreamSubscription? _mtuSubscription;
  Timer? autoconnecttimer;
  Duration autoconnecttimeout = const Duration(seconds: 10);
  bool sendmCharacteristicstate = false;
  bool receivemCharacteristicstate = false;
  StreamSubscription? _servicesSubscription;
  StreamSubscription? _notifySubscription;
  Map<String, dynamic>? connetcedBtDriver;
  bool mtu = false;
  // late Guid uuid;
  // late DeviceIdentifier deviceId;
  // late Guid serviceUuid;
  // late Guid? secondaryServiceUuid;
  // late CharacteristicProperties properties;
  // late List<BluetoothDescriptor> descriptors;
  init() {
    // flutterBlue = FlutterBlue.instance;
    // sendmCharacteristic = null;
    // receivemCharacteristic = null;
    // if (_streamSubscriptionData != null) {
    //   _streamSubscriptionData!.cancel();
    // }
  }

  void connection(BluetoothDevice connectDevice) async {
    if (autoconnecttimer != null) {
      autoconnecttimer!.cancel();
    }
    flutterBlue.stopScan();
    // try {
    //   disconnect();
    // } catch (e) {
    //   debugPrint("$e");
    // }
    debugPrint("准备连接");
    device = connectDevice;
    try {
      if (_streamSubscriptionData != null) {
        _streamSubscriptionData!.cancel();
      }
    } catch (e) {
      debugPrint("取消失败");
    }
    runZonedGuarded(() async {
      // var connectedDevices;
      // connectedDevices = await flutterBlue.connectedDevices;
      // for (int i = 0; i < connectedDevices.length; i++) {
      //   connectedDevices[i].disconnect();
      // }
      await device!
          .connect(autoConnect: false, timeout: const Duration(seconds: 10));
      listenbtstate();

      //timer!.cancel();
      //等待设置mtu
      // if (!Platform.isIOS) {
      //   //ios不需要协商MTU
      //   await device.requestMtu(512);
      //   await Future.delayed(const Duration(seconds: 1));
      // }
      connetcedBtDriver = {"id": device!.id.toString()};
      print(connetcedBtDriver);
      debugPrint("连接成功");
      // device.discoverServices().then((value) {

      // }).onError((error, stackTrace) => null);
      debugPrint("执行 UUID1");

      List<BluetoothService> services = await device!.discoverServices();
      if (!firststate) {
        firststate = true;
        debugPrint("执行 UUID");

        for (var service in services) {
          if (service.uuid.toString() ==
              "0000fff0-0000-1000-8000-00805f9b34fb") {
            List<BluetoothCharacteristic> characteristics =
                service.characteristics;
            for (var characteristic in characteristics) {
              if (characteristic.uuid.toString() ==
                  "0000fff4-0000-1000-8000-00805f9b34fb") {
                debugPrint("匹配到正确的接收特征值");
                receivemCharacteristic = characteristic;
                receivemCharacteristicstate = true;
                if (sendmCharacteristicstate) {
                  break;
                }
              }
              if (characteristic.uuid.toString() ==
                      "0000fff6-0000-1000-8000-00805f9b34fb"
                  //"49535343-8841-43f4-a8d4-ecbe34729bb3"
                  ) {
                debugPrint("匹配到正确的发送特征值");
                sendmCharacteristic = characteristic;
                sendmCharacteristicstate = true;
                if (receivemCharacteristicstate) {
                  break;
                }
              }
            }
          }
        }
        receivemCharacteristicstate = false;
        sendmCharacteristicstate = false;
        debugPrint("准备接收数据");
        await receivemCharacteristic!.setNotifyValue(true);
        _streamSubscriptionData = receivemCharacteristic!.value.listen((value) {
          debugPrint("收到数据");
          debugPrint("$value");
          if (value.isNotEmpty) {
            processingSmartData(value);
          }
        });

        if (Platform.isAndroid) {
          //ios不需要协商MTU
          autoconnecttimer = Timer(autoconnecttimeout, () {
            eventBus.fire(MCConnectEvent(false));
            Fluttertoast.showToast(msg: "蓝牙配置失败");
            disconnect();
          });
          _mtuSubscription = device!.mtu.listen((mtu) {
            if (mtu > 120) {
              print(mtu);
              autoconnecttimer?.cancel();
              _mtuSubscription?.cancel();
              eventBus.fire(MCConnectEvent(true));
              progressChip.getver();
            }
          });
          device!.requestMtu(512);
        }
      }
      // progressChip.getver();
    }, (Object error, StackTrace stack) async {
      debugPrint("蓝牙出错了");
      debugPrint("$error");
      eventBus.fire(MCConnectEvent(false));
      disconnect();
    });
  }

  Future<void> senddata(List<int> value) async {
    debugPrint("发送数据");
    if (state) {
      await sendmCharacteristic!.write(value);
    }
  }

  bool getMcBtState() {
    return state;
  }

  void listenbtstate() {
    _streamSubscriptionState = device!.state.listen((event) {
      if (event == BluetoothDeviceState.disconnected ||
          event == BluetoothDeviceState.disconnecting) {
        connect = 0;
        state = false;
        firststate = false;
        _streamSubscriptionState!.cancel();
        eventBus.fire(MCConnectEvent(false));
      }
      if (event == BluetoothDeviceState.connected) {
        connect = 1;
      }
      if (event == BluetoothDeviceState.connecting) {
        connect = 2;
      }
    });
  }

  void disconnect() async {
    state = false;
    try {
      await device!.disconnect();
    } catch (e) {
      debugPrint("$e");
    }
    // eventBus.fire(BTStateEvent(false));
  }

  ///自动连接
  Future<void> autoConnect() async {
    //如果蓝牙已打

    bool connected = true;

    late StreamSubscription _streamSubscriptionDrive;

    flutterBlue.startScan(
      timeout: const Duration(seconds: 5),
    );
    // 监听扫描结果
    _streamSubscriptionDrive = flutterBlue.scanResults.listen((results) {
      // 扫描结果 可扫描到的所有蓝牙设备
      for (ScanResult r in results) {
        debugPrint(r.device.id.toString());
        debugPrint(appData.mcbluetoothname.toUpperCase());
        if (r.device.id.toString().toUpperCase() ==
                appData.mcbluetoothname.toUpperCase() &&
            connected) {
          connected = false;
          flutterBlue.stopScan();
          _streamSubscriptionDrive.cancel();
          connection(r.device);
        }
      }
    });
  }
}
