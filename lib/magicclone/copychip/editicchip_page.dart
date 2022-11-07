import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/alleventbus.dart';
import 'package:magictank/convers/convers.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/magicclone/chipclass/progresschip.dart';
import 'package:magictank/magicclone/copychip/editshow_page.dart';
import 'package:magictank/userappbar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class EditIcChipPage extends StatefulWidget {
  const EditIcChipPage({Key? key}) : super(key: key);

  @override
  State<EditIcChipPage> createState() => _EditIcChipPageState();
}

class _EditIcChipPageState extends State<EditIcChipPage> {
  int seleblock = 0;
  late StreamSubscription eventBusFn;
  late ProgressDialog pd;
  Timer? timer;
  Duration timeout = const Duration(seconds: 30);
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  @override
  void initState() {
    pd = ProgressDialog(context: context);
    eventBusFn = eventBus.on<ChipReadEvent>().listen(
      (ChipReadEvent event) {
        setState(() {});
        pd.close();
        if (timer != null) {
          timer!.cancel();
        }
        if (event.state) {
          Fluttertoast.showToast(msg: "成功");
        } else {
          Fluttertoast.showToast(msg: "失败");
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    eventBusFn.cancel();
    super.dispose();
  }

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

  List<Widget> datashow(int index1, int index2) {
    List<Widget> temp = [];

    Color color = Colors.black;
    if (seleblock == 0 && index1 == 0) {
      color = Colors.blue;
    }
    //print(progressChip.chipPageData[seleblock * 4 + index1]);

    // print(progressChip.chipPageData[seleblock * 4]);
    // print(progressChip.chipPageData[seleblock * 4 + index1].split(""));
    // progressChip.chipPageData[seleblock * 4][index1]
    //           .split("")
    //           .sublist(i * 2 + index2 * 8, (i + 1) * 2 + index2 * 8)
    for (var i = 0; i < 8; i++) {
      temp.add(
        Container(
          width: 35.r,
          height: 25.r,
          color: Colors.white,
          // margin: EdgeInsets.only(right: 6.r),
          child: TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (c) {
                    return EditShow(
                      arguments: {
                        "title": "编辑数据",
                        "data": progressChip
                            .chipPageData[seleblock * 4 + index1]
                            .substring(i * 2 + index2 * 8 * 2,
                                (i + 1) * 2 + index2 * 8 * 2)
                            .toUpperCase()
                      },
                    );
                  }).then((value) {
                if (value != null) {
                  List<String> changedata = progressChip
                      .chipPageData[seleblock * 4 + index1]
                      .split("");
                  changedata[i * 2 + index2 * 8 * 2] = value[0];
                  changedata[i * 2 + index2 * 8 * 2 + 1] = value[1];
                  progressChip.chipPageData[seleblock * 4 + index1] =
                      listStringToString(changedata);
                }
                setState(() {});
              });

              debugPrint(
                  "扇区:$seleblock 块:$index1 位置:${i * 2 + index2 * 8 * 2}");
            },
            child: Center(
              child: Text(
                progressChip.chipPageData[seleblock * 4 + index1]
                    .substring(
                        i * 2 + index2 * 8 * 2, (i + 1) * 2 + index2 * 8 * 2)
                    .toUpperCase(),
                style: TextStyle(
                    color: index1 == 3
                        ? (i < 6 && index2 == 0)
                            ? Colors.green
                            : ((i > 2 && index2 == 1)
                                ? Colors.green[900]
                                : Colors.red)
                        : color),
              ),
            ),
          ),
        ),
      );
    }
    return temp;
  }

