import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:magictank/convers/convers.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';
import 'package:magictank/magicclone/chipclass/progresschip.dart';
import 'package:magictank/magicclone/copychip/editshow_page.dart';
import 'package:magictank/userappbar.dart';

import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../../alleventbus.dart';

class EdigChipPage extends StatefulWidget {
  final Map? arguments;

  const EdigChipPage({Key? key, this.arguments}) : super(key: key);

  @override
  _EdigChipPageState createState() => _EdigChipPageState();
}

class _EdigChipPageState extends State<EdigChipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userCloneBar(context),
      body: EdigChip(
        arguments: widget.arguments,
      ),
    );
  }
}

class EdigChip extends StatefulWidget {
  final Map? arguments;
  const EdigChip({Key? key, this.arguments}) : super(key: key);

  @override
  _EdigChipState createState() => _EdigChipState();
}

class _EdigChipState extends State<EdigChip> {
  //List pagedata = [];
  Timer? timer;

  ///IC卡读方式 1:全读 2 按照扇区读 3 按页读
  int icReadModel = 0;

  ///IC卡读方式 1:仅写当前页 2:写当前扇区 3:全写
  int icWriteModel = 0;
  Duration timeout = const Duration(seconds: 30);
  int currenPage = 0;
  late ProgressDialog pd;
  StreamSubscription? eventBusFn;
  StreamSubscription? chipWriteEventFn;
  int _progressState = 0; //操作状态 1 读 2写 3锁 4解锁
  bool model_46 = false;
  List<int> default46pw = [];
  int pagenum = 0;
  int writepagenum = 0;
  int _lockPage = -1;
  //int _unlockPage = -1;
  @override
  void initState() {
    pd = ProgressDialog(context: context);
    // debugPrint(arguments);
    //  pagedata = List.from(progressChip.chipPageData);
    //  if (progressChip.chipname == "4600") {
    //  default46pw = stringHexToIntList(pagedata[0]);
    //   }
    // debugPrint(pagedata);
    eventBusFn = eventBus.on<ChipReadEvent>().listen(
      (ChipReadEvent event) {
        if (event.state == false) {
          if (pd.isOpen()) {
            pd.close();
          }
          if (timer != null) {
            timer!.cancel();
          }
          showDialog(
              context: context,
              builder: (c) {
                return MyTextDialog(S.of(context).haveerror);
              });
        } else {
          debugPrint("wrstate:$_progressState");
          progressState();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    if (eventBusFn != null) {
      eventBusFn!.cancel();
    }
    super.dispose();
  }

//处理状态 包括读取 写入 上锁 解锁  处理状态
  void progressState() {
    switch (_progressState) {
      case 1: //读
        pagenum++;
        switch (progressChip.chipnamebyte[0]) {
          case 0x46:
            switch (pagenum) {
              case 1:
                progressChip.readChipData2(3, readmodel: model_46);
                break;
              case 2:
                progressChip.readChipData2(4, readmodel: model_46);
                break;
              case 3:
                timer!.cancel();
                debugPrint("读取成功");
                Fluttertoast.showToast(msg: S.of(context).chipreadok);
                pd.close();
                setState(() {});
                break;
              default:
            }
            break;
          case 0x48:
            switch (pagenum) {
              case 1:
                progressChip.readChipData2(2);
                break;
              case 2:
                progressChip.readChipData2(3);
                break;
              case 3:
                timer!.cancel();
                debugPrint("读取成功");
                Fluttertoast.showToast(msg: S.of(context).chipreadok);
                pd.close();
                setState(() {});
                break;
            }
            break;
          case 0x4d:
            switch (pagenum) {
              case 1:
                progressChip.readChipData2(2);
                break;
              case 2:
                progressChip.readChipData2(3);
                break;
              case 3:
                progressChip.readChipData2(8);
                break;
              case 4:
                progressChip.readChipData2(9);
                break;
              case 5:
                progressChip.readChipData2(10);
                break;
              case 6:
                progressChip.readChipData2(11);
                break;
              case 7:
                progressChip.readChipData2(12);
                break;
              case 8:
                progressChip.readChipData2(13);
                break;
              case 9:
                progressChip.readChipData2(14);
                break;
              case 10:
                progressChip.readChipData2(15);
                break;
              case 11:
                progressChip.readChipData2(18);
                break;
              case 12:
                progressChip.readChipData2(29);
                break;
              case 13:
                progressChip.readChipData2(30);
                break;
              case 14:
                timer!.cancel();
                debugPrint("读取成功");
                Fluttertoast.showToast(msg: S.of(context).chipreadok);
                pd.close();
                setState(() {});
                break;
              default:
                timer!.cancel();
                debugPrint("成功");
                Fluttertoast.showToast(msg: S.of(context).chipreadok);
                pd.close();
                setState(() {});
                break;
            }
            break;
          case 0x1c:
            switch (icReadModel) {
              case 1: //全读
                debugPrint("成功");
                Fluttertoast.showToast(msg: S.of(context).chipreadok);
                pd.close();
                timer!.cancel();
                setState(() {});
                break;
              case 2: //按照扇区读
                if (pagenum >= 16) {
                  debugPrint("成功");
                  Fluttertoast.showToast(msg: S.of(context).chipreadok);
                  pd.close();
                  timer!.cancel();
                  setState(() {});
                } else {
                  pd.update(value: pagenum);

                  progressChip.readChipData2(pagenum, icreadmodel: icReadModel);
                }
                break;
              case 3: //按页读
                if (pagenum >= 63) {
                  debugPrint("成功");
                  Fluttertoast.showToast(msg: S.of(context).chipreadok);
                  pd.close();
                  timer!.cancel();
                  setState(() {});
                } else {
                  if ((pagenum + 1) % 4 == 0) {
                    pagenum++;
                  }
                  pd.update(value: pagenum);
                  progressChip.readChipData2(pagenum, icreadmodel: icReadModel);
                }
                break;
            }
            break;
          case 0x8a:
            if (pagenum > 15) {
              debugPrint("成功");
              Fluttertoast.showToast(msg: S.of(context).chipreadok);
              pd.close();
              timer!.cancel();
              setState(() {});
            } else {
              progressChip.readChipData2(pagenum);
            }
            break;

          default:
        }
        break;
      case 2: //写
        switch (progressChip.chipnamebyte[0]) {
          case 0x48:
            switch (writepagenum) {
              case 0:
                progressChip.writeChipData(3);
                writepagenum = 100;
                break;
              case 13:
                progressChip.writeChipData(11);
                writepagenum = 100;
                break;
              default:
                timer?.cancel();
                debugPrint("成功");
                Fluttertoast.showToast(msg: S.of(context).chipwriteok);
                pd.close();
                setState(() {});
                break;
            }
            break;
          default:
            timer!.cancel();
            debugPrint("成功");
            Fluttertoast.showToast(msg: S.of(context).chipwriteok);
            pd.close();
            setState(() {});
            break;
        }

        break;
      // switch (progressChip.chipname) {
      //   case "4800":
      //     switch (progressChip.getCurrenPageState()) {
      //       case 0x10 + 3:
      //         progressChip.writeChipData(2);
      //         break;
      //       case 0x10 + 2:
      //         timer!.cancel();
      //         pd.close();
      //         Fluttertoast.showToast(msg: "成功");
      //         pd.close();
      //         break;
      //       case 0x10 + 11:
      //         progressChip.writeChipData(10);
      //         break;
      //       case 0x10 + 10:
      //         timer!.cancel();
      //         pd.close();
      //         Fluttertoast.showToast(msg: "成功");
      //         pd.close();
      //         break;
      //       default:
      //         timer!.cancel();
      //         pd.close();
      //         Fluttertoast.showToast(msg: "成功");
      //         pd.close();
      //         break;
      //     }
      //     break;
      //   default:
      //     timer!.cancel();
      //     debugPrint("成功");
      //     Fluttertoast.showToast(msg: "写入成功");
      //     pd.close();
      //     setState(() {});
      //     break;
      // }

      case 3: //上锁
        lockOK();
        timer!.cancel();
        debugPrint("成功");
        Fluttertoast.showToast(msg: S.of(context).chiplockok);
        pd.close();
        setState(() {});
        break;
      case 4: //解锁
        unlockOK();
        timer!.cancel();
        debugPrint("成功");
        Fluttertoast.showToast(msg: S.of(context).chipunlockok);
        pd.close();
        setState(() {});
        break;
      default:
        if (timer != null) {
          timer!.cancel();
        }
        debugPrint("成功");
        Fluttertoast.showToast(msg: "成功");
        pd.close();
        setState(() {});
        break;
    }
  }

//超时设置
  void progressTimeout(String showmessage) {
    if (timer != null) {
      timer!.cancel();
    }
    switch (progressChip.chipnamebyte[0]) {
      case 0x1c:
        timeout = const Duration(seconds: 120);
        break;
      default:
        timeout = const Duration(seconds: 30);
        break;
    }
    timer = Timer(timeout, () {
      pd.close();
      showDialog(
          context: context,
          builder: (c) {
            return MyTextDialog(showmessage);
          });
    });
  }

//芯片功能 其它项目  比如48的解锁  放在列表的最下方
  Widget other() {
    switch (progressChip.chipnamebyte[0]) {
      case 0x48:
        return ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () {
              pd.show(max: 100, msg: "解锁中...");
              currenPage = 0x21;
              _progressState = 100;
              progressChip.chipUnlock(0);
            },
            child: Text(
              S.of(context).chipunlock,
              style: const TextStyle(color: Colors.black),
            ));
      case 0x46:
        return Container(
          height: 40.h,
          width: double.maxFinite,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              Expanded(
                child: RadioListTile(
                  title: Text(S.of(context).chip46model1),
                  value: 0,
                  groupValue: model_46 ? 1 : 0,
                  onChanged: (value) {
                    model_46 = false;
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: Text(S.of(context).chip46model2),
                  value: 1,
                  groupValue: model_46 ? 1 : 0,
                  onChanged: (value) {
                    model_46 = true;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        );
      case 0x4d:
        return Container(
          height: 40.h,
          width: double.maxFinite,
          decoration: const BoxDecoration(
              color: Color(0XFFD2CDEC),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: const Text("质询"),
                onPressed: () {},
              ),
              TextButton(
                child: const Text("解锁"),
                onPressed: () {},
              ),
              TextButton(
                child: const Text("DST+"),
                onPressed: () {},
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }

//编辑列表子title
  Widget pageTitle(int index, String subtitle, String title,
      {bool button = true, bool lockbutton = false}) {
    return Container(
      height: 45.h,
      width: double.maxFinite,
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextButton(
        child: Row(
          children: [
            SizedBox(
              width: 80.w,
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xff50c5c4),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(
                title.toString().toUpperCase(),
                style: const TextStyle(color: Color(0xff666666)),
              ),
            ),
            button
                ? Container(
                    decoration: const BoxDecoration(
                        color: Color(0xff50c5c4),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: Text(
                        S.of(context).chipwrite,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        switch (progressChip.chipnamebyte[0]) {
                          case 0x1c:
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return const MySeleDialog(
                                      ["仅写当前页", "仅写当前扇区", "全写(默认密码)"]);
                                }).then((value) {
                              switch (value) {
                                case 1:
                                  icWriteModel = 1;
                                  progressTimeout(
                                      S.of(context).chipwritetimerout);

                                  writeData(index);
                                  break;
                                case 2:
                                  icWriteModel = 2;
                                  progressTimeout(
                                      S.of(context).chipwritetimerout);

                                  writeData(index);
                                  break;
                                case 3:
                                  icWriteModel = 3;
                                  progressTimeout(
                                      S.of(context).chipwritetimerout);

                                  writeData(index);
                                  break;
                                default:
                                  break;
                              }
                            });
                            break;
                          case 0x48:
                            showDialog(
                                context: context,
                                builder: (c) {
                                  return const MySeleDialog(["仅写当前页", "全写"]);
                                }).then((value) {
                              switch (value) {
                                case 1:
                                  writeData(index);

                                  break;
                                case 2:
                                  print("全写");
                                  writeData(14);
                                  break;
                              }
                            });
                            break;
                          default:
                            progressTimeout(S.of(context).chipwritetimerout);
                            writeData(index);
                            break;
                        }
                      },
                    ),
                  )
                : Container(),
            lockbutton
                ? Container(
                    width: 30.r,
                    height: 30.r,
                    margin: EdgeInsets.only(left: 5.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.r),
                      ),
                      image: DecorationImage(
                          image: AssetImage(progressChip.chipPageData[index][
                                      progressChip.chipPageData[index].length -
                                          1] ==
                                  "1"
                              ? "image/mcclone/Icon_lock.png"
                              : "image/mcclone/Icon_unlock.png"),
                          fit: BoxFit.cover),
                    ),
                    child: TextButton(
                      child: Container(),
                      onPressed: () {
                        if (progressChip.chipPageData[index]
                                [progressChip.chipPageData[index].length - 1] ==
                            "1") {
                          switch (progressChip.chipnamebyte[0]) {
                            case 0x8a:
                              Fluttertoast.showToast(msg: "8A支持解锁");
                              break;
                            default:
                              pd.show(
                                  max: 100, msg: S.of(context).chipunlocking);
                              progressTimeout(S.of(context).chipreadtimerout);
                              //  progressChip.chipUnlock(index);
                              unLockChip();
                              break;
                          }
                        } else {
                          switch (progressChip.chipnamebyte[0]) {
                            case 0x8a:
                              showDialog(
                                  context: context,
                                  builder: (c) {
                                    return MyTextDialog("警告:锁定后将无法解锁");
                                  }).then((value) {
                                lockChip(index);
                              });
                              break;
                            default:
                              pd.show(max: 100, msg: "上锁中...");
                              progressTimeout(S.of(context).chiplocktimerout);
                              //  progressChip.chipLock(index);
                              lockChip(index);
                              break;
                          }
                        }

                        debugPrint("解锁");
                      },
                    ),
                  )
                : Container()
          ],
        ),
        onPressed: () {
          setState(() {
            showDialog(
                context: context,
                builder: (c) {
                  return EditShow(
                    arguments: {
                      "title": subtitle,
                      "data": title.toString().toUpperCase()
                    },
                  );
                }).then((rvalue) {
              if (rvalue != null) {
                switch (progressChip.chipnamebyte[0]) {
                  case 0x4d: //4D需要把锁位增加进去
                    debugPrint("$rvalue");
                    progressChip.chipPageData[index] = rvalue +
                        progressChip.chipPageData[index]
                            [progressChip.chipPageData[index].length - 2] +
                        progressChip.chipPageData[index]
                            [progressChip.chipPageData[index].length - 1];
                    debugPrint("${progressChip.chipPageData[index]}");
                    break;
                  default:
                    progressChip.chipPageData[index] = rvalue;
                    break;
                }

                setState(() {});
              }
            });
          });
        },
      ),
    );
  }

//46编辑页面
  List<Widget> chip46list() {
    List<Widget> temp = [];
    temp.add(pageTitle(0, S.of(context).pw, progressChip.chipPageData[0],
        button: false));
    temp.add(pageTitle(1, "ID", progressChip.chipPageData[1])); //P0
    for (var i = 2; i < progressChip.chipPageData.length; i++) {
      temp.add(pageTitle(i, "P${i - 1}", progressChip.chipPageData[i]));
    }
    temp.add(other());
    return temp;
  }

//48编辑页面
  List<Widget> chip48list() {
    List<Widget> temp = [];
    temp.add(pageTitle(0, "ID", progressChip.chipPageData[0]));
    for (var i = 1; i < 5; i++) {
      temp.add(pageTitle(i, "um2[${16 - i}]", progressChip.chipPageData[i]));
    }
    temp.add(pageTitle(5, "page[1]", progressChip.chipPageData[5]));
    temp.add(pageTitle(6, "page[0]", progressChip.chipPageData[6]));
    for (var i = 7; i < progressChip.chipPageData.length - 1; i++) {
      temp.add(pageTitle(i, "key[${16 - i}]", progressChip.chipPageData[i]));
    }
    temp.add(pageTitle(progressChip.chipPageData.length - 1, "PIN",
        progressChip.chipPageData[progressChip.chipPageData.length - 1]));
    temp.add(other());
    return temp;
  }

//4d编辑页面
  List<Widget> chip4dlist() {
    List<Widget> temp = [];
    // String te = "";
    // te.substring(start)
    //   for (var i = 0; i < progressChip.chipPageData.length; i++){
    temp.add(pageTitle(
        0, S.of(context).pw, progressChip.chipPageData[0].substring(0, 2),
        lockbutton: true));
    temp.add(pageTitle(
        1, S.of(context).user, progressChip.chipPageData[1].substring(0, 2),
        lockbutton: true));
    temp.add(pageTitle(
        2,
        "ID",
        progressChip.chipPageData[2]
            .substring(0, progressChip.chipPageData[2].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        3,
        S.of(context).pw,
        progressChip.chipPageData[3]
            .substring(0, progressChip.chipPageData[3].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        4,
        "P8",
        progressChip.chipPageData[4]
            .substring(0, progressChip.chipPageData[4].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        5,
        "P9",
        progressChip.chipPageData[5]
            .substring(0, progressChip.chipPageData[5].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        6,
        "P10",
        progressChip.chipPageData[6]
            .substring(0, progressChip.chipPageData[6].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        7,
        "P11",
        progressChip.chipPageData[7]
            .substring(0, progressChip.chipPageData[7].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        8,
        "P12",
        progressChip.chipPageData[8]
            .substring(0, progressChip.chipPageData[8].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        9,
        "P13",
        progressChip.chipPageData[9]
            .substring(0, progressChip.chipPageData[9].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        10,
        "P14",
        progressChip.chipPageData[10]
            .substring(0, progressChip.chipPageData[10].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        11,
        "P15",
        progressChip.chipPageData[11]
            .substring(0, progressChip.chipPageData[11].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        12,
        "P18",
        progressChip.chipPageData[12]
            .substring(0, progressChip.chipPageData[12].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        13,
        "P29",
        progressChip.chipPageData[13]
            .substring(0, progressChip.chipPageData[13].length - 2),
        lockbutton: true));
    temp.add(pageTitle(
        14,
        "P30",
        progressChip.chipPageData[14]
            .substring(0, progressChip.chipPageData[14].length - 2),
        lockbutton: true));
    // temp.add(pageTitle(4, "随机数", progressChip.chipPageData[4].substring(0, 2),
    //     lockbutton: true));
    // temp.add(pageTitle(5, "签名", progressChip.chipPageData[5]));
    // }
    //  temp.add(other());
    return temp;
  }

//8A编辑页面
  List<Widget> chip8alist() {
    List<Widget> temp = [];
    for (var i = 0; i < progressChip.chipPageData.length; i++) {
      temp.add(pageTitle(
          i,
          "P$i",
          progressChip.chipPageData[i]
              .substring(0, progressChip.chipPageData[0].length - 2),
          lockbutton: true));
    }

    return temp;
  }

//IC编辑页面
  List<Widget> chipiclist() {
    List<Widget> temp = [];

    for (var i = 0; i < progressChip.chipPageData.length; i++) {
      if ((i + 1) % 4 == 0) {
        temp.add(pageTitle(i, "密码$i", progressChip.chipPageData[i]));
      } else {
        temp.add(pageTitle(i, "block$i", progressChip.chipPageData[i]));
      }
    }
    //  temp.add(other());
    return temp;
  }

//根据芯片类型 返回编辑的列表
  Widget pagelist() {
    switch (progressChip.chipnamebyte[0]) {
      case 0x46:
        return ListView(children: chip46list());
      case 0x48:
        return ListView(children: chip48list());
      case 0x4d:
        return ListView(children: chip4dlist());
      case 0x1c:
        return ListView(children: chipiclist());
      case 0x8a:
        return ListView(children: chip8alist());

      default:
        return Container();
    }
  }

//写入数据
  void writeData(var index) {
    //String data = "";
    //wrstate = 0; //标志位写入状态
    _progressState = 2;

    pd.show(max: 100, msg: "写入中..");

    switch (progressChip.chipnamebyte[0]) {
      case 0x46:
        //P3 第一个字节改为0E 就为加密模式
        progressChip.writeChipData(index - 1, writemodel: model_46);
        break;
      case 0x48:
        //列表index
        writepagenum = index;
        switch (index) {
          case 0: //id
            progressChip.writeChipData(2);
            break;
          case 1: //um2[15]
            progressChip.writeChipData(15);
            break;
          case 2: //um2[14]
            progressChip.writeChipData(14);
            break;
          case 3: //um2[13]
            progressChip.writeChipData(13);
            break;
          case 4: //um2[12]
            progressChip.writeChipData(12);
            break;
          case 5: //page[1]
            progressChip.writeChipData(1);
            break;
          case 6: //page[0]
            progressChip.writeChipData(0);
            break;
          case 7:
            progressChip.writeChipData(9);
            break;
          case 8:
            progressChip.writeChipData(8);
            break;
          case 9: //key[9]
            progressChip.writeChipData(7);
            break;
          case 10: //key[8]
            progressChip.writeChipData(6);
            break;
          case 11: //key[7]
            progressChip.writeChipData(5);
            break;
          case 12: //key[6]
            progressChip.writeChipData(4);
            break;
          case 13: //key[5]

            progressChip.writeChipData(10);
            break;
          case 14:
            progressChip.writeChipData(16);
            break;
        }
        break;
      case 0x4d:
        switch (index) {
          case 0:
            progressChip.writeChipData(1);
            break;
          case 1:
            progressChip.writeChipData(2);
            break;
          case 2:
            progressChip.writeChipData(3);
            break;
          case 3:
            progressChip.writeChipData(4);
            break;
          case 4:
            progressChip.writeChipData(8);
            break;
          case 5:
            progressChip.writeChipData(9);
            break;
          case 6:
            progressChip.writeChipData(10);
            break;
          case 7:
            progressChip.writeChipData(11);
            break;
          case 8:
            progressChip.writeChipData(12);
            break;
          case 9:
            progressChip.writeChipData(13);
            break;
          case 10:
            progressChip.writeChipData(14);
            break;
          case 11:
            progressChip.writeChipData(15);
            break;
          case 12:
            progressChip.writeChipData(18);
            break;
          case 13:
            progressChip.writeChipData(29);
            break;
          case 14:
            progressChip.writeChipData(30);
            break;
          default:
        }
        break;
      case 0x1c:
        if (icWriteModel == 2) //如果按照扇区写;判断当前写的是什么扇区
        {
          progressChip.writeChipData((index ~/ 4), icwritemodel: icWriteModel);
        } else {
          progressChip.writeChipData(index, icwritemodel: icWriteModel);
        }
        break;
      case 0x8a:
        progressChip.writeChipData(index);
        break;
    }
  }

//读取数据
  void readData() async {
    _progressState = 1;
    pagenum = 0;
    debugPrint("model_46:$model_46");
    switch (progressChip.chipnamebyte[0]) {
      case 0x48:
        //读取word 0,1
        progressChip.readChipData2(1);
        break;
      case 0x46:
        progressChip.readChipData2(1, readmodel: model_46);
        break;
      case 0x4d:
        progressChip.readChipData2(1);
        break;
      case 0x1c:
        progressChip.readChipData2(0, icreadmodel: icReadModel);
        break;
      case 0x8a:
        progressChip.readChipData2(0);
        break;
    }
  }

//锁定芯片
  void lockChip(int index) {
    _progressState = 3;
    switch (progressChip.chipnamebyte[0]) {
      case 0x4d:
        _lockPage = index;
        switch (index) {
          case 0:
            progressChip.chipLock(1);
            break;
          case 1:
            progressChip.chipLock(2);
            break;
          case 2:
            progressChip.chipLock(3);
            break;
          case 3:
            progressChip.chipLock(4);
            break;
          case 4:
            progressChip.chipLock(8);
            break;
          case 5:
            progressChip.chipLock(9);
            break;
          case 6:
            progressChip.chipLock(10);
            break;
          case 7:
            progressChip.chipLock(11);
            break;
          case 8:
            progressChip.chipLock(12);
            break;
          case 9:
            progressChip.chipLock(13);
            break;
          case 10:
            progressChip.chipLock(14);
            break;
          case 11:
            progressChip.chipLock(15);
            break;
          case 12:
            progressChip.chipLock(18);
            break;
          case 13:
            progressChip.chipLock(29);
            break;
          case 14:
            progressChip.chipLock(30);
            break;
        }
        break;
      case 0x8a:
        print("锁定8A:$index");
        _lockPage = index;
        progressChip.chipLock(index);
        break;
    }
  }

//解锁OK
  void unlockOK() {
    //解码成功后需要重新更新页面数据

    switch (progressChip.chipnamebyte[0]) {
      case 0x4d:
        for (var i = 0; i < progressChip.chipPageData.length; i++) {
          progressChip.chipPageData[i] = changeStringIndex(
              progressChip.chipPageData[i],
              progressChip.chipPageData[i].length - 1,
              "0");
        }
        break;
    }
  }

//锁定OK
  void lockOK() {
    //上锁OK
    switch (progressChip.chipnamebyte[0]) {
      case 0x4d:
        progressChip.chipPageData[_lockPage] = changeStringIndex(
            progressChip.chipPageData[_lockPage],
            progressChip.chipPageData[_lockPage].length - 1,
            "1");
        // setState(() {});
        // progressChip.chipPageData[_lockPage]
        //     [progressChip.chipPageData[_lockPage].length - 1] = "1";
        break;
      case 0x8a:
        progressChip.chipPageData[_lockPage] = changeStringIndex(
            progressChip.chipPageData[_lockPage],
            progressChip.chipPageData[_lockPage].length - 1,
            "1");
        break;
    }
  }

//解锁芯片
  void unLockChip() {
    _progressState = 4;
    switch (progressChip.chipnamebyte[0]) {
      case 0x4d:
        progressChip.chipUnlock(0);
        break;
      case 0x48:
        progressChip.chipUnlock(0);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          progressChip.chipname.toUpperCase(),
          style: TextStyle(fontSize: 30.sp, color: const Color(0xff666666)),
        ),
        SizedBox(
          height: 5.h,
        ),
        Expanded(
          child: pagelist(),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          width: 130.w,
          height: 30.0.h,
          decoration: const BoxDecoration(
              color: Color(0XFF50c5c4),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: TextButton(
            child: const Text(
              "读取",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (mcbtmodel.getMcBtState()) {
                switch (progressChip.chipnamebyte[0]) {
                  case 0x1c:
                    showDialog(
                        context: context,
                        builder: (c) {
                          return const MySeleDialog(
                              ["全读(默认密码)", "按扇区读", "按页读"]);
                        }).then((value) {
                      switch (value) {
                        case 1:
                          icReadModel = 1;
                          pd.show(max: 100, msg: "读取中..请稍后");
                          readData();

                          progressTimeout("读取超时请稍后再试！");
                          break;
                        case 2:
                          icReadModel = 2;
                          pd.show(max: 100, msg: "读取中..请稍后");
                          readData();

                          progressTimeout("读取超时请稍后再试！");
                          break;
                        case 3:
                          icReadModel = 3;
                          pd.show(max: 100, msg: "读取中..请稍后");
                          readData();

                          progressTimeout("读取超时请稍后再试！");
                          break;
                      }
                    });
                    break;
                  default:
                    pd.show(max: 100, msg: "读取中..请稍后");
                    readData();
                    progressTimeout("读取超时请稍后再试！");
                    break;
                }
              } else {
                showDialog(
                    context: context,
                    builder: (c) {
                      return const MyTextDialog("请先连接蓝牙");
                    }).then((value) {
                  if (value) {
                    Navigator.pushNamed(context, '/selemc', arguments: 2);
                  }
                });
              }
            },
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
