import 'package:fluam_app/conf.dart';
import 'package:fluam_app/ui/MainUI.dart';
import 'package:fluam_app/ui/MainUI_desktop.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Future goMainAndRemoveUntil(BuildContext context) {
    return Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) {
      if (AppConf.isDesktop) {
        return MainUIDesktop();
      }
      return MainUI();
    }), (route) => route == null);
  }
}
