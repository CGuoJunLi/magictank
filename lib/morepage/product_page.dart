import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:magictank/userappbar.dart';

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
        body: InAppWebView(
          initialUrlRequest:
              URLRequest(url: Uri.parse("https://www.xingruiauto.com")),
        ));
  }
}
