import 'dart:async';

//import 'package:archive/archive_io.dart';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/http/downfile.dart';
import 'package:magictank/userappbar.dart';

import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../../main.dart';
import '../../alleventbus.dart';

class UpgradeCenterPage extends StatefulWidget {
  const UpgradeCenterPage({Key? key}) : super(key: key);

  @override
  _UpgradeCenterPageState createState() => _UpgradeCenterPageState();
}

class _UpgradeCenterPageState extends State<UpgradeCenterPage> {
  List<Widget> upgradeWidget = [];
  List<Widget> upgradeWidgettab = [];
  String serverMCVersion = "0";
  String url = host +
      "/McBinver?language=" +
      (locales!.languageCode == "zh" ? "0" : "1");
  late StreamSubscription eventBusFn;
  late StreamSubscription downFileEventFn;
  late StreamSubscription eventBusDf;
  late ProgressDialog pd;
  bool cangetdata = false;
  @override
  void initState() {
    getServerVer();
    pd = ProgressDialog(context: context);
    eventBusFn = eventBus.on<DownFileEvent>().listen((DownFileEvent event) {
      pd.update(value: event.progress);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cangetdata = true;
      setState(() {});
    });
    super.initState();
  }

  Future<void> getServerVer() async {
    // var result = await Api.appVer(locales!.languageCode == "zh" ? "0" : "1");
    // serverAppVersion = result["version"].toString();
    // result = await Api.chipVer(locales!.languageCode == "zh" ? "0" : "1");
    // serverChipVersion = result["version"].toString();
    var result = await Api.mcBinVer(locales!.languageCode == "zh" ? "0" : "1");
    serverMCVersion = result["version"].toString();
    if (mounted) {
      setState(() {});
    }
  }

  void downChipDataFiles() async {
    if (!pd.isOpen()) {
      pd.show(max: 100, msg: S.of(context).downing);
    }
    Api.downfile(appData.netchipdata["url"], appData.chipDataZipPath, 3);

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
    pd.show(max: 100, msg: S.of(context).unzip);
    final inputStream = InputFileStream(appData.chipDataZipPath);
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
            OutputFileStream('${appData.mcRootPath}/${file.name}');
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
    Fluttertoast.showToast(msg: S.of(context).unzipok);
  }

