import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/mycontainer.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class KeyModelPage extends StatefulWidget {
  const KeyModelPage({Key? key}) : super(key: key);

  @override
  _KeyModelPageState createState() => _KeyModelPageState();
}

class _KeyModelPageState extends State<KeyModelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const KeyModel(),
    );
  }
}

class KeyModel extends StatefulWidget {
  const KeyModel({Key? key}) : super(key: key);

  @override
  _KeyModelState createState() => _KeyModelState();
}

class _KeyModelState extends State<KeyModel> {
  late ProgressDialog pd;
  List<String> titlestr = ["平铣胚模型", "立铣胚模型", "自定义模型"];
  List<String> titleimage = [
    "image/tank/model1_bt.png",
    "image/tank/model5_bt.png",
    "image/tank/diymodel_bt.png"
  ];
  @override
  void initState() {
    super.initState();
    pd = ProgressDialog(context: context);
  }

  Widget title(context, index) {
    return TextButton(
        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        onPressed: () {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, "/modellist",
                  arguments: {"type": 1});
              break;
            case 1:
              Navigator.pushNamed(context, "/modellist",
                  arguments: {"type": 2});
              break;
            case 2:
              if (appData.loginstate) {
                Navigator.pushNamed(context, "/diymodel");
                //  sendCmd([cncBtSmd.openClamp, 0, 0]);
              } else {
                showDialog(
                    context: context,
                    builder: (c) {
                      return const MyTextDialog("此功能需要登录", button2: "登录");
                    }).then((value) {
                  if (value) {
                    Navigator.pushNamed(context, '/login');
                  }
                });
              }
              break;
            default:
          }
        },
        child: myContainer(300.r, 150.r, 35.r, titlestr[index],
            titleimage[index], EdgeInsets.only(top: 35.r),
            assetimage: true));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return title(context, index);
        });
  }
}
