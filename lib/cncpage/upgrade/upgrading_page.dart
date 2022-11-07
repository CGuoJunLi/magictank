import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';

import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';

import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';

import 'package:magictank/convers/convers.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../alleventbus.dart';
import 'dataprocess.dart';

class UpgradingPage extends StatefulWidget {
  final Map arguments;
  const UpgradingPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  _UpgradingPageState createState() => _UpgradingPageState();
}

class _UpgradingPageState extends State<UpgradingPage> {
  int progress = 0;

  late ProgressDialog pd;
  bool sendstate = false;
  bool firstFrame = true;
  int soh = 1; // Start Of Head
  int eot = 4; // End Of Transmission
  int ack = 6; // Positive ACknowledgement
  int stx = 2;

  int invertedPacketNumber = 255;
  int packetNumber = 0;
  int dataLen = 0;
  int allPackNum = 0;
  int currentPack = 0;
  List<int> fileData = [];
  late StreamSubscription updatEvent;
  late StreamSubscription updatLcdBinEvent;
  late StreamSubscription updatYmodel;
  @override
  void initState() {
    currentPack = 0;
    sendstate = false;
    firstFrame = true;
    fileData = List.from(widget.arguments["data"]);
    if (widget.arguments["model"] == 2) {
      sendfile3();
    } else {
      if (cncVersion.verPCB == 113 || cncVersion.verPCB == 112) {
        ////print(ymodel)
        ////print(fileData.length);

        sendfile2();
      } else {
        cncVersion.processstate = 1;
        sendfile();
      }
    }
    // eventBus = EventBus();
    pd = ProgressDialog(context: context);

    updatEvent = eventBus.on<UpdatEvent>().listen((event) {
      if (event.state == 1) {
        setState(() {
          updatEvent.cancel();
          cncVersion.version = widget.arguments["version"];
          getver();
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "升级成功");
        });
      } else {
        if (mounted) {
          updatEvent.cancel();
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "升级失败,请重启机器后再试!");
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // updatEvent.cancel();
    //updatLcdBinEvent.cancel();
    super.dispose();
  }

  Future<void> sendfile() async {
    // String ranbin64 = "hc1aHg+dyaU=";
    //String bin64 =
    //     "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";
    // Duration duration = const Duration(seconds: 5);
    bool sendstate = false;
    int packageSum = 0;
    //int LiveI = 0;
    DataProcessor dataProcessor = DataProcessor();
    List<int> data = []; //发送擦除命令
    //arguments["data"] = base64Decode(bin64);
    if (cncVersion.version > 0) {
      sendCmd([0x70]); //先跳转至IAP
      cncVersion.version = 0;
      await Future.delayed(const Duration(seconds: 5));
    }
    data.add(0x12);
    data.addAll(base64Decode(cncVersion.ranbase64));
    //data.addAll(base64Decode(ranbin64));
    //先发送 擦除命令
    //sendstate = true;
    sendstate = // true;
        await updatacmd(data, false);
    if (!sendstate) {
      //发送失败
      setState(() {
        Fluttertoast.showToast(msg: "升级失败");
        Navigator.pop(context); //
      });
    } else {
      await Future.delayed(const Duration(seconds: 10)); //等待5s后再查询状态
      data.clear();
      debugPrint("查询状态");
      data.add(0x10); //查询机器状态
      sendstate = //true;
          await updatacmd(data, true);
      // await Future.delayed(Duration(seconds: 3));
      if (sendstate) {
        //开始发送数据
        packageSum = widget.arguments["data"].length ~/ ((126 - 2) * 64 - 4);
        //计算包的个数
        debugPrint("包数量:$packageSum");
        if (packageSum * ((126 - 2) * 64 - 4) !=
            widget.arguments["data"].length) {
          packageSum++;
        }
        debugPrint("包数量2:$packageSum");

        //await Future.delayed(Duration(seconds: 2)); //等待两秒后发送数据
        int address = 0x00; //物理地址
        //处理数据 将数据进行分包 string. codeUnits
        for (var i = 0; i < packageSum; i++) {
          //LiveI = i;
          List<int> temp = [];
          //如果是最后一个包
          if (i == packageSum - 1) {
            int len =
                widget.arguments["data"].length - i * ((126 - 2) * 64 - 4);
            temp = List.filled(len + 4, 0);
            //  temp = arguments["data"].sublist(i * ((126 - 2) * 64 - 4));
            //  debugPrint("len:$len ${arguments["data"].length} $temp");
            List.copyRange(temp, 4, widget.arguments["data"],
                widget.arguments["data"].length - len);
            // System.arraycopy(upDate,
            //     i * ((DataProcessor.frameLen - 2) * 64 - 4), bytes, 4, len);
          } else {
            temp = List.filled(((dataProcessor.frameLen - 2) * 64), 0);
            List.copyRange(
                temp,
                4,
                widget.arguments["data"],
                i * ((dataProcessor.frameLen - 2) * 64 - 4),
                i * ((dataProcessor.frameLen - 2) * 64 - 4) +
                    ((dataProcessor.frameLen - 2) * 64 - 4));
            // temp = arguments["data"].sublist(i * ((126 - 2) * 64 - 4),
            //     i * ((126 - 2) * 64 - 4) + ((126 - 2) * 64 - 4));
          }
          debugPrint("address:$address");
          if (address <= 255) {
            temp[3] = address;
          } else {
            temp[2] = address >> 8;
            temp[3] = address & 0XFF;
            debugPrint("最后一帧");
          }
          address += ((126 - 2) * 64 - 4);
          temp[1] = 0x01;
          var sendpack = dataProcessor.writes(temp);
          for (var k = 0; k < sendpack.length; k++) {
            await Future.delayed(const Duration(milliseconds: 50));
            debugPrint(
                "当前包:$i/$packageSum,$k帧/${sendpack.length},总包:$packageSum ");

            await cncbt4model.senddata(sendpack[k]);

            setState(() {
              progress = (((64 * i * 120 + k * 120) /
                          widget.arguments["data"].length) *
                      100)
                  .toInt();
              ////print(progress);
            });
          }
          await Future.delayed(const Duration(milliseconds: 50));
          //debugPrint("address:$address");
          //debugPrint("发送升级包成功$i ${temp.length} $temp");
        }
        debugPrint("升级完成");
        //   cncVersion.version = widget.arguments["version"];
      } else {
        setState(() {
          Fluttertoast.showToast(msg: "升级失败");
          Navigator.pop(context); //
        });
      }
    }
  }

  Future<void> sendfiledata() async {}
  Future<void> sendfile2() async {
    // int proprassVal = 0;
    if (cncVersion.version > 10) {
      debugPrint("先跳转至IAP");
      await sendCmd([0x7A]); //先跳转至IAP
      cncVersion.version = 0;
      await Future.delayed(const Duration(seconds: 3));
    }

    // List<int> data = [0x19];

    cncVersion.state = 5;
    dataLen = widget.arguments["data"].length;
    debugPrint("数据长度:$dataLen");
    allPackNum = (widget.arguments["data"].length + 1023) ~/ 1024;
    debugPrint("包数:$allPackNum");
    currentPack = 0;
    firstFrame = true;
    debugPrint("firstFrame$firstFrame");
    debugPrint("currentPack$currentPack");
    debugPrint("sendstate$sendstate");
    debugPrint("进入升级模式");
    bool state = await sendCmd([0x19], answer: true);
    if (state) {
      await Future.delayed(const Duration(seconds: 3));
      print("发送升级命令");
      await ymodelSendCmd([0x05]);
      //await ymodelSendCmd([0x05]);
      // await Future.delayed(duration);
      updatYmodel =
          eventBus.on<YmodelEvent>().listen((YmodelEvent event) async {
        print("收到Ymodel");
        switch (event.rdata) {
          case 67: // 0x43 CRC16
            sendstate = true;
            //  setState(() {});
            if (currentPack < allPackNum + 1) {
              if (currentPack == 0) {
                await sendinitdatapack();
              } else {
                debugPrint("currentPack:$currentPack");
                await senddatapack();
              }
              ////print(currentPack);
              ////print(currentPack / allPackNum * 100);
              progress = (currentPack / allPackNum * 100).toInt();
              setState(() {});
            } else if (currentPack == allPackNum + 1) {
              ymodelSendCmd([eot]); //传输完成
              cncVersion.state = 0;
              updatYmodel.cancel();
              cncVersion.version = widget.arguments["version"];
              Fluttertoast.showToast(msg: "升级成功!");
              getver();
              Navigator.pop(context);
              debugPrint("传输完成");
            }
            break;
          case 68: //0x44  ACK
            break;
          case 69: //0x45 ERR
            cncVersion.state = 0;
            sendstate = false;
            updatYmodel.cancel();
            Fluttertoast.showToast(msg: "升级失败,请重启机器后再试!");
            Navigator.pop(context);
            break;
        }
      });
    }
  }

  Future<void> sendinitdatapack() async {
    List<int> sendData = [];
    List<int> packData = List.filled(1024, 0);
    log("发送第一帧");
    sendstate = false;
    firstFrame = false; //先发送第一帧
    sendData.add(stx);
    sendData.add(packetNumber);
    sendData.add(invertedPacketNumber);
    packData[0] = 48;
    packData[1] = 0;
    var temp = asciiStringToint(dataLen.toString());

    for (var i = 0; i < temp.length; i++) {
      packData[2 + i] = temp[i];
    }
    sendData.addAll(packData);
    ////print(intToFormatHex(getcrc16(packData), 4));
    sendData.addAll(intToFormatHex(getcrc16(packData), 4).reversed);
    ////print(sendData);

    await ymodelSendCmd(sendData);
    currentPack++;
  }

  Future<void> senddatapack() async {
    List<int> sendData = [];
    List<int> packData = [];

    sendstate = false;
    firstFrame = false; //先发送第一帧

    packetNumber++;
    if (packetNumber > 255) packetNumber -= 256;

    /* calculate invertedPacketNumber */
    invertedPacketNumber = 255 - packetNumber;
    sendData.add(stx);
    sendData.add(packetNumber);
    sendData.add(invertedPacketNumber);
    packData = fileData.sublist(0, 1024);
    sendData.addAll(packData);
    //  ////print(intToFormatHex(getcrc16(packData), 4));
    sendData.addAll(intToFormatHex(getcrc16(packData), 4).reversed);
    //  ////print(sendData);
    await ymodelSendCmd(sendData);

    fileData.removeRange(0, 1024);
    if (fileData.length < 1024 && fileData.isNotEmpty) {
      debugPrint("不足1024 :${fileData.length}");
      fileData.addAll(List.filled(1024 - fileData.length, 0));
      // for (var i = 0; i < 1024 - fileData.length; i++) {
      //   fileData.add(0);
      // }
      debugPrint("补充后的长度 :${fileData.length}");
    }

    currentPack++;
  }

  Future<void> sendfile3() async {
    int packageSum = 0;
    //int LiveI = 0;
    int beginstate = 0;
    packageSum = (widget.arguments["data"].length + 115) ~/ 116;

    List<int> data = []; //发送擦除命令
    int i = 0;
    updatLcdBinEvent = eventBus
        .on<LcdUpBinStateEvent>()
        .listen((LcdUpBinStateEvent event) async {
      switch (event.state) {
        case 0:
          if (beginstate < 1) {
            beginstate++;
          } else {
            if (beginstate == 1) {
              data = [];
              data.add(0x7d);
              data.addAll(intToFormatHex(i, 8));
              data.addAll(intToFormatHex(packageSum, 8));
              List<int> temp = List.filled(116, 0);
              if ((i + 1) * 116 > widget.arguments["data"].length) {
                List.copyRange(temp, 0, widget.arguments["data"], i * 116);
              } else {
                List.copyRange(
                    temp, 0, widget.arguments["data"], i * 116, (i + 1) * 116);
              }
              data.addAll(temp);
              sendCmd(data);
              i++;
            } else {
              updatLcdBinEvent.cancel();
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "升级失败,请重启机器后再试!");
            }
          }
          break;
        case 1:
          cncVersion.lcdVersion = widget.arguments["version"];
          updatLcdBinEvent.cancel();
          Fluttertoast.showToast(msg: "升级成功!");
          Navigator.pop(context);
          break;
        case 2:
          //progress = ((i / allPackNum) * 100).toInt();

          if (i < packageSum) {
            data = [];
            data.add(0x7d);
            data.addAll(intToFormatHex(i, 8));
            data.addAll(intToFormatHex(packageSum, 8));
            List<int> temp = List.filled(116, 0);
            if ((i + 1) * 116 > widget.arguments["data"].length) {
              List.copyRange(temp, 0, widget.arguments["data"], i * 116);
            } else {
              List.copyRange(
                  temp, 0, widget.arguments["data"], i * 116, (i + 1) * 116);
            }

            data.addAll(temp);
            sendCmd(data);
          }
          if (i == packageSum) {
            data = [0x7d, 1, 0];
            sendCmd(data);
          }
          setState(() {
            progress = ((i / packageSum) * 100).toInt();
            ////print(progress);
          });
          i++;
          setState(() {});
          break;
        case 5:
          updatLcdBinEvent.cancel();
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "升级失败,请重启机器后再试!");
          break;
      }
    });

    //arguments["data"] = base64Decode(bin64);
    /// if (cncVersion.lcdVersion > 100) {

    sendCmd([0x7d, 0, 0]); //先跳转至IAP
    //  cncVersion.lcdVersion = 0;
    //  }
    Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: 300,
            height: 200,
            child: Column(
              children: [
                const Text(
                  "正在升级,请稍后...",
                  style: TextStyle(fontSize: 20),
                ),
                const Divider(),
                Expanded(
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text("$progress%"),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("取消")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
