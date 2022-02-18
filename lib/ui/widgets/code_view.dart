import 'package:flutter/material.dart';

import '../../util/color.dart';

class CodeView extends StatelessWidget {
  final String text;

  CodeView(this.text);

  @override
  Widget build(BuildContext context) {
    Color backGroundColor = Colors.black87;
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                text,
                style: TextStyle(
                    color: ColorUtil.getTitleFormBackGround(backGroundColor),
                    fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
