import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/userappbar.dart';

class McCloneInf extends StatefulWidget {
  const McCloneInf({Key? key}) : super(key: key);

  @override
  State<McCloneInf> createState() => _McCloneInfState();
}

class _McCloneInfState extends State<McCloneInf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: userCloneBar(context),
      body: ListView(
        children: [
          Container(
            width: 340.w,
            height: 237.h,
            margin: EdgeInsets.all(10.r),
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                  child: Row(
                    children: const [
                      Text("设备名称"),
                      Expanded(child: SizedBox()),
                      Text("E-Clone"),
                    ],
                  ),
                ),
                Divider(
                  height: 1.w,
                ),
                SizedBox(
                    height: 40.h,
                    child: Row(
                      children: const [
                        Text("SN:"),
                        Expanded(child: SizedBox()),
                        Text("xxxxxx"),
                      ],
                    )),
                Divider(
                  height: 1.w,
                ),
                SizedBox(
                    height: 40.h,
                    child: Row(
                      children: const [
                        Text("芯片生成次数:"),
                        Expanded(child: SizedBox()),
                        Text("xxxx"),
                      ],
                    )),
              ],
            ),
          ),
          // Container(
          //   width: 340.w,
          //   height: 237.h,
          //   margin: EdgeInsets.all(10.r),
          //   decoration: BoxDecoration(
          //       color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
          //   child: Column(
          //     children: [
          //       Row(
          //         children: [
          //           Text("硬件版本"),
          //         ],
          //       ),
          //       Divider(
          //         height: 1.w,
          //       ),
          //       Row(
          //         children: [
          //           Text("数据库版本"),Text("数据库版本"),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
