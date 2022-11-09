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
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/cncpage/bluecmd/cmd.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';

CncBlutooth4Server cncbt4model = CncBlutooth4Server();

class CncBlutooth4Server {
  bool blSwitch = false;
  String btaddr = "";
  final FlutterReactiveBle flutterBlue = FlutterReactiveBle();
  QualifiedCharacteristic? sendmCharacteristic;
  QualifiedCharacteristic? receivemCharacteristic;
  StreamSubscription? _receiveSubscription;
  StreamSubscription? scanbtsubscription;
  StreamSubscription? _connectSubscription;
  Timer? autoconnecttimer;
  Duration autoconnecttimeout = const Duration(seconds: 10);
  Map? connetcedBtDriver;
  bool mtu = false;
  bool autoconnetagain = false;
  Timer? timer;
  // late Guid uuid;
  // late DeviceIdentifier deviceId;
  // late Guid serviceUuid;
  // late Guid? secondaryServiceUuid;
  // late CharacteristicProperties properties;
  // late List<BluetoothDescriptor> descriptors;
  init() {
    //flutterBlue = FlutterBlue.instance;
    // sendmCharacteristic = null;
    // receivemCharacteristic = null;
    // if (_streamSubscriptionData != null) {
    //   _streamSubscriptionData!.cancel();
    // }
  }

  void connection(DiscoveredDevice connectDevice) async {
    print(connectDevice.name);
    print(connectDevice.id);
    _connectSubscription?.cancel();
    _connectSubscription = flutterBlue
        .connectToDevice(
            id: connectDevice.id, connectionTimeout: Duration(seconds: 10))
        .listen((event) async {
      if (event.connectionState == DeviceConnectionState.connecting) {
        print("连接中..");
      }
      if (event.connectionState == DeviceConnectionState.disconnected) {
        print("设备已丢失,准备再次连接");
        disconnect();
      }
      if (event.connectionState == DeviceConnectionState.connected) {
        print("连接成功");
        //  connetcedBtDriver = connectDevice;
        connetcedBtDriver = {
          "id": connectDevice.id,
          "name": connectDevice.name
        };
        int mtu =
            await flutterBlue.requestMtu(deviceId: connectDevice.id, mtu: 200);
        print(mtu);
        sendmCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("ffe0"),
            characteristicId: Uuid.parse("ffe1"),
            deviceId: connectDevice.id);
        receivemCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("ffe0"),
            characteristicId: Uuid.parse("ffe1"),
            deviceId: connectDevice.id);
        _receiveData();
        cncbtmodel.state = true;
        await Future.delayed(Duration(seconds: 2));
        getver();
        autoconnetagain = false;
        eventBus.fire(CNCConnectEvent(true));
      }
    }, onError: (e) {
      disconnect();
      print("连接失败");
      //});
    });
  }

  _receiveData() {
    _receiveSubscription = flutterBlue
        .subscribeToCharacteristic(receivemCharacteristic!)
        .listen((data) {
      if (data.isNotEmpty) {
        procesData(data);
      }
    }, onError: (dynamic error) {
      print("err:$error");
    });
  }

  Future<void> senddata(List<int> value) async {
    if (cncbtmodel.state) {
      await flutterBlue.writeCharacteristicWithoutResponse(sendmCharacteristic!,
          value: value);
    }
  }

  void disconnect() async {
    connetcedBtDriver = null;
    cncbtmodel.state = false;
    scanbtsubscription?.cancel();
    _connectSubscription?.cancel();
    _receiveSubscription?.cancel();
    if (autoconnetagain) {
      print("autoconnetagain");
      autoConnect();
    } else {
      eventBus.fire(CNCConnectEvent(false));
    }
  }

  ///自动连接
  Future<void> autoConnect() async {
    // connetcedBtDriver = {
    //   "id": json.decode(appData.cncbluetoothname)["id"],
    //   "name": json.decode(appData.cncbluetoothname)["name"],
    // };
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
    scanbtsubscription = cncbt4model.flutterBlue.scanForDevices(
      withServices: [],
    ).listen((device) {
      if (json.decode(appData.cncbluetoothname)["id"] == device.id) {
        scanbtsubscription?.cancel();
        timer?.cancel();
        autoconnetagain = true;
        connection(device);
      }
    }, onError: (e) {
      scanbtsubscription?.cancel();
      disconnect();
      Fluttertoast.showToast(msg: "查找设备出错");
      print("出错了?$e");
    });

    //   print(appData.cncbluetoothname);
    //   _connectSubscription = flutterBlue
    //       .connectToAdvertisingDevice(
    //     id: json.decode(appData.cncbluetoothname)["id"],
    //     withServices: [],
    //     prescanDuration: const Duration(seconds: 10),
    //     servicesWithCharacteristicsToDiscover: {
    //       Uuid.parse("0000ffe0-0000-1000-8000-00805f9b34fb"): [
    //         Uuid.parse("0000ffe1-0000-1000-8000-00805f9b34fb"),
    //         Uuid.parse("0000ffe1-0000-1000-8000-00805f9b34fb")
    //       ]
    //     },
    //     connectionTimeout: const Duration(seconds: 10),
    //   )
    //       .listen((event) async {
    //     if (event.connectionState == DeviceConnectionState.connecting) {
    //       print("连接中");
    //     }
    //     if (event.connectionState == DeviceConnectionState.connected) {
    //       print("连接成功");

    //       connetcedBtDriver = {
    //         "id": json.decode(appData.cncbluetoothname)["id"],
    //         "name": json.decode(appData.cncbluetoothname)["name"],
    //       };

    //       await flutterBlue.requestMtu(
    //           deviceId: connetcedBtDriver!["id"], mtu: 250);
    //       sendmCharacteristic = QualifiedCharacteristic(
    //           serviceId: Uuid.parse("0000ffe0-0000-1000-8000-00805f9b34fb"),
    //           characteristicId:
    //               Uuid.parse("0000ffe1-0000-1000-8000-00805f9b34fb"),
    //           deviceId: connetcedBtDriver!["id"]);
    //       receivemCharacteristic = QualifiedCharacteristic(
    //         serviceId: Uuid.parse("0000ffe0-0000-1000-8000-00805f9b34fb"),
    //         characteristicId: Uuid.parse("0000ffe1-0000-1000-8000-00805f9b34fb"),
    //         deviceId: connetcedBtDriver!["id"],
    //       );
    //       _receiveData();
    //       // await Future.delayed(Duration(seconds: 2));
    //       getver();
    //       eventBus.fire(CNCConnectEvent(true));
    //     }
    //     if (event.connectionState == DeviceConnectionState.disconnected) {
    //       print("连接断开");
    //       connetcedBtDriver = null;
    //       _connectSubscription?.cancel();
    //       _receiveSubscription?.cancel();
    //       eventBus.fire(CNCConnectEvent(false));
    //     }
    //   }, onError: (e) {
    //     print(e);
    //     connetcedBtDriver = null;
    //     _connectSubscription?.cancel();
    //     _receiveSubscription?.cancel();
    //     eventBus.fire(CNCConnectEvent(false));
    //     print("连接失败");
    //   });
  }
}
