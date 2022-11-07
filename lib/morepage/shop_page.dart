import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:magictank/userappbar.dart';

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
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://www.xingruiauto.com")),
      ),
    );
  }
}
