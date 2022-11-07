import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class UserCenterPage extends StatefulWidget {
  const UserCenterPage({Key? key}) : super(key: key);

  @override
  _UserCenterPageState createState() => _UserCenterPageState();
}

class _UserCenterPageState extends State<UserCenterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userAppBar(context),
      body: const UserCenter(),
    );
  }
}

class UserCenter extends StatefulWidget {
  const UserCenter({Key? key}) : super(key: key);

  @override
  _UserCenterState createState() => _UserCenterState();
}

class _UserCenterState extends State<UserCenter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 48.h,
            child: Center(
              child: Text(
                S.of(context).myaccount,
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            )),
        Container(
          height: 105.h,
          margin: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8.sp)),
          width: double.maxFinite,
          // color: Colors.green,
          child: TextButton(
            child: Row(
              children: [
                // Image.asset("image/loading.gif"),

                CachedNetworkImage(
                  imageUrl: appData.headimage.replaceAll("https", "http"),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: appData.loginstate
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              S.of(context).username + ":" + appData.username,
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              S.of(context).user + ":" + appData.account,
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              S.of(context).token +
                                  ":" +
                                  (appData.integral).toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        )
                      : Text(S.of(context).needlogin),
                ),
                const Icon(Icons.arrow_right),
              ],
            ),
            onPressed: () {
              setState(() {
                if (appData.loginstate) {
                  Navigator.pushNamed(context, '/userinfo');
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              });
            },
          ),
        ),
        Expanded(child: Container()),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff384c70)),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (c) {
                      return MyTextDialog(S.of(context).outlogintip);
                    }).then((value) async {
                  if (value) {
                    appData.loginstate = false;
                    await appData.upgradeAppData(
                        {"loginstate": false, "autologin": false});
                    // await Api.updatauserinfo(FormData.fromMap({
                    //   "account": appData.account,
                    //   "integral": appData.integral
                    // }));
                    context.read<AppProvid>().upgradeuserinfo(
                        {"loginstate": false, "autologin": false});
                    Navigator.pop(context);
                  }
                });
              },
              child: Text(S.of(context).outlogin)),
        ),
      ],
    );
  }
}
