import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'buttons.dart';

void main() {
  runApp(Cal());
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class Cal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),

    );
  }
}

