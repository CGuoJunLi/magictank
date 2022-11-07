import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditShow extends StatefulWidget {
  final Map? arguments;
  const EditShow({Key? key, this.arguments}) : super(key: key);
  @override
  _EditShowState createState() => _EditShowState();
}

//315151 462351
class _EditShowState extends State<EditShow> {
  List<String> text = [];
  int index = 0;
  List<Map> buttonstyle = []; //用于标记旋转的按钮
  int linenum = 0; //判断字符需要几行显示;
  List keyvalue = [
    //键盘字符
    'A',
    '1',
    '2',
    '3',
    'B',
    '4',
    '5',
    '6',
    'C',
    '7',
    '8',
    '9',
    'D',
    'E',
    'F',
    '0',
  ];
  // _EdigShowState({this.arguments});
  @override
  void initState() {
    for (var i = 0; i < widget.arguments!["data"].length; i++) {
      text.add(widget.arguments!["data"][i]);
    }
    if (text.length <= 8) {
      linenum = 1;
    } else {
      if (text.length % 8 == 0) {
        //如果是8的倍数
        linenum = text.length ~/ 8;
      } else {
        linenum = text.length ~/ 8 + 1;
      }
    }
    //debugPrint("$text");
    super.initState();
  }

  List<Widget> keyboardwigget() {
    List<Widget> temp = [];
    List<Widget> temp2 = [];
    temp.add(Expanded(child: Container()));
    for (var i = 0; i < keyvalue.length ~/ 4; i++) {
      for (var j = 0; j < 4; j++) {
        //  debugPrint(keyvalue[j + i * 4]);
        temp2.add(
          Expanded(
            child: TextButton(
              onPressed: () {
                setState(() {
                  text[index] = keyvalue[j + i * 4];
                  index++;
                  if (index > text.length - 1) index = 0;
                });
              },
              child: Text(
                keyvalue[j + i * 4],
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      }
      temp.add(Row(
        children: temp2,
      ));
      temp.add(const Divider(
        height: 0,
      ));
      temp2 = [];
    }
    temp.add(Expanded(child: Container()));
    return temp;
  }

  Widget showdata2(context, index, data) {
    return OutlinedButton(
      style: ButtonStyle(
          maximumSize: MaterialStateProperty.all(const Size(20, 20))),
      child: Text(data[index]),
      onPressed: () {},
    );
  }

//line 代表显示的第几行
  List<Widget> showdata3(int line, List<String> data) {
    List<Widget> temp = [];
    for (var i = 0; i < data.length; i++) {
      temp.add(
          // SizedBox(
          //   width: 40.r,
          //   height: 40.r,
          //   child: OutlinedButton(
          //     style: ButtonStyle(
          //       padding: MaterialStateProperty.all(EdgeInsets.zero),
          //       backgroundColor: index == i + line * 8
          //           ? MaterialStateProperty.all(const Color(0XFF6E66AA))
          //           : MaterialStateProperty.all(i % 2 == 0
          //               ? const Color(0XFFD2CDEC)
          //               : const Color(0XFFCDDCEC)),
          //     ),
          //     child: Text(data[i]),
          //     onPressed: () {
          //       setState(() {
          //         index = 8 * line + i;
          //       });
          //     },
          //   ),
          // ),
          SizedBox(
        width: 40.r,
        height: 40.r,
        child: TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            setState(() {
              index = 8 * line + i;
            });
          },
          child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff50c5c4)),
                  borderRadius: BorderRadius.circular(5.r),
                  color: index == i + line * 8
                      ? const Color(0xff50c5c4)
                      : Colors.white),
              child: Center(
                child: Text(
                  data[i],
                  style: TextStyle(
                      fontSize: 30.sp,
                      color:
                          index == i + line * 8 ? Colors.white : Colors.black),
                ),
              )),
        ),
      ));
    }
    return temp;
  }

  List<Widget> showdata(List<String> data) {
    List<Widget> temp = [];
    int count =
        (data.length % 8 == 0 ? data.length ~/ 8 : data.length ~/ 8 + 1);
    for (var i = 0; i < count; i++) {
      int itemcount = data.length % 8 == 0
          ? 8
          : (i < data.length % 8 - 1 ? 8 : data.length % 8);
      debugPrint("$itemcount");
      temp.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: showdata3(
            i,
            data.length % 8 == 0
                ? data.sublist(i * 8, (i + 1) * 8)
                : (i < count - 1
                    ? data.sublist(i * 8, (i + 1) * 8)
                    : data.sublist(i * 8))),
      ));
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          Expanded(child: Container()),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffeeeeee),
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
              ),
              width: 340.w,
              height: 150.h + linenum * 30.h,
              child: Column(
                children: [
                  Text(
                    widget.arguments!["title"],
                    style:
                        const TextStyle(fontSize: 20, color: Color(0XFF50c5c4)),
                  ),
                  const Divider(),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: showdata(text),
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "取消",
                            style: TextStyle(color: Color(0xff50c5c4)),
                          ),
                        ),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {
                            String temp = "";

                            for (var i = 0; i < text.length; i++) {
                              temp += text[i];
                            }

                            Navigator.pop(context, temp);
                          },
                          child: const Text(
                            "确定",
                            style: TextStyle(color: Color(0xff50c5c4)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ),
            ),
          ),
          //alignment: Alignment.topCenter,
          SizedBox(height: 5.h),
          Container(
            width: double.maxFinite,
            height: 220.h,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: keyboardwigget(),
            ),
          ),
        ],
      ),
    );
  }
}
