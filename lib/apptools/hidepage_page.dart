import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';

import 'package:magictank/home4_page.dart';

class HidePagePage extends StatefulWidget {
  const HidePagePage({Key? key}) : super(key: key);

  @override
  State<HidePagePage> createState() => _HidePagePageState();
}

class _HidePagePageState extends State<HidePagePage> {
  bool checkHide() {
    int j = 0;
    for (var i = 0; i < appData.hidePage.length; i++) {
      if (appData.hidePage[i] == "true") {
        j++;
      }
    }
    if (j == 2) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return const Tips4Page();
          }), (route) => false);

          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0.0,
            title: SizedBox(
              width: 97.r,
              height: 18.r,
              child: Image.asset(
                "image/share/mainappbar.png",
                // fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const Tips4Page();
                }), (route) => false);
              },
              color: Colors.black,
              icon: Image.asset("image/share/Icon_back.png"),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return const Tips4Page();
                    }), (route) => false);
                  },
                  color: Colors.black,
                  icon: SizedBox(
                    width: 24.r,
                    height: 20.r,
                    child: Image.asset(
                      "image/share/Icon_home.png",
                      fit: BoxFit.cover,
                    ),
                  ))
            ],
          ),
          // appBar: PreferredSize(
          //   preferredSize: Size(double.maxFinite, 60.h),
          //   child: Builder(
          //     builder: (context) {
          //       return Container(
          //         width: double.maxFinite,
          //         padding: EdgeInsets.only(top: 20.h),
          //         height: 60.h,
          //         //color: Colors.red,
          //         child: Stack(
          //           children: [
          //             Align(
          //               alignment: Alignment.centerLeft,
          //               child: TextButton(
          //                   onPressed: () {
          //                     // Scaffold.of(context).openDrawer();
          //                     Navigator.of(context).pushAndRemoveUntil(
          //                         MaterialPageRoute(builder: (context) {
          //                       return const Tips4Page();
          //                     }), (route) => false);
          //                   },
          //                   child: Image.asset("image/share/Icon_back.png")),
          //             ),
          //             Align(
          //               alignment: Alignment.center,
          //               child: Image.asset(
          //                 "image/share/mainappbar.png",
          //                 // fit: BoxFit.cover,
          //               ),
          //             ),
          //             Align(
          //                 alignment: Alignment.centerRight,
          //                 child: TextButton(
          //                     onPressed: () {
          //                       Navigator.of(context).pushAndRemoveUntil(
          //                           MaterialPageRoute(builder: (context) {
          //                         return const Tips4Page();
          //                       }), (route) => false);
          //                     },
          //                     child: Image.asset("image/share/Icon_home.png")))
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),

          body: ListView(
            children: [
              SwitchListTile(
                  title: const Text("E-Clone拷贝机"),
                  value: appData.hidePage[0] == "true" ? true : false,
                  onChanged: (value) {
                    if (value) {
                      if (checkHide()) {
                        appData.hidePage[0] = value ? "true" : "false";
                        if (appData.lastPage == 1 && value) {
                          appData.lastPage = 0;
                          appData.upgradeAppData({"lastpage": 0});
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return MyTextDialog(S.of(context).lestone);
                            });
                      }
                    } else {
                      appData.hidePage[0] = value ? "true" : "false";
                    }
                    //   appData.upgradeAppData({"welcomepage": value});
                    appData.upgradeAppData({"hidepage": appData.hidePage});
                    setState(() {});
                  }),
              SwitchListTile(
                  title: const Text("子机下载器"),
                  value: appData.hidePage[1] == "true" ? true : false,
                  onChanged: (value) {
                    if (value) {
                      if (checkHide()) {
                        appData.hidePage[1] = value ? "true" : "false";
                        if (appData.lastPage == 2 && value) {
                          appData.lastPage = 0;
                          appData.upgradeAppData({"lastpage": 0});
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return MyTextDialog(S.of(context).lestone);
                            });
                      }
                    } else {
                      appData.hidePage[1] = value ? "true" : "false";
                    }
                    appData.upgradeAppData({"hidepage": appData.hidePage});
                    setState(() {});
                  }),
              SwitchListTile(
                  title: const Text("Magic TANK"),
                  value: appData.hidePage[2] == "true" ? true : false,
                  onChanged: (value) {
                    if (value) {
                      if (checkHide()) {
                        appData.hidePage[2] = value ? "true" : "false";
                        if (appData.lastPage == 3 && value) {
                          appData.lastPage = 0;
                          appData.upgradeAppData({"lastpage": 0});
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return MyTextDialog(S.of(context).lestone);
                            });
                      }
                    } else {
                      appData.hidePage[2] = value ? "true" : "false";
                    }
                    //appData.upgradeAppData({"welcomepage": value});
                    appData.upgradeAppData({"hidepage": appData.hidePage});
                    setState(() {});
                  }),
            ],
          ),
        ));
  }
}