  void downAPPFiles() async {
    if (!pd.isOpen()) {
      pd.show(max: 100, msg: S.of(context).downing);
    }
    Api.downfile(appData.netapp["url"], appData.chipDataZipPath, 1);

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

  Widget mcupgrade() {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: const Color(0xffeeeeee),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: double.maxFinite,
            height: 124.h,
            decoration: const BoxDecoration(
              color: Colors.white,
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
                            color: Colors.black,
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
                            color: Colors.black,
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
                    "image/mcclone/mcclone.png",
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
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Text(S.of(context).type),
                    ),
                    Expanded(
                      child: Text(S.of(context).locatver),
                    ),
                    Expanded(
                      child: Text(S.of(context).netver),
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
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    if (appData.netapp["version"] != "") {
                      if (appData.appversion == appData.netapp["version"]) {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("APP无需升级!");
                            });
                      } else {
                        if (!appData.hideProgressDialog[0]) {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return const MyTextDialog("是否升级APP?");
                              }).then((value) async {
                            if (value) {
                              await Api.downfile(
                                  appData.netapp["url"], appData.apkPath, 0);
                              showDialog(
                                  context: context,
                                  builder: (c) {
                                    return const MyProgressDialog(
                                      "正在下载数据中...",
                                      progresssmodel: 0,
                                    );
                                  }).then((value) async {
                                switch (value) {
                                  case 1:
                                    appData.hideProgressDialog[0] =
                                        true; //隐藏钥匙数据下载框
                                    break;
                                  case 3:
                                    appData.hideProgressDialog[0] = false;
                                    break;
                                  default:
                                    cancelDown(appData.netapp["url"]);
                                    appData.hideProgressDialog[0] = false;
                                    break;
                                }
                                setState(() {});
                              });
                            }
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return const MyProgressDialog(
                                  "正在下载数据中...",
                                  progresssmodel: 0,
                                );
                              }).then((value) async {
                            switch (value) {
                              case 1:
                                appData.hideProgressDialog[0] =
                                    true; //隐藏钥匙数据下载框
                                break;
                              case 3:
                                appData.hideProgressDialog[0] = false;
                                break;
                              default:
                                cancelDown(appData.netapp["url"]);
                                appData.hideProgressDialog[0] = false;
                                break;
                            }
                            setState(() {});
                          });
                        }
                      }
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          "App版本",
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          appData.appversion,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appData.netapp["version"].toString(),
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.black),
                          ),
                          appData.hideProgressDialog[0] &&
                                  (cangetdata &&
                                      context.watch<AppProvid>().appdownload <
                                          100)
                              ? Text(
                                  "下载中:${context.watch<AppProvid>().appdownload}%",
                                  style: TextStyle(
                                      fontSize: 13.sp, color: Colors.black),
                                )
                              : Container(),
                        ],
                      )),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    if (!appData.hideProgressDialog[2]) {
                      if (int.parse(appData.chipversion) <
                          appData.netchipdata["version"]) {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("是否升级到最新版本");
                            }).then((value) async {
                          if (value) {
                            await Api.downfile(appData.netchipdata["url"],
                                appData.chipDataZipPath, 2);
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return const MyProgressDialog(
                                    "正在下载数据中...",
                                    progresssmodel: 2,
                                  );
                                }).then((value) async {
                              switch (value) {
                                case 1:
                                  appData.hideProgressDialog[2] =
                                      true; //隐藏钥匙数据下载框
                                  break;
                                case 3:
                                  break;
                                default:
                                  cancelDown(appData.netchipdata["url"]);
                                  break;
                              }
                              setState(() {});
                            });
                          }
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("是否需要重新下载？");
                            }).then((value) async {
                          if (value) {
                            await Api.downfile(appData.netchipdata["url"],
                                appData.chipDataZipPath, 2);
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return const MyProgressDialog(
                                    "正在下载数据中...",
                                    progresssmodel: 2,
                                  );
                                }).then((value) async {
                              switch (value) {
                                case 1:
                                  appData.hideProgressDialog[2] =
                                      true; //隐藏钥匙数据下载框
                                  break;
                                case 3:
                                  break;
                                default:
                                  cancelDown(appData.netchipdata["url"]);
                                  appData.hideProgressDialog[2] =
                                      false; //隐藏钥匙数据下载框
                                  break;
                              }
                              setState(() {});
                            });
                          }
                        });
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return const MyProgressDialog(
                              "正在下载数据中...",
                              progresssmodel: 2,
                            );
                          }).then((value) async {
                        switch (value) {
                          case 1:
                            appData.hideProgressDialog[2] = true; //隐藏芯片下载数据
                            break;
                          case 3:
                            appData.hideProgressDialog[2] = false;
                            break;
                          default:
                            cancelDown(appData.netkeydata["url"]);
                            appData.hideProgressDialog[2] = false;
                            break;
                        }
                        setState(() {});
                      });
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          "数据库版本",
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          appData.chipversion,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appData.netchipdata["version"].toString(),
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.black),
                          ),
                          appData.hideProgressDialog[2] &&
                                  (cangetdata &&
                                      context
                                              .watch<AppProvid>()
                                              .chipdatadownload <
                                          100)
                              ? Text(
                                  "下载中:${context.watch<AppProvid>().chipdatadownload}%",
                                  style: TextStyle(
                                      fontSize: 13.sp, color: Colors.black),
                                )
                              : Container(),
                        ],
                      )),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    setState(() {
                      debugPrint("进入升级列表");
                      Navigator.pushNamed(context, '/mcupgradelist');
                    });
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          S.of(context).firmwarever,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          appData.mcVer.toString(),
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          serverMCVersion,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Text("魔力星(深圳)科技有限公司",
              style: TextStyle(fontSize: 13.sp, color: Colors.black)),
          const SizedBox(
            height: 2,
          ),
          Text(
            "©Magic Star (Shenzhen) Technology Co., LTD. All rights reserved",
            style: TextStyle(fontSize: 10.sp, color: Colors.black),
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
      backgroundColor: const Color(0xffeeeeee),
      resizeToAvoidBottomInset: false,
      appBar: userCloneBar(context),
      body: mcupgrade(),
    );
  }
}
