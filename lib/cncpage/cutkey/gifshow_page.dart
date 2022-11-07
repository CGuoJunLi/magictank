import 'dart:io';

import 'package:flutter/material.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class GifShowPage extends StatelessWidget {
  final String gifPagth;
  const GifShowPage(this.gifPagth, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: Image.file(
              File(gifPagth),
              fit: BoxFit.cover,
            ),
          )),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).okbt))
        ],
      ),
    );
  }
}
