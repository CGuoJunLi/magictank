import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class SpeedSetPage extends StatefulWidget {
  const SpeedSetPage({Key? key}) : super(key: key);

  @override
  State<SpeedSetPage> createState() => _SpeedSetPageState();
}

class _SpeedSetPageState extends State<SpeedSetPage> {
  @override
  void initState() {
    // print(cncVersion.bldcSpeed);
    // print(cncVersion.cutSpeed);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      appBar: userTankBar(context),
      body: ListView(
        children: [
          Container(
            width: double.maxFinite,
            height: 40.h,
            color: const Color(0xffdde1ea),
            child: Center(
              child: Text(S.of(context).cutsetting),
            ),
          ),
          Container(
            width: 340.w,
            height: 103.h,
            margin: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 74.w,
                  height: 103.h,
                  child: Column(
                    children: [
                      const Expanded(child: SizedBox()),
                      SizedBox(
                        width: 53.r,
                        height: 53.r,
                        child: Image.asset(
                            "image/tank/cnctools/Icon_motorspeed.png"),
                      ),
                      Text(S.of(context).bldcspeed),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: Image.asset(
                            "image/tank/cnctools/Icon_motorspeed1.png",
                            color: cncVersion.bldcSpeed == 1
                                ? Colors.white
                                : const Color(0xff666666),
                          ),
                        ),
                        Text(
                          S.of(context).lowspeed,
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: Image.asset(
                            "image/tank/cnctools/Icon_motorspeed2.png",
                            color: cncVersion.bldcSpeed == 2
                                ? Colors.white
                                : const Color(0xff666666),
                          ),
                        ),
                        Text(
                          S.of(context).mediumspeed,
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: Image.asset(
                            "image/tank/cnctools/Icon_motorspeed3.png",
                            color: cncVersion.bldcSpeed == 3
                                ? Colors.white
                                : const Color(0xff666666),
                          ),
                        ),
                        Text(
                          S.of(context).highspeed,
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          Container(
            width: 340.w,
            height: 103.h,
            margin: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 74.w,
                  height: 103.h,
                  child: Column(
                    children: [
                      const Expanded(child: SizedBox()),
                      SizedBox(
                        width: 53.r,
                        height: 53.r,
                        child: Image.asset(
                            "image/tank/cnctools/Icon_cutspeed.png"),
                      ),
                      Text(S.of(context).cuttingspeed),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: Image.asset(
                            "image/tank/cnctools/Icon_cutspeed1.png",
                            color: cncVersion.cutSpeed == 1
                                ? Colors.white
                                : const Color(0xff666666),
                          ),
                        ),
                        Text(
                          S.of(context).lowspeed,
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: Image.asset(
                            "image/tank/cnctools/Icon_cutspeed2.png",
                            color: cncVersion.cutSpeed == 2
                                ? Colors.white
                                : const Color(0xff666666),
                          ),
                        ),
                        Text(
                          S.of(context).mediumspeed,
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: Image.asset(
                            "image/tank/cnctools/Icon_cutspeed3.png",
                            color: cncVersion.cutSpeed == 3
                                ? Colors.white
                                : const Color(0xff666666),
                          ),
                        ),
                        Text(
                          S.of(context).highspeed,
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          Container(
            width: 340.w,
            height: 103.h,
            margin: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 74.w,
                  height: 103.h,
                  child: Column(
                    children: [
                      const Expanded(child: SizedBox()),
                      SizedBox(
                        width: 53.r,
                        height: 53.r,
                        child: Image.asset("image/tank/cnctools/Icon_xdd.png"),
                      ),
                      Text(S.of(context).xdr),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: 35.r,
                            height: 24.r,
                            child: Text(
                              "1.5",
                              style: TextStyle(
                                  fontSize: 24.sp, color: Colors.black),
                            )),
                        Text(
                          "mm",
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: 35.r,
                            height: 24.r,
                            child: Text(
                              "1.9",
                              style: TextStyle(
                                  fontSize: 24.sp, color: Colors.black),
                            )),
                        Text(
                          "mm",
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: 35.r,
                            height: 24.r,
                            child: Text(
                              "2.0",
                              style: TextStyle(
                                  fontSize: 24.sp, color: Colors.black),
                            )),
                        Text(
                          "mm",
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          Container(
            width: 340.w,
            height: 103.h,
            margin: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 74.w,
                  height: 103.h,
                  child: Column(
                    children: [
                      const Expanded(child: SizedBox()),
                      SizedBox(
                        width: 53.r,
                        height: 53.r,
                        child: Image.asset("image/tank/cnctools/Icon_beep.png"),
                      ),
                      Text(S.of(context).buzz),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: const Center(
                      child: Text(
                        "开",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {},
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0XFF384C70))),
                    child: const Center(
                      child: Text(
                        "关",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
