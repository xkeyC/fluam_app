import 'package:hive_flutter/hive_flutter.dart';

class AppDB {
  static Future init() async {
    await Hive.initFlutter("Fluam/db");
  }
}
