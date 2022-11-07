import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class CreateChipListPage extends StatelessWidget {
  final Map? arguments;
  const CreateChipListPage({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffeeeeee),
      appBar: userCloneBar(context),
      body: CreateChipList(arguments: arguments),
    );
  }
}

// class ExpandStateBean {
//   //控制打开关闭状态
//   var index, isOpen;
//   ExpandStateBean(this.index, this.isOpen);
// }

class CreateChipList extends StatefulWidget {
  final Map? arguments;
  const CreateChipList({Key? key, this.arguments}) : super(key: key);

  @override
  State<CreateChipList> createState() => _CreateChipListState();
}

class _CreateChipListState extends State<CreateChipList> {
  List originList = [];
  // List<ExpandStateBean> expandStateList = [];
  //var arguments;
  int oldindex = 0;
  @override
  void initState() {
    //  arguments = widget.arguments;
    originList = List.from(widget.arguments!["sub"]);
    for (var i = 0; i < originList.length; i++) {
      if (i == 0) {
        originList[i]["state"] = true;
      } else {
        originList[i]["state"] = false;
      }
    }
    debugPrint("$originList");
    super.initState();
  }

  List<Widget> chipList(int index) {
    List<Widget> temp = [];
    for (var i = 0; i < originList[index]["content"].length; i++) {
      temp.add(ListTile(
        title: Text(originList[index]["content"][i]["name"]),
        subtitle: Text(originList[index]["content"][i]["support"]),
        onTap: () {
          debugPrint("生成芯片");
          Navigator.pushNamed(context, '/createchiphandle',
              arguments: originList[index]["content"][i]);
        },
      ));
    }
    return temp;
  }

  List<Widget> subList() {
    List<Widget> temp = [];

    for (var i = 0; i < originList.length; i++) {
      temp.add(
        ExpansionTile(
            initiallyExpanded: originList[i]["state"],
            title: Text(originList[i]["title"]),
            children: chipList(i),
            onExpansionChanged: (state) {
              setState(() {
                originList[i]["state"] = state;
                for (var j = 0; j < originList.length; j++) {
                  if (i != j) {
                    originList[i]["state"] = false;
                  }
                }
                debugPrint("$originList");
              });
            }),
      );
    }
    return temp;
  }

//设置展开还是关闭
  // _setCurrentIndex(int index, isExpand) {
  //   setState(() {
  //     originList[index]["state"] = !isExpand;
  //     for (var i = 0; i < originList.length; i++) {
  //       if (i != index) {
  //         originList[i]["state"] = false;
  //       }
  //     }
  //   });
  // }

  List<ExpansionPanel> title() {
    List<ExpansionPanel> temp = [];
    for (var i = 0; i < originList.length; i++) {
      temp.add(
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded) {
            return Container(
              height: 20.h,
              color: Colors.white,
              child: Text(originList[i]["title"]),
            );
          },
          body: Column(children: chipList(i)),
          isExpanded: originList[i]["state"],
        ),
      );
    }
    return temp;
  }

  List<int> mList = [];
  learnExpansionPanelList() {
    for (int i = 0; i < 5; i++) {
      mList.add(i);
    }
  }

  void _setOpenState(int index) {
    for (var i = 0; i < originList.length; i++) {
      if (i != index) {
        originList[i]["state"] = false;
      }
    }
    setState(() {});
  }

  List<Widget> chidWidget(int index) {
    List<Widget> temp = [];
    for (var i = 0; i < originList[index]["content"].length; i++) {
      temp.add(
        Container(
          width: double.maxFinite,
          height: 70.h,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: const BoxDecoration(
              color: Color(0xff50c5c4),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: TextButton(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20.w, 0, 0, 0),
                  width: double.maxFinite,
                  child: Text(
                    originList[index]["content"][i]["name"],
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    const Text(
                      "芯片:",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      originList[index]["content"][i]["support"],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/createchiphandle',
                  arguments: originList[index]["content"][i]);
            },
          ),
        ),
      );
    }
    return temp;
  }

  List<Widget> mainWidget() {
    List<Widget> temp = [];
    for (var i = 0; i < originList.length; i++) {
      temp.add(
        Container(
          width: double.maxFinite,
          height: 40.h,
          margin: const EdgeInsets.fromLTRB(5, 0, 10, 5),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: TextButton(
            child: Row(
              children: [
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                Text(
                  originList[i]["title"],
                  style: const TextStyle(color: Colors.black),
                ),
                Expanded(
                  child: Container(),
                  flex: 2,
                ),
                originList[i]["state"]
                    ? Text(
                        S.of(context).chickput,
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      )
                    : Container(),
                SizedBox(
                  width: 5.w,
                ),
                originList[i]["state"]
                    ? Container(
                        width: 60.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: const Color(0xff50c5c4),
                          borderRadius: BorderRadius.all(Radius.circular(20.h)),
                        ),
                        child: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white))
                    : SizedBox(
                        width: 60.w,
                        height: 40.h,
                        // color: Colors.black,
                        child: const Icon(Icons.keyboard_arrow_right,
                            color: Color(0xff666666)))
              ],
            ),
            onPressed: () {
              originList[i]["state"] = !originList[i]["state"];
              _setOpenState(i);
            },
          ),
        ),
      );

      temp.add(originList[i]["state"]
          ? Column(
              children: chidWidget(i),
            )
          : Container());
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       Container(
    //         width: double.maxFinite,
    //         child: Text(
    //           arguments["master"],
    //           style: TextStyle(fontSize: 40),
    //           textAlign: TextAlign.left,
    //         ),
    //       ),
    //       SizedBox(
    //         height: 10,
    //       ),
    //       Expanded(
    //         child: ListView(
    //           children: [],
    //         ),
    //       ),
    //       // ExpansionPanelList(
    //       //   expansionCallback: (index, bools) {
    //       //     _setCurrentIndex(index, bools);
    //       //   },
    //       //   children: title(),
    //       // ),
    //     ],
    //   ),
    // );
    return Column(
      children: [
        SizedBox(
            width: double.maxFinite,
            height: 50.h,
            child: Center(
              child: Text(
                widget.arguments!["master"],
                style:
                    TextStyle(fontSize: 30.sp, color: const Color(0xff666666)),
                textAlign: TextAlign.center,
              ),
            )),

        Expanded(
          child: ListView(
            children: mainWidget(),
          ),
        ),
        // ExpansionPanelList(
        //   expansionCallback: (index, bools) {
        //     _setCurrentIndex(index, bools);
        //   },
        //   children: title(),
        // ),
      ],
    );
  }
}
