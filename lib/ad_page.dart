import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';

class AdPage extends StatefulWidget {
  const AdPage({Key? key}) : super(key: key);

  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  int count = 10;
  Timer? timer;
  // _showTimer(context) {
  //   var timer;
  //   timer = Timer.periodic(Duration(milliseconds: 3000), (t) {
  //     t.cancel();
  //     Navigator.pushReplacementNamed(context, "/");
  //   });
  // }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTime();
    });

    super.initState();
  }

  void startTime() async {
    //设置启动图生效时间
    var _duration = const Duration(seconds: 1);
    Timer(_duration, () {
      // 空等1秒之后再计时
      timer = Timer.periodic(const Duration(milliseconds: 1000), (v) {
        count--;
        if (count == 0) {
          timer!.cancel();
          appData.welcomepage = false;
          // Navigator.pushReplacementNamed(context, "/");
        } else {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: const Alignment(1.0, -1.0), // 右上角对齐
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl:
                  "https://www.xingruiauto.com/tank/downpic/?picname=ad.png",
              errorWidget: (context, s, dynamic) {
                return Image.asset("image/ad.png");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 10.0, 0.0),
            child: TextButton(
              // color: const Color.fromRGBO(0, 0, 0, 0.3),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20)),
              child: Text(
                "$count S",
                style: TextStyle(color: Colors.white, fontSize: 15.sp),
              ),
              onPressed: () {
                timer!.cancel();
                appData.welcomepage = false;
                setState(() {});
                //  Navigator.pushReplacementNamed(context, "/");
              },
            ),
          )
        ],
      ),
    );
  }
}
