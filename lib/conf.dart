import 'io/hive_db.dart';

class AppConf {
  static Future<int> initApp() async {
    await AppDB.init();
    return 1;
  }

  static bool _isDesktop = false;

  static void setDesktop() {
    _isDesktop = true;
  }

  /// if true,the UI will be Desktop mode.
  static bool get isDesktop => _isDesktop;
}
