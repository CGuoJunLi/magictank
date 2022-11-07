import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/cncpage/mycontainer.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class FireCheckPage extends StatefulWidget {
  const FireCheckPage({Key? key}) : super(key: key);

  @override
  State<FireCheckPage> createState() => _FireCheckPageState();
}

class _FireCheckPageState extends State<FireCheckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: userCloneBar(context),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 48.h,
            padding: EdgeInsets.only(left: 10.w, top: 18.h),
            child: Text(S.of(context).firecheck),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 242.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                myContainerBox(165.w, 242.h, 40.h, "蓝牙未连接",
                    Image.asset("image/mcclone/firecheck.png")),
                myContainerBox(165.w, 242.h, 40.h, "线圈检测记录",
                    Image.asset("image/mcclone/firecheck.png")),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.h, top: 15.h),
            width: double.maxFinite,
            height: 56.h,
            child: Text(S.of(context).firechecktip),
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            child: Text(S.of(context).firecheckok),
          ),
          SizedBox(
            height: 10.h,
          ),
          const SizedBox(
            child: Text(
              "芯片",
            ),
          ),
          SizedBox(
            width: 245.w,
            child: Divider(
              height: 1.h,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
