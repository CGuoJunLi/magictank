import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';
import 'package:magictank/magicclone/chipclass/progresschip.dart';
import 'package:magictank/userappbar.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../alleventbus.dart';

class CopyChipPage extends StatefulWidget {
  const CopyChipPage({Key? key}) : super(key: key);

  @override
  _CopyChipPageState createState() => _CopyChipPageState();
}

class _CopyChipPageState extends State<CopyChipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: userCloneBar(context),
      body: const CopyChip(),
    );
  }
}

class CopyChip extends StatefulWidget {
  const CopyChip({Key? key}) : super(key: key);

  @override
  _CopyChipState createState() => _CopyChipState();
}

class _CopyChipState extends State<CopyChip> {
  bool copystae = false;
  late StreamSubscription btStateEvent;
  List<Map> getchip = [];
  late ProgressDialog pd;
  StreamSubscription? eventBusFn;
  Timer? timer;
  Duration timeout = const Duration(seconds: 20);

  @override
  void dispose() {
    if (eventBusFn != null) {
      eventBusFn!.cancel();
    }

    debugPrint("dispose");
    super.dispose();
  }

  @override
  void initState() {
    pd = ProgressDialog(context: context);
    //eventBus = EventBus();
    super.initState();
  }

  _autoConnectBT() {
    if (appData.autoconnect &&
        mcbtmodel.blSwitch &&
        appData.mcbluetoothname != "") {
      pd.show(max: 100, msg: S.of(context).autoconnectbt);
      btStateEvent = eventBus.on<MCConnectEvent>().listen(
        (MCConnectEvent event) async {
          if (event.state) {
            //  progressChip.getver();
            btStateEvent.cancel();
            //   await Future.delayed(const Duration(seconds: 2));
            pd.close();
            _checkChip();
          } else {
            pd.close();
            btStateEvent.cancel();
            Navigator.pushNamed(context, "/selemc");
          }
        },
      );
      mcbtmodel.autoConnect();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const MyTextDialog("请先连接蓝牙");
          }).then((value) {
        if (value) {
          Navigator.pushNamed(context, '/selemc');
        }
      });
    }
  }

  void listenChipState() {
    eventBusFn = eventBus.on<ChipReadEvent>().listen(
      (ChipReadEvent event) {
        if (event.state == false) {
          pd.close();
          timer!.cancel();
          copystae = false;
          //  appData.speakText("识别失败,请检查后再试吧!");
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog(S.of(context).chipdiscernerrortip);
              });
        } else {
          if (timer != null) {
            timer!.cancel();
          }
          getchip = List.from(progressChip.chipdata);
          debugPrint("识别成功");
          //appData.speakText(
          //     "识别成功,识别到的芯片为:${progressChip.chipname[0]},${progressChip.chipname[1]},${progressChip.chipname[2]},${progressChip.chipname[3]}");
          pd.close();
          copystae = true;
          if (mounted) {
            setState(() {});
          }
        }
      },
    );
  }

  void listenChipCopyState() {
    eventBusFn = eventBus.on<ChipReadEvent>().listen(
      (ChipReadEvent event) {
        if (event.state == false) {
          pd.close();
          timer!.cancel();
          //  appData.speakText("识别失败,请检查后再试吧!");
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (c) {
                return MyTextDialog(
                  S.of(context).copychiperror,
                  button2: "再试一次",
                );
              }).then((value) {
            if (value) {
              pd.show(max: 100, msg: "拷贝中...");
              progressChip.copyCurrentChip();
              progressTimeout(S.of(context).discerntimeout);
            } else {
              eventBusFn!.cancel();
            }
          });
        } else {
          timer!.cancel();
          //appData.speakText(
          //     "识别成功,识别到的芯片为:${progressChip.chipname[0]},${progressChip.chipname[1]},${progressChip.chipname[2]},${progressChip.chipname[3]}");
          pd.close();
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (c) {
                return MyTextDialog(
                  S.of(context).copychipok,
                  button2: "再次拷贝",
                );
              }).then((value) {
            if (value) {
              pd.show(max: 100, msg: "拷贝中...");
              progressChip.copyCurrentChip();
              progressTimeout(S.of(context).discerntimeout);
            } else {
              eventBusFn!.cancel();
            }
          });
          if (mounted) {
            setState(() {});
          }
        }
      },
    );
  }

  List<Widget> chipdata(Map data) {
    List<Widget> temp = [];

    data.forEach((key, value) {
      temp.add(Stack(
        children: [
          Align(
            child: Text(key),
            alignment: Alignment.centerLeft,
          ),
          Align(
            child: Text(value),
            alignment: Alignment.center,
          ),
        ],
      ));
      temp.add(const Divider());
    });
    return temp;
  }

  void progressTimeout(String showmessage) {
    if (timer != null) {
      timer!.cancel();
    }

    timeout = const Duration(seconds: 30);

    timer = Timer(timeout, () {
      pd.close();
      showDialog(
          context: context,
          builder: (c) {
            return MyTextDialog(showmessage);
          });
    });
  }

  _checkChip() {
    if (eventBusFn != null) {
      eventBusFn!.cancel();
    }
    progressTimeout(S.of(context).discerntimeout);
    listenChipState();
    pd.show(max: 100, msg: S.of(context).discerning);
    progressChip.discernChip();
  }

  Widget copychipbar(context) {
    return Container(
      height: 48.h,
      width: double.maxFinite,
      color: const Color(0XFF50c5c4),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: Image.asset("image/mcclone/Icon_Copy_Copy.png"),
                  ),
                  Text(
                    S.of(context).copybt,
                    style: TextStyle(fontSize: 13.sp, color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                //  debugPrint(copystae);
                if (eventBusFn != null) {
                  eventBusFn!.cancel();
                }
                if (copystae) {
                  if (progressChip.copy) {
                    pd.show(max: 100, msg: "拷贝中");
                    listenChipCopyState();
                    progressTimeout(S.of(context).discerntimeout);
                    progressChip.copyCurrentChip();
                  } else {
                    print(progressChip.chipnamebyte);
                    Navigator.pushNamed(context, '/copychipinstructions',
                        arguments: {
                          "name": getchip[0][S.of(context).copytype],
                          "chipnamebyte": List.from(progressChip.chipnamebyte),
                          "id": progressChip.chipid,
                          "needcheck": false
                        });
                  }
                } else {
                  Navigator.pushNamed(context, '/copychiplist');
                }
                // debugPrint("拷贝芯片");
              },
            ),
            flex: 1,
          ),
          //const VerticalDivider(), //垂直分割线
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: Image.asset("image/mcclone/Icon_Copy_Edit.png"),
                  ),
                  Text(
                    S.of(context).editdata,
                    style: TextStyle(fontSize: 13.sp, color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  if (copystae) {
                    //debugPrint(getchip[1]);
                    // debugPrint(getchip[0]["防盗类型"]);
                    if (eventBusFn != null) {
                      eventBusFn!.cancel();
                    }

                    if (progressChip.chipnamebyte[0] == 0x1c) {
                      Navigator.pushNamed(
                        context,
                        '/editicchip',
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        '/editchip',
                      );
                    }
                  } else {
                    Fluttertoast.showToast(msg: S.of(context).needdiscern);
                  }
                });
              },
            ),
            flex: 1,
          ),
          // const VerticalDivider(), //垂直分割线
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: Image.asset("image/mcclone/Icon_Copy_Check.png"),
                  ),
                  Text(
                    S.of(context).chipdiscern,
                    style: TextStyle(fontSize: 13.sp, color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                copystae = false;
                if (mcbtmodel.getMcBtState()) {
                  _checkChip();
                } else {
                  _autoConnectBT();
                }
                setState(() {});
              },
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 10.h,
        ),
        Container(
          width: 340.w,
          height: 210.h,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14.r)),
          child: Image.asset(
            "image/mcclone/inchip.png",
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          width: 340.w,
          height: 240.h,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14.r)),
          child: copystae
              ? ListView(children: chipdata(getchip[0]))
              : Center(child: Text(S.of(context).chipdiscerntip)),
        ),
        SizedBox(
          height: 10.h,
        ),
        copychipbar(context),
      ],
    );
  }
}
