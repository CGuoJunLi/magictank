import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/generated/l10n.dart';

class DrawerPage extends StatelessWidget {
  final int machineType;
  const DrawerPage(this.machineType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("image/share/appdrawer.png"),
        //     repeat: ImageRepeat.repeat,
        //   ),
        // ),
        // color: Colors.black,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              color: const Color(0xff384c70),
              height: 140.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 14.h,
                  ),
                  Text(
                    S.of(context).welcomemagicstar,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    width: 58.r,
                    height: 58.r,
                    decoration: BoxDecoration(
                      color: const Color(0xff384c70),
                      borderRadius: BorderRadius.all(
                        Radius.circular(29.r),
                      ),
                    ),
                    child: appData.loginstate
                        ? CachedNetworkImage(
                            imageUrl:
                                appData.headimage.replaceAll("https", "http"),
                            // fit: BoxFit.cover,
                            errorWidget: (context, url, error) {
                              debugPrint(url);
                              return Image.asset(
                                "image/share/Icon_defaultHead.png",
                                // fit: BoxFit.cover,
                              );
                            })
                        : Image.asset(
                            "image/share/Icon_defaultHead.png",
                            // fit: BoxFit.cover,
                          ),
                  ),
                  const Expanded(child: SizedBox()),
                  SizedBox(
                    height: 20.h,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/usercenter');
                      },
                      child: Text(
                        appData.loginstate
                            ? (S.of(context).welcome + appData.account)
                            : S.of(context).login,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, "/selecnc",
                  //         arguments: machineType);
                  //   },
                  //   child: Row(
                  //     children: [
                  //       SizedBox(
                  //         width: 30.r,
                  //         height: 30.r,
                  //         child: Image.asset(
                  //           "image/share/Icon_blutooth.png",
                  //         ),
                  //       ),
                  //       //  Icon(Icons.bluetooth),
                  //       Expanded(
                  //         child: Text(
                  //           S.of(context).selebt,
                  //           style: TextStyle(
                  //             fontSize: 18.sp,
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/selelanguage");
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30.r,
                          height: 30.r,
                          child: Image.asset(
                            "image/share/Icon_language.png",
                          ),
                        ),
                        //  Icon(Icons.bluetooth),
                        Expanded(
                          child: Text(
                            S.of(context).selelanuage,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/appsetting');
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30.r,
                          height: 30.r,
                          child: Image.asset(
                            "image/share/Icon_setting.png",
                            color: const Color(0xff384c70),
                          ),
                        ),
                        //  Icon(Icons.bluetooth),
                        Expanded(
                          child: Text(
                            S.of(context).appsetting,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/aboutus");
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30.r,
                          height: 30.r,
                          child: Image.asset(
                            "image/share/Icon_about.png",
                          ),
                        ),
                        //  Icon(Icons.bluetooth),
                        Expanded(
                          child: Text(
                            S.of(context).aboutus,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/showprivacy");
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30.r,
                          height: 30.r,
                          child: Image.asset(
                            "image/share/Icon_privet.png",
                          ),
                        ),
                        //  Icon(Icons.bluetooth),
                        Expanded(
                          child: Text(
                            S.of(context).privacy,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
