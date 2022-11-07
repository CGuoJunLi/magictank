import 'dart:async';

//import 'package:archive/archive_io.dart';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/http/api.dart';

import 'package:open_file/open_file.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../../main.dart';

class SmartUpgradeCenterPage extends StatefulWidget {
  const SmartUpgradeCenterPage({Key? key}) : super(key: key);

  @override
  _SmartUpgradeCenterPageState createState() => _SmartUpgradeCenterPageState();
}

class _SmartUpgradeCenterPageState extends State<SmartUpgradeCenterPage> {
  List<Widget> upgradeWidget = [];
  List<Widget> upgradeWidgettab = [];
  String serverSmartVersion = "0";
  String url = host +
      "/McBinver?language=" +
      (locales!.languageCode == "zh" ? "0" : "1");
  late StreamSubscription eventBusFn;
  late StreamSubscription downFileEventFn;
  late StreamSubscription eventBusDf;
  late ProgressDialog pd;
  @override
  void initState() {
    getServerVer();
    pd = ProgressDialog(context: context);
    eventBusFn = eventBus.on<DownFileEvent>().listen((DownFileEvent event) {
      pd.update(value: event.progress);
    });
    super.initState();
  }

  Future<void> getServerVer() async {
    // var result = await Api.appVer(locales!.languageCode == "zh" ? "0" : "1");
    // serverAppVersion = result["version"].toString();
    // result = await Api.chipVer(locales!.languageCode == "zh" ? "0" : "1");
    // serverChipVersion = result["version"].toString();
    var result =
        await Api.smartBinVer(locales!.languageCode == "zh" ? "0" : "1");
    serverSmartVersion = result["version"].toString();
    if (mounted) {
      setState(() {});
    }
  }

  void downChipDataFiles() async {
    if (!pd.isOpen()) {
      pd.show(max: 100, msg: "更新数据...");
    }
    Api.downfile(appData.netchipdata["url"], appData.smartDataZipPath, 4);

    eventBusDf = eventBus.on<DownFileEvent>().listen(
      (DownFileEvent event) async {
        if (event.progress == -1) {
          if (pd.isOpen()) {
            pd.close();
            Fluttertoast.showToast(msg: "网络异常,请稍后再试!");
          }
        } else {
          pd.update(value: event.progress);
          debugPrint("${event.progress}");
          if (!pd.isOpen() || event.progress == 100) {
            pd.close();
            eventBusDf.cancel();
            await _geizipfile();
            await appData.getChipCarList();
            await appData.getChipIdList();
            await appData.getChipDataList();
            pd.close();
          }
          setState(() {});
        }
      },
    );
  }

  Future<void> _geizipfile() async {
    pd.show(max: 100, msg: "解压资源中...");
    final inputStream = InputFileStream(appData.smartDataZipPath);
    // Decode the zip from the InputFileStream. The archive will have the contents of the
    // zip, without having stored the data in memory.
    final archive = ZipDecoder().decodeBuffer(inputStream);
    // For all of the entries in the archive

    for (var file in archive.files) {
      // If it's a file and not a directory
      if (file.isFile) {
        // Write the file content to a directory called 'out'.
        // In practice, you should make sure file.name doesn't include '..' paths
        // that would put it outside of the extraction directory.
        // An OutputFileStream will write the data to disk.
        final outputStream =
            OutputFileStream('${appData.smartRootPath}/${file.name}');
        // The writeContent method will decompress the file content directly to disk without
        // storing the decompressed data in memory.
        file.writeContent(outputStream);
        // Make sure to close the output stream so the File is closed.
        outputStream.close();
      }
    }
    if (pd.isOpen()) {
      pd.close();
    }
    Fluttertoast.showToast(msg: "解压完成");
  }

  void downAPPFiles() async {
    if (!pd.isOpen()) {
      pd.show(max: 100, msg: "下载文件中...");
    }
    Api.downfile(appData.netapp["url"], appData.smartDataZipPath, 1);

    eventBusDf = eventBus.on<DownFileEvent>().listen(
      (DownFileEvent event) async {
        if (event.progress == -1) {
          if (pd.isOpen()) {
            pd.close();
            Fluttertoast.showToast(msg: "网络异常,请稍后再试!");
          }
        } else {
          pd.update(value: event.progress);
          debugPrint("${event.progress}");
          if (!pd.isOpen() || event.progress == 100) {
            pd.close();
            eventBusDf.cancel();
            OpenFile.open(appData.apkPath);
          }
          setState(() {});
        }
      },
    );
  }

  Widget smartupgrade() {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.black,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: double.maxFinite,
            height: 124.h,
            decoration: const BoxDecoration(
              color: Color(0xffa7a6df),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        child: Text(
                          "Easy Clone",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                        top: 20.h,
                        left: 10.w,
                      ),
                      Positioned(
                        child: Text(
                          "芯片拷贝机",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white,
                          ),
                        ),
                        top: 40.h,
                        left: 10.w,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    "image/upgrade_image.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            width: double.maxFinite,
            height: 200.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  image: AssetImage(
                    "image/upgrade_background.png",
                  ),
                  fit: BoxFit.cover),
            ),
            child: ListView(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    const Expanded(
                      child: Text("类型"),
                    ),
                    const Expanded(
                      child: Text("本地版本"),
                    ),
                    const Expanded(
                      child: Text("服务器版本"),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
                const Divider(
                  height: 1,
                ),
                TextButton(
                  onPressed: () {
                    if (appData.netapp["version"] != "") {
                      if (appData.appversion == appData.netapp["version"]) {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("APP无需升级!");
                            });
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return const MyTextDialog("是否升级APP?");
                          }).then((value) {
                        if (value) {
                          downAPPFiles();
                        }
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "App版本",
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          appData.appversion,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          appData.netapp["version"].toString(),
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      debugPrint("进入升级列表");
                      Navigator.pushNamed(context, '/SmartUpgradelist');
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "SM固件版本",
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          appData.mcVer,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          serverSmartVersion,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                TextButton(
                  onPressed: () {
                    if (int.parse(appData.chipversion) <
                        appData.netchipdata["version"]) {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return const MyTextDialog("是否下载数据?");
                          }).then((value) {
                        if (value) {
                          downChipDataFiles();
                        }
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return const MyTextDialog("是否需要重新下载？");
                          }).then((value) {
                        if (value) {
                          downChipDataFiles();
                        }
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "数据库版本",
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          appData.smartversion,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          appData.netsmartdata["version"].toString(),
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            width: double.maxFinite,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0XFFADAAEA)),
              ),
              child: Stack(
                children: const [
                  Align(
                    child: Text("升级日志"),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    child: Icon(Icons.chevron_right),
                    alignment: Alignment.centerRight,
                  )
                ],
              ),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Image.asset("image/upgrade_logo.png", scale: 2.0),
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Text("魔力星(深圳)科技有限公司",
              style: TextStyle(fontSize: 13.sp, color: Colors.white)),
          const SizedBox(
            height: 2,
          ),
          Text(
            "©Magic Star (Shenzhen) Technology Co., LTD. All rights reserved",
            style: TextStyle(fontSize: 10.sp, color: Colors.white),
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //  elevation: 0,
        backgroundColor: const Color(0XFF6E66AA),
        centerTitle: true,
        title: SizedBox(
          width: 97.r,
          height: 18.r,
          child: Image.asset(
            "image/mcclone/mcbar.png",

            //fit: BoxFit.cover,
          ),
        ),
      ),
      body: smartupgrade(),
    );
  }
}
