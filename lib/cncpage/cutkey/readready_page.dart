import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//import 'package:flutter/widgets.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/generated/l10n.dart';

//读码准备界面
class ReadReadyPage extends StatefulWidget {
  const ReadReadyPage({Key? key}) : super(key: key);

  @override
  State<ReadReadyPage> createState() => _ReadReadyPageState();
}

class _ReadReadyPageState extends State<ReadReadyPage> {
  int headdiff = 0; //头部磨损
  int cutsdiff = 0; //齿位磨损

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: 300.w,
          height: 400.h,
          child: Column(
            children: [
              Container(
                width: 300.w,
                height: 50.h,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13.0),
                        topRight: Radius.circular(13.0))),
                child: Center(
                  child: Text(
                    S.of(context).readkey,
                    style: TextStyle(fontSize: 17.sp),
                  ),
                ),
              ),
              Container(
                height: 30.h,
                color: const Color(0xff384c70),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    S.of(context).headabrase,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  )),
                  Expanded(
                      child: Text(
                    S.of(context).toothabrase,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  )),
                ]),
              ),
              Container(
                height: 20.h,
                color: const Color(0xffeeeeee),
              ),
              Expanded(
                  child: Image.asset(
                "image/tank/Icon_headchange.png",
                fit: BoxFit.cover,
              )),
              Container(
                height: 50.h,
                color: const Color(0xffeeeeee),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    SizedBox(
                      width: 40.w,
                      height: 20.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0XFF384C70)),
                        ),
                        onPressed: () {
                          setState(() {
                            if (headdiff > 0) {
                              headdiff = headdiff - 1;
                            }
                          });
                        },
                        child: const Text("-"),
                      ),
                    ),
                    Expanded(
                        child: Text((headdiff / 100).toString() + "mm",
                            textAlign: TextAlign.center)),
                    SizedBox(
                      width: 40.w,
                      height: 20.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0XFF384C70)),
                        ),
                        onPressed: () {
                          setState(() {
                            headdiff = headdiff + 1;
                          });
                        },
                        child: const Text("+"),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    SizedBox(
                      width: 40.w,
                      height: 20.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0XFF384C70)),
                        ),
                        onPressed: () {
                          setState(() {
                            if (cutsdiff > 0) {
                              cutsdiff = cutsdiff - 1;
                            }
                          });
                        },
                        child: const Text("-"),
                      ),
                    ),
                    Expanded(
                        child: Text((cutsdiff / 100).toString() + "mm",
                            textAlign: TextAlign.center)),
                    SizedBox(
                      width: 40.w,
                      height: 20.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0XFF384C70)),
                        ),
                        onPressed: () {
                          setState(() {
                            //  cutdepth = cutdepth + 1;

                            cutsdiff = cutsdiff + 1;
                          });
                        },
                        child: const Text("+"),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
              ),
              Container(
                  height: 50.h,
                  decoration: const BoxDecoration(
                      color: Color(0xffeeeeee),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(13.0),
                          bottomRight: Radius.circular(13.0))),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150.w,
                        height: 40.h,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70),
                            ),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13.0))),
                          ),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            S.of(context).cancel,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150.w,
                        height: 40.h,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70),
                            ),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13.0))),
                          ),
                          onPressed: () {
                            baseKey.cutDiff = cutsdiff;
                            baseKey.headDiff = headdiff;

                            Navigator.pop(context, true);
                          },
                          child: Text(
                            S.of(context).continuebt,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
