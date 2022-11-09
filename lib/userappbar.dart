import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/home4_page.dart';

AppBar userAppBar(context, {bool homeshow = true}) {
  return AppBar(
    elevation: 0.0,
    toolbarHeight: 32.r,
    title: SizedBox(
      width: 97.r,
      height: 18.r,
      child: Image.asset(
        "image/share/mainappbar.png",
        fit: BoxFit.cover,
      ),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.black,
      icon: SizedBox(
          width: 24.r,
          height: 20.r,
          child: Image.asset(
            "image/share/Icon_back.png",
            fit: BoxFit.cover,
          )),
    ),
    actions: [
      homeshow
          ? IconButton(
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
          : SizedBox(),
    ],
  );
}

// PreferredSize userAppBar({bool homeshow = true}) {
//   return PreferredSize(
//     preferredSize: Size(double.maxFinite, 28.h),
//     child: Builder(
//       builder: (context) {
//         return SizedBox(
//           width: double.maxFinite,
//           height: 28.h,
//           //color: Colors.red,
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton(
//                     onPressed: () {
//                       // Scaffold.of(context).openDrawer();
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset("image/share/Icon_back.png")),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: SizedBox(
//                   width: 92.w,
//                   height: 18.h,
//                   child: Image.asset(
//                     "image/share/mainappbar.png",
//                     // fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               homeshow
//                   ? Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pushAndRemoveUntil(
//                                 MaterialPageRoute(builder: (context) {
//                               return const Tips4Page();
//                             }), (route) => false);
//                           },
//                           child: Image.asset("image/share/Icon_home.png")))
//                   : const SizedBox()
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }

// PreferredSize userTankBar({bool homeshow = true}) {
//   return PreferredSize(
//     preferredSize: Size(double.maxFinite, 28.h),
//     child: Builder(
//       builder: (context) {
//         return SizedBox(
//           width: double.maxFinite,

//           height: 28.h,
//           //color: Colors.red,
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton(
//                     style: ButtonStyle(
//                       padding: MaterialStateProperty.all(EdgeInsets.zero),
//                     ),
//                     onPressed: () {
//                       // Scaffold.of(context).openDrawer();
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset("image/share/Icon_back.png")),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: SizedBox(
//                   width: 92.w,
//                   height: 18.h,
//                   child: Image.asset(
//                     "image/tank/Icon_tankbar.png",
//                     // fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               homeshow
//                   ? Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                           style: ButtonStyle(
//                             padding: MaterialStateProperty.all(EdgeInsets.zero),
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).pushAndRemoveUntil(
//                                 MaterialPageRoute(builder: (context) {
//                               return const Tips4Page();
//                             }), (route) => false);
//                           },
//                           child: Image.asset("image/share/Icon_home.png")))
//                   : const SizedBox()
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }

AppBar userTankBar(context, {bool homeshow = true}) {
  return AppBar(
    toolbarHeight: 32.r,
    elevation: 0.0,
    title: SizedBox(
      width: 97.r,
      height: 18.r,
      child: Image.asset(
        "image/tank/Icon_tankbar.png",
        // fit: BoxFit.cover,
      ),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.black,
      icon: SizedBox(
          width: 24.r,
          height: 20.r,
          child: Image.asset(
            "image/share/Icon_back.png",
            fit: BoxFit.cover,
          )),
    ),
    actions: [
      homeshow
          ? IconButton(
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
                  )),
            )
          : SizedBox(),
    ],
  );
}

AppBar userCloneBar(context, {bool homeshow = true}) {
  return AppBar(
    elevation: 0.0,
    toolbarHeight: 32.r,
    title: SizedBox(
      width: 97.r,
      height: 18.r,
      child: Image.asset(
        "image/mcclone/mcbar.png",
        // fit: BoxFit.cover,
      ),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.black,
      icon: SizedBox(
          width: 24.r,
          height: 20.r,
          child: Image.asset(
            "image/share/Icon_back.png",
            fit: BoxFit.cover,
          )),
    ),
    actions: [
      homeshow
          ? IconButton(
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
          : SizedBox(),
    ],
  );
}

AppBar userSmartBar(context, {bool homeshow = true}) {
  return AppBar(
    elevation: 0.0,
    toolbarHeight: 32.r,
    title: SizedBox(
      width: 97.r,
      height: 18.r,
      child: Image.asset(
        "image/mcclone/mcbar.png",
        // fit: BoxFit.cover,
      ),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.black,
      icon: Image.asset("image/share/Icon_back.png"),
    ),
    actions: [
      homeshow
          ? IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const Tips4Page();
                }), (route) => false);
              },
              color: Colors.black,
              icon: Image.asset("image/share/Icon_home.png"),
            )
          : SizedBox(),
    ],
  );
}
// PreferredSize userCloneBar({bool homeshow = true}) {
//   return PreferredSize(
//     preferredSize: Size(double.maxFinite, 28.h),
//     child: Builder(
//       builder: (context) {
//         return SizedBox(
//           width: double.maxFinite,

//           height: 28.h,
//           //color: Colors.red,
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton(
//                     onPressed: () {
//                       // Scaffold.of(context).openDrawer();
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset("image/share/Icon_back.png")),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: SizedBox(
//                     width: 92.w,
//                     height: 18.h,
//                     child: Image.asset(
//                       "image/mcclone/mcbar.png",
//                       // fit: BoxFit.cover,
//                     )),
//               ),
//               homeshow
//                   ? Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pushAndRemoveUntil(
//                                 MaterialPageRoute(builder: (context) {
//                               return const Tips4Page();
//                             }), (route) => false);
//                           },
//                           child: Image.asset("image/share/Icon_home.png")))
//                   : const SizedBox()
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }

// PreferredSize userSmartBar({bool homeshow = true}) {
//   return PreferredSize(
//     preferredSize: Size(double.maxFinite, 60.h),
//     child: Builder(
//       builder: (context) {
//         return Container(
//           width: double.maxFinite,
//           padding: EdgeInsets.only(top: 20.h),
//           height: 60.h,
//           //color: Colors.red,
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton(
//                     onPressed: () {
//                       // Scaffold.of(context).openDrawer();
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset("image/share/Icon_back.png")),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: Image.asset(
//                   "image/share/mainappbar.png",
//                   // fit: BoxFit.cover,
//                 ),
//               ),
//               homeshow
//                   ? Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pushAndRemoveUntil(
//                                 MaterialPageRoute(builder: (context) {
//                               return const Tips4Page();
//                             }), (route) => false);
//                           },
//                           child: Image.asset("image/share/Icon_home.png")))
//                   : const SizedBox()
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }
