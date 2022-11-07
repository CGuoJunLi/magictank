import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/userappbar.dart';

class AboutUSPage extends StatelessWidget {
  const AboutUSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userAppBar(context),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: SizedBox(),
              flex: 3,
            ),
            SizedBox(
              width: 291.r,
              height: 54.r,
              child: Image.asset(
                "image/share/mainappbar.png",
                fit: BoxFit.cover,
              ),
            ),
            const Expanded(
              child: SizedBox(),
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
            const Expanded(
              child: SizedBox(),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
