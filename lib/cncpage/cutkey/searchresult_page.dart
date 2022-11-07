import 'package:flutter/material.dart';
import 'package:magictank/userappbar.dart';

class SearchResult extends StatelessWidget {
  final List arguments;
  const SearchResult(this.arguments, {Key? key}) : super(key: key);

  List<Widget> keylist(context) {
    List<Widget> temp = [];
    for (var i = 0; i < arguments.length; i++) {
      temp.add(SizedBox(
        child: TextButton(
          child: Text(arguments[i].toString()),
          onPressed: () {
            Navigator.pop(context, i);
          },
        ),
      ));
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: ListView(
        children: keylist(context),
      ),
    );
  }
}
