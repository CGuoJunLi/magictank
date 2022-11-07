import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';
import 'package:magictank/magicclone/chipclass/progresschip.dart';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert' as convert;

import '../alleventbus.dart';

SocketManage socketManage = SocketManage();
MqttManage mqttManage = MqttManage();

class SocketManage {
  late Socket _socket;
  late StreamSubscription socketlisten;
  String iP = "110.40.254.90";
  // 建立连接
  Future<void> connectSocket() async {
    //debugPrint("ip:$iP");
    _socket = await Socket.connect(
      iP, // "1.116.53.218",
      8190,
      // "192.168.0.116",
      // 8080,
      timeout: const Duration(seconds: 20),
    ).catchError((e) {
      debugPrint("Unable to connect: $e"); //连接超时后不再连接
      // connectSocket(); // 连接超时，重新建立连接
    });
    socketlisten = _socket.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: false); //   _socket订阅流
  }

  // 收到消息回调
  // checkdata(event) == event[event.length - 1]
  void onData(event) {
    debugPrint("收到服务器数据");
    debugPrint("$event");
    if (event[0] == 0XE5 && event[1] == 0XE5) {
      //校验成功
      // debugPrint("network 校验成功");
      progressChip.progressNetChipData(event);
    } else {
      // debugPrint(event);
    }
    //debugPrint(event); 收到数据
    //String str = utf8.decode(event);
    // debugPrint("---onData---$str");
  }

  // 收到错误回调
  void onError(err) {
    debugPrint("---onError---");
  }

  // 断开回调
  void onDone() {
    // Future.delayed(Duration(milliseconds: 2000), () {
    //   connectSocket(); // 重新建立连接
    // });
    debugPrint("---onDone---");
  }

  // 发数据
  void writeData(List<int> data) {
    _socket.add(data);
  }

  //
  void writeString(String data) {
    _socket.write(data);
  }

  // 关闭流通道
  void socketClose() async {
    try {
      await socketlisten.cancel();
      await _socket.flush();
      await _socket.close();
      debugPrint("关闭流");
    } catch (e) {
      debugPrint("关闭失败");
    }
  }
}

class MqttManage {
  String certClientCrt = '''-----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----
  ''';
  final client = MqttServerClient('110.40.254.90', '');
  var pongCount = 0; // Pong counter
  String topic = 'test'; // 订阅的主题 Crack/蓝牙地址/service
  String pubTopic = '123'; //发送的主题 手机发送的Topic: ＂Crack/蓝牙地址/Client＂
  String acount = "admin";
  String password = "public";
  String clientID = ""; //客户端的ID生成方式: //蓝牙地址
  bool connect = false;

  Future<void> serverConnect() async {
    //换蓝牙
    clientID =
        mcbtmodel.connetcedBtDriver!["id"].toString().replaceAll(":", "");
    print(clientID);
    // clientID = "fba0decc53f0";
    topic = "Crack/$clientID/service";
    pubTopic = "Crack/$clientID/Client";
    debugPrint(clientID);
    debugPrint(topic);
    debugPrint(pubTopic);

    client.logging(on: true); //是否需要登录

    //var certPath = "image/cert/cert.pem";

    /// 开启安全设置
    client.secure = true;
    //client.onBadCertificate = (_) => true;
    client.onBadCertificate = (dynamic a) => true;

    /// 创建SecurityContext
    final mqttContext = SecurityContext.defaultContext;

    /// 加载SSL证书
    // var byteData = await rootBundle.load(certPath);
    // print("byteData:${byteData.buffer.asUint8List()}");

    /// 将证书的buffer数据添加到context中
    // mqttContext.setClientAuthoritiesBytes();
    // client.onBadCertificate = ((certificate) {
    //   return true;
    // });

    //  mqttContext.setTrustedCertificatesBytes(byteData.buffer.asUint8List());
    client.secure = true;
    final SecurityContext context = SecurityContext.defaultContext;

    try {
      context.setTrustedCertificatesBytes(utf8.encode(certClientCrt));
      // context.useCertificateChainBytes(utf8.encode(cert_client_crt));
      // context.usePrivateKeyBytes(utf8.encode(cert_client_key));

    } on Exception catch (e) {
      //出现异常 证书配置错误
      debugPrint("证书配置错误 : " + e.toString());
    }

    client.securityContext = context;
    // mqttContext.setTrustedCertificates(certPath);

    /// client指定context.
    client.securityContext = mqttContext;

    client.setProtocolV311(); //版本
    client.keepAlivePeriod = 60; //心跳维持
    client.onDisconnected = onDisconnected; //断开回调
    client.onConnected = onConnected; //连接回调
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientID)
        // .withWillTopic(
        //     'willtopic') // If you set this you must set a will message
        // .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    debugPrint('客户端连接....');
    client.connectionMessage = connMess;
    //准备连接
    try {
      await client.connect(acount, password);
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      debugPrint('连接异常1  client exception - $e');
      connect = false;
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      connect = false;
      debugPrint('连接异常 2 socket exception - $e');
      client.disconnect();
    }

    ///检查是否连接
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atMostOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        debugPrint('收到:${c[0].topic}订阅的数据 $pt -->');
        progressChip.progressNetChipData(json.decode(pt));
      });
      debugPrint("客户连接装连接成功");
      connect = true;
      eventBus.fire(ChipReadEvent(true));
    } else {
      /// Use status here rather than state if you also want the broker return code.
      debugPrint("连接失败");
      connect = false;
      eventBus.fire(ChipReadEvent(false));
      client.disconnect();
      //exit(-1);
    }
  }

  void serverSendData(Map data) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(convert.jsonEncode(data));

    /// Subscribe to it
    // debugPrint('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
    client.subscribe(pubTopic, MqttQos.exactlyOnce);

    /// Publish it
    //debugPrint('EXAMPLE::Publishing our topic');
    client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void serverDisconent() async {
    try {
      client.unsubscribe(topic); //取消订阅 并断开连接
      await MqttUtilities.asyncSleep(2);
      client.disconnect();
    } catch (e) {
      debugPrint("断开连接失败:$e");
    }
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    debugPrint('主题的订阅已确认 $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print("断开");
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      debugPrint('正确退出');
    } else {
      debugPrint('错误退出');
      // exit(-1);
    }
    if (pongCount == 3) {
      debugPrint('pongCount 正确');
    } else {
      debugPrint('pongCount 错误 $pongCount');
    }
  }

  /// The successful connect callback
  void onConnected() {
    debugPrint('连接成功');
  }

  /// Pong callback
  void pong() {
    pongCount++;
  }
}
