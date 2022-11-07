//钥匙类型界面
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:magictank/generated/l10n.dart';

import 'package:magictank/userappbar.dart';

class SeleKeyDataBasePage extends StatefulWidget {
  const SeleKeyDataBasePage({Key? key}) : super(key: key);

  @override
  State<SeleKeyDataBasePage> createState() => _SeleKeyDataBasePageState();
}

class _SeleKeyDataBasePageState extends State<SeleKeyDataBasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: const SeleKeyDataBase(),
    );
  }
}

class SeleKeyDataBase extends StatefulWidget {
  const SeleKeyDataBase({Key? key}) : super(key: key);

  @override
  State<SeleKeyDataBase> createState() => _SeleKeyDataBaseState();
}

class _SeleKeyDataBaseState extends State<SeleKeyDataBase> {
  Widget userbuttonstyle(int index, String imagepath, String buttonstr) {
    return TextButton(
        onPressed: () {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/cardata', arguments: {"type": 1});
              break;
            case 1:
              Navigator.pushNamed(context, '/cardata', arguments: {"type": 3});
              break;
            case 2:
              Navigator.pushNamed(context, '/cardata', arguments: {"type": 2});
              break;
            case 3:
              Navigator.pushNamed(context, '/nonconductive');
              break;
            default:
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xff394c70),
              borderRadius: BorderRadius.circular(8)),
          width: 308.w,
          height: 70.h,
          child: Stack(
            children: [
              Positioned(
                  left: 29.w,
                  top: 18.h,
                  child: SizedBox(
                    width: 44.w,
                    height: 35.h,
                    child: Center(
                      child: Image.asset(imagepath),
                    ),
                  )),
              Positioned(
                left: 102.w,
                top: 7.h,
                child: Container(
                  width: 199.w,
                  height: 57.h,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      buttonstr,
                      style: TextStyle(fontSize: 15.sp, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 37.h),
      //  padding: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 37.h),
      width: 340.w,
      height: 520.h,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            userbuttonstyle(0, "image/tank/Icon_cardatabase.png",
                S.of(context).cardatabase),
            userbuttonstyle(1, "image/tank/Icon_motordatabase.png",
                S.of(context).motordatabase),
            userbuttonstyle(2, "image/tank/Icon_civildatabase.png",
                S.of(context).civildatabase),
            userbuttonstyle(3, "image/tank/Icon_nondatabase.png",
                S.of(context).nondatabase),
          ],
        ),
      ),
    );
  }
}
