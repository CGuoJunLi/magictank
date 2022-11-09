import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';

import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';

import 'package:nordic_dfu/nordic_dfu.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

// class UpgradePage extends StatelessWidget {
//   const UpgradePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.chevron_left),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         title: Text("TankApp"),
//       ),
//       body: Upgrade(),
//     );
//   }
// }

class Upgrade extends StatefulWidget {
  final String fileurl;
  const Upgrade(this.fileurl, {Key? key}) : super(key: key);
  @override
  _UpgradeState createState() => _UpgradeState();
}

class _UpgradeState extends State<Upgrade> {
  final _images = [
    {'name': 'NewMagicCloen', 'link': ''},
  ];

  late ProgressDialog pd;

  int step = 0;
  int downvalue = 0; //文件下载进度
  int sendvalue = 0; //发送给进度
  late String _localPath;
  int progressValue = 0;
  // List<_TaskInfo>? _tasks;
  // late List<_ItemHolder> _items;
  // late bool _isLoading;
  // late bool _permissionReady;
  // ReceivePort _port = ReceivePort();
  late StreamSubscription downFileevent;
  @override
  void initState() {
    _images[0]["link"] = widget.fileurl;
    debugPrint("下载连接为：" + widget.fileurl);
    // debugPrint(mcbtmodel.device.id.toString());
    pd = ProgressDialog(context: context);
    //_prepareSaveDir();
    // pd!.show(max: 100, msg: "下载文件中");

    // _prepareSaveDir();
    super.initState();

    downmagiclone();
  }

  Future<void> downmagiclone() async {
    await _prepareSaveDir();
    downFileevent = eventBus.on<DownFileEvent>().listen((event) {
      setState(() {
        downvalue = event.progress;
        if (downvalue == 100) {
          downFileevent.cancel();
          step = 1;
          upmclone();
        }
      });
    });
    Api.downfile(widget.fileurl, _localPath + "/mcbin.zip", 4);
    debugPrint("下载完成");
  }

  Future<void> upmclone() async {
    //开始升级进程
    //换蓝牙
    //mcbtmodel.disconnect();
    print(mcbtmodel.connetcedBtDriver!["id"]);
    // mcbtmodel.dfusenddata();
    /*
    await NordicDfu.startDfu(
      mcbtmodel.connetcedBtDriver!["id"],
      _localPath + '/mcbin.zip',
      fileInAsset: false,
      progressListener:
          DefaultDfuProgressListenerAdapter(onProgressChangedHandle: (
        deviceAddress,
        percent,
        speed,  
        avgSpeed,
        currentPart,
        partsTotal,
      ) async {
        debugPrint('deviceAddress: $deviceAddress, percent: $percent');

        sendvalue = percent!;
        if (sendvalue == 100) {
          await Future.delayed(const Duration(seconds: 3));
          //  mcbtmodel.connection(mcbtmodel.device);
          Fluttertoast.showToast(msg: "升级成功,请手动连接机器");
          Navigator.pop(context, true);
        }
        setState(() {});
      }),
    ).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "升级失败");
      Navigator.pop(context, true);
    });*/

    await NordicDfu().startDfu(
        mcbtmodel.connetcedBtDriver!["id"], _localPath + '/mcbin.zip',
        fileInAsset: false,
        iosSpecialParameter:
            IosSpecialParameter(alternativeAdvertisingNameEnabled: false),
        onProgressChanged: (
      deviceAddress,
      percent,
      speed,
      avgSpeed,
      currentPart,
      partsTotal,
    ) async {
      debugPrint('deviceAddress: $deviceAddress, percent: $percent');
      sendvalue = percent;
      // sendvalue = percent;
      if (percent == 100) {
        await Future.delayed(const Duration(seconds: 3));
        //  mcbtmodel.connection(mcbtmodel.device);
        Fluttertoast.showToast(msg: "升级成功,请手动连接机器");
        Navigator.pop(context, true);
      }
      setState(() {});
    }, onDeviceConnected: ((str) {
      print("链接成功" + str);
    }), onDeviceConnecting: ((str) {
      print("链接中" + str);
    }), onDeviceDisconnected: ((str) {
      print("断开连接" + str);
    }), onDeviceDisconnecting: ((str) {
      print("断开连接中" + str);
    }), onDfuAborted: ((str) {
      print(str);
    }), onDfuCompleted: ((str) {
      print("终止" + str);
    }), onDfuProcessStarted: ((str) {
      print("onDfuProcessStarted" + str);
    }), onDfuProcessStarting: ((str) {
      print("onDfuProcessStarting：" + str);
    }), onEnablingDfuMode: ((str) {
      print("onEnablingDfuMode：" + str);
    }), onFirmwareValidating: ((str) {
      print("onFirmwareValidating：" + str);
    }), onError: ((address, error, errorType, message) {
      print(address);
      print(error);
      print(errorType);
      print(message);
    }));
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    debugPrint(_localPath);
  }

  Future<String?> _findLocalPath() async {
    String externalStorageDirPath;
    var directory = await getApplicationDocumentsDirectory();
    externalStorageDirPath = directory.path;
    debugPrint(externalStorageDirPath);
    return externalStorageDirPath;
  }

  @override
  void dispose() {
    downFileevent.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
          child: Container(
        // color: Colors.white,
        width: 300.w,
        height: 200.h,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          children: [
            const Text("MagicClone"),
            SizedBox(
              height: 10.h,
            ),
            Text(
              S.of(context).downmc + "$downvalue%",
              style: const TextStyle(color: Color(0xff50c5c4)),
            ),
            SizedBox(
              height: 10.h,
            ),
            step > 0
                ? Text(
                    S.of(context).upmc + "$sendvalue%",
                    style: const TextStyle(color: Color(0xff50c5c4)),
                  )
                : Container(),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 35.r,
                  height: 35.r,
                  child:
                      const CircularProgressIndicator(color: Color(0xff50c5c4)),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //   if (step == 0) {
                //只有下载的时候才能取消
                NordicDfu().abortDfu();
                Navigator.pop(context, false);
                //  }
              },
              child: Text(S.of(context).cancel),
            )
          ],
        ),
      )),
    );
  }
}

// class _TaskInfo {
//   final String? name;
//   final String? link;

//   String? taskId;
//   int? progress = 0;
//   DownloadTaskStatus? status = DownloadTaskStatus.undefined;

//   _TaskInfo({this.name, this.link});
// }

// class _ItemHolder {
//   final String? name;
//   final _TaskInfo? task;
//   _ItemHolder({this.name, this.task});
// }
