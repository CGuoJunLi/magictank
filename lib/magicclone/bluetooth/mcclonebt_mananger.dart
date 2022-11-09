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
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

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
  bool state = false;
  bool blSwitch = false;
  String btaddr = "";
  final FlutterReactiveBle flutterBlue = FlutterReactiveBle();
  QualifiedCharacteristic? sendmCharacteristic;
  QualifiedCharacteristic? receivemCharacteristic;
  StreamSubscription? _receiveSubscription;
  StreamSubscription? _connectSubscription;
  StreamSubscription? scanbtsubscription;
  Timer? autoconnecttimer;
  Duration autoconnecttimeout = const Duration(seconds: 10);
  Map? connetcedBtDriver;
  bool mtu = false;
  DiscoveredDevice? connectDevice;
  Timer? timer;
  bool autoconnetagain = false;
  // late Guid uuid;
  // late DeviceIdentifier deviceId;
  // late Guid serviceUuid;
  // late Guid? secondaryServiceUuid;
  // late CharacteristicProperties properties;
  // late List<BluetoothDescriptor> descriptors;
  init() {
    print("初始化mc蓝牙");
    flutterBlue.initialize();

    //flutterBlue = FlutterBlue.instance;
    // sendmCharacteristic = null;
    // receivemCharacteristic = null;
    // if (_streamSubscriptionData != null) {
    //   _streamSubscriptionData!.cancel();
    // }
  }

  void connection(DiscoveredDevice connectDevice) async {
    connectDevice = connectDevice;

    _connectSubscription?.cancel();
    print("开始连接");
    _connectSubscription = flutterBlue
        .connectToDevice(
            id: connectDevice.id, connectionTimeout: Duration(seconds: 10))
        .listen((event) async {
      if (event.connectionState == DeviceConnectionState.connecting) {
        print("连接中");
      }
      if (event.connectionState == DeviceConnectionState.disconnected) {
        print("设备已丢失,如果是自动连接准备再次连接");
        disconnect();
      }
      if (event.connectionState == DeviceConnectionState.connected) {
        print("btmang 连接成功");
        autoconnetagain = false;
        //  connetcedBtDriver = connectDevice;
        connetcedBtDriver = {
          "id": connectDevice.id,
          "name": connectDevice.name
        };
        int mtu =
            await flutterBlue.requestMtu(deviceId: connectDevice.id, mtu: 200);
        print(mtu);
        sendmCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("fff0"),
            characteristicId: Uuid.parse("fff6"),
            deviceId: connectDevice.id);
        receivemCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("fff0"),
            characteristicId: Uuid.parse("fff4"),
            deviceId: connectDevice.id);
        _receiveData();
        state = true;
        Fluttertoast.showToast(msg: "连接成功");
        eventBus.fire(MCConnectEvent(true));
        progressChip.getver();
      }
    }, onError: (e) {
      print("连接断开:$e");
      Fluttertoast.showToast(msg: "连接出错");
      disconnect();
    }
            // ,onDone: (() async {
            //   // disconnect();
            //   //可能是假连接
            //   print("连接完成?");
            //   if (!state) {
            //     connection(connectDevice);
            //   } else {
            //     disconnect();
            //   }
            // })
            );
  }

  void checkdeviceconnetc() {
    flutterBlue.connectedDeviceStream.listen((event) {});
  }

  _receiveData() {
    _receiveSubscription = flutterBlue
        .subscribeToCharacteristic(receivemCharacteristic!)
        .listen((data) {
      if (data.isNotEmpty) {
        progressChip.progressbtchipdata(data);
      }
    }, onError: (dynamic error) {
      print("err:$error");
      disconnect();
    });
  }

  Future<void> senddata(List<int> value) async {
    await flutterBlue.writeCharacteristicWithoutResponse(sendmCharacteristic!,
        value: value);
  }

  bool getMcBtState() {
    return state;
  }

  void disconnect() async {
    print("断开连接");

    connetcedBtDriver = null;
    state = false;
    _connectSubscription?.cancel();
    _receiveSubscription?.cancel();
    if (autoconnetagain) {
      autoConnect();
    } else {
      eventBus.fire(MCConnectEvent(false));
    }
  }

  ///自动连接
  Future<void> autoConnect() async {
    print("自动连接拷贝机:${appData.mcbluetoothname}");
    connetcedBtDriver = null;
    state = false;
    _connectSubscription?.cancel();
    _receiveSubscription?.cancel();
    //connetcedBtDriver = {"id": appData.mcbluetoothname, "name": "magic-cloud"};
    scanbtsubscription?.cancel();
    timer?.cancel();
    timer = Timer(const Duration(seconds: 20), () {
      print("超时");
      timer?.cancel();
      scanbtsubscription?.cancel();
      autoconnetagain = false;
      Fluttertoast.showToast(msg: "查找设备超时");
      disconnect();
    });
    scanbtsubscription = flutterBlue.scanForDevices(
      withServices: [],
    ).listen((device) {
      if (appData.mcbluetoothname == device.id) {
        scanbtsubscription?.cancel();
        timer?.cancel();
        autoconnetagain = true;
        connection(device);
      }
    }, onError: (e) {
      disconnect();
      scanbtsubscription?.cancel();
      Fluttertoast.showToast(msg: "查找设备出错");
      print("出错了?$e");
    });
  }
}
