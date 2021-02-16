import 'package:fluam_app/conf.dart';

import 'main.dart' as original_main;

// This file is the default main entry-point for go-flutter application.
void main() {
  AppConf.setDesktop();
  original_main.main();
}
