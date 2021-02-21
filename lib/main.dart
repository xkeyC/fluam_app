import 'dart:io' show Platform;

import 'package:fluam_app/conf.dart';
import 'package:fluam_app/ui/SplashUI.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    AppConf.setDesktop();
  }

  runApp(SplashUI());
}
