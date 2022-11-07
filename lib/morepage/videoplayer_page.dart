import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:magictank/userappbar.dart';

class VideoPlayerPage extends StatelessWidget {
  final String url;
  const VideoPlayerPage(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userAppBar(context),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(url),
          ),
        ));
  }
}
