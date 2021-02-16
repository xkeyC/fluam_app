import 'package:flutter/material.dart';

class MainUI extends StatefulWidget {
  @override
  _MainUIState createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fluam"),
      ),
    );
  }
}
