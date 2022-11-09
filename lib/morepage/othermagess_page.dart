import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:marquee/marquee.dart';

import 'package:url_launcher/url_launcher.dart';

import '../appdata.dart';
import '../main.dart';

class OtherMessagePage extends StatefulWidget {
  const OtherMessagePage({Key? key}) : super(key: key);

  @override
  _OtherMessagePageState createState() => _OtherMessagePageState();
}

class _OtherMessagePageState extends State<OtherMessagePage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    setState(() {});
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Widget userbuttonstyle(
      int buttonindex, String buttonimage, String buttonstr) {
    return SizedBox(
      width: 86.w,
      height: 50.h,
      child: TextButton(
        onPressed: () {
          switch (buttonindex) {
            case 0:
              Navigator.pushNamed(context, "/news");
              break;
            case 1:
              Navigator.pushNamed(context, "/product");
              break;
            case 2:
              Navigator.pushNamed(context, "/shop");
              break;
            case 3:
              showDialog(
                  context: context,
                  builder: (c) {
                    return const MyTextDialog(
                      "客服微信:+8613410147731\r\n What's App:+8613410622843",
                    );
                  });
              break;
            case 4:
              Navigator.pushNamed(context, "/videotutorial");
              break;
            case 5:
              Navigator.pushNamed(context, "/videotutorial");
              break;
            case 6:
              Navigator.pushNamed(context, "/videotutorial");
              break;
            case 7:
              Navigator.pushNamed(context, "/devt");
              break;
            case 8:
              Navigator.pushNamed(context, "/feedback");
              break;
            default:
          }
        },
        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        child: Column(
          children: [
            SizedBox(
              width: 22.r,
              height: 22.r,
              child: Image.asset(
                buttonimage,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: Center(
                child: Text(
                  buttonstr,
                  style: TextStyle(color: Colors.black, fontSize: 13.sp),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: const Color(0xffeeeeee),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            width: 340.w,
            height: 150.h,
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: 19.h,
                  ),
                  SizedBox(
                    height: 15.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("欢迎:"),
                        TextButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            if (appData.loginstate) {
                              Navigator.pushNamed(context, "/usercenter");
                            } else {
                              Navigator.pushNamed(context, "/login");
                            }
                          },
                          child: Text(
                            appData.loginstate ? appData.username : "请登录",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                          // child: Text(
                          //   context.watch<AppProvid>().userinfo["loginstate"]
                          //       ? appData.account
                          //       : "请登录",
                          //   style: TextStyle(fontSize: 15.sp),
                          // ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  Container(
                    width: 56.r,
                    height: 56.r,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28.r)),
                    child: appData.loginstate
                        ? CachedNetworkImage(
                            imageUrl:
                                appData.headimage.replaceAll("https", "http"),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "image/share/Icon_defaultHead.png",
                          ),
                  ),
                  SizedBox(
                    height: 17.h,
                  ),
                  Text("账户积分:" +
                      (appData.loginstate
                          ? appData.integral.toString()
                          : "--")),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: 45.h,
          // ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 340.w,
            height: 235.h,
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: 14.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 19.w,
                      ),
                      userbuttonstyle(
                          0, "image/other/Icon_new.png", S.of(context).news),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(1, "image/other/Icon_product.png",
                          S.of(context).product),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(
                          2, "image/other/Icon_mall.png", S.of(context).mall),
                      SizedBox(
                        width: 19.w,
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      SizedBox(
                        width: 19.w,
                      ),
                      userbuttonstyle(
                          3, "image/other/Icon_tech.png", S.of(context).tech),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(
                          4, "image/other/Icon_video.png", S.of(context).video),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(
                          5, "image/other/Icon_word.png", S.of(context).word),
                      SizedBox(
                        width: 19.w,
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      SizedBox(
                        width: 19.w,
                      ),
                      userbuttonstyle(6, "image/other/Icon_keydata.png",
                          S.of(context).keydata),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(7, "image/other/Icon_development.png",
                          S.of(context).development),
                      const Expanded(child: SizedBox()),
                      userbuttonstyle(8, "image/other/Icon_suggest.png",
                          S.of(context).suggest),
                      SizedBox(
                        width: 19.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                ],
              ),
            ),
          ),
          //SizedBox(height: 51.h),
          const Expanded(child: SizedBox()),
          Divider(
            color: Colors.grey,
            height: 1.h,
          ),

          //跑马灯
          SizedBox(
            height: 29.h,
            width: double.maxFinite,
            child: Row(
              children: [
                SizedBox(
                  width: 22.r,
                  height: 29.r,
                  child: const Icon(
                    Icons.volume_up,
                    color: Color(0xff0f83c6),
                    //  size: 16.sp,
                  ),
                ),
                SizedBox(
                  width: 338.w,
                  height: 29.h,
                  child: Marquee(
                    text: "欢迎",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 11.h,
                        color: const Color(0xff0f83c6)),
                    scrollAxis: Axis.horizontal,
                    blankSpace: 338.w,
                    velocity: 50.0,
                    // pauseAfterRound: Duration(seconds: 1),
                    // startPadding: 10.0,
                    // accelerationDuration: Duration(seconds: 1),
                    // accelerationCurve: Curves.linear,
                    // decelerationDuration: Duration(milliseconds: 1),
                    // decelerationCurve: Curves.easeOut,
                  ),
                ),
                //padding: EdgeInsets.all(1),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          )
        ],
      ),
    );
  }
}

class OtherMessagePageBar extends StatefulWidget {
  const OtherMessagePageBar({Key? key}) : super(key: key);

  @override
  State<OtherMessagePageBar> createState() => _OtherMessagePageBarState();
}

class _OtherMessagePageBarState extends State<OtherMessagePageBar> {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Widget userbuttonstyle(
      BuildContext context, int index, String imagepath, String buttonstr) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(imagepath),
            ),
            Text(
              buttonstr,
              style: TextStyle(color: Colors.black, fontSize: 11.sp),
            ),
          ],
        ),
        onPressed: () {
          switch (index) {
            case 0:
              if (appData.loginstate) {
                Navigator.pushNamed(context, "/usercenter").then((value) {
                  setState(() {});
                });
              } else {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (c) {
                      return const MyTextDialog(
                        "此功能需要登录!",
                        button2: "登录",
                      );
                    }).then((value) {
                  if (value) {
                    Navigator.pushNamed(context, "/login").then((value) {
                      setState(() {});
                    });
                  }
                });
              }
              break;
            case 1:
              if (appData.loginstate) {
                Navigator.pushNamed(context, "/gettoken");
              } else {
                showDialog(
                    context: context,
                    builder: (c) {
                      return const MyTextDialog(
                        "此功能需要登录!",
                        button2: "登录",
                      );
                    }).then((value) {
                  if (value) {
                    Navigator.pushNamed(context, "/login").then((value) {
                      setState(() {});
                    });
                  }
                });
              }
              break;
            case 2:
              showDialog(
                  context: context,
                  builder: (c) {
                    return const MyTextDialog(
                      "客服微信:+8613410147731\r\n What's App:+8613410622843",
                      button2: "发送邮件",
                    );
                  }).then((value) {
                if (value) {
                  // final Uri launchUri = Uri(
                  //   scheme: 'tel',
                  //   path: "+8615560134942",
                  // );

                  final Uri emailLaunchUri = Uri(
                    scheme: '2M2TANK',
                    path: 'smith@example.com',
                    query: encodeQueryParameters(<String, String>{
                      'subject': 'Example Subject & Symbols are allowed!'
                    }),
                  );
                  // final Uri launchUri = Uri(
                  //   scheme: 'tel',
                  //   path: "+8615560134942",
                  // );
                  launchUrl(emailLaunchUri);
                }
              });
              break;
            case 3:
              Navigator.pushNamed(context, "/appsetting");
              break;
            default:
          }
        },
      ),
      flex: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 48.r,
      padding: EdgeInsets.only(bottom: 5.w),
      child: Row(
        children: [
          userbuttonstyle(
              context, 0, "image/other/Icon_user.png", S.of(context).user),
          const VerticalDivider(), //垂直分割线
          userbuttonstyle(context, 1, "image/other/Icon_integral.png",
              S.of(context).integralquery),
          const VerticalDivider(), //垂直分割线
          userbuttonstyle(context, 2, "image/other/Icon_customer.png",
              S.of(context).customer),
          const VerticalDivider(), //垂直分割线
          userbuttonstyle(
            context,
            3,
            "image/share/Icon_setting.png",
            S.of(context).appsetting,
          )
        ],
      ),
    );
  }
}
