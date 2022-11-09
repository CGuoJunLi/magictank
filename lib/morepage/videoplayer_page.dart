import 'package:flutter/material.dart';

import 'package:magictank/userappbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlayerPage extends StatelessWidget {
  final String url;
  const VideoPlayerPage(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userAppBar(context),
        body: WebView(initialUrl: "https://www.xingruiauto.com"));
  }
}
