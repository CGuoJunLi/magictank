import 'package:flutter/material.dart';
import 'package:magictank/userappbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userAppBar(context),
        body: WebView(initialUrl: "https://www.xingruiauto.com"));
  }
}