  Widget blockBody() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text("block0:"),
        SizedBox(
          width: 320.r,
          height: 70.r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: datashow(0, 0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: datashow(0, 1),
              ),
            ],
          ),
        ),
        const Text("block1:"),
        SizedBox(
          width: 320.r,
          height: 70.r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: datashow(1, 0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: datashow(1, 1),
              ),
            ],
          ),
        ),
        const Text("block2:"),
        SizedBox(
          width: 320.r,
          height: 70.r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: datashow(2, 0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: datashow(2, 1),
              ),
            ],
          ),
        ),
        const Text("block3:"),
        SizedBox(
          width: 320.r,
          height: 70.r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: datashow(3, 0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: datashow(3, 1),
              ),
            ],
          ),
        ),
        Container(
          width: 320.r,
          height: 32.r,
          color: Colors.white,
          margin: EdgeInsets.only(top: 10.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("数据配色:"),
              const Text(
                "UID-厂家信息",
                style: TextStyle(color: Colors.blue),
              ),
              const Text(
                "密匙A",
                style: TextStyle(color: Colors.green),
              ),
              Text(
                "密匙B",
                style: TextStyle(color: Colors.green[900]),
              ),
              const Text(
                "访问控制",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        )
      ],
    );
  }

  List<Widget> blockTitle() {
    List<Widget> temp = [];
    for (var i = 0; i < 16; i++) {
      temp.add(
        SizedBox(
          width: 70.r,
          height: 60.r,
          child: TextButton(
            onPressed: () {
              seleblock = i;
              setState(() {});
            },
            child: Column(
              children: [
                Text("扇区:$i"),
                const Text("<正常>"),
                Container(
                  width: 80.r,
                  height: 3.r,
                  color:
                      i == seleblock ? const Color(0xff50c5c4) : Colors.white,
                )
              ],
            ),
          ),
        ),
      );
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: userCloneBar(context),
      body: Column(
        children: [
          Divider(
            height: 2.r,
            thickness: 2.r,
          ),
          SizedBox(
            width: double.maxFinite,
            height: 48.h,
            child: Center(
              child: Text(
                "IC:" + progressChip.chipdata[0]["UID"].toUpperCase(),
                style:
                    TextStyle(color: const Color(0xff666666), fontSize: 18.sp),
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 60.r,
            color: Colors.white,
            child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      seleblock--;
                      if (seleblock < 0) {
                        seleblock = 0;
                      }
                      itemScrollController.jumpTo(index: seleblock);
                      setState(() {});
                    },
                    child: const Text("<")),
                Expanded(
                  // child: ListView(
                  //   scrollDirection: Axis.horizontal,
                  //   children: blockTitle(),
                  // ),
                  child: ScrollablePositionedList.builder(
                    itemCount: 16,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 70.r,
                        height: 60.r,
                        child: TextButton(
                          onPressed: () {
                            seleblock = index;
                            setState(() {});
                          },
                          child: Column(
                            children: [
                              Text("扇区:$index"),
                              const Text("<正常>"),
                              Container(
                                width: 80.r,
                                height: 3.r,
                                color: index == seleblock
                                    ? const Color(0xff50c5c4)
                                    : Colors.white,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    seleblock++;
                    if (seleblock > 15) {
                      seleblock = 15;
                    }
                    itemScrollController.jumpTo(index: seleblock);
                    setState(() {});
                  },
                  child: const Text(">"),
                )
              ],
            ),
          ),
          Expanded(child: blockBody()),
          SizedBox(
            width: double.maxFinite,
            height: 51.r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      minimumSize:
                          MaterialStateProperty.all(Size(103.r, 25.r))),
                  onPressed: () {
                    progressTimeout(S.of(context).chipreadtimerout);
                    pd.show(max: 100, msg: "读取中");
                    progressChip.readChipData2(seleblock, icreadmodel: 2);
                  },
                  child: Container(
                    width: 103.r,
                    height: 25.r,
                    decoration: BoxDecoration(
                        color: const Color(0xff50c5c4),
                        borderRadius: BorderRadius.circular(13.r)),
                    child: const Center(
                      child: Text(
                        "读取",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      minimumSize:
                          MaterialStateProperty.all(Size(103.r, 25.r))),
                  onPressed: () {
                    progressTimeout(S.of(context).chipwritetimerout);
                    pd.show(max: 100, msg: "写入中...");

                    progressChip.writeChipData(seleblock, icwritemodel: 2);
                  },
                  child: Container(
                    width: 103.r,
                    height: 25.r,
                    decoration: BoxDecoration(
                        color: const Color(0xff50c5c4),
                        borderRadius: BorderRadius.circular(13.r)),
                    child: const Center(
                      child: Text(
                        "写入",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
