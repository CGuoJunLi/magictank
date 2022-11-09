import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userAppBar(context),
      body: const UserInfo(),
    );
  }
}

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  List<XFile>? _imageFileList;
  ProgressDialog? pd;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  Map<String, dynamic> userinfo = {
    "phone": appData.userphone,
    "name": appData.username,
    "address": appData.address,
  };
  //dynamic _pickImageError;
  bool isVideo = false;

  //String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();

      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      double volume = kIsWeb ? 0.0 : 1.0;

      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    if (isVideo) {
      final XFile? file = await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 10));
      await _playVideo(file);
    } else {
      try {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 100.0,
          maxHeight: 100.0,
          // imageQuality: quality,
        );
        var temp = pickedFile!.path.split('/');
        //var temp2 = temp[temp.length - 1].split('.');
        var filetemp = await MultipartFile.fromFile(pickedFile.path,
            filename: temp[temp.length - 1]);
        setState(() {
          //  if (pickedFile != null) {
          appData.headimage = pickedFile.path;
          //  }
          _imageFile = pickedFile;
          userinfo["pic"] = filetemp;
          ////print(filetemp.filename);
        });
      } catch (e) {
        setState(() {
          //  _pickImageError = e;
        });
      }
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {}

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
          _imageFileList = response.files;
        });
      }
    } else {
      debugPrint(response.exception!.code);
      // _retrieveDataError = response.exception!.code;
    }
  }

  @override
  void initState() {
    pd = ProgressDialog(context: context);
    userinfo["name"] = appData.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          height: 48.h,
          child: Center(
            child: Text(
              S.of(context).userinfo,
              style: TextStyle(color: const Color(0xff384c70), fontSize: 17.sp),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (c) {
                  return MySeleDialog(
                      [S.of(context).photoalbum, S.of(context).carmerphoto]);
                }).then((value) {
              switch (value) {
                case 1:
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.gallery, context: context);

                  break;
                case 2:
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.camera, context: context);
                  break;
                default:
                  break;
              }
            });
          },
          child: Row(
            children: [
              SizedBox(width: 23.w),
              Text(
                S.of(context).headimage,
                style: TextStyle(color: Colors.black, fontSize: 17.sp),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              SizedBox(
                width: 90.r,
                height: 90.r,
                child: _imageFileList == null
                    ? CachedNetworkImage(
                        imageUrl: appData.headimage,
                      )
                    : Image.file(
                        File(_imageFileList![0].path),
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(width: 23.w),
            ],
          ),
        ),
        TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          child: Container(
            height: 40.h,
            color: const Color(0xffdde2ea),
            child: Row(
              children: [
                SizedBox(width: 23.w),
                Text(
                  S.of(context).username,
                  style: const TextStyle(color: Colors.black),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Text(
                  userinfo["name"],
                  style: const TextStyle(color: Colors.black),
                ),
                SizedBox(width: 23.w),
              ],
            ),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (c) {
                  return MyEgditDialog(
                    appData.username,
                    title: S.of(context).inputnewusername,
                  );
                }).then((value) {
              ////print(value);
              if (value["state"]) {
                setState(() {
                  userinfo["name"] = value["value"];
                  //appData.username = value["value"];
                });
              }
            });
          },
        ),
        // TextButton(
        //   style:
        //       ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        //   onPressed: () {
        //     showDialog(
        //         context: context,
        //         builder: (c) {
        //           return MyEgditDialog(
        //             appData.qqnumber,
        //             title: S.of(context).newqqnumber,
        //           );
        //         }).then((value) {
        //       ////print(value);
        //       if (value["state"]) {
        //         userinfo["qqnumer"] = value["value"];

        //         setState(() {});
        //       }
        //     });
        //   },
        //   child: Container(
        //     height: 40.h,
        //     color: const Color(0xffdde2ea),
        //     child: Row(
        //       children: [
        //         SizedBox(width: 23.w),
        //         const Text(
        //           "QQ",
        //           style: TextStyle(color: Colors.black),
        //         ),
        //         const Expanded(
        //           child: SizedBox(),
        //         ),
        //         Text(
        //           appData.qqnumber == "" ? "" : appData.qqnumber,
        //           style: const TextStyle(color: Colors.black),
        //         ),
        //         SizedBox(width: 23.w),
        //       ],
        //     ),
        //   ),
        // ),
        // TextButton(
        //   style:
        //       ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        //   onPressed: () {
        //     showDialog(
        //         context: context,
        //         builder: (c) {
        //           return MyEgditDialog(
        //             appData.email,
        //             title: S.of(context).inputnewemail,
        //           );
        //         }).then((value) {
        //       ////print(value);
        //       if (value["state"]) {
        //         setState(() {
        //           userinfo["email"] = value["value"];
        //           //appData.email = value["value"];
        //         });
        //       }
        //     });
        //   },
        //   child: Container(
        //     height: 40.h,
        //     color: const Color(0xffdde2ea),
        //     child: Row(
        //       children: [
        //         SizedBox(width: 23.w),
        //         const Text(
        //           "邮箱",
        //           style: TextStyle(color: Colors.black),
        //         ),
        //         const Expanded(
        //           child: SizedBox(),
        //         ),
        //         Text(
        //           appData.email == "" ? "" : appData.email,
        //           style: const TextStyle(color: Colors.black),
        //         ),
        //         SizedBox(width: 23.w),
        //       ],
        //     ),
        //   ),
        // ),

        TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            showDialog(
                context: context,
                builder: (c) {
                  return MyEgditDialog(
                    appData.address,
                    title: S.of(context).inputnewadress,
                  );
                }).then((value) {
              ////print(value);
              if (value["state"]) {
                setState(() {
                  userinfo["address"] = value["value"];
                  // appData.address = value["value"];
                });
              }
            });
          },
          child: Container(
            height: 40.h,
            color: const Color(0xffdde2ea),
            child: Row(
              children: [
                SizedBox(width: 23.w),
                Text(
                  S.of(context).useraddress,
                  style: const TextStyle(color: Colors.black),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Text(
                  userinfo["address"],
                  style: const TextStyle(color: Colors.black),
                ),
                SizedBox(width: 23.w),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff384c70))),
            child: Text(S.of(context).okbt),
            onPressed: () async {
              pd!.show(max: 100, msg: S.of(context).updata);
              userinfo["account"] = appData.account; //本地账户提交
              var value = await Api.updatauserinfo(userinfo);

              appData.upgradeAppData(value);
              pd!.close();
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo({Key? key}) : super(key: key);

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: 0,
          child: Container(),
        ),
      );
    } else {
      return Container();
    }
  }
}
