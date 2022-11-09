import 'package:flutter/material.dart';

import 'package:magictank/userappbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userAppBar(context),
        body: WebView(initialUrl: "https://www.xingruiauto.com"));
  }
}
