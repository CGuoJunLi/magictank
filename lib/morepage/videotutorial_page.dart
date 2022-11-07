import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/userappbar.dart';

class VideoTutorialPage extends StatelessWidget {
  const VideoTutorialPage({Key? key}) : super(key: key);

  List<Widget> itmelist(context) {
    List<Map<String, String>> itme = [
      {"name": "新手教程", "pic": "image/share/video_t1.png"},
      {"name": "APP介绍", "pic": "image/share/video_t2.png"},
      {"name": "基础操作", "pic": "image/share/video_t3.png"},
      {"name": "资深锁匠", "pic": "image/share/video_t4.png"},
      {"name": "常见售后", "pic": "image/share/video_t5.png"},
    ];
    List<Widget> temp = [];
    for (var i = 0; i < itme.length; i++) {
      temp.add(
        TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            Navigator.pushNamed(context, "/videolist",
                arguments: itme[i]["name"].toString());
          },
          child: Container(
            width: 340.r,
            height: 70.r,
            padding: EdgeInsets.only(left: 7.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                SizedBox(
                    width: 83.r,
                    height: 57.r,
                    child: Image.asset(itme[i]["pic"].toString())),
                SizedBox(
                  width: 26.r,
                ),
                Expanded(
                  child: SizedBox(child: Text(itme[i]["name"].toString())),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 33.r,
            child: Center(
              child: Text(
                "视频中心",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
              ),
            ),
          ),
          Divider(
            height: 8.r,
            thickness: 8.r,
            color: Color(0xffdde2ea),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: itmelist(context),
          ))
        ],
      ),
    );
  }
}

class VideoListPage extends StatelessWidget {
  final String title;
  static List<Map<String, String>> itme = [
    {
      "name": "拆箱组装",
      "pic": "image/share/video_1_1.png",
      "url":
          "https://v.youku.com/v_show/id_XNTg3OTc3ODA1Mg==.html?spm=a2hcb.profile.app.5~5!2~5~5!3~5!2~5~5!6~A"
    },
    {
      "name": "通电开机",
      "pic": "image/share/video_1_2.png",
      "url":
          "https://v.youku.com/v_show/id_XNTg4MDY5NTQ4MA==.html?spm=a2hcb.profile.app.5~5!2~5~5!3~5!2~5~5!5~A"
    },
    {
      "name": "数据下载连接机器",
      "pic": "image/share/video_1_3.png",
      "url":
          "https://v.youku.com/v_show/id_XNTg4MDY5NTU1Mg==.html?spm=a2hcb.profile.app.5~5!2~5~5!3~5!2~5~5!4~A"
    },
    {
      "name": "更换铣刀导针",
      "pic": "image/share/video_1_4.png",
      "url":
          "https://v.youku.com/v_show/id_XNTg3OTc3ODM0NA==.html?spm=a2hbt.13141534.1_2.d_1&scm=20140719.manual.114461.video_XNTg3OTc3ODM0NA=="
    },
    {
      "name": "归零点矫正",
      "pic": "image/share/video_1_5.png",
      "url":
          "https://v.youku.com/v_show/id_XNTg4MDY5NTkwMA==.html?spm=a2hbt.13141534.1_2.d_0&scm=20140719.manual.114461.video_XNTg4MDY5NTkwMA=="
    },
  ];
  const VideoListPage(this.title, {Key? key}) : super(key: key);

  Widget itemtitle(context, index) {
    return Padding(
        padding: EdgeInsets.only(top: 10.r),
        child: TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            // print(itme[index]["url"]);
            Navigator.pushNamed(context, "/videoplayer",
                arguments: itme[index]["url"].toString());
          },
          child: Container(
            width: 340.r,
            height: 70.r,
            padding: EdgeInsets.only(left: 7.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                SizedBox(
                    width: 83.r,
                    height: 57.r,
                    child: Image.asset(itme[index]["pic"].toString())),
                SizedBox(
                  width: 26.r,
                ),
                Expanded(
                  child: SizedBox(child: Text(itme[index]["name"].toString())),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 33.r,
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
              ),
            ),
          ),
          Divider(
            height: 8.r,
            thickness: 8.r,
            color: Color(0xffdde2ea),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: itme.length,
            itemBuilder: (context, index) {
              return itemtitle(context, index);
            },
          )),
        ],
      ),
    );
  }
}

// TextButton(
//     onPressed: () {
//       Navigator.pushNamed(context, '/videoplayer',
//           arguments:
//               "https://v.youku.com/v_show/id_XNTg3OTc3ODA1Mg==.html?spm=a2hcb.profile.app.5~5!2~5~5!3~5!2~5~5!6~A");
//     },
//     child: const Text("拆箱组装")),
// TextButton(
//     onPressed: () {
//       Navigator.pushNamed(context, '/videoplayer',
//           arguments:
//               "https://v.youku.com/v_show/id_XNTg4MDY5NTQ4MA==.html?spm=a2hcb.profile.app.5~5!2~5~5!3~5!2~5~5!5~A");
//     },
//     child: const Text("通电开机")),
// TextButton(
//     onPressed: () {
//       Navigator.pushNamed(context, '/videoplayer',
//           arguments:
//               "https://v.youku.com/v_show/id_XNTg4MDY5NTU1Mg==.html?spm=a2hcb.profile.app.5~5!2~5~5!3~5!2~5~5!4~A");
//     },
//     child: const Text("数据下载连接机器")),
// TextButton(
//     onPressed: () {
//       Navigator.pushNamed(context, '/videoplayer',
//           arguments:
//               "https://v.youku.com/v_show/id_XNTg4MDY5NTY0MA==.html?spm=a2hbt.13141534.1_2.d_2&scm=20140719.manual.114461.video_XNTg4MDY5NTY0MA==");
//     },
//     child: const Text("跟换铣刀导针")),
// TextButton(
//     onPressed: () {
//       Navigator.pushNamed(context, '/videoplayer',
//           arguments:
//               "https://v.youku.com/v_show/id_XNTg3OTc3ODM0NA==.html?spm=a2hbt.13141534.1_2.d_1&scm=20140719.manual.114461.video_XNTg3OTc3ODM0NA==");
//     },
//     child: const Text("夹具矫正")),
// TextButton(
//     onPressed: () {
//       Navigator.pushNamed(context, '/videoplayer',
//           arguments:
//               "https://v.youku.com/v_show/id_XNTg4MDY5NTkwMA==.html?spm=a2hbt.13141534.1_2.d_0&scm=20140719.manual.114461.video_XNTg4MDY5NTkwMA==");
//     },
//     child: const Text("归零点矫正")),
