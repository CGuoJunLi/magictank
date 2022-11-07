import 'package:flutter/material.dart';
import 'package:magictank/userappbar.dart';

class SeleDiyModelPage extends StatelessWidget {
  const SeleDiyModelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const SeleDiyModel(),
    );
  }
}

class SeleDiyModel extends StatefulWidget {
  const SeleDiyModel({Key? key}) : super(key: key);

  @override
  State<SeleDiyModel> createState() => _SeleDiyModelState();
}

class _SeleDiyModelState extends State<SeleDiyModel> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 100.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                width: 3,
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: TextButton(
              child: const Text("测量创建模型"),
              onPressed: () {
                ///  Navigator.pushNamed(context, '/diymodelstep');
                Navigator.pushReplacementNamed(context, '/diymodelstep');

                //  Navigator.pushNamed(context, '/diykeystep');
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                width: 3,
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            height: 100.0,
            child: TextButton(
              child: const Text("智能创建模型"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/smartdiymodelstep');
                //   Navigator.pushNamed(context, "/smartdiy");
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
